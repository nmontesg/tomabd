/* ---------- Plans for basic game actions ---------- */

play_card(S) :- slot(S).
discard_card(S) :- slot(S).
give_hint(P, rank, R, SL) :-
    my_name(Me) & player(P) & P \== Me & rank(R) & common_slots(P, R, SL).
give_hint(P, color, C, SL) :-
    my_name(Me) & player(P) & P \== Me & color(C) & common_slots(P, C, SL).


// these are procedural plans to take direct action in the game
// process the explicit information conveyed by the action (ordered slots update)

// abduction must happen BEFORE the agent performs the action, because all
// other players have to abduce with the state of the game as it is when
// the action is selected, i.e. BEFORE it is performed


@playCard[domain(hanabi), atomic]
+!play_card(Slot) : my_name(Me)
    <- reveal_card(Slot);
    play_card(Slot);
    .broadcast(achieve, remove_hint_info(Me, Slot));
    !remove_hint_info(Me, Slot);
    .broadcast(achieve, update_slots(took_card(Slot)));
    !update_slots(took_card(Slot));
    !replace_card(Slot).

    
@discardCard[domain(hanabi), atomic]
+!discard_card(Slot) : my_name(Me)
    <- reveal_card(Slot);
    discard_card(Slot);
    .broadcast(achieve, remove_hint_info(Me, Slot));
    !remove_hint_info(Me, Slot);
    .broadcast(achieve, update_slots(took_card(Slot)));
    !update_slots(took_card(Slot));
    !replace_card(Slot).


@giveHint[domain(hanabi), atomic]
+!give_hint(HintedPlayer, Mode, Value, SlotList) : my_name(Me)
    <- .concat("has_card_", Mode, String);
    .term2string(Term, String);
    ?cards_per_player(N);
    for ( .range(S, 1, N) ) {
        Belief =.. [Term, [HintedPlayer, S, Value], [source(hint)]];
        if ( .member(S, SlotList) ) {
            .broadcast(hint, Belief);
            +Belief;
        } else {
            .broadcast(hint, ~Belief);
            +(~Belief);
        }
    }
    spend_info_token(HintedPlayer, Mode, Value, SlotList).


@replaceCard1[domain(hanabi), atomic]
+!replace_card(Slot) : num_cards_deck(D) & D > 0
    <- draw_random_card(Slot);
    .broadcast(achieve, update_slots(placed_card(Slot)));
    !update_slots(placed_card(Slot)).


@replaceCard2[domain(hanabi), atomic]
+!replace_card(Slot) : num_cards_deck(0) & my_name(Me)
    <- .abolish(has_card_color(Me, Slot, _));
    .abolish(~has_card_color(Me, Slot, _));
    .abolish(has_card_rank(Me, Slot, _));
    .abolish(~has_card_rank(Me, Slot, _)).


@updateSlots1[domain(hanabi), atomic]
+!update_slots(took_card(Slot)) [source(self)] : my_name(Me)
    <- ?ordered_slots(Me, L);
    .nth(N, L, Slot);
    .delete(N, L, Lprime);
    -ordered_slots(Me, _);
    +ordered_slots(Me, Lprime).


@updateSlots2[domain(hanabi), atomic]
+!update_slots(took_card(Slot)) [source(Player)] : Player \== self
    <- ?ordered_slots(Player, L);
    .nth(N, L, Slot);
    .delete(N, L, Lprime);
    -ordered_slots(Player, _);
    +ordered_slots(Player, Lprime).


@updateSlots3[domain(hanabi), atomic]
+!update_slots(placed_card(Slot)) [source(self)] : my_name(Me)
    <- ?ordered_slots(Me, L);
    .concat(L, [Slot], Lprime);
    -ordered_slots(Me, _);
    +ordered_slots(Me, Lprime).


@updateSlots4[domain(hanabi), atomic]
+!update_slots(placed_card(Slot)) [source(Player)] : Player \== self
    <- ?ordered_slots(Player, L);
    .concat(L, [Slot], Lprime);
    -ordered_slots(Player, _);
    +ordered_slots(Player, Lprime).


@removeHintInfo[domain(hanabi), atomic]
+!remove_hint_info(Player, Slot)
    <- .abolish(has_card_color(Player, Slot, _) [source(hint)]);
    .abolish(~has_card_color(Player, Slot, _) [source(hint)]);
    .abolish(has_card_rank(Player, Slot, _) [source(hint)]);
    .abolish(~has_card_rank(Player, Slot, _) [source(hint)]).
