package hanabiEnv;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.Buffer;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Random;

import jason.asSyntax.Literal;
import jason.asSyntax.NumberTermImpl;
import jason.asSyntax.Structure;
import jason.asSyntax.Term;
import jason.environment.Environment;
import jason.mas2j.AgentParameters;
import jason.mas2j.MAS2JProject;
import jason.stdlib.println;


public class HanabiGame extends Environment {
    private List<String> hanabiColors = List.of("red", "yellow", "green", "white", "blue");
    private List<Integer> cardsPerRank = List.of(3, 2, 2, 2, 1);
    private Random cardDealer = new Random();
    private int[][] deck = new int[5][5];

    private ArrayList<String> agents = new ArrayList<String>();
    private HashSet<String> readyAgents = new HashSet<String>();

    // global variables
    private int numPlayers;
    private int numLives, maxLives;
    private int numInfoTokens, maxInfoTokens;
    private int numColors, numRanks;
    private int numTotalCards, numCardsDeck, numDiscardedCards;
    private int[][] discarded = new int[5][5];
    private int[] stack = new int[5];
    private int cardsPerPlayer;
    private int score, maxScore;

    private HanabiCardHolder[] cardHolders = new HanabiCardHolder[5];

    private int move = 1;
    private int playerTurn;
    private boolean lastRound;
    private String lastPlayer;

    private int hintId;
    private int seed;

    private File evolutionLogger;
    // private FileWriter evolutionWriter;
    private BufferedWriter evolutionBuffer;

    private ArrayList<File> probabilityLoggers = new ArrayList<File>();
    // private ArrayList<FileWriter> probabilityWriters = new ArrayList<FileWriter>();
    private ArrayList<BufferedWriter> probabilityBuffers = new ArrayList<BufferedWriter>();

    @Override
    public void init(String[] args) {
        // number of players: read agents from mas2j file itself
        numPlayers = 0;
        try {
            // parse mas2j file
            jason.mas2j.parser.mas2j parser = new jason.mas2j.parser.mas2j(new FileInputStream(args[0]));
            MAS2JProject project = parser.mas();

            // get the names from the project
            for (AgentParameters ap : project.getAgents()) {
                String agName = ap.name;
                agents.add(agName);
                numPlayers += 1;
            }
        } catch (Exception e) {
            throw new RuntimeException("Error while parsing " + args[0] + ": " + e.toString());
        }

        addPercept(Literal.parseLiteral(String.format("num_players(%d)", numPlayers)));
        for (int i = 0; i < numPlayers; i++) {
            addPercept(Literal.parseLiteral(String.format("player(%s)", agents.get(i))));
            addPercept(Literal.parseLiteral(String.format("turn_number(%s,%d)", agents.get(i), i+1)));
        }
        playerTurn = 0;

        // lives
        maxLives = Integer.parseInt(args[1]);
        numLives = maxLives;
        if (maxLives < 1) {
            throw new IllegalArgumentException("number of lives must be at least 1");
        }
        addPercept(Literal.parseLiteral(String.format("max_lives(%d)", maxLives)));
        addPercept(Literal.parseLiteral(String.format("num_lives(%d)", maxLives)));

        // information tokens
        maxInfoTokens = Integer.parseInt(args[2]);
        numInfoTokens = maxInfoTokens;
        if (maxInfoTokens < 1) {
            throw new IllegalArgumentException("number of information tokens must be at least 1");
        }
        addPercept(Literal.parseLiteral(String.format("max_info_tokens(%d)", maxInfoTokens)));
        addPercept(Literal.parseLiteral(String.format("num_info_tokens(%d)", maxInfoTokens)));

        // colors
        numColors = Integer.parseInt(args[3]);
        if (numColors < 1 || numColors > 5) {
            throw new IllegalArgumentException("number of card colors must be between 1 and 5");
        }
        addPercept(Literal.parseLiteral(String.format("num_colors(%d)", numColors)));

        // ranks
        numRanks = Integer.parseInt(args[4]);
        if (numRanks < 1 || numRanks > 5) {
            throw new IllegalArgumentException("number of card ranks must be between 1 and 5");
        }
        addPercept(Literal.parseLiteral(String.format("num_ranks(%d)", numRanks)));

        // total cards in deck
        numTotalCards = 0;
        for (int i = 0; i < numRanks; i++) {
            numTotalCards += numColors * cardsPerRank.get(i);
            addPercept(Literal.parseLiteral(String.format("cards_per_rank(%d,%d)", i+1, cardsPerRank.get(i))));
            addPercept(Literal.parseLiteral(String.format("rank(%d)", i + 1)));
        }
        numCardsDeck = numTotalCards;
        numDiscardedCards = 0;
        addPercept(Literal.parseLiteral(String.format("num_total_cards(%d)", numTotalCards)));
        addPercept(Literal.parseLiteral(String.format("num_cards_deck(%d)", numTotalCards)));
        addPercept(Literal.parseLiteral(String.format("num_discarded_cards(%d)", 0)));

        for (int i = 0; i < numColors; i++) {
            for (int j = 0; j < numRanks; j++) {
                // deck as an array: deck[color][rank(-1)] <-- number of cards
                deck[i][j] = cardsPerRank.get(j);
                // no cards of any color-rank discarded yet
                discarded[i][j] = 0;
                addPercept(Literal.parseLiteral(String.format("discarded(%s,%d,%d)", hanabiColors.get(i), j + 1, 0)));
            }
        }

        // set seed of the random card dealer
        seed = Integer.parseInt(args[5]);
        addPercept(Literal.parseLiteral(String.format("seed(%d)", seed)));
        cardDealer.setSeed(seed);

        // the stacks of cards
        for (int i = 0; i < numColors; i++) {
            stack[i] = 0;
            addPercept(Literal.parseLiteral(String.format("stack(%s,%d)", hanabiColors.get(i), 0)));
            addPercept(Literal.parseLiteral(String.format("color(%s)", hanabiColors.get(i))));
        }

        // number of cards in the holders
        if (numPlayers == 2 || numPlayers == 3) {
            cardsPerPlayer = 5;
        } else {
            cardsPerPlayer = 4;
        }
        addPercept(Literal.parseLiteral(String.format("cards_per_player(%d)", cardsPerPlayer)));
        for (int i = 0; i < cardsPerPlayer; i++) {
            addPercept(Literal.parseLiteral(String.format("slot(%d)", i + 1)));
        }

        // score
        score = 0;
        maxScore = numRanks * numColors;
        addPercept(Literal.parseLiteral(String.format("score(%d)", 0)));
        addPercept(Literal.parseLiteral(String.format("max_score(%d)", maxScore)));

        // hint counter
        hintId = 0;
        addPercept(Literal.parseLiteral(String.format("hint_id(%d)", hintId)));

        // card holders
        for (int i = 0; i < numPlayers; i++) {
            cardHolders[i] = new HanabiCardHolder(agents.get(i), cardsPerPlayer);
        }
        // populate card holders initially from within the environment
        for (int i = 0; i < numPlayers; i++) {
            String agent = agents.get(i);
            for (int j = 1; j <= cardsPerPlayer; j++) {
                drawRandomCard(agent, j);
            }
        }

        lastRound = false;
        lastPlayer = null;

        addPercept(Literal.parseLiteral(String.format("move(%d)", move)));

        // set up logger for the overall evolution of the game
        try {
            String evolutionFileName = String.format("hanabi_%d_%d.csv", numPlayers, seed);
            evolutionLogger = new File(evolutionFileName);
            evolutionLogger.createNewFile();
            FileWriter evolutionWriter = new FileWriter(evolutionFileName);
            evolutionBuffer = new BufferedWriter(evolutionWriter);
            evolutionBuffer.write("move;player;action_functor;actions_args;hints;score\n");
        } catch (IOException e) {
            e.printStackTrace();
        }

        // set up loggers for the probability distributions
        try {
            for (String a: agents) {
                String probabilityFileName = String.format("hanabi_prob_%s_%d_%d.csv", a, numPlayers, seed);
                File probabilityFile = new File(probabilityFileName);
                probabilityFile.createNewFile();
                probabilityLoggers.add(probabilityFile);
                FileWriter probabilityFileWriter = new FileWriter(probabilityFileName);
                BufferedWriter probabilityBuff = new BufferedWriter(probabilityFileWriter);
                // probabilityWriters.add(probabilityFileWriter);
                probabilityBuffers.add(probabilityBuff);
                probabilityBuff.write("move;slot;color;rank;n;after_abduction\n");
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @Override
    public boolean executeAction(String agent, Structure action) {
        boolean result = false;
        int slot;

        // if wrong player is taking action, return false right away
        if (playerTurn > 0 && !agent.equals(agents.get(playerTurn - 1))) {
            return result;
        }

        switch (action.getFunctor()) {
            case "inform_ready":
                result = informReady(agent);
                break;
                
            case "finish_turn":
                result = moveToNextPlayer(agent);
                break;
        
            case "draw_random_card":
                slot = Integer.parseInt(action.getTerm(0).toString());
                result = drawRandomCard(agent, slot);
                break;

            case "reveal_card":
                slot = Integer.parseInt(action.getTerm(0).toString());
                result = revealCard(agent, slot);
                break;

            case "play_card":
                slot = Integer.parseInt(action.getTerm(0).toString());
                result = playCard(agent, slot);
                try {
                    evolutionBuffer.write(String.format("%d;%s;%s;%s;%d;%d\n", move-1, agent, "play_card", slot, hintId, score));
                } catch (IOException e) {
                    e.printStackTrace();
                }
                break;

            case "discard_card":
                slot = Integer.parseInt(action.getTerm(0).toString());
                result = discardCard(agent, slot);
                try {
                    evolutionBuffer.write(String.format("%d;%s;%s;%s;%d;%d\n", move-1, agent, "discard_card", slot, hintId, score));
                } catch (IOException e) {
                    e.printStackTrace();
                }
                break;
            
            case "spend_info_token":
                result = spendInfoToken();
                String actionArgs = action.getTerms().toString();
                String actionArgsNoBrack = actionArgs.substring(1, actionArgs.length()-1);
                try {
                    evolutionBuffer.write(String.format("%d;%s;%s;%s;%d;%d\n", move-1, agent, "give_hint", actionArgsNoBrack, hintId, score));
                } catch (IOException e) {
                    e.printStackTrace();
                }
                break;
            
            case "log_probability":
                int index = agents.indexOf(agent);
                System.out.println(agent + ": line 285");
                BufferedWriter probLog = probabilityBuffers.get(index);
                System.out.println(agent + ": line 287");
                String actionStr = action.toString();
                System.out.println(agent + ": line 289");
                String argStr = actionStr.substring(actionStr.indexOf("(")+1, actionStr.indexOf(")"));
                System.out.println(agent + ": line 291");
                String newArgStr = argStr.replace(",", ";");
                System.out.println(agent + ": line 293");
                try {
                    System.out.println(agent + ": line 295");
                    probLog.write(String.format("%d;%s\n", move-1, newArgStr));
                    System.out.println(agent + ": line 297");
                } catch (IOException e) {
                    e.printStackTrace();
                }
                System.out.println(agent + ": line 301");
                result = true;
                System.out.println(agent + ": line 303");
                break;

            default:
                break;
        }
       
        return result;
    }

    private boolean informReady(String agent) {
        if (readyAgents.contains(agent)) {
            return false;
        }
        readyAgents.add(agent);
        if (readyAgents.size() == numPlayers) {
            playerTurn = 1;
            String movingPlayer = agents.get(playerTurn - 1);
            addPercept(Literal.parseLiteral(String.format("player_turn(%s)", movingPlayer)));
        }
        return true;
    }

    private boolean moveToNextPlayer(String agent) {
        if (lastRound && agent.equals(lastPlayer)) {
            stop();
            return true;
        }
        removePerceptsByUnif(Literal.parseLiteral("player_turn(_)"));
        playerTurn = playerTurn % numPlayers + 1;
        String movingPlayer = agents.get(playerTurn - 1);
        addPercept(Literal.parseLiteral(String.format("player_turn(%s)", movingPlayer)));
        return true;
    }

    private boolean drawRandomCard(String agent, int slot) {
        if (numCardsDeck == 0) {
            return false;
        }

        // draw random card from deck
        String colorDrawn = "none";
        int rankDrawn = -1;
        int chosenCard = cardDealer.nextInt(numCardsDeck);
        int counter = 0, i = 0, j = 0;
        outer: for (i = 0; i < numColors; i++) {
            for (j = 0; j < numRanks; j++) {
                counter += deck[i][j];
                if (counter > chosenCard) {
                    deck[i][j] -= 1;
                    colorDrawn = hanabiColors.get(i);
                    rankDrawn = j + 1;
                    break outer;
                }
            }
        }

        // something went wrong when drawing the card
        if (colorDrawn == "none" || rankDrawn == -1) {
            return false;
        }

        // update numCardsDeck
        numCardsDeck -= 1;
        removePerceptsByUnif(Literal.parseLiteral(String.format("num_cards_deck(_)")));
        addPercept(Literal.parseLiteral(String.format("num_cards_deck(%d)", numCardsDeck)));

        // put the drawn card in the holder of the agent
        int index = agents.indexOf(agent);
        boolean cardCorrectlyPlaced = cardHolders[index].placeCard(slot, colorDrawn, rankDrawn);
        if (!cardCorrectlyPlaced) {
            return false;
        }

        // update percepts for the other agents
        for (int k = 0; k < numPlayers; k++) {
            if (k != index) {
                addPercept(agents.get(k), Literal.parseLiteral(String.format("has_card_color(%s,%d,%s)", agent, slot, colorDrawn)));
                addPercept(agents.get(k), Literal.parseLiteral(String.format("has_card_rank(%s,%d,%d)", agent, slot, rankDrawn)));
            }
        }

        // when last card is drawn, mechanism to consider that only one move per player is left
        if (numCardsDeck == 0) {
            lastRound = true;
            addPercept(Literal.parseLiteral("late_game"));
            lastPlayer = agent;
            addPercept(Literal.parseLiteral(String.format("last_player(%s)", agent)));
        }

        return true;
    }

    private boolean revealCard(String agent, int slot) {
        int index = agents.indexOf(agent);
        HanabiCard card = cardHolders[index].getCard(slot);
        if (card == null) {
            return false;
        }
        addPercept(agent, Literal.parseLiteral(String.format("has_card_color(%s,%d,%s)", agent, slot, card.getColor())));
        addPercept(agent, Literal.parseLiteral(String.format("has_card_rank(%s,%d,%d)", agent, slot, card.getRank())));
        addPercept(Literal.parseLiteral(String.format("knows(%s,has_card_color(%s,%d,%s) [source(percept)]) [domain(hanabi)]", agent, agent, slot, card.getColor())));
        addPercept(Literal.parseLiteral(String.format("knows(%s,has_card_rank(%s,%d,%d) [source(percept)]) [domain(hanabi)]", agent, agent, slot, card.getRank())));
        return true;
    }

    private boolean playCard(String agent, int slot) {
        int index = agents.indexOf(agent);
        HanabiCard card = cardHolders[index].pickCard(slot);
        if (card == null) {
            return false;
        }

        for (String ag : agents) {
            removePerceptsByUnif(ag, Literal.parseLiteral(String.format("has_card_color(%s,%d,_)", agent, slot)));
            removePerceptsByUnif(ag, Literal.parseLiteral(String.format("has_card_rank(%s,%d,_)", agent, slot)));    
        }

        removePerceptsByUnif(Literal.parseLiteral(String.format("knows(%s,has_card_color(%s,%d,_) [source(percept)]) [domain(hanabi)]", agent, agent, slot)));
        removePerceptsByUnif(Literal.parseLiteral(String.format("knows(%s,has_card_rank(%s,%d,_) [source(percept)]) [domain(hanabi)]", agent, agent, slot)));
        
        String color = card.getColor();
        int rank = card.getRank();
        int colorInd = hanabiColors.indexOf(color);
        int stackHeight = stack[colorInd];

        // card is successfully played
        if (rank == stackHeight + 1) {
            // place card in stack
            stack[colorInd] += 1;
            removePerceptsByUnif(Literal.parseLiteral(String.format("stack(%s,_)", color)));
            addPercept(Literal.parseLiteral(String.format("stack(%s,%d)", color, stack[colorInd])));
            // update score by 1 point
            score += 1;
            removePerceptsByUnif(Literal.parseLiteral(String.format("score(_)")));
            addPercept(Literal.parseLiteral(String.format("score(%d)",score)));
            // if current score == maxScore: finish execution of the game
            if (score == maxScore) {
                try {
                    evolutionBuffer.write(String.format("%d;%d;%s;%s;%s;%d;%d\n", seed, move, agent, "play_card", slot, hintId, score));
                } catch (IOException e) {
                    e.printStackTrace();
                }
                stop();
            } else if (rank == numRanks && numInfoTokens < maxInfoTokens) {
                // complete stack has bonus: plus one information token
                numInfoTokens += 1;
                removePerceptsByUnif(Literal.parseLiteral(String.format("num_info_tokens(_)")));
                addPercept(Literal.parseLiteral(String.format("num_info_tokens(%d)", numInfoTokens)));
            }
        } else {
            // cards is not okay to play: loose one live
            numLives -= 1;
            removePerceptsByUnif(Literal.parseLiteral(String.format("num_lives(_)")));
            addPercept(Literal.parseLiteral(String.format("num_lives(%d)", numLives)));

            // discard the badly played card
            numDiscardedCards += 1;
            removePerceptsByUnif(Literal.parseLiteral(String.format("num_discarded_cards(_)")));
            addPercept(Literal.parseLiteral(String.format("num_discarded_cards(%d)", numDiscardedCards)));
            discarded[colorInd][rank-1] += 1;
            removePerceptsByUnif(Literal.parseLiteral(String.format("discarded(%s,%d,_)", color, rank)));
            addPercept(Literal.parseLiteral(String.format("discarded(%s,%d,%d)", color, rank, discarded[colorInd][rank-1])));
        }

        // if all lives lost: loose the game (score goes to 0) and finish execution
        if (numLives == 0) {
            score = 0;
            removePerceptsByUnif(Literal.parseLiteral(String.format("score(_)")));
            addPercept(Literal.parseLiteral(String.format("score(%d)", score)));
            try {
                evolutionBuffer.write(String.format("%d;%d;%s;%s;%s;%d;%d\n", seed, move, agent, "play_card", slot, hintId, score));
            } catch (IOException e) {
                e.printStackTrace();
            }
            stop();
        }

        move += 1;
        removePerceptsByUnif(Literal.parseLiteral(String.format("move(_)")));
        addPercept(Literal.parseLiteral(String.format("move(%d)", move)));
        return true;
    }

    private boolean discardCard(String agent, int slot) {
        if (numInfoTokens == maxInfoTokens) {
            return false;
        }

        // pick the card from the holder
        int index = agents.indexOf(agent);
        HanabiCard card = cardHolders[index].pickCard(slot);
        if (card == null) {
            return false;
        }

        for (String ag : agents) {
            removePerceptsByUnif(ag, Literal.parseLiteral(String.format("has_card_color(%s,%d,_)", agent, slot)));
            removePerceptsByUnif(ag, Literal.parseLiteral(String.format("has_card_rank(%s,%d,_)", agent, slot)));    
        }

        removePerceptsByUnif(Literal.parseLiteral(String.format("knows(%s,has_card_color(%s,%d,_) [source(percept)]) [domain(hanabi)]", agent, agent, slot)));
        removePerceptsByUnif(Literal.parseLiteral(String.format("knows(%s,has_card_rank(%s,%d,_) [source(percept)]) [domain(hanabi)]", agent, agent, slot)));

        String color = card.getColor();
        int rank = card.getRank();
        int colorInd = hanabiColors.indexOf(color);

        numDiscardedCards += 1;
        removePerceptsByUnif(Literal.parseLiteral(String.format("num_discarded_cards(_)")));
        addPercept(Literal.parseLiteral(String.format("num_discarded_cards(%d)", numDiscardedCards)));
        discarded[colorInd][rank-1] += 1;
        removePerceptsByUnif(Literal.parseLiteral(String.format("discarded(%s,%d,_)", color, rank)));
        addPercept(Literal.parseLiteral(String.format("discarded(%s,%d,%d)", color, rank, discarded[colorInd][rank-1])));

        // get one info token
        numInfoTokens += 1;
        removePerceptsByUnif(Literal.parseLiteral(String.format("num_info_tokens(_)")));
        addPercept(Literal.parseLiteral(String.format("num_info_tokens(%d)", numInfoTokens)));

        move += 1;
        removePerceptsByUnif(Literal.parseLiteral(String.format("move(_)")));
        addPercept(Literal.parseLiteral(String.format("move(%d)", move)));
        return true;
    }

    private boolean spendInfoToken() {
        if (numInfoTokens == 0) {
            return false;
        }

        numInfoTokens -= 1;
        removePerceptsByUnif(Literal.parseLiteral(String.format("num_info_tokens(_)")));
        addPercept(Literal.parseLiteral(String.format("num_info_tokens(%d)", numInfoTokens)));

        hintId += 1;
        removePerceptsByUnif(Literal.parseLiteral(String.format("hint_id(_)")));
        addPercept(Literal.parseLiteral(String.format("hint_id(%d)", hintId)));

        move += 1;
        removePerceptsByUnif(Literal.parseLiteral(String.format("move(_)")));
        addPercept(Literal.parseLiteral(String.format("move(%d)", move)));
        return true;
    }

    @Override
    public void stop() {
        super.stop();
        System.out.println(String.format("Game finished with score %d and %d hints.", score, hintId));
        try {
            evolutionBuffer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }

        try{
            for (BufferedWriter bw: probabilityBuffers) {
                bw.close();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        System.exit(0);
    }

}
