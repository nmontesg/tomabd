/* ----------------------- ABDUCTIVE REASONING STEPS ----------------------- */

abduce(Goal1 & Goal2, Delta0, Delta) [domain(independent)] :-
    tomabd.misc.expr_operator(Goal1 & Goal2, "and") &
    abduce(Goal1, Delta0, Delta1) &
    abduce(Goal2, Delta1, Delta).

abduce(Goal, Delta, Delta) [domain(independent)] :-
    not tomabd.misc.expr_operator(Goal, _) & Goal.

abduce(Goal, Delta, Delta) [domain(independent)] :-
    not tomabd.misc.expr_operator(Goal, _) & not Goal &
    abducible(Goal) & .member(Goal, Delta).

abduce(Goal, Delta, [Goal|Delta]) [domain(independent)] :-
    not tomabd.misc.expr_operator(Goal, _) & not Goal &
    abducible(Goal) & not .member(Goal, Delta).

abduce(Goal, Delta0, Delta) [domain(independent)] :-
    not tomabd.misc.expr_operator(Goal, _) & not Goal & not abducible(Goal) &
    .relevant_rules(Goal, RL) & .length(RL, N) & N > 0 & .member(R, RL) &
    tomabd.misc.unify_goal_rule(Goal, R, UnifiedR) & 
    tomabd.misc.rule_head_body(UnifiedR, _, Body) &
    abduce(Body, Delta0, Delta).

// this is a domain-independent ToM rule to ensure that the abductive reasoning
// steps are carried over when switching viewpoints

believes(_, Rule) [domain(independent)] :-
    tomabd.misc.rule(Rule) &
    tomabd.misc.rule_head_body(Rule, Head, _) &
    tomabd.misc.get_annots(Head, Annots) &
    .member(domain(independent), Annots).
