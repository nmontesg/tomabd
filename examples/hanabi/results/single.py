#!~/anaconda3/bin/python
# -*- coding: utf-8 -*-

"""
Analyze individual Hanabi games.
"""

__author__ = "Nieves Montes"

import math
import os
import logging
from itertools import product

import pandas as pd
import numpy as np

logging.basicConfig(level=logging.CRITICAL)

# global variables
results_parent_path = "/home/nmontes/OneDrive/Documentos/PhD/hanabi-results"
num_players = 2
path = "{}/{}_players".format(results_parent_path, num_players)
slots_per_player = 5 if num_players == 2 or num_players == 3 else 4
max_seed = 500


def get_seeds():
    seeds = [int(folder.split('_')[-1]) for folder in os.listdir(path)]
    simulation_runs = len(seeds)
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


def process_hint(hint_move, base=25):
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

    explicit_info_mre = {
        s: kullback_leibler_distance(pre_action_distribution, \
            post_action_distribution, s, base=base) \
        for s in range(1, slots_per_player+1)
    }

    # compute information gain by the IMPLICIT knowledge conveyed by the hint
    post_explanation_file = "{}/results_{}_{}/{}_{}_true.csv".format(path, \
        num_players, seed, receiver, move+1)
    try:
        post_explanation_distribution = pd.read_csv(post_explanation_file, \
            sep=';')
    except FileNotFoundError:
        return explicit_info_mre, {}
    
    compute_probability(post_explanation_distribution)

    implicit_info_mre = {
        s: kullback_leibler_distance(post_action_distribution, \
            post_explanation_distribution, s, base=base) \
        for s in range(1, slots_per_player+1)
    }

    return explicit_info_mre, implicit_info_mre


def process_game(seed, base=25):
    results = {}

    evolution_file = "{}/{}_players/results_{}_{}/evolution.csv".\
        format(results_parent_path, num_players, num_players, seed)
    evolution = pd.read_csv(evolution_file, sep=';', on_bad_lines='warn')

    # find the basic results
    results["moves"] = evolution["move"].iloc[-1]
    results["score"] = evolution["score"].iloc[-1]
    results["hints"] = evolution["hints"].iloc[-1]
    results["efficiency"] = results["score"] / results["hints"]

    # find the game moves where hints were given
    hint_moves = evolution.loc[evolution["action_functor"] == "give_hint"]
    receiver = hint_moves["actions_args"].apply(lambda s: get_arg(s, 0, ','))
    hint_moves.insert(hint_moves.shape[1], "receiver", receiver)

    # get the explicit and implicit information gained at hints at every slot 
    # and add to the df
    info_gain = [process_hint(h, base=base) for _, h in hint_moves.iterrows()]
    explicit_info_gain = [x[0] for x in info_gain]
    implicit_info_gain = [x[1] for x in info_gain]
    hint_moves.insert(hint_moves.shape[1], "explicit_info_gain", \
        explicit_info_gain)
    hint_moves.insert(hint_moves.shape[1], "implicit_info_gain", \
        implicit_info_gain)

    # get the total explicit and implicit information gained at hints and
    # add to the df
    total_explicit_info = hint_moves["explicit_info_gain"].\
        apply(lambda x: sum(x.values()))
    total_implicit_info = hint_moves["implicit_info_gain"].\
        apply(lambda x: sum(x.values()))
    hint_moves.insert(hint_moves.shape[1], "total_explicit_info", \
        total_explicit_info)
    hint_moves.insert(hint_moves.shape[1], "total_implicit_info", \
        total_implicit_info)

    avg_explicit_info = hint_moves["total_explicit_info"].mean()
    avg_implicit_info = hint_moves["total_implicit_info"].mean()
    game_explicit_info = hint_moves["total_explicit_info"].sum()
    game_implicit_info = hint_moves["total_implicit_info"].sum()

    results["avg_explicit_info"] = avg_explicit_info
    results["avg_implicit_info"] = avg_implicit_info
    results["total_explicit_info"] = game_explicit_info
    results["total_implicit_info"] = game_implicit_info

    return results, hint_moves


if __name__ == '__main__':
    seeds = get_seeds()
    logging.info(seeds)
    logging.info("For {} players, {} simulations have been run".\
        format(num_players, len(seeds)))

    missing_seeds = [s for s in range(max_seed) if not s in seeds]
    if (len(missing_seeds) > 0):
        logging.info("The following seeds are missing: {}".\
            format(missing_seeds))

    all_games = pd.DataFrame()

    # analyze one game at a time
    for seed in seeds:
        results, hint_moves = process_game(seed)
        results["seed"] = seed
        res = {k: [v] for k, v in results.items()}
        results_df = pd.DataFrame.from_dict(res)
        all_games = pd.concat([all_games, results_df], ignore_index=True)
