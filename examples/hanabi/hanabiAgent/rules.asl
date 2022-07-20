// Prolog-like rules. Clauses that apply to the domain under study.

{ include("common_slots.asl") }

/* ------------------------------------------------------------------------- */

~has_card_color(Player, Slot, C1) [domain(hanabi)] :-
    player(Player) & slot(Slot) & color(C1) & color(C2) & C1 \== C2 &
    has_card_color(Player, Slot, C2).

~has_card_rank(Player, Slot, R1) [domain(hanabi)] :-
    player(Player) & slot(Slot) & rank(R1) & rank(R2) & R1 \== R2 &
    has_card_rank(Player, Slot, R2).

// number of cards that have been disclosed to me EXCEPT the identity of the 
// card of Player at position Slot

disclosed_cards(Color, Rank, Player, Slot, N) [domain(hanabi)] :-
    color(Color) & rank(Rank) & player(Player) & slot(Slot) &
    .findall(
        has_card(P, S, Color, Rank),
        has_card_color(P, S, Color) & has_card_rank(P, S, Rank) & slot(S) & P \== Player,
        L1
    ) & .length(L1, N1) &
    .findall(
        has_card(Player, S, Color, Rank),
        has_card_color(Player, S, Color) & has_card_rank(Player, S, Rank) & S \== Slot,
        L2
    ) & .length(L2, N2) &
    discarded(Color, Rank, N3) &
    card_in_stack(Color, Rank, N4) &
    N = N1+N2+N3+N4.

card_in_stack(Color, Rank, 0) [domain(hanabi)] :- stack(Color, Stack) & Stack < Rank.
card_in_stack(Color, Rank, 1) [domain(hanabi)] :- stack(Color, Stack) & Stack >= Rank.


// how many turns ahead of me is another player
turns_ahead(Player, Diff) [domain(hanabi)] :-
    my_name(Me) & turn_number(Me, T1) &
    turn_number(Player, T2) & T2 >= T1 &
    Diff = T2-T1.

turns_ahead(Player, Diff) [domain(hanabi)] :-
    my_name(Me) & turn_number(Me, T1) &
    turn_number(Player, T2) & T2 < T1 &
    num_players(NP) & Diff = T2-T1+NP.


available_info_tokens [domain(hanabi)] :- num_info_tokens(Tokens) & Tokens > 0.
spent_info_tokens [domain(hanabi)] :- max_info_tokens(Max) & num_info_tokens(Tokens) & Tokens < Max.

// unhinted means that no positive explicit information has been conveyed
// by a hint on that card
unhinted_slot(Player, Slot) [domain(hanabi)] :-
    not has_card_color(Player, Slot, _) [source(hint)] &
    not has_card_rank(Player, Slot, _) [source(hint)].

hinted_slot(Player, Slot) [domain(hanabi)] :- has_card_color(Player, Slot, _) [source(hint)].
hinted_slot(Player, Slot) [domain(hanabi)] :- has_card_rank(Player, Slot, _) [source(hint)].

partially_hinted(Player, Slot, color) [domain(hanabi)] :-
    has_card_color(Player, Slot, _) [source(hint)] &
    not has_card_rank(Player, Slot, _) [source(hint)].

partially_hinted(Player, Slot, rank) [domain(hanabi)] :-
    not has_card_color(Player, Slot, _) [source(hint)] &
    has_card_rank(Player, Slot, _) [source(hint)].

totally_hinted(Player, Slot) [domain(hanabi)] :-
    has_card_color(Player, Slot, _) [source(hint)] &
    has_card_rank(Player, Slot, _) [source(hint)].


// unhinted cards means that there is no other card that, if hinted, shares
// the same color and rank with the unhinted card
// we can use the metapredicate .findall for this rule because it calls it
// on literals that are annotated with source(hint)
no_share_color(_, []) [domain(hanabi)].
no_share_color(Color, [ps(Player, Slot)|T]) [domain(hanabi)] :-
    (not has_card_color(Player, Slot, Color) | ~has_card_color(Player, Slot, Color)) &
    no_share_color(Color, T).
no_share_rank(_, []) [domain(hanabi)].
no_share_rank(Rank, [ps(Player, Slot)|T]) [domain(hanabi)] :-
    (not has_card_rank(Player, Slot, Rank) | ~has_card_rank(Player, Slot, Rank)) &
    no_share_rank(Rank, T).

unhinted(Color, Rank) [domain(hanabi)] :-
    .findall(ps(P1, S1), has_card_color(P1, S1, Color) [source(hint)], CommonColorHint) &
    no_share_rank(Rank, CommonColorHint) &
    .findall(ps(P2, S2), has_card_rank(P2, S2, Rank) [source(hint)], CommonRankHint) &
    no_share_color(Color, CommonRankHint).


// the chop position for a player is the oldest unhinted slot
chop(Player, Chop) [domain(hanabi)] :-
    player(Player) & ordered_slots(Player, OrderedSlots) &
    oldest_unhinted_slot(Player, OrderedSlots, Chop).

oldest_unhinted_slot(Player, [H|_], H) [domain(hanabi)] :-
    unhinted_slot(Player, H).
oldest_unhinted_slot(Player, [H|T], E) [domain(hanabi)] :-
    hinted_slot(Player, H) &
    oldest_unhinted_slot(Player, T, E).


// rules to get the unhinted slots of a player from a list of slots
new_cards(_, [], []) [domain(hanabi)].
new_cards(Player, [H|T], [H|New]) [domain(hanabi)] :-
    unhinted_slot(Player, H) & new_cards(Player, T, New).
new_cards(Player, [H|T], New) [domain(hanabi)] :-
    not unhinted_slot(Player, H) & new_cards(Player, T, New).


// rules to find the oldest slot from a list of slots
oldest_slot(Player, ListOfSlots, Slot) [domain(hanabi)] :-
    ordered_slots(Player, OrderedSlots) &
    first_to_appear(OrderedSlots, ListOfSlots, Slot).

first_to_appear([H|T], L, H) [domain(hanabi)] :- .member(H, L).
first_to_appear([H|T], L, E) [domain(hanabi)] :- not .member(H, L) & first_to_appear(T, L, E).


// slot of focus for a player from a list of slots
// The focus is the oldest slot that hadn't been previously hinted.
// If all the slots in the hint were already hinted, then the focus is on
// the oldest
focus(Player, ListOfSlots, Focus) [domain(hanabi)] :-
    new_cards(Player, ListOfSlots, NewCards) &
    .length(NewCards, NumNewCards) & NumNewCards > 0 &
    oldest_slot(Player, NewCards, Focus).

focus(Player, ListOfSlots, Focus) [domain(hanabi)] :-
    new_cards(Player, ListOfSlots, []) &
    oldest_slot(Player, ListOfSlots, Focus).


// rules to set what is the maximum score that could be gathered from a 
// stack of a particular color.
max_stack_height(Color, 0) [domain(hanabi)] :-
    color(Color) &
    cards_per_rank(1, N1) & discarded(Color, 1, N1).

max_stack_height(Color, 1) [domain(hanabi)] :-
    color(Color) &
    cards_per_rank(1, N1) & discarded(Color, 1, N11) & N11 < N1 &
    cards_per_rank(2, N2) & discarded(Color, 2, N2).

max_stack_height(Color, 2) [domain(hanabi)] :-
    color(Color) &
    cards_per_rank(1, N1) & discarded(Color, 1, N11) & N11 < N1 &
    cards_per_rank(2, N2) & discarded(Color, 2, N22) & N22 < N2 &
    cards_per_rank(3, N3) & discarded(Color, 3, N3).

max_stack_height(Color, 3) [domain(hanabi)] :-
    color(Color) &
    cards_per_rank(1, N1) & discarded(Color, 1, N11) & N11 < N1 &
    cards_per_rank(2, N2) & discarded(Color, 2, N22) & N22 < N2 &
    cards_per_rank(3, N3) & discarded(Color, 3, N33) & N33 < N3 &
    cards_per_rank(4, N4) & discarded(Color, 4, N4).

max_stack_height(Color, 4) [domain(hanabi)] :-
    color(Color) &
    cards_per_rank(1, N1) & discarded(Color, 1, N11) & N11 < N1 &
    cards_per_rank(2, N2) & discarded(Color, 2, N22) & N22 < N2 &
    cards_per_rank(3, N3) & discarded(Color, 3, N33) & N33 < N3 &
    cards_per_rank(4, N4) & discarded(Color, 4, N44) & N44 < N4 &
    cards_per_rank(5, N5) & discarded(Color, 5, N5).

max_stack_height(Color, 5) [domain(hanabi)] :-
    color(Color) &
    cards_per_rank(1, N1) & discarded(Color, 1, N11) & N11 < N1 &
    cards_per_rank(2, N2) & discarded(Color, 2, N22) & N22 < N2 &
    cards_per_rank(3, N3) & discarded(Color, 3, N33) & N33 < N3 &
    cards_per_rank(4, N4) & discarded(Color, 4, N44) & N44 < N4 &
    cards_per_rank(5, N5) & discarded(Color, 5, N55) & N55 < N5.


// A card is immediately playable
playable(Color, Rank) [domain(hanabi)] :-
    color(Color) & rank(Rank) &
    stack(Color, Stack) & Stack = Rank-1.

// A card is critical of all of its copies except one have been discarded
critical(Color, Rank) [domain(hanabi)] :-
    color(Color) & rank(Rank) &
    cards_per_rank(Rank, NumCards) &
    discarded(Color, Rank, Disc) &
    Disc = NumCards-1.

// A card is usefull if it could be played at some point in the future
useful(Color, Rank) [domain(hanabi)] :-
    color(Color) & rank(Rank) &
    stack(Color, Stack) & Stack < Rank &
    max_stack_height(Color, Max) & Rank <= Max.

// A card is useless if it cannot be played at any point in the future of the game
useless(Color, Rank) [domain(hanabi)] :-
    color(Color) & rank(Rank) &
    stack(Color, Stack) & Stack >= Rank.

useless(Color, Rank) [domain(hanabi)] :-
    color(Color) & rank(Rank) &
    max_stack_height(Color, Max) & Rank > Max.

useless(Color, Rank) [domain(hanabi)] :-
    color(Color) & rank(Rank) &
    max_stack_height(Color, Max) & stack(Color, Max).
