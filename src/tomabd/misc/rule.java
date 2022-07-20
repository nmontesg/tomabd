package tomabd.misc;

import jason.*;
import jason.asSyntax.*;
import jason.asSemantics.*;
import java.util.ArrayList;
import java.util.Iterator;
import tomabd.agent.TomAbdAgent;

/**
 * Check whether the argument is a rule or return an iterator over the rules
 * in the belief base.
 * 
 * <b>Usage:</b>
 *      - <tt>tomabd.misc.rule({a :- b & c})</tt>: true
 *      - <tt>tomabd.misc.rule(b [source(self)])</tt>: false
 *      - <tt>.findall(R, tomabd.misc.rule(R), L)</tt>: <tt>L</tt> unifies
 *      with a list of all the rules in the belief base.
 */
public class rule extends DefaultInternalAction {

    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
        if (!args[0].isVar()) {
            // the argument is not a variable, return whether it is a rule
            try {
                Term t = args[0];
                return t.isRule();
            } catch (Exception e) {
                throw new JasonException("Error in 'tomabd.misc.rule': " + e.toString());
            }
        } else {
            // the argument is a variable, return an interator of unifiers over
            // the rules in the agent's BB
            TomAbdAgent ag = (TomAbdAgent)ts.getAg();
            ArrayList<Rule> ruleList = new ArrayList<Rule>();
            for (Literal l : ag.getBB()) {
                if (l.isRule()) {
                    Rule r = (Rule)l.clone();
                    ruleList.add(r);
                }
            }
            Iterator<Rule> it = ruleList.iterator();

            return new Iterator<Unifier>() {

                public boolean hasNext() { return it.hasNext(); }

                public Unifier next() {
                    Rule r = it.next();
                    Unifier annonUnif = new Unifier();
                    Rule annonRule = (Rule)r.makeVarsAnnon(annonUnif);
                    Unifier c = (Unifier)un.clone();
                    c.unifies(annonRule, args[0]);
                    return c;
                }

            };
        }
    }
}
