/* ---------- COMMON SLOTS BY COLOR ---------- */

// common_slots(Player, Color, []) [domain(hanabi)] :-
//     cards_per_player(4) & color(Color) &
//     ~has_card_color(Player, 1, Color) &
//     ~has_card_color(Player, 2, Color) &
//     ~has_card_color(Player, 3, Color) &
//     ~has_card_color(Player, 4, Color).

common_slots(Player, Color, [1]) [domain(hanabi)] :-
    cards_per_player(4) & color(Color) &
    has_card_color(Player, 1, Color) &
    ~has_card_color(Player, 2, Color) &
    ~has_card_color(Player, 3, Color) &
    ~has_card_color(Player, 4, Color).

common_slots(Player, Color, [2]) [domain(hanabi)] :-
    cards_per_player(4) & color(Color) &
    ~has_card_color(Player, 1, Color) &
    has_card_color(Player, 2, Color) &
    ~has_card_color(Player, 3, Color) &
    ~has_card_color(Player, 4, Color).

common_slots(Player, Color, [3]) [domain(hanabi)] :-
    cards_per_player(4) & color(Color) &
    ~has_card_color(Player, 1, Color) &
    ~has_card_color(Player, 2, Color) &
    has_card_color(Player, 3, Color) &
    ~has_card_color(Player, 4, Color).

common_slots(Player, Color, [4]) [domain(hanabi)] :-
    cards_per_player(4) & color(Color) &
    ~has_card_color(Player, 1, Color) &
    ~has_card_color(Player, 2, Color) &
    ~has_card_color(Player, 3, Color) &
    has_card_color(Player, 4, Color).

common_slots(Player, Color, [1,2]) [domain(hanabi)] :-
    cards_per_player(4) & color(Color) &
    has_card_color(Player, 1, Color) &
    has_card_color(Player, 2, Color) &
    ~has_card_color(Player, 3, Color) &
    ~has_card_color(Player, 4, Color).

common_slots(Player, Color, [1,3]) [domain(hanabi)] :-
    cards_per_player(4) & color(Color) &
    has_card_color(Player, 1, Color) &
    ~has_card_color(Player, 2, Color) &
    has_card_color(Player, 3, Color) &
    ~has_card_color(Player, 4, Color).

common_slots(Player, Color, [1,4]) [domain(hanabi)] :-
    cards_per_player(4) & color(Color) &
    has_card_color(Player, 1, Color) &
    ~has_card_color(Player, 2, Color) &
    ~has_card_color(Player, 3, Color) &
    has_card_color(Player, 4, Color).

common_slots(Player, Color, [2,3]) [domain(hanabi)] :-
    cards_per_player(4) & color(Color) &
    ~has_card_color(Player, 1, Color) &
    has_card_color(Player, 2, Color) &
    has_card_color(Player, 3, Color) &
    ~has_card_color(Player, 4, Color).

common_slots(Player, Color, [2,4]) [domain(hanabi)] :-
    cards_per_player(4) & color(Color) &
    ~has_card_color(Player, 1, Color) &
    has_card_color(Player, 2, Color) &
    ~has_card_color(Player, 3, Color) &
    has_card_color(Player, 4, Color).

common_slots(Player, Color, [3,4]) [domain(hanabi)] :-
    cards_per_player(4) & color(Color) &
    ~has_card_color(Player, 1, Color) &
    ~has_card_color(Player, 2, Color) &
    has_card_color(Player, 3, Color) &
    has_card_color(Player, 4, Color).

common_slots(Player, Color, [1,2,3]) [domain(hanabi)] :-
    cards_per_player(4) & color(Color) &
    has_card_color(Player, 1, Color) &
    has_card_color(Player, 2, Color) &
    has_card_color(Player, 3, Color) &
    ~has_card_color(Player, 4, Color).

common_slots(Player, Color, [1,2,4]) [domain(hanabi)] :-
    cards_per_player(4) & color(Color) &
    has_card_color(Player, 1, Color) &
    has_card_color(Player, 2, Color) &
    ~has_card_color(Player, 3, Color) &
    has_card_color(Player, 4, Color).

common_slots(Player, Color, [1,3,4]) [domain(hanabi)] :-
    cards_per_player(4) & color(Color) &
    has_card_color(Player, 1, Color) &
    ~has_card_color(Player, 2, Color) &
    has_card_color(Player, 3, Color) &
    has_card_color(Player, 4, Color).

common_slots(Player, Color, [2,3,4]) [domain(hanabi)] :-
    cards_per_player(4) & color(Color) &
    ~has_card_color(Player, 1, Color) &
    has_card_color(Player, 2, Color) &
    has_card_color(Player, 3, Color) &
    has_card_color(Player, 4, Color).

common_slots(Player, Color, [1,2,3,4]) [domain(hanabi)] :-
    cards_per_player(4) & color(Color) &
    has_card_color(Player, 1, Color) &
    has_card_color(Player, 2, Color) &
    has_card_color(Player, 3, Color) &
    has_card_color(Player, 4, Color).


/* ------------------------------------------------------*/



// common_slots(Player, Color, []) [domain(hanabi)] :-
//     cards_per_player(5) & color(Color) &
//     ~has_card_color(Player, 1, Color) &
//     ~has_card_color(Player, 2, Color) &
//     ~has_card_color(Player, 3, Color) &
//     ~has_card_color(Player, 4, Color) &
//     ~has_card_color(Player, 5, Color).

common_slots(Player, Color, [1]) [domain(hanabi)] :-
    cards_per_player(5) & color(Color) &
    has_card_color(Player, 1, Color) &
    ~has_card_color(Player, 2, Color) &
    ~has_card_color(Player, 3, Color) &
    ~has_card_color(Player, 4, Color) &
    ~has_card_color(Player, 5, Color).

common_slots(Player, Color, [2]) [domain(hanabi)] :-
    cards_per_player(5) & color(Color) &
    ~has_card_color(Player, 1, Color) &
    has_card_color(Player, 2, Color) &
    ~has_card_color(Player, 3, Color) &
    ~has_card_color(Player, 4, Color) &
    ~has_card_color(Player, 5, Color).

common_slots(Player, Color, [3]) [domain(hanabi)] :-
    cards_per_player(5) & color(Color) &
    ~has_card_color(Player, 1, Color) &
    ~has_card_color(Player, 2, Color) &
    has_card_color(Player, 3, Color) &
    ~has_card_color(Player, 4, Color) &
    ~has_card_color(Player, 5, Color).

common_slots(Player, Color, [4]) [domain(hanabi)] :-
    cards_per_player(5) & color(Color) &
    ~has_card_color(Player, 1, Color) &
    ~has_card_color(Player, 2, Color) &
    ~has_card_color(Player, 3, Color) &
    has_card_color(Player, 4, Color) &
    ~has_card_color(Player, 5, Color).

common_slots(Player, Color, [5]) [domain(hanabi)] :-
    cards_per_player(5) & color(Color) &
    ~has_card_color(Player, 1, Color) &
    ~has_card_color(Player, 2, Color) &
    ~has_card_color(Player, 3, Color) &
    ~has_card_color(Player, 4, Color) &
    has_card_color(Player, 5, Color).

common_slots(Player, Color, [1,2]) [domain(hanabi)] :-
    cards_per_player(5) & color(Color) &
    has_card_color(Player, 1, Color) &
    has_card_color(Player, 2, Color) &
    ~has_card_color(Player, 3, Color) &
    ~has_card_color(Player, 4, Color) &
    ~has_card_color(Player, 5, Color).

common_slots(Player, Color, [1,3]) [domain(hanabi)] :-
    cards_per_player(5) & color(Color) &
    has_card_color(Player, 1, Color) &
    ~has_card_color(Player, 2, Color) &
    has_card_color(Player, 3, Color) &
    ~has_card_color(Player, 4, Color) &
    ~has_card_color(Player, 5, Color).

common_slots(Player, Color, [1,4]) [domain(hanabi)] :-
    cards_per_player(5) & color(Color) &
    has_card_color(Player, 1, Color) &
    ~has_card_color(Player, 2, Color) &
    ~has_card_color(Player, 3, Color) &
    has_card_color(Player, 4, Color) &
    ~has_card_color(Player, 5, Color).

common_slots(Player, Color, [1,5]) [domain(hanabi)] :-
    cards_per_player(5) & color(Color) &
    has_card_color(Player, 1, Color) &
    ~has_card_color(Player, 2, Color) &
    ~has_card_color(Player, 3, Color) &
    ~has_card_color(Player, 4, Color) &
    has_card_color(Player, 5, Color).

common_slots(Player, Color, [2,3]) [domain(hanabi)] :-
    cards_per_player(5) & color(Color) &
    ~has_card_color(Player, 1, Color) &
    has_card_color(Player, 2, Color) &
    has_card_color(Player, 3, Color) &
    ~has_card_color(Player, 4, Color) &
    ~has_card_color(Player, 5, Color).

common_slots(Player, Color, [2,4]) [domain(hanabi)] :-
    cards_per_player(5) & color(Color) &
    ~has_card_color(Player, 1, Color) &
    has_card_color(Player, 2, Color) &
    ~has_card_color(Player, 3, Color) &
    has_card_color(Player, 4, Color) &
    ~has_card_color(Player, 5, Color).

common_slots(Player, Color, [2,5]) [domain(hanabi)] :-
    cards_per_player(5) & color(Color) &
    ~has_card_color(Player, 1, Color) &
    has_card_color(Player, 2, Color) &
    ~has_card_color(Player, 3, Color) &
    ~has_card_color(Player, 4, Color) &
    has_card_color(Player, 5, Color).

common_slots(Player, Color, [3,4]) [domain(hanabi)] :-
    cards_per_player(5) & color(Color) &
    ~has_card_color(Player, 1, Color) &
    ~has_card_color(Player, 2, Color) &
    has_card_color(Player, 3, Color) &
    has_card_color(Player, 4, Color) &
    ~has_card_color(Player, 5, Color).

common_slots(Player, Color, [3,5]) [domain(hanabi)] :-
    cards_per_player(5) & color(Color) &
    ~has_card_color(Player, 1, Color) &
    ~has_card_color(Player, 2, Color) &
    has_card_color(Player, 3, Color) &
    ~has_card_color(Player, 4, Color) &
    has_card_color(Player, 5, Color).

common_slots(Player, Color, [4,5]) [domain(hanabi)] :-
    cards_per_player(5) & color(Color) &
    ~has_card_color(Player, 1, Color) &
    ~has_card_color(Player, 2, Color) &
    ~has_card_color(Player, 3, Color) &
    has_card_color(Player, 4, Color) &
    has_card_color(Player, 5, Color).


common_slots(Player, Color, [1,2,3]) [domain(hanabi)] :-
    cards_per_player(5) & color(Color) &
    has_card_color(Player, 1, Color) &
    has_card_color(Player, 2, Color) &
    has_card_color(Player, 3, Color) &
    ~has_card_color(Player, 4, Color) &
    ~has_card_color(Player, 5, Color).

common_slots(Player, Color, [1,2,4]) [domain(hanabi)] :-
    cards_per_player(5) & color(Color) &
    has_card_color(Player, 1, Color) &
    has_card_color(Player, 2, Color) &
    ~has_card_color(Player, 3, Color) &
    has_card_color(Player, 4, Color) &
    ~has_card_color(Player, 5, Color).

common_slots(Player, Color, [1,2,5]) [domain(hanabi)] :-
    cards_per_player(5) & color(Color) &
    has_card_color(Player, 1, Color) &
    has_card_color(Player, 2, Color) &
    ~has_card_color(Player, 3, Color) &
    ~has_card_color(Player, 4, Color) &
    has_card_color(Player, 5, Color).

common_slots(Player, Color, [1,3,4]) [domain(hanabi)] :-
    cards_per_player(5) & color(Color) &
    has_card_color(Player, 1, Color) &
    ~has_card_color(Player, 2, Color) &
    has_card_color(Player, 3, Color) &
    has_card_color(Player, 4, Color) &
    ~has_card_color(Player, 5, Color).

common_slots(Player, Color, [1,3,5]) [domain(hanabi)] :-
    cards_per_player(5) & color(Color) &
    has_card_color(Player, 1, Color) &
    ~has_card_color(Player, 2, Color) &
    has_card_color(Player, 3, Color) &
    ~has_card_color(Player, 4, Color) &
    has_card_color(Player, 5, Color).

common_slots(Player, Color, [1,4,5]) [domain(hanabi)] :-
    cards_per_player(5) & color(Color) &
    has_card_color(Player, 1, Color) &
    ~has_card_color(Player, 2, Color) &
    ~has_card_color(Player, 3, Color) &
    has_card_color(Player, 4, Color) &
    has_card_color(Player, 5, Color).

common_slots(Player, Color, [2,3,4]) [domain(hanabi)] :-
    cards_per_player(5) & color(Color) &
    ~has_card_color(Player, 1, Color) &
    has_card_color(Player, 2, Color) &
    has_card_color(Player, 3, Color) &
    has_card_color(Player, 4, Color) &
    ~has_card_color(Player, 5, Color).

common_slots(Player, Color, [2,3,5]) [domain(hanabi)] :-
    cards_per_player(5) & color(Color) &
    ~has_card_color(Player, 1, Color) &
    has_card_color(Player, 2, Color) &
    has_card_color(Player, 3, Color) &
    ~has_card_color(Player, 4, Color) &
    has_card_color(Player, 5, Color).

common_slots(Player, Color, [2,4,5]) [domain(hanabi)] :-
    cards_per_player(5) & color(Color) &
    ~has_card_color(Player, 1, Color) &
    has_card_color(Player, 2, Color) &
    ~has_card_color(Player, 3, Color) &
    has_card_color(Player, 4, Color) &
    has_card_color(Player, 5, Color).

common_slots(Player, Color, [3,4,5]) [domain(hanabi)] :-
    cards_per_player(5) & color(Color) &
    ~has_card_color(Player, 1, Color) &
    ~has_card_color(Player, 2, Color) &
    has_card_color(Player, 3, Color) &
    has_card_color(Player, 4, Color) &
    has_card_color(Player, 5, Color).

common_slots(Player, Color, [1,2,3,4]) [domain(hanabi)] :-
    cards_per_player(5) & color(Color) &
    has_card_color(Player, 1, Color) &
    has_card_color(Player, 2, Color) &
    has_card_color(Player, 3, Color) &
    has_card_color(Player, 4, Color) &
    ~has_card_color(Player, 5, Color).

common_slots(Player, Color, [1,2,3,5]) [domain(hanabi)] :-
    cards_per_player(5) & color(Color) &
    has_card_color(Player, 1, Color) &
    has_card_color(Player, 2, Color) &
    has_card_color(Player, 3, Color) &
    ~has_card_color(Player, 4, Color) &
    has_card_color(Player, 5, Color).

common_slots(Player, Color, [1,2,4,5]) [domain(hanabi)] :-
    cards_per_player(5) & color(Color) &
    has_card_color(Player, 1, Color) &
    has_card_color(Player, 2, Color) &
    ~has_card_color(Player, 3, Color) &
    has_card_color(Player, 4, Color) &
    has_card_color(Player, 5, Color).

common_slots(Player, Color, [1,3,4,5]) [domain(hanabi)] :-
    cards_per_player(5) & color(Color) &
    has_card_color(Player, 1, Color) &
    ~has_card_color(Player, 2, Color) &
    has_card_color(Player, 3, Color) &
    has_card_color(Player, 4, Color) &
    has_card_color(Player, 5, Color).

common_slots(Player, Color, [2,3,4,5]) [domain(hanabi)] :-
    cards_per_player(5) & color(Color) &
    ~has_card_color(Player, 1, Color) &
    has_card_color(Player, 2, Color) &
    has_card_color(Player, 3, Color) &
    has_card_color(Player, 4, Color) &
    has_card_color(Player, 5, Color).

common_slots(Player, Color, [1,2,3,4,5]) [domain(hanabi)] :-
    cards_per_player(5) & color(Color) &
    has_card_color(Player, 1, Color) &
    has_card_color(Player, 2, Color) &
    has_card_color(Player, 3, Color) &
    has_card_color(Player, 4, Color) &
    has_card_color(Player, 5, Color).


/* ---------- COMMON SLOTS BY RANK ---------- */

// common_slots(Player, Rank, []) [domain(hanabi)] :-
//     cards_per_player(4) & rank(Rank) &
//     ~has_card_rank(Player, 1, Rank) &
//     ~has_card_rank(Player, 2, Rank) &
//     ~has_card_rank(Player, 3, Rank) &
//     ~has_card_rank(Player, 4, Rank).

common_slots(Player, Rank, [1]) [domain(hanabi)] :-
    cards_per_player(4) & rank(Rank) &
    has_card_rank(Player, 1, Rank) &
    ~has_card_rank(Player, 2, Rank) &
    ~has_card_rank(Player, 3, Rank) &
    ~has_card_rank(Player, 4, Rank).

common_slots(Player, Rank, [2]) [domain(hanabi)] :-
    cards_per_player(4) & rank(Rank) &
    ~has_card_rank(Player, 1, Rank) &
    has_card_rank(Player, 2, Rank) &
    ~has_card_rank(Player, 3, Rank) &
    ~has_card_rank(Player, 4, Rank).

common_slots(Player, Rank, [3]) [domain(hanabi)] :-
    cards_per_player(4) & rank(Rank) &
    ~has_card_rank(Player, 1, Rank) &
    ~has_card_rank(Player, 2, Rank) &
    has_card_rank(Player, 3, Rank) &
    ~has_card_rank(Player, 4, Rank).

common_slots(Player, Rank, [4]) [domain(hanabi)] :-
    cards_per_player(4) & rank(Rank) &
    ~has_card_rank(Player, 1, Rank) &
    ~has_card_rank(Player, 2, Rank) &
    ~has_card_rank(Player, 3, Rank) &
    has_card_rank(Player, 4, Rank).

common_slots(Player, Rank, [1,2]) [domain(hanabi)] :-
    cards_per_player(4) & rank(Rank) &
    has_card_rank(Player, 1, Rank) &
    has_card_rank(Player, 2, Rank) &
    ~has_card_rank(Player, 3, Rank) &
    ~has_card_rank(Player, 4, Rank).

common_slots(Player, Rank, [1,3]) [domain(hanabi)] :-
    cards_per_player(4) & rank(Rank) &
    has_card_rank(Player, 1, Rank) &
    ~has_card_rank(Player, 2, Rank) &
    has_card_rank(Player, 3, Rank) &
    ~has_card_rank(Player, 4, Rank).

common_slots(Player, Rank, [1,4]) [domain(hanabi)] :-
    cards_per_player(4) & rank(Rank) &
    has_card_rank(Player, 1, Rank) &
    ~has_card_rank(Player, 2, Rank) &
    ~has_card_rank(Player, 3, Rank) &
    has_card_rank(Player, 4, Rank).

common_slots(Player, Rank, [2,3]) [domain(hanabi)] :-
    cards_per_player(4) & rank(Rank) &
    ~has_card_rank(Player, 1, Rank) &
    has_card_rank(Player, 2, Rank) &
    has_card_rank(Player, 3, Rank) &
    ~has_card_rank(Player, 4, Rank).

common_slots(Player, Rank, [2,4]) [domain(hanabi)] :-
    cards_per_player(4) & rank(Rank) &
    ~has_card_rank(Player, 1, Rank) &
    has_card_rank(Player, 2, Rank) &
    ~has_card_rank(Player, 3, Rank) &
    has_card_rank(Player, 4, Rank).

common_slots(Player, Rank, [3,4]) [domain(hanabi)] :-
    cards_per_player(4) & rank(Rank) &
    ~has_card_rank(Player, 1, Rank) &
    ~has_card_rank(Player, 2, Rank) &
    has_card_rank(Player, 3, Rank) &
    has_card_rank(Player, 4, Rank).

common_slots(Player, Rank, [1,2,3]) [domain(hanabi)] :-
    cards_per_player(4) & rank(Rank) &
    has_card_rank(Player, 1, Rank) &
    has_card_rank(Player, 2, Rank) &
    has_card_rank(Player, 3, Rank) &
    ~has_card_rank(Player, 4, Rank).

common_slots(Player, Rank, [1,2,4]) [domain(hanabi)] :-
    cards_per_player(4) & rank(Rank) &
    has_card_rank(Player, 1, Rank) &
    has_card_rank(Player, 2, Rank) &
    ~has_card_rank(Player, 3, Rank) &
    has_card_rank(Player, 4, Rank).

common_slots(Player, Rank, [1,3,4]) [domain(hanabi)] :-
    cards_per_player(4) & rank(Rank) &
    has_card_rank(Player, 1, Rank) &
    ~has_card_rank(Player, 2, Rank) &
    has_card_rank(Player, 3, Rank) &
    has_card_rank(Player, 4, Rank).

common_slots(Player, Rank, [2,3,4]) [domain(hanabi)] :-
    cards_per_player(4) & rank(Rank) &
    ~has_card_rank(Player, 1, Rank) &
    has_card_rank(Player, 2, Rank) &
    has_card_rank(Player, 3, Rank) &
    has_card_rank(Player, 4, Rank).

common_slots(Player, Rank, [1,2,3,4]) [domain(hanabi)] :-
    cards_per_player(4) & rank(Rank) &
    has_card_rank(Player, 1, Rank) &
    has_card_rank(Player, 2, Rank) &
    has_card_rank(Player, 3, Rank) &
    has_card_rank(Player, 4, Rank).


/* ------------------------------------------------------*/



// common_slots(Player, Rank, []) [domain(hanabi)] :-
//     cards_per_player(5) & rank(Rank) &
//     ~has_card_rank(Player, 1, Rank) &
//     ~has_card_rank(Player, 2, Rank) &
//     ~has_card_rank(Player, 3, Rank) &
//     ~has_card_rank(Player, 4, Rank) &
//     ~has_card_rank(Player, 5, Rank).

common_slots(Player, Rank, [1]) [domain(hanabi)] :-
    cards_per_player(5) & rank(Rank) &
    has_card_rank(Player, 1, Rank) &
    ~has_card_rank(Player, 2, Rank) &
    ~has_card_rank(Player, 3, Rank) &
    ~has_card_rank(Player, 4, Rank) &
    ~has_card_rank(Player, 5, Rank).

common_slots(Player, Rank, [2]) [domain(hanabi)] :-
    cards_per_player(5) & rank(Rank) &
    ~has_card_rank(Player, 1, Rank) &
    has_card_rank(Player, 2, Rank) &
    ~has_card_rank(Player, 3, Rank) &
    ~has_card_rank(Player, 4, Rank) &
    ~has_card_rank(Player, 5, Rank).

common_slots(Player, Rank, [3]) [domain(hanabi)] :-
    cards_per_player(5) & rank(Rank) &
    ~has_card_rank(Player, 1, Rank) &
    ~has_card_rank(Player, 2, Rank) &
    has_card_rank(Player, 3, Rank) &
    ~has_card_rank(Player, 4, Rank) &
    ~has_card_rank(Player, 5, Rank).

common_slots(Player, Rank, [4]) [domain(hanabi)] :-
    cards_per_player(5) & rank(Rank) &
    ~has_card_rank(Player, 1, Rank) &
    ~has_card_rank(Player, 2, Rank) &
    ~has_card_rank(Player, 3, Rank) &
    has_card_rank(Player, 4, Rank) &
    ~has_card_rank(Player, 5, Rank).

common_slots(Player, Rank, [5]) [domain(hanabi)] :-
    cards_per_player(5) & rank(Rank) &
    ~has_card_rank(Player, 1, Rank) &
    ~has_card_rank(Player, 2, Rank) &
    ~has_card_rank(Player, 3, Rank) &
    ~has_card_rank(Player, 4, Rank) &
    has_card_rank(Player, 5, Rank).

common_slots(Player, Rank, [1,2]) [domain(hanabi)] :-
    cards_per_player(5) & rank(Rank) &
    has_card_rank(Player, 1, Rank) &
    has_card_rank(Player, 2, Rank) &
    ~has_card_rank(Player, 3, Rank) &
    ~has_card_rank(Player, 4, Rank) &
    ~has_card_rank(Player, 5, Rank).

common_slots(Player, Rank, [1,3]) [domain(hanabi)] :-
    cards_per_player(5) & rank(Rank) &
    has_card_rank(Player, 1, Rank) &
    ~has_card_rank(Player, 2, Rank) &
    has_card_rank(Player, 3, Rank) &
    ~has_card_rank(Player, 4, Rank) &
    ~has_card_rank(Player, 5, Rank).

common_slots(Player, Rank, [1,4]) [domain(hanabi)] :-
    cards_per_player(5) & rank(Rank) &
    has_card_rank(Player, 1, Rank) &
    ~has_card_rank(Player, 2, Rank) &
    ~has_card_rank(Player, 3, Rank) &
    has_card_rank(Player, 4, Rank) &
    ~has_card_rank(Player, 5, Rank).

common_slots(Player, Rank, [1,5]) [domain(hanabi)] :-
    cards_per_player(5) & rank(Rank) &
    has_card_rank(Player, 1, Rank) &
    ~has_card_rank(Player, 2, Rank) &
    ~has_card_rank(Player, 3, Rank) &
    ~has_card_rank(Player, 4, Rank) &
    has_card_rank(Player, 5, Rank).

common_slots(Player, Rank, [2,3]) [domain(hanabi)] :-
    cards_per_player(5) & rank(Rank) &
    ~has_card_rank(Player, 1, Rank) &
    has_card_rank(Player, 2, Rank) &
    has_card_rank(Player, 3, Rank) &
    ~has_card_rank(Player, 4, Rank) &
    ~has_card_rank(Player, 5, Rank).

common_slots(Player, Rank, [2,4]) [domain(hanabi)] :-
    cards_per_player(5) & rank(Rank) &
    ~has_card_rank(Player, 1, Rank) &
    has_card_rank(Player, 2, Rank) &
    ~has_card_rank(Player, 3, Rank) &
    has_card_rank(Player, 4, Rank) &
    ~has_card_rank(Player, 5, Rank).

common_slots(Player, Rank, [2,5]) [domain(hanabi)] :-
    cards_per_player(5) & rank(Rank) &
    ~has_card_rank(Player, 1, Rank) &
    has_card_rank(Player, 2, Rank) &
    ~has_card_rank(Player, 3, Rank) &
    ~has_card_rank(Player, 4, Rank) &
    has_card_rank(Player, 5, Rank).

common_slots(Player, Rank, [3,4]) [domain(hanabi)] :-
    cards_per_player(5) & rank(Rank) &
    ~has_card_rank(Player, 1, Rank) &
    ~has_card_rank(Player, 2, Rank) &
    has_card_rank(Player, 3, Rank) &
    has_card_rank(Player, 4, Rank) &
    ~has_card_rank(Player, 5, Rank).

common_slots(Player, Rank, [3,5]) [domain(hanabi)] :-
    cards_per_player(5) & rank(Rank) &
    ~has_card_rank(Player, 1, Rank) &
    ~has_card_rank(Player, 2, Rank) &
    has_card_rank(Player, 3, Rank) &
    ~has_card_rank(Player, 4, Rank) &
    has_card_rank(Player, 5, Rank).

common_slots(Player, Rank, [4,5]) [domain(hanabi)] :-
    cards_per_player(5) & rank(Rank) &
    ~has_card_rank(Player, 1, Rank) &
    ~has_card_rank(Player, 2, Rank) &
    ~has_card_rank(Player, 3, Rank) &
    has_card_rank(Player, 4, Rank) &
    has_card_rank(Player, 5, Rank).

common_slots(Player, Rank, [1,2,3]) [domain(hanabi)] :-
    cards_per_player(5) & rank(Rank) &
    has_card_rank(Player, 1, Rank) &
    has_card_rank(Player, 2, Rank) &
    has_card_rank(Player, 3, Rank) &
    ~has_card_rank(Player, 4, Rank) &
    ~has_card_rank(Player, 5, Rank).

common_slots(Player, Rank, [1,2,4]) [domain(hanabi)] :-
    cards_per_player(5) & rank(Rank) &
    has_card_rank(Player, 1, Rank) &
    has_card_rank(Player, 2, Rank) &
    ~has_card_rank(Player, 3, Rank) &
    has_card_rank(Player, 4, Rank) &
    ~has_card_rank(Player, 5, Rank).

common_slots(Player, Rank, [1,2,5]) [domain(hanabi)] :-
    cards_per_player(5) & rank(Rank) &
    has_card_rank(Player, 1, Rank) &
    has_card_rank(Player, 2, Rank) &
    ~has_card_rank(Player, 3, Rank) &
    ~has_card_rank(Player, 4, Rank) &
    has_card_rank(Player, 5, Rank).

common_slots(Player, Rank, [1,3,4]) [domain(hanabi)] :-
    cards_per_player(5) & rank(Rank) &
    has_card_rank(Player, 1, Rank) &
    ~has_card_rank(Player, 2, Rank) &
    has_card_rank(Player, 3, Rank) &
    has_card_rank(Player, 4, Rank) &
    ~has_card_rank(Player, 5, Rank).

common_slots(Player, Rank, [1,3,5]) [domain(hanabi)] :-
    cards_per_player(5) & rank(Rank) &
    has_card_rank(Player, 1, Rank) &
    ~has_card_rank(Player, 2, Rank) &
    has_card_rank(Player, 3, Rank) &
    ~has_card_rank(Player, 4, Rank) &
    has_card_rank(Player, 5, Rank).

common_slots(Player, Rank, [1,4,5]) [domain(hanabi)] :-
    cards_per_player(5) & rank(Rank) &
    has_card_rank(Player, 1, Rank) &
    ~has_card_rank(Player, 2, Rank) &
    ~has_card_rank(Player, 3, Rank) &
    has_card_rank(Player, 4, Rank) &
    has_card_rank(Player, 5, Rank).

common_slots(Player, Rank, [2,3,4]) [domain(hanabi)] :-
    cards_per_player(5) & rank(Rank) &
    ~has_card_rank(Player, 1, Rank) &
    has_card_rank(Player, 2, Rank) &
    has_card_rank(Player, 3, Rank) &
    has_card_rank(Player, 4, Rank) &
    ~has_card_rank(Player, 5, Rank).

common_slots(Player, Rank, [2,3,5]) [domain(hanabi)] :-
    cards_per_player(5) & rank(Rank) &
    ~has_card_rank(Player, 1, Rank) &
    has_card_rank(Player, 2, Rank) &
    has_card_rank(Player, 3, Rank) &
    ~has_card_rank(Player, 4, Rank) &
    has_card_rank(Player, 5, Rank).

common_slots(Player, Rank, [2,4,5]) [domain(hanabi)] :-
    cards_per_player(5) & rank(Rank) &
    ~has_card_rank(Player, 1, Rank) &
    has_card_rank(Player, 2, Rank) &
    ~has_card_rank(Player, 3, Rank) &
    has_card_rank(Player, 4, Rank) &
    has_card_rank(Player, 5, Rank).

common_slots(Player, Rank, [3,4,5]) [domain(hanabi)] :-
    cards_per_player(5) & rank(Rank) &
    ~has_card_rank(Player, 1, Rank) &
    ~has_card_rank(Player, 2, Rank) &
    has_card_rank(Player, 3, Rank) &
    has_card_rank(Player, 4, Rank) &
    has_card_rank(Player, 5, Rank).

common_slots(Player, Rank, [1,2,3,4]) [domain(hanabi)] :-
    cards_per_player(5) & rank(Rank) &
    has_card_rank(Player, 1, Rank) &
    has_card_rank(Player, 2, Rank) &
    has_card_rank(Player, 3, Rank) &
    has_card_rank(Player, 4, Rank) &
    ~has_card_rank(Player, 5, Rank).

common_slots(Player, Rank, [1,2,3,5]) [domain(hanabi)] :-
    cards_per_player(5) & rank(Rank) &
    has_card_rank(Player, 1, Rank) &
    has_card_rank(Player, 2, Rank) &
    has_card_rank(Player, 3, Rank) &
    ~has_card_rank(Player, 4, Rank) &
    has_card_rank(Player, 5, Rank).

common_slots(Player, Rank, [1,2,4,5]) [domain(hanabi)] :-
    cards_per_player(5) & rank(Rank) &
    has_card_rank(Player, 1, Rank) &
    has_card_rank(Player, 2, Rank) &
    ~has_card_rank(Player, 3, Rank) &
    has_card_rank(Player, 4, Rank) &
    has_card_rank(Player, 5, Rank).

common_slots(Player, Rank, [1,3,4,5]) [domain(hanabi)] :-
    cards_per_player(5) & rank(Rank) &
    has_card_rank(Player, 1, Rank) &
    ~has_card_rank(Player, 2, Rank) &
    has_card_rank(Player, 3, Rank) &
    has_card_rank(Player, 4, Rank) &
    has_card_rank(Player, 5, Rank).

common_slots(Player, Rank, [2,3,4,5]) [domain(hanabi)] :-
    cards_per_player(5) & rank(Rank) &
    ~has_card_rank(Player, 1, Rank) &
    has_card_rank(Player, 2, Rank) &
    has_card_rank(Player, 3, Rank) &
    has_card_rank(Player, 4, Rank) &
    has_card_rank(Player, 5, Rank).

common_slots(Player, Rank, [1,2,3,4,5]) [domain(hanabi)] :-
    cards_per_player(5) & rank(Rank) &
    has_card_rank(Player, 1, Rank) &
    has_card_rank(Player, 2, Rank) &
    has_card_rank(Player, 3, Rank) &
    has_card_rank(Player, 4, Rank) &
    has_card_rank(Player, 5, Rank).