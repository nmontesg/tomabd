// Unnamed variables are not allowed in action(Agent, Action) selection rules

action(Agent, give_hint(HintedPlayer, rank, 5, SlotList)) [domain(hanabi),priority(1.0)] :-
    my_name(Agent) &
    player(HintedPlayer) &
    available_info_tokens &
    turns_ahead(HintedPlayer, 1) &
    chop(HintedPlayer, Chop) &
    has_card_rank(HintedPlayer, Chop, 5) &
    has_card_color(HintedPlayer, Chop, Color) &
    useful(Color, 5) &
    unhinted(Color, 5) &
    common_slots(HintedPlayer, 5, SlotList).

action(Agent, give_hint(HintedPlayer, rank, 5, SlotList)) [domain(hanabi),priority(1.1)] :-
    my_name(Agent) &
    player(HintedPlayer) &
    available_info_tokens &
    turns_ahead(HintedPlayer, 2) &
    chop(HintedPlayer, Chop) &
    has_card_rank(HintedPlayer, Chop, 5) &
    has_card_color(HintedPlayer, Chop, Color) &
    useful(Color, 5) &
    unhinted(Color, 5) &
    common_slots(HintedPlayer, 5, SlotList).

action(Agent, give_hint(HintedPlayer, rank, 5, SlotList)) [domain(hanabi),priority(1.2)] :-
    my_name(Agent) &
    player(HintedPlayer) &
    available_info_tokens &
    turns_ahead(HintedPlayer, 3) &
    chop(HintedPlayer, Chop) &
    has_card_rank(HintedPlayer, Chop, 5) &
    has_card_color(HintedPlayer, Chop, Color) &
    useful(Color, 5) &
    unhinted(Color, 5) &
    common_slots(HintedPlayer, 5, SlotList).

action(Agent, give_hint(HintedPlayer, rank, 5, SlotList)) [domain(hanabi),priority(1.3)] :-
    my_name(Agent) &
    player(HintedPlayer) &
    available_info_tokens &
    turns_ahead(HintedPlayer, 4) &
    chop(HintedPlayer, Chop) &
    has_card_rank(HintedPlayer, Chop, 5) &
    has_card_color(HintedPlayer, Chop, Color) &
    useful(Color, 5) &
    unhinted(Color, 5) &
    common_slots(HintedPlayer, 5, SlotList).

/* ------------------------------------------------------------------------- */

action(Agent, give_hint(HintedPlayer, color, Color, SlotList)) [domain(hanabi),priority(2.0)] :-
    my_name(Agent) &
    player(HintedPlayer) &
    available_info_tokens &
    turns_ahead(HintedPlayer, 1) &
    chop(HintedPlayer, Chop) &
    has_card_color(HintedPlayer, Chop, Color) &
    has_card_rank(HintedPlayer, Chop, Rank) & Rank \== 5 &
    critical(Color, Rank) &
    useful(Color, Rank) &
    common_slots(HintedPlayer, Color, SlotList).

action(Agent, give_hint(HintedPlayer, color, Color, SlotList)) [domain(hanabi),priority(2.1)] :-
    my_name(Agent) &
    player(HintedPlayer) &
    available_info_tokens &
    turns_ahead(HintedPlayer, 2) &
    chop(HintedPlayer, Chop) &
    has_card_color(HintedPlayer, Chop, Color) &
    has_card_rank(HintedPlayer, Chop, Rank) & Rank \== 5 &
    critical(Color, Rank) &
    useful(Color, Rank) &
    common_slots(HintedPlayer, Color, SlotList).

action(Agent, give_hint(HintedPlayer, color, Color, SlotList)) [domain(hanabi),priority(2.2)] :-
    my_name(Agent) &
    player(HintedPlayer) &
    available_info_tokens &
    turns_ahead(HintedPlayer, 2) &
    chop(HintedPlayer, Chop) &
    has_card_color(HintedPlayer, Chop, Color) &
    has_card_rank(HintedPlayer, Chop, Rank) & Rank \== 5 &
    critical(Color, Rank) &
    useful(Color, Rank) &
    common_slots(HintedPlayer, Color, SlotList).

action(Agent, give_hint(HintedPlayer, color, Color, SlotList)) [domain(hanabi),priority(2.3)] :-
    my_name(Agent) &
    player(HintedPlayer) &
    available_info_tokens &
    turns_ahead(HintedPlayer, 2) &
    chop(HintedPlayer, Chop) &
    has_card_color(HintedPlayer, Chop, Color) &
    has_card_rank(HintedPlayer, Chop, Rank) & Rank \== 5 &
    critical(Color, Rank) &
    useful(Color, Rank) &
    common_slots(HintedPlayer, Color, SlotList).

/* ------------------------------------------------------------------------- */

action(Agent, give_hint(HintedPlayer, color, Color, SlotList)) [domain(hanabi),priority(3.0)] :-
    my_name(Agent) &
    player(HintedPlayer) &
    available_info_tokens &
    turns_ahead(HintedPlayer, 1) &
    common_slots(HintedPlayer, Color, SlotList) &
    focus(HintedPlayer, SlotList, Focus) &
    has_card_color(HintedPlayer, Focus, Color) &
    has_card_rank(HintedPlayer, Focus, Rank) &
    playable(Color, Rank) &
    unhinted(Color, Rank).

action(Agent, give_hint(Player, rank, Rank, SlotList)) [domain(hanabi),priority(3.1)] :-
    player(Agent) &
    available_info_tokens &
    turns_ahead(Player, 1) &
    has_card_color(Player, Focus, Color) &
    has_card_rank(Player, Focus, Rank) &
    playable(Color, Rank) &
    unhinted(Color, Rank) &
    common_slots(Player, Rank, SlotList) &
    focus(Player, SlotList, Focus).

action(Agent, give_hint(Player, color, Color, SlotList)) [domain(hanabi),priority(3.2)] :-
    player(Agent) &
    available_info_tokens &
    turns_ahead(Player, 2) &
    has_card_color(Player, Focus, Color) &
    has_card_rank(Player, Focus, Rank) &
    playable(Color, Rank) &
    unhinted(Color, Rank) &
    common_slots(Player, Color, SlotList) &
    focus(Player, SlotList, Focus).

action(Agent, give_hint(Player, rank, Rank, SlotList)) [domain(hanabi),priority(3.3)] :-
    player(Agent) &
    available_info_tokens &
    turns_ahead(Player, 2) &
    has_card_color(Player, Focus, Color) &
    has_card_rank(Player, Focus, Rank) &
    playable(Color, Rank) &
    unhinted(Color, Rank) &
    common_slots(Player, Rank, SlotList) &
    focus(Player, SlotList, Focus).

action(Agent, give_hint(Player, color, Color, SlotList)) [domain(hanabi),priority(3.4)] :-
    player(Agent) &
    available_info_tokens &
    turns_ahead(Player, 3) &
    has_card_color(Player, Focus, Color) &
    has_card_rank(Player, Focus, Rank) &
    playable(Color, Rank) &
    unhinted(Color, Rank) &
    common_slots(Player, Color, SlotList) &
    focus(Player, SlotList, Focus).

action(Agent, give_hint(Player, rank, Rank, SlotList)) [domain(hanabi),priority(3.5)] :-
    player(Agent) &
    available_info_tokens &
    turns_ahead(Player, 3) &
    has_card_color(Player, Focus, Color) &
    has_card_rank(Player, Focus, Rank) &
    playable(Color, Rank) &
    unhinted(Color, Rank) &
    common_slots(Player, Rank, SlotList) &
    focus(Player, SlotList, Focus).

action(Agent, give_hint(Player, color, Color, SlotList)) [domain(hanabi),priority(3.6)] :-
    player(Agent) &
    available_info_tokens &
    turns_ahead(Player, 4) &
    has_card_color(Player, Focus, Color) &
    has_card_rank(Player, Focus, Rank) &
    playable(Color, Rank) &
    unhinted(Color, Rank) &
    common_slots(Player, Color, SlotList) &
    focus(Player, SlotList, Focus).

action(Agent, give_hint(Player, rank, Rank, SlotList)) [domain(hanabi),priority(3.7)] :-
    player(Agent) &
    available_info_tokens &
    turns_ahead(Player, 4) &
    has_card_color(Player, Focus, Color) &
    has_card_rank(Player, Focus, Rank) &
    playable(Color, Rank) &
    unhinted(Color, Rank) &
    common_slots(Player, Rank, SlotList) &
    focus(Player, SlotList, Focus).

/* ------------------------------------------------------------------------- */

action(Agent, play_card(Slot)) [domain(hanabi),priority(4.0)] :-
    player(Agent) &
    my_name(Agent) & slot(Slot) &
    has_card_color(Agent, Slot, Color) &
    has_card_rank(Agent, Slot, Rank) &
    playable(Color, Rank).

/* ------------------------------------------------------------------------- */

action(Agent, give_hint(Player, rank, Rank, SlotList)) [domain(hanabi),priority(5.0)] :-
    player(Agent) &
    available_info_tokens &
    turns_ahead(Player, 1) &
    slot(Slot) &
    has_card_color(Player, Slot, Color) &
    has_card_rank(Player, Slot, Rank) &
    partially_hinted(Player, Slot, color) &
    playable(Color, Rank) &
    common_slots(Player, Rank, SlotList).

action(Agent, give_hint(Player, color, Color, SlotList)) [domain(hanabi),priority(5.1)] :-
    player(Agent) &
    available_info_tokens &
    turns_ahead(Player, 1) &
    slot(Slot) &
    has_card_color(Player, Slot, Color) &
    has_card_rank(Player, Slot, Rank) &
    partially_hinted(Player, Slot, rank) &
    playable(Color, Rank) &
    common_slots(Player, Color, SlotList).

action(Agent, give_hint(Player, rank, Rank, SlotList)) [domain(hanabi),priority(5.2)] :-
    player(Agent) &
    available_info_tokens &
    turns_ahead(Player, 2) &
    slot(Slot) &
    has_card_color(Player, Slot, Color) &
    has_card_rank(Player, Slot, Rank) &
    partially_hinted(Player, Slot, color) &
    playable(Color, Rank) &
    common_slots(Player, Rank, SlotList).

action(Agent, give_hint(Player, color, Color, SlotList)) [domain(hanabi),priority(5.3)] :-
    player(Agent) &
    available_info_tokens &
    turns_ahead(Player, 2) &
    slot(Slot) &
    has_card_color(Player, Slot, Color) &
    has_card_rank(Player, Slot, Rank) &
    partially_hinted(Player, Slot, rank) &
    playable(Color, Rank) &
    common_slots(Player, Color, SlotList).

action(Agent, give_hint(Player, rank, Rank, SlotList)) [domain(hanabi),priority(5.4)] :-
    player(Agent) &
    available_info_tokens &
    turns_ahead(Player, 3) &
    slot(Slot) &
    has_card_color(Player, Slot, Color) &
    has_card_rank(Player, Slot, Rank) &
    partially_hinted(Player, Slot, color) &
    playable(Color, Rank) &
    common_slots(Player, Rank, SlotList).

action(Agent, give_hint(Player, color, Color, SlotList)) [domain(hanabi),priority(5.5)] :-
    player(Agent) &
    available_info_tokens &
    turns_ahead(Player, 3) &
    slot(Slot) &
    has_card_color(Player, Slot, Color) &
    has_card_rank(Player, Slot, Rank) &
    partially_hinted(Player, Slot, rank) &
    playable(Color, Rank) &
    common_slots(Player, Color, SlotList).

action(Agent, give_hint(Player, rank, Rank, SlotList)) [domain(hanabi),priority(5.6)] :-
    player(Agent) &
    available_info_tokens &
    turns_ahead(Player, 4) &
    slot(Slot) &
    has_card_color(Player, Slot, Color) &
    has_card_rank(Player, Slot, Rank) &
    partially_hinted(Player, Slot, color) &
    playable(Color, Rank) &
    common_slots(Player, Rank, SlotList).

action(Agent, give_hint(Player, color, Color, SlotList)) [domain(hanabi),priority(5.7)] :-
    player(Agent) &
    available_info_tokens &
    turns_ahead(Player, 4) &
    slot(Slot) &
    has_card_color(Player, Slot, Color) &
    has_card_rank(Player, Slot, Rank) &
    partially_hinted(Player, Slot, rank) &
    playable(Color, Rank) &
    common_slots(Player, Color, SlotList).

/* ------------------------------------------------------------------------- */

action(Agent, discard_card(Slot)) [domain(hanabi),priority(6.0)] :-
    player(Agent) &
    spent_info_tokens &
    my_name(Agent) &
    has_card_color(Agent, Slot, Color) &
    has_card_rank(Agent, Slot, Rank) &
    useless(Color, Rank).

/* ------------------------------------------------------------------------- */

action(Agent, discard_card(C)) [domain(hanabi),priority(7.0)] :-
    player(Agent) &
    spent_info_tokens &
    my_name(Agent) &
    chop(Agent, C).

/* ------------------------------------------------------------------------- */

action(Agent, give_hint(Player, rank, Rank, SlotList)) [domain(hanabi),priority(8.0)] :-
    player(Agent) &
    available_info_tokens &
    turns_ahead(Player, 1) &
    slot(Slot) &
    has_card_color(Player, Slot, Color) &
    has_card_rank(Player, Slot, Rank) &
    partially_hinted(Player, Slot, color) &
    critical(Color, Rank) &
    useful(Color, Rank) &
    common_slots(Player, Rank, SlotList).

action(Agent, give_hint(Player, color, Color, SlotList)) [domain(hanabi),priority(8.1)] :-
    player(Agent) &
    available_info_tokens &
    turns_ahead(Player, 1) &
    slot(Slot) &
    has_card_color(Player, Slot, Color) &
    has_card_rank(Player, Slot, Rank) &
    partially_hinted(Player, Slot, rank) &
    critical(Color, Rank) &
    useful(Color, Rank) &
    common_slots(Player, Color, SlotList).

action(Agent, give_hint(Player, rank, Rank, SlotList)) [domain(hanabi),priority(8.2)] :-
    player(Agent) &
    available_info_tokens &
    turns_ahead(Player, 2) &
    slot(Slot) &
    has_card_color(Player, Slot, Color) &
    has_card_rank(Player, Slot, Rank) &
    partially_hinted(Player, Slot, color) &
    critical(Color, Rank) &
    useful(Color, Rank) &
    common_slots(Player, Rank, SlotList).

action(Agent, give_hint(Player, color, Color, SlotList)) [domain(hanabi),priority(8.3)] :-
    player(Agent) &
    available_info_tokens &
    turns_ahead(Player, 2) &
    slot(Slot) &
    has_card_color(Player, Slot, Color) &
    has_card_rank(Player, Slot, Rank) &
    partially_hinted(Player, Slot, rank) &
    critical(Color, Rank) &
    useful(Color, Rank) &
    common_slots(Player, Color, SlotList).

action(Agent, give_hint(Player, rank, Rank, SlotList)) [domain(hanabi),priority(8.4)] :-
    player(Agent) &
    available_info_tokens &
    turns_ahead(Player, 3) &
    slot(Slot) &
    has_card_color(Player, Slot, Color) &
    has_card_rank(Player, Slot, Rank) &
    partially_hinted(Player, Slot, color) &
    critical(Color, Rank) &
    useful(Color, Rank) &
    common_slots(Player, Rank, SlotList).

action(Agent, give_hint(Player, color, Color, SlotList)) [domain(hanabi),priority(8.5)] :-
    player(Agent) &
    available_info_tokens &
    turns_ahead(Player, 3) &
    slot(Slot) &
    has_card_color(Player, Slot, Color) &
    has_card_rank(Player, Slot, Rank) &
    partially_hinted(Player, Slot, rank) &
    critical(Color, Rank) &
    useful(Color, Rank) &
    common_slots(Player, Color, SlotList).

action(Agent, give_hint(Player, rank, Rank, SlotList)) [domain(hanabi),priority(8.6)] :-
    player(Agent) &
    available_info_tokens &
    turns_ahead(Player, 4) &
    slot(Slot) &
    has_card_color(Player, Slot, Color) &
    has_card_rank(Player, Slot, Rank) &
    partially_hinted(Player, Slot, color) &
    critical(Color, Rank) &
    useful(Color, Rank) &
    common_slots(Player, Rank, SlotList).

action(Agent, give_hint(Player, color, Color, SlotList)) [domain(hanabi),priority(8.7)] :-
    player(Agent) &
    available_info_tokens &
    turns_ahead(Player, 4) &
    slot(Slot) &
    has_card_color(Player, Slot, Color) &
    has_card_rank(Player, Slot, Rank) &
    partially_hinted(Player, Slot, rank) &
    critical(Color, Rank) &
    useful(Color, Rank) &
    common_slots(Player, Color, SlotList).

/* ------------------------------------------------------------------------- */

action(Agent, give_hint(Player, color, Color, SlotList)) [domain(hanabi),priority(9.0)] :-
    player(Agent) &
    available_info_tokens &
    turns_ahead(Player, 1) &
    slot(Slot) &
    has_card_color(Player, Slot, Color) &
    has_card_rank(Player, Slot, Rank) &
    partially_hinted(Player, Slot, rank) &
    useful(Color, Rank) &
    common_slots(Player, Color, SlotList).

action(Agent, give_hint(Player, rank, Rank, SlotList)) [domain(hanabi),priority(9.1)] :-
    player(Agent) &
    available_info_tokens &
    turns_ahead(Player, 1) &
    slot(Slot) &
    has_card_color(Player, Slot, Color) &
    has_card_rank(Player, Slot, Rank) &
    partially_hinted(Player, Slot, color) &
    useful(Color, Rank) &
    common_slots(Player, Rank, SlotList).

action(Agent, give_hint(Player, color, Color, SlotList)) [domain(hanabi),priority(9.2)] :-
    player(Agent) &
    available_info_tokens &
    turns_ahead(Player, 2) &
    slot(Slot) &
    has_card_color(Player, Slot, Color) &
    has_card_rank(Player, Slot, Rank) &
    partially_hinted(Player, Slot, rank) &
    useful(Color, Rank) &
    common_slots(Player, Color, SlotList).

action(Agent, give_hint(Player, rank, Rank, SlotList)) [domain(hanabi),priority(9.3)] :-
    player(Agent) &
    available_info_tokens &
    turns_ahead(Player, 2) &
    slot(Slot) &
    has_card_color(Player, Slot, Color) &
    has_card_rank(Player, Slot, Rank) &
    partially_hinted(Player, Slot, color) &
    useful(Color, Rank) &
    common_slots(Player, Rank, SlotList).

action(Agent, give_hint(Player, color, Color, SlotList)) [domain(hanabi),priority(9.4)] :-
    player(Agent) &
    available_info_tokens &
    turns_ahead(Player, 3) &
    slot(Slot) &
    has_card_color(Player, Slot, Color) &
    has_card_rank(Player, Slot, Rank) &
    partially_hinted(Player, Slot, rank) &
    useful(Color, Rank) &
    common_slots(Player, Color, SlotList).

action(Agent, give_hint(Player, rank, Rank, SlotList)) [domain(hanabi),priority(9.5)] :-
    player(Agent) &
    available_info_tokens &
    turns_ahead(Player, 3) &
    slot(Slot) &
    has_card_color(Player, Slot, Color) &
    has_card_rank(Player, Slot, Rank) &
    partially_hinted(Player, Slot, color) &
    useful(Color, Rank) &
    common_slots(Player, Rank, SlotList).

action(Agent, give_hint(Player, color, Color, SlotList)) [domain(hanabi),priority(9.6)] :-
    player(Agent) &
    available_info_tokens &
    turns_ahead(Player, 4) &
    slot(Slot) &
    has_card_color(Player, Slot, Color) &
    has_card_rank(Player, Slot, Rank) &
    partially_hinted(Player, Slot, rank) &
    useful(Color, Rank) &
    common_slots(Player, Color, SlotList).

action(Agent, give_hint(Player, rank, Rank, SlotList)) [domain(hanabi),priority(9.7)] :-
    player(Agent) &
    available_info_tokens &
    turns_ahead(Player, 4) &
    slot(Slot) &
    has_card_color(Player, Slot, Color) &
    has_card_rank(Player, Slot, Rank) &
    partially_hinted(Player, Slot, color) &
    useful(Color, Rank) &
    common_slots(Player, Rank, SlotList).

/* ------------------------------------------------------------------------- */

action(Agent, give_hint(Player, color, Color, SlotList)) [domain(hanabi),priority(10.0)] :-
    player(Agent) &
    available_info_tokens &
    turns_ahead(Player, 1) &
    slot(Slot) &
    has_card_color(Player, Slot, Color) &
    has_card_rank(Player, Slot, Rank) &
    totally_hinted(Player, Slot) &
    playable(Color, Rank) &
    common_slots(Player, Color, SlotList).

action(Agent, give_hint(Player, color, Color, SlotList)) [domain(hanabi),priority(10.1)] :-
    player(Agent) &
    available_info_tokens &
    turns_ahead(Player, 2) &
    slot(Slot) &
    has_card_color(Player, Slot, Color) &
    has_card_rank(Player, Slot, Rank) &
    totally_hinted(Player, Slot) &
    playable(Color, Rank) &
    common_slots(Player, Color, SlotList).

action(Agent, give_hint(Player, color, Color, SlotList)) [domain(hanabi),priority(10.2)] :-
    player(Agent) &
    available_info_tokens &
    turns_ahead(Player, 3) &
    slot(Slot) &
    has_card_color(Player, Slot, Color) &
    has_card_rank(Player, Slot, Rank) &
    totally_hinted(Player, Slot) &
    playable(Color, Rank) &
    common_slots(Player, Color, SlotList).

action(Agent, give_hint(Player, color, Color, SlotList)) [domain(hanabi),priority(10.3)] :-
    player(Agent) &
    available_info_tokens &
    turns_ahead(Player, 4) &
    slot(Slot) &
    has_card_color(Player, Slot, Color) &
    has_card_rank(Player, Slot, Rank) &
    totally_hinted(Player, Slot) &
    playable(Color, Rank) &
    common_slots(Player, Color, SlotList).

/* ------------------------------------------------------------------------- */

action(Agent, discard_card(Slot)) [domain(hanabi),priority(11.0)] :-
    player(Agent) &
    spent_info_tokens &
    my_name(Agent) &
    ordered_slots(Agent, [Slot|T]).

/* ------------------------------------------------------------------------- */

action(Agent, give_hint(Player, color, Color, SlotList)) [domain(hanabi),priority(12.0)] :-
    player(Agent) &
    num_info_tokens(Tokens) & max_info_tokens(Tokens) &
    turns_ahead(Player, 1) &
    slot(Slot) &
    has_card_color(Player, Slot, Color) &
    has_card_rank(Player, Slot, Rank) &
    unhinted(Color, Rank) &
    useful(Color, Rank) &
    common_slots(Player, Color, SlotList) &
    focus(Player, SlotList, Slot).

action(Agent, give_hint(Player, rank, Rank, SlotList)) [domain(hanabi),priority(12.1)] :-
    player(Agent) &
    num_info_tokens(Tokens) & max_info_tokens(Tokens) &
    turns_ahead(Player, 1) &
    slot(Slot) &
    has_card_color(Player, Slot, Color) &
    has_card_rank(Player, Slot, Rank) &
    unhinted(Color, Rank) &
    useful(Color, Rank) &
    common_slots(Player, Rank, SlotList) &
    focus(Player, SlotList, Slot).

action(Agent, give_hint(Player, color, Color, SlotList)) [domain(hanabi),priority(12.2)] :-
    player(Agent) &
    num_info_tokens(Tokens) & max_info_tokens(Tokens) &
    turns_ahead(Player, 2) &
    slot(Slot) &
    has_card_color(Player, Slot, Color) &
    has_card_rank(Player, Slot, Rank) &
    unhinted(Color, Rank) &
    useful(Color, Rank) &
    common_slots(Player, Color, SlotList) &
    focus(Player, SlotList, Slot).

action(Agent, give_hint(Player, rank, Rank, SlotList)) [domain(hanabi),priority(12.3)] :-
    player(Agent) &
    num_info_tokens(Tokens) & max_info_tokens(Tokens) &
    turns_ahead(Player, 2) &
    slot(Slot) &
    has_card_color(Player, Slot, Color) &
    has_card_rank(Player, Slot, Rank) &
    unhinted(Color, Rank) &
    useful(Color, Rank) &
    common_slots(Player, Rank, SlotList) &
    focus(Player, SlotList, Slot).

action(Agent, give_hint(Player, color, Color, SlotList)) [domain(hanabi),priority(12.4)] :-
    player(Agent) &
    num_info_tokens(Tokens) & max_info_tokens(Tokens) &
    turns_ahead(Player, 3) &
    slot(Slot) &
    has_card_color(Player, Slot, Color) &
    has_card_rank(Player, Slot, Rank) &
    unhinted(Color, Rank) &
    useful(Color, Rank) &
    common_slots(Player, Color, SlotList) &
    focus(Player, SlotList, Slot).

action(Agent, give_hint(Player, rank, Rank, SlotList)) [domain(hanabi),priority(12.5)] :-
    player(Agent) &
    num_info_tokens(Tokens) & max_info_tokens(Tokens) &
    turns_ahead(Player, 3) &
    slot(Slot) &
    has_card_color(Player, Slot, Color) &
    has_card_rank(Player, Slot, Rank) &
    unhinted(Color, Rank) &
    useful(Color, Rank) &
    common_slots(Player, Rank, SlotList) &
    focus(Player, SlotList, Slot).

action(Agent, give_hint(Player, color, Color, SlotList)) [domain(hanabi),priority(12.6)] :-
    player(Agent) &
    num_info_tokens(Tokens) & max_info_tokens(Tokens) &
    turns_ahead(Player, 4) &
    slot(Slot) &
    has_card_color(Player, Slot, Color) &
    has_card_rank(Player, Slot, Rank) &
    unhinted(Color, Rank) &
    useful(Color, Rank) &
    common_slots(Player, Color, SlotList) &
    focus(Player, SlotList, Slot).

action(Agent, give_hint(Player, rank, Rank, SlotList)) [domain(hanabi),priority(12.7)] :-
    player(Agent) &
    num_info_tokens(Tokens) & max_info_tokens(Tokens) &
    turns_ahead(Player, 4) &
    slot(Slot) &
    has_card_color(Player, Slot, Color) &
    has_card_rank(Player, Slot, Rank) &
    unhinted(Color, Rank) &
    useful(Color, Rank) &
    common_slots(Player, Rank, SlotList) &
    focus(Player, SlotList, Slot).

/* ------------------------------------------------------------------------- */

action(Agent, discard_card(Slot)) [domain(hanabi),priority(13.0)] :-
    my_name(Agent) &
    max_info_tokens(Max) &
    num_info_tokens(Tokens) &
    Tokens < Max &
    ordered_slots(Agent, OrdSlots) &
    oldest_slot(Agent, OrdSlots, Slot).

action(Agent, play_card(Slot)) [domain(hanabi),priority(13.1)] :-
    my_name(Agent) &
    max_info_tokens(Max) &
    num_info_tokens(Max) &
    ordered_slots(Agent, OrdSlots) &
    oldest_slot(Agent, OrdSlots, Slot).
