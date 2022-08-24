{ include("hanabiAgent/actions.asl") }              // plans to perform actions on the environment
{ include("hanabiAgent/strategy.asl") }             // action selection clauses
{ include("hanabiAgent/rules.asl") }                // auxiliary clauses
// { include("hanabiAgent/prob.asl") }                 // probability distributions

domain(hanabi).

/* ---------- Plan to initialize ordered slots for all players ---------- */

!get_ready.

@getReady[domain(hanabi), atomic]
+!get_ready

    : seed(Seed) & .my_name(Me) & num_players(NP) & cards_per_player(N)
    
    <- .set_random_seed(Seed);

    // add own identity as a belief
    +my_name(Me);

    // initialize slots for players from oldest to newest
    .findall(Ag, player(Ag), PlayerList);
    .findall(X, .range(X, 1, N), SlotList);
    for ( .member(P, PlayerList) ) {
        +ordered_slots(P, SlotList);
    }

    // initialize probability distributions for all the slots
    // !initialize_probability_distributions;
    
    // inform that I am ready to start the game
    inform_ready.


/* ----------------------- General turn-taking plans ----------------------- */


all_minus_me(L) [domain(hanabi)] :-
    .all_names(L0) & .my_name(Me) & .delete(Me, L0, L1) & .sort(L1, L).


@takeTurn[domain(hanabi)]
+player_turn(Me) : .my_name(Me) //& .my_name(alice)
    <-
    !select_action;
    .wait(all_minus_me(L) & .findall(Src, abduction_finished [source(Src)], L0) & .sort(L0, L));
    !perform_action;
    finish_turn.


@selectAction[domain(hanabi), atomic]
+!select_action : .my_name(Me)
    <- tomabd.agent.select_action(Action, Priority);
    .log(info, Action, " (", Priority, ")");
    +selected_action(Action);
    .broadcast(publicAction, Action).


@selectActionFailure1[domain(hanabi), atomic]
-!select_action : .my_name(Me) & spent_info_tokens
    <- ?ordered_slots(Me, [H|_]);
    Action = discard_card(H);
    .log(info, Action, " (fail) ");
    +selected_action(Action);
    .broadcast(publicAction, Action).


@selectActionFailure2[domain(hanabi), atomic]
-!select_action : .my_name(Me) & not spent_info_tokens
    <- ?ordered_slots(Me, [H|_]);
    Action = play_card(H);
    .log(info, Action, " (fail) ");
    +selected_action(Action);
    .broadcast(publicAction, Action).


@otherFailure[domain(hanabi), atomic]
-!Goal : seed(Seed)
    <- .log(info, "\n\npremature stop of game with seed ", Seed);
    .stopMAS.


@performAction[domain(hanabi), atomic]
+!perform_action
    <- ?selected_action(Action);
    .abolish(selected_action(_));
    .abolish(abduction_finished);
    !Action.


@kqmlReceivedHint[domain(hanabi), atomic]
+!kqml_received(KQML_Sender_Var, hint, KQML_Content_Var, KQML_MsgId) : .my_name(Me)
    <- .add_annot(KQML_Content_Var, source(hint), H);
    +H.


@kqmlReceivedPublicAction[domain(hanabi), atomic]
+!kqml_received(KQML_Sender_Var, publicAction, Action, KQML_MsgId) : .my_name(Me)
    <-
    if ( Action = give_hint(HintedPlayer, Mode, Value, SlotList) ) {
        .concat("has_card_", Mode, String);
        .term2string(Term, String);
        ?cards_per_player(N);
        for ( .range(S, 1, N) ) {
            Belief =.. [Term, [HintedPlayer, S, Value], [source(aux)]];
            if ( .member(S, SlotList) ) {
                +Belief;
            } else {
                +(~Belief);
            }
        }
    }

    // first-order Theory of Mind -- abduction task
    tomabd.agent.tom_abduction_task(
        [],
        KQML_Sender_Var, Action, ActExpls, ObsExpls, ActTomRule, ObsTomRule
    );

    if ( .type(ActTomRule, literal) ) {
        +ActTomRule;
    }
    if ( .type(ObsTomRule, literal) ) {
        +ObsTomRule;
    }

    if ( Action = give_hint(HintedPlayer, Mode, Value, SlotList) ) {
        .concat("has_card_", Mode, String);
        .term2string(Term, String);
        ?cards_per_player(N);
        for ( .range(S, 1, N) ) {
            Belief =.. [Term, [HintedPlayer, S, Value], [source(aux)]];
            if ( .member(S, SlotList) ) {
                -Belief;
            } else {
                -(~Belief);
            }
        }
    }

    .send(KQML_Sender_Var, tell, abduction_finished).


knows(Ag, Fact [source(aux)]) [domain(hanabi)] :- player(Ag) & Fact [source(aux)].


/* ------------------------------ ABDUCIBLES ------------------------------ */

abducible(has_card_color(Player, Slot, C)) [domain(hanabi)] :-
    player(Player) & my_name(Me) & Player \== Me &
    slot(Slot) & color(C) &
    not has_card_color(Player, Slot, _) &
    not ~has_card_color(Player, Slot, C).

abducible(has_card_rank(Player, Slot, R)) [domain(hanabi)] :-
    player(Player) & my_name(Me) & Player \== Me &
    slot(Slot) & rank(R) &
    my_name(Me) & Player \== Me &
    not has_card_rank(Player, Slot, _) & 
    not ~has_card_rank(Player, Slot, R).



/* ------------------------ THEORY OF MIND CLAUSES ------------------------ */

knows(Ag, my_name(Ag) [source(self)]) [domain(hanabi)].
knows(Ag, domain(hanabi) [source(self)]) [domain(hanabi)].


// Percepts: Except Ag's own cards, all other percepts are shared.
// has_card_color and has_card_rank are only available to Ag as percepts if
// they don't refer to Ag's own cards.

knows(Ag, P [source(percept)]) [domain(hanabi)] :-
    player(Ag) & 
    P [source(percept)] &
    P =.. [Functor, _, _] &
    Functor \== has_card_color &
    Functor \== has_card_rank.

knows(Agi, has_card_color(Agj, S, C) [source(percept)]) [domain(hanabi)] :-
    player(Agi) & player(Agj) & Agi \== Agj & slot(S) & color(C) &
    has_card_color(Agj, S, C) [source(percept)].

knows(Agi, has_card_rank(Agj, S, R) [source(percept)]) [domain(hanabi)] :-
    player(Agi) & player(Agj) & Agi \== Agj & slot(S) & rank(R) &
    has_card_rank(Agj, S, R) [source(percept)].

knows(Ag, has_card_color(Me, S, C) [source(percept)]) [domain(hanabi)] :-
    player(Ag) & my_name(Me) & slot(S) & color(C) &
    has_card_color(Me, S, C) [source(percept)].

knows(Ag, has_card_rank(Me, S, R) [source(percept)]) [domain(hanabi)] :-
    player(Ag) & my_name(Me) & slot(S) & rank(R) &
    has_card_rank(Me, S, R) [source(percept)].

// Hints: information explicitly derived from hints is available to all other agents

knows(Ag, P [source(hint)]) [domain(hanabi)] :- player(Ag) & P [source(hint)].

// Mental notes: as all agents share the same code, they all make the same
// mental notes, which refer to the hints given and the ordered slots of
// the players

knows(Ag, hint(Id, FromPlayer, ToPlayer, Mode, Value, Slots) [source(self)]) [domain(hanabi)] :-
    player(Ag) & hint(Id, FromPlayer, ToPlayer, Mode, Value, Slots) [source(self)].

knows(Agi, ordered_slots(Agj, Slots) [source(self)]) [domain(hanabi)] :-
    player(Agi) & player(Agj) & ordered_slots(Agj, Slots) [source(self)].

// all other agents know have the same clauses as myself, including tom clauses,
// domain-related ICs, etc. This is made explicit now.

knows(Ag, Rule) [domain(hanabi)] :-
    player(Ag) &
    tomabd.misc.rule(Rule) &
    tomabd.misc.rule_head_body(Rule, Head, _) &
    tomabd.misc.get_annots(Head, Annots) &
    .member(domain(hanabi), Annots).


/* ------------------- DOMAIN-DEPENDENT IMPOSSIBILITIES ------------------- */

imp [domain(hanabi)] :-
    player(P) & slot(S) & color(C) &
    has_card_color(P, S, C) & ~has_card_color(P, S, C).

imp [domain(hanabi)] :-
    player(P) & slot(S) & rank(R) &
    has_card_rank(P, S, R) & ~has_card_rank(P, S, R).

imp [domain(hanabi)] :-
    player(P) & slot(S) & color(C1) & color(C2) & C1 \== C2 &
    has_card_color(P, S, C1) & has_card_color(P, S, C2).

imp [domain(hanabi)] :-
    player(P) & slot(S) & rank(R1) & rank(R2) & R1 \== R2 &
    has_card_rank(P, S, R1) & has_card_rank(P, S, R2).


// An agent can only have a card of Color and Rank at any
// Slot if the number of cards of that Color and Rank that have
// been disclosed to the agent everywhere EXCEPT that Slot do not add up to the
// total number of cards of Rank

imp [domain(hanabi)] :-
    player(P) & slot(S) & color(C) & rank(R) &
    has_card_color(P, S, C) & has_card_rank(P, S, R) &
    disclosed_cards(C, R, P, S, N) & cards_per_rank(R, N).
