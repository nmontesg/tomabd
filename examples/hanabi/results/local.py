import pandas as pd
import numpy as np
import math
import os
import logging

from itertools import product

logging.basicConfig(level=logging.INFO)

# global variables
results_parent_path = "/home/nmontes/OneDrive/Documentos/PhD/hanabi-results"
num_players = 2
path = "{}/{}_players".format(results_parent_path, num_players)
slots_per_player = 5 if num_players == 2 or num_players == 3 else 4
max_seed = 500


def get_seeds():
    seeds = [int(folder.split('_')[-1]) for folder in os.listdir(path)]
    simulation_runs = len(seeds)
    print("For {} players, {} simulations have been run".format(num_players, simulation_runs))
    missing_seeds = [s for s in range(max_seed) if not s in seeds]
    print("The following seeds are missing:", *missing_seeds)
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
        assert n > 0, "probability distribution for slot {} is ill-defined".format(slot)
    prob = df.apply(lambda x: x.num/den[x.slot], axis=1)
    df.insert(df.shape[1], "prob", prob)


def kullback_leibler_distance(Q, P, slot, base=10):
    colors = ["red", "green", "white", "blue", "yellow"]
    ranks = [1, 2, 3, 4, 5]
    D_kl = 0
    for c, r in product(colors, ranks):
        Q_prob = Q.loc[(Q["slot"] == slot) & (Q["color"] == c) & (Q["rank"] == r), "prob"].iloc[0]
        P_prob = P.loc[(P["slot"] == slot) & (P["color"] == c) & (P["rank"] == r), "prob"].iloc[0]
        if np.isclose(P_prob, 0, atol=1.0E-9):
            continue
        D_kl += P_prob * math.log(P_prob/Q_prob, base)
    return D_kl


def process_hint(hint_move, base=10):
    move = hint_move["move"]
    receiver = hint_move["receiver"]

    # compute information gain by the EXPLICIT knowledge conveyed by the hint
    pre_action_file = "{}/results_{}_{}/{}_{}_false.csv".format(path, num_players, seed, receiver, move)
    post_action_file = "{}/results_{}_{}/{}_{}_false.csv".format(path, num_players, seed, receiver, move+1)

    pre_action_distribution = pd.read_csv(pre_action_file, sep=';')
    post_action_distribution = pd.read_csv(post_action_file, sep=';')

    compute_probability(pre_action_distribution)
    compute_probability(post_action_distribution)

    explicit_info_mre = {}
    for s in range(1, slots_per_player+1):
        explicit_info_mre[s] = kullback_leibler_distance(pre_action_distribution, post_action_distribution, s, base=base)

    # compute information gain by the IMPLICIT knowledge conveyed by the hint
    post_explanation_file = "{}/results_{}_{}/{}_{}_true.csv".format(path, num_players, seed, receiver, move+1)
    try:
        post_explanation_distribution = pd.read_csv(post_explanation_file, sep=';')
    except FileNotFoundError:
        return explicit_info_mre, {}
    
    try:
        compute_probability(post_explanation_distribution)
    except AssertionError:
        return explicit_info_mre, {}

    implicit_info_mre = {}
    for s in range(1, slots_per_player+1):
        implicit_info_mre[s] = kullback_leibler_distance(post_action_distribution, post_explanation_distribution, s)

    return explicit_info_mre, implicit_info_mre


def focus_slot(d):
    if not d:
        return None
    elif np.isclose(sum(d.values()), 0, atol=1.0E-5):
        return None
    else:
        return max(d, key=d.get)


if __name__ == '__main__':
    # seeds = get_seeds()
    seeds = [5]
    # overall_results = pd.DataFrame(
    #     columns=[
    #         "seed", "moves", "score", "hints", "efficiency",
    #         "hints_w_implicit", "avg_explicit_info", "avg_implicit_info"
    #     ]
    # )

    # analyze one game
    for seed in seeds:
        evolution_file = "{}/{}_players/results_{}_{}/evolution.csv".format(results_parent_path, num_players, num_players, seed)
        evolution = pd.read_csv(evolution_file, sep=';', on_bad_lines='warn')

        # find the basic results
        moves = evolution["move"].iloc[-1]
        final_score = evolution["score"].iloc[-1]
        total_hints = evolution["hints"].iloc[-1]
        efficiency = final_score / total_hints

        logging.info("SEED {}".format(seed))
        logging.info("Moves: {}".format(moves))
        logging.info("Score: {}".format(final_score))
        logging.info("Hints: {}".format(total_hints))
        logging.info("Efficiency: {:.2f}%".format(efficiency*100))

        # find the game moves where hints were given
        hint_moves = evolution.loc[evolution["action_functor"] == "give_hint"]
        receiver = hint_moves["actions_args"].apply(lambda s: get_arg(s, 0, ','))
        hint_moves.insert(hint_moves.shape[1], "receiver", receiver)

        # find the gain in explicit and implicit information
        info_gain = []
        bypass_seed = False
        for _, h in hint_moves.iterrows():
            try:
                ig = process_hint(h)
                info_gain.append(ig)
            except AssertionError as e:
                logging.info(e)
                logging.info("Assertion error for seed {}".format(seed))
                logging.info("Error in hint:")
                logging.info(h)
                bypass_seed = True
                break
        
        if bypass_seed:
            continue
                
        explicit_info_gain = [x[0] for x in info_gain]
        implicit_info_gain = [x[1] for x in info_gain]

        focus_slots = [focus_slot(d) for d in implicit_info_gain]
        hint_with_impl_info = len([i for i in focus_slots if i is not None])/len(focus_slots)

        hint_moves.insert(hint_moves.shape[1], "explicit_info_gain", explicit_info_gain)
        hint_moves.insert(hint_moves.shape[1], "implicit_info_gain", implicit_info_gain)
        hint_moves.insert(hint_moves.shape[1], "focus_slot", focus_slots)

        # find the total gain in implicit and explicit information per hint
        total_explicit_info = hint_moves["explicit_info_gain"].apply(lambda x: sum(x.values()))
        total_implicit_info = hint_moves["implicit_info_gain"].apply(lambda x: sum(x.values()))

        hint_moves.insert(hint_moves.shape[1], "total_explicit_info", total_explicit_info)
        hint_moves.insert(hint_moves.shape[1], "total_implicit_info", total_implicit_info)

        # find the average gain in implicit and explicit information per hint
        # throughout the whole game
        avg_explicit_info = hint_moves["total_explicit_info"].mean()
        avg_implicit_info = hint_moves["total_implicit_info"].mean()

        # save the computations concerning the hints
        hint_moves_file = "{}/{}_players/results_{}_{}/hint_moves.csv".format(results_parent_path, num_players, num_players, seed)
        hint_moves.to_csv(hint_moves_file, sep=';')

    #     overall_results.loc[overall_results.shape[0]] = [
    #         seed, moves, final_score, total_hints, efficiency,
    #         hint_with_impl_info, avg_explicit_info, avg_implicit_info
    #     ]
    
    # overall_results.to_csv("2_players.csv", sep=';')
    