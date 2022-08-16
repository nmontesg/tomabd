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
    }
    !log_all_distributions(false).


// when I reveal a card and learn of its identity, I have to diminish its
// number by one in all other slots
@updateProbabilityDistributionsUponReveal[domain(hanabi),atomic]
+!update_probability_distributions_upon_reveal(Slot) : .my_name(Me)
    <- ?has_card_color(Me, Slot, Color);
    ?has_card_rank(Me, Slot, Rank);

    .findall(C, color(C), Colors);
    .findall(R, rank(R), Ranks);
    ?cards_per_player(NC);

    for ( .range(S, 1, NC) ) {
        if (S \== Slot) {
            for ( .member(IC, Colors) ) {
                for ( .member(IR, Ranks) ) {
                    if (possible_cards(S, IC, IR, N) & N > 0) {
                        -+possible_cards(S, IC, IR, N-1);
                    }
                }
            }
        }
    }.


// when I replace a card, reset its probability distribution
@resetProbabilityDistribution[domain(hanabi),atomic]
+!reset_probability_distribution(Slot) : my_name(Me)
    <- .perceive;
    .findall(C, color(C), Colors);
    .findall(R, rank(R), Ranks);

    for ( .member(IC, Colors) ) {
        for ( .member(IR, Ranks) ) {
            ?disclosed_cards(IC, IR, Me, _, N1);
            ?cards_per_rank(IR, N2);
            -+possible_cards(S, IC, IR, N2-N1);
        }
    }.


// when another player replaces a card, I reduce by one the possibility of that
// card in all my slots
@updateProbabilityDistributionsAfterReplacement[domain(hanabi),atomic]
+!update_probability_distributions_after_replacement(Slot) [source(Agent)] : .my_name(Me)
    <- ?has_card_color(Agent, Slot, Color);
    ?has_card_rank(Agent, Slot, Rank);
    .findall(possible_cards(S, Color, Rank, N), possible_cards(S, Color, Rank, N), L);
    for ( .member(M, L) ) {
        M =.. [possible_cards, [S, Color, Rank, N], _];
        if ( Num > 0 ) {
            -+possible_cards(S, Color, Rank, N-1);
        }
    }.



// write all the probability distributions in the logger
@logAllDistributionsMe[domain(hanabi),atomic]
+!log_all_distributions(Bool) [source(self)]
    <- .findall(possible_cards(S, C, R, N), possible_cards(S, C, R, N), L);
    for ( .member(M, L) ) {
        M =.. [possible_cards, [Slot, Color, Rank, Num], _];
        log_probability(Slot, Color, Rank, Num, Bool);
    }.

@logAllDistributionsOther[domain(hanabi),atomic]
+!log_all_distributions(Bool) [source(Other)] : .my_name(Me) & Me \== Other
    <- .findall(possible_cards(S, C, R, N), possible_cards(S, C, R, N), L);
    for ( .member(M, L) ) {
        M =.. [possible_cards, [Slot, Color, Rank, Num], _];
        log_probability(Slot, Color, Rank, Num, Bool);
    }.

    // TODO: look for abductive explanations
    // if there is some abductive explanation, update the probability distributions
    // accordingly and write in the log with true
    