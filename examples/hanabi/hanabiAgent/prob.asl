@initializeProbabilityDistributions[domain(hanabi),atomic]
+!initialize_probability_distributions : .my_name(Me)
    <- .perceive;
    .findall(C, color(C), Colors);
    .findall(R, rank(R), Ranks);

    ?num_total_cards(AllCards);
    ?cards_per_player(NC);
    UnknownCards = AllCards-NC;

    // initially all probability distributions are equal for all slots
    // because they only consider information on the other player's cards
    for ( .range(S, 1, NC) ) {
        for ( .member(IC, Colors) ) {
            for ( .member(IR, Ranks) ) {
                ?disclosed_cards(IC, IR, Me, _, N1);
                ?cards_per_rank(IR, N2);
                +possible_cards(S, IC, IR, N2-N1);
            }
        }
    }.
