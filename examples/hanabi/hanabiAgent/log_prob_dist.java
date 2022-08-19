package hanabiAgent;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.util.Iterator;

import jason.*;
import jason.asSyntax.*;
import jason.bb.BeliefBase;
import jason.asSemantics.*;

public class log_prob_dist extends DefaultInternalAction {

    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
        try {
            String suffix = ((Atom) args[0]).toString();
            Agent ag = ts.getAg();
            String agName = ts.getAgArch().getAgName();
            Unifier queryU = new Unifier();

            Literal numPlayers = Literal.parseLiteral("num_players(NP)");
            Literal seed = Literal.parseLiteral("seed(S)");
            Literal move = Literal.parseLiteral("move(M)");

            ag.believes(numPlayers, queryU);
            ag.believes(seed, queryU);
            ag.believes(move, queryU);

            String numPlayersStr = ((NumberTermImpl) queryU.get("NP")).toString();
            String seedStr = ((NumberTermImpl) queryU.get("S")).toString();
            String moveStr = ((NumberTermImpl) queryU.get("M")).toString();

            String fileName = String.format("results_%s_%s/%s_%s_%s.csv", numPlayersStr, seedStr, agName, moveStr, suffix);
            File file = new File(fileName);
            file.createNewFile();
            FileWriter fw = new FileWriter(fileName);
            BufferedWriter bw = new BufferedWriter(fw);
            bw.write("slot;color;rank;num\n");

            Literal possibleCards = Literal.parseLiteral("possible_cards(S,C,R,N)");
            queryU.clear();
            Iterator<Unifier> it = possibleCards.logicalConsequence(ag, queryU);
            while (it.hasNext()) {
                Unifier u = it.next();
                String slot = ((NumberTermImpl) u.get("S")).toString();
                String color = ((Atom) u.get("C")).toString();
                String rank = ((NumberTermImpl) u.get("R")).toString();
                String num = ((NumberTermImpl) u.get("N")).toString();
                bw.write(String.format("%s;%s;%s;%s\n", slot, color, rank, num));
            }
            bw.close();

            return true;
        } catch (Exception e) {
            throw new JasonException("Error in 'hanabiAgent.log_prob_dist': " + e.toString());
        }
    }
    
}
