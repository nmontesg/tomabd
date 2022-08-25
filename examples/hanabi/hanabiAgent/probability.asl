impossible(Slot, Color, _) [domain(hanabi)] :-
    .my_name(Me) & ~has_card_color(Me, Slot, Color).

impossible(Slot, Color, _) [domain(hanabi)] :-
    .my_name(Me) & has_card_color(Me, Slot, ColorP) & ColorP \== Color.

impossible(Slot, _, Rank) [domain(hanabi)] :-
    .my_name(Me) & ~has_card_rank(Me, Slot, Rank).

impossible(Slot, _, Rank) [domain(hanabi)] :-
    .my_name(Me) & has_card_rank(Me, Slot, RankP) & RankP \== Rank.



// find the slot that an explanation refers to
explanation_components(Explanation, Predicate, Slot, Values) :-
    .my_name(Me) &
    .findall(
        x(S, Pred, V),
        .member(F, Explanation) & F =.. [Pred, [Me, S, V], _],
        L
    ) &
    .setof(M1, .member(M, L) & M = x(M1, _, _), LS) & LS = [Slot] &
    .setof(M2, .member(M, L) & M = x(_, M2, _), LP) & LP = [Predicate] &    
    .setof(M3, .member(M, L) & M = x(_, _, M3), Values).


impossible(Slot, Color, _) [domain(hanabi)] :-
    tomabd.misc.rule(Rule) &
    tomabd.misc.rule_head_body(Rule, Head, _) &
    tomabd.misc.get_annots(Head, [expl(Explanation), source(abduction)]) &
    explanation_to_list(Explanation, ExplL) &
    explanation_components(ExplL, has_card_color, Slot, LC) &
    not .member(Color, LC).

impossible(Slot, _, Rank) [domain(hanabi)] :-
    tomabd.misc.rule(Rule) &
    tomabd.misc.rule_head_body(Rule, Head, _) &
    tomabd.misc.get_annots(Head, [expl(Explanation), source(abduction)]) &
    explanation_to_list(Explanation, ExplL) &
    explanation_components(ExplL, has_card_rank, Slot, LR) &
    not .member(Rank, LR).


@logProbabilityDistributions[domain(hanabi), atomic]
+!log_probability_distributions(Bool) : .my_name(Me)
    <- .findall(x(S, C, R), slot(S) & color(C) & rank(R), L);
    for ( .member(M, L) ) {
        M = x(S, C, R);
        if ( impossible(S, C, R) ) {
            +possible_cards(S, C, R, 0);
        } else {
            ?cards_per_rank(R, N1);
            ?disclosed_cards(C, R, Me, S, N2);
            +possible_cards(S, C, R, N1-N2);
        }
    }
    hanabiAgent.log_prob_dist(Bool);
    .abolish(possible_cards(_, _, _, _)).


@logProbability1[domain(hanabi), atomic]
+!log_probability

    : .my_name(Me) & latest_abductive_rule(IC)

    <- !log_probability_distributions(false);
    +IC;
    .abolish(latest_abductive_rule(_));
    !log_probability_distributions(true).


@logProbability2[domain(hanabi), atomic]
+!log_probability : .my_name(Me) & not latest_abductive_explanation(_)
    <- !log_probability_distributions(false).


explanation_to_list(F, [F]) :-
    not tomabd.misc.expr_operator(F, _).
explanation_to_list(F1 | F2, [F1|T]) :-
    tomabd.misc.expr_operator((F1 | F2), "or") &
    explanation_to_list(F2, T).