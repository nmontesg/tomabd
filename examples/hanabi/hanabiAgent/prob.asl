@initializeProbabilityDistributions[domain(hanabi), atomic]
+!initialize_probability_distributions : .my_name(Me)
    <- .perceive;
    .findall(x(S, C, R), slot(S) & color(C) & rank(R), LX);

    // initially all probability distributions are equal for all slots
    // because they only consider information on the other player's cards
    for ( .member(M, LX) ) {
        M = x(S, C, R);
        ?disclosed_cards(C, R, Me, _, N1);
        ?cards_per_rank(R, N2);
        +possible_cards(S, C, R, N2-N1);
    }
    hanabiAgent.log_prob_dist(false).


// when I reveal a card and learn of its identity, I have to diminish its
// number by one in all other slots
@updateProbabilityDistributionsUponReveal[domain(hanabi), atomic]
+!update_probability_distributions_upon_reveal(Slot) : .my_name(Me)
    <- .perceive;
    ?has_card_color(Me, Slot, Color);
    ?has_card_rank(Me, Slot, Rank);

    .findall(
        possible_cards(S, Color, Rank, N),
        possible_cards(S, Color, Rank, N) & slot(S) & S \== Slot & N > 0,
        LB
    );

    for ( .member(M, LB) ) {
        M = possible_cards(Sl, Color, Rank, Num);
        -possible_cards(Sl, Color, Rank, Num);
        +possible_cards(Sl, Color, Rank, Num-1);
    }.



// when I replace a card, reset its probability distribution
@resetProbabilityDistribution[domain(hanabi), atomic]
+!reset_probability_distribution(Slot) : my_name(Me)
    <- .abolish(possible_cards(Slot, _, _, _));
    .perceive;
    .findall(x(C, R), color(C) & rank(R), LX);

    for ( .member(M, LX) ) {
        M = x(C, R);
        ?disclosed_cards(C, R, Me, Slot, N1);
        ?cards_per_rank(R, N2);
        +possible_cards(Slot, C, R, N2-N1);
    }.


// when another player replaces a card, I reduce by one the possibility of that
// card in all my slots
@updateProbabilityDistributionsAfterReplacement[domain(hanabi), atomic]
+!update_probability_distributions_after_replacement(Slot) [source(Agent)] : .my_name(Me)
    <- .perceive;
    ?has_card_color(Agent, Slot, Color);
    ?has_card_rank(Agent, Slot, Rank);
    .findall(
        possible_cards(S, Color, Rank, N),
        possible_cards(S, Color, Rank, N) & N > 0,
        L
    );
    for ( .member(M, L) ) {
        M = possible_cards(S, Color, Rank, N);
        -possible_cards(S, Color, Rank, N);
        +possible_cards(S, Color, Rank, N-1);
    }.


@updateExplicitHintInfo1[domain(hanabi), atomic]
+!update_probability_explicit_hint(HintInfo) : .my_name(Me) & HintInfo = has_card_color(Me, Slot, Color) [source(hint)]
    <- .findall(x(C, R), color(C) & C \== Color & rank(R), LX);
    for ( .member(M, LX) ) {
        M = x(C, R);
        ?possible_cards(Slot, C, R, N);
        -possible_cards(Slot, C, R, N);
        +possible_cards(Slot, C, R, 0);
    }.


@updateExplicitHintInfo2[domain(hanabi), atomic]
+!update_probability_explicit_hint(HintInfo) : .my_name(Me) & HintInfo = ~has_card_color(Me, Slot, Color) [source(hint)]
    <- .findall(R, rank(R), LR);
    for ( .member(R, LR) ) {
        ?possible_cards(Slot, Color, R, N);
        -possible_cards(Slot, Color, R, N);
        +possible_cards(Slot, Color, R, 0);
    }.


@updateExplicitHintInfo3[domain(hanabi), atomic]
+!update_probability_explicit_hint(HintInfo) : .my_name(Me) & HintInfo = has_card_rank(Me, Slot, Rank) [source(hint)]
    <- .findall(x(C, R), color(C) & rank(R) & R \== Rank, LX);
    for ( .member(M, LX) ) {
        M = x(C, R);
        ?possible_cards(Slot, C, R, N);
        -possible_cards(Slot, C, R, N);
        +possible_cards(Slot, C, R, 0);
    }.


@updateExplicitHintInfo4[domain(hanabi), atomic]
+!update_probability_explicit_hint(HintInfo) : .my_name(Me) & HintInfo = ~has_card_rank(Me, Slot, Rank) [source(hint)]
    <- .findall(C, color(C), LC);
    for ( .member(C, LC) ) {
        ?possible_cards(Slot, C, Rank, N);
        -possible_cards(Slot, C, Rank, N);
        +possible_cards(Slot, C, Rank, 0);
    }.
