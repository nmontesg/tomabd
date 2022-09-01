#!~/anaconda3/bin/python
# -*- coding: utf-8 -*-

"""
Analyze individual Hanabi games.
"""

__author__ = "Nieves Montes"


import argparse
import logging
import math
import os
from itertools import product

import pandas as pd
import numpy as np

logging.basicConfig(level=logging.INFO)

parser = argparse.ArgumentParser(description='Process the results from \
    the simulations of Hanabi games.')
parser.add_argument('N', type=int, help='process the games with N players')
ns = parser.parse_args()

# global variables
results_parent_path = "/home/nmontes/OneDrive/Documentos/PhD/hanabi-results"
num_players = ns.N
path = "{}/{}_players".format(results_parent_path, num_players)
slots_per_player = 5 if num_players == 2 or num_players == 3 else 4
max_seed = 500

all_players = ["alice", "bob", "cathy", "donald", "emma"]
players = all_players[0:num_players]


def get_seeds():
    seeds = [int(folder.split('_')[-1]) for folder in os.listdir(path)]
    return seeds


def get_arg(s, n, sep):
    """
    Get the n-th argument from string s (arguments are comma-separated).
    """
    l = [a.strip() for a in s.split(sep)]
    return l[n]


def compute_probability(df):
    den = df.groupby("slot")["num"].sum()
    for slot, n in den.iteritems():
        assert n > 0, "probability distribution for slot {} is \
            ill-defined".format(slot)
    prob = df.apply(lambda x: x.num/den[x.slot], axis=1)
    df.insert(df.shape[1], "prob", prob)


def kullback_leibler_distance(Q, P, slot, base=25):
    colors = ["red", "green", "white", "blue", "yellow"]
    ranks = [1, 2, 3, 4, 5]
    D_kl = 0
    for c, r in product(colors, ranks):
        Q_prob = Q.loc[(Q["slot"] == slot) & (Q["color"] == c) & \
            (Q["rank"] == r), "prob"].iloc[0]
        P_prob = P.loc[(P["slot"] == slot) & (P["color"] == c) & \
            (P["rank"] == r), "prob"].iloc[0]
        if np.isclose(P_prob, 0, atol=1.0E-9):
            continue
        D_kl += P_prob * math.log(P_prob/Q_prob, base)
    return D_kl


def process_hint(hint_move, seed, base=25):
    move = hint_move["move"]
    receiver = hint_move["receiver"]

    # compute information gain by the EXPLICIT knowledge conveyed by the hint
    pre_action_file = "{}/results_{}_{}/{}_{}_false.csv".format(path, \
        num_players, seed, receiver, move)
    post_action_file = "{}/results_{}_{}/{}_{}_false.csv".format(path, \
        num_players, seed, receiver, move+1)
    pre_action_distribution = pd.read_csv(pre_action_file, sep=';')
    post_action_distribution = pd.read_csv(post_action_file, sep=';')

    compute_probability(pre_action_distribution)
    compute_probability(post_action_distribution)

    explicit_info_mre_per_slot = {
        s: kullback_leibler_distance(pre_action_distribution, \
            post_action_distribution, s, base=base) \
        for s in range(1, slots_per_player+1)
    }
    total_explicit_info_mre = sum(explicit_info_mre_per_slot.values())

    # compute information gain by the IMPLICIT knowledge conveyed by the hint
    post_explanation_file = "{}/results_{}_{}/{}_{}_true.csv".format(path, \
        num_players, seed, receiver, move+1)
    try:
        post_explanation_distribution = pd.read_csv(post_explanation_file, \
            sep=';')
    except FileNotFoundError:
        return total_explicit_info_mre, float('nan')
    
    compute_probability(post_explanation_distribution)

    implicit_info_mre_per_slot = {
        s: kullback_leibler_distance(post_action_distribution, \
            post_explanation_distribution, s, base=base) \
        for s in range(1, slots_per_player+1)
    }
    total_implicit_info_mre = sum(implicit_info_mre_per_slot.values())

    return total_explicit_info_mre, total_implicit_info_mre


def process_game(seed, **kwargs):
    results = {}

    evolution_file = "{}/{}_players/results_{}_{}/evolution.csv".\
        format(results_parent_path, num_players, num_players, seed)
    evolution = pd.read_csv(evolution_file, sep=';', on_bad_lines='error')

    # find the basic results
    results["moves"] = evolution["move"].iloc[-1]
    results["score"] = evolution["score"].iloc[-1]
    results["hints"] = evolution["hints"].iloc[-1]

    # find the game moves where hints were given and find who received that
    # hint
    hint_moves = evolution.loc[evolution["action_functor"] == "give_hint"]
    receiver = hint_moves["actions_args"].apply(lambda s: get_arg(s, 0, ','))
    hint_moves.insert(hint_moves.shape[1], "receiver", receiver)

    # get the explicit and implicit information gained at hints at every slot 
    # and add to the df
    info_gain = [process_hint(h, seed, **kwargs) \
        for _, h in hint_moves.iterrows()]
    explicit_info_gain = [x[0] for x in info_gain]
    implicit_info_gain = [x[1] for x in info_gain]

    # get the total explicit and implicit information gained at hints and
    # add to the df
    total_explicit_info = np.nansum(explicit_info_gain)
    total_implicit_info = np.nansum(implicit_info_gain)
    
    avg_explicit_info = np.nanmean(explicit_info_gain)
    avg_implicit_info = np.nanmean(implicit_info_gain)

    results["total_explicit_info"] = total_explicit_info
    results["total_implicit_info"] = total_implicit_info
    results["avg_explicit_info"] = avg_explicit_info
    results["avg_implicit_info"] = avg_implicit_info
    
    return results


if __name__ == '__main__':
    seeds = get_seeds()
    logging.info("For {} players, {} simulations have been run".\
        format(num_players, len(seeds)))

    missing_seeds = [s for s in range(max_seed) if not s in seeds]
    if (len(missing_seeds) > 0):
        logging.info("For {} players, the following seeds are missing: {}".\
            format(num_players, missing_seeds))

    all_games = pd.DataFrame()

    for seed in [309, 321, 122, 336, 34, 40, 297]:
        try:
            results = process_game(seed)
        except Exception:
            logging.warning("For {} players and seed {}, reading the evolution \
            file resulted in error".format(num_players, seed))
            continue
        results["seed"] = seed
        res = {k: [v] for k, v in results.items()}
        results_df = pd.DataFrame.from_dict(res)
        results_df.set_index("seed")
        all_games = pd.concat([all_games, results_df])

    summary_file = "summary_{}_players.csv".format(num_players)
    all_games.to_csv(summary_file, sep=';')
