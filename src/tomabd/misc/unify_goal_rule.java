package tomabd.misc;

import jason.*;
import jason.asSyntax.*;
import jason.asSemantics.*;

/**
 * Unify the grounded variables in the goal with the free variables in the
 * rule.
 * 
 * <b>Usage:</b>
 * 
 * <tt>tomabd.misc.unify_goal_rule(a(b), {a(X) :- c(X) & d(Y)}, R)</tt>:
 * <tt>R</tt> unifies with <tt>{a(b) :- c(b) & d(Y)}</tt>.
 */
public class unify_goal_rule extends DefaultInternalAction {

    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
        try {

            // 1. Annonymize variables in the goal and in the rule
            Unifier annonUnif = new Unifier();
            Literal goal = (Literal)args[0];
            Literal annonGoal = goal.makeVarsAnnon(annonUnif);
            annonGoal.clearAnnots();
            Rule rule = (Rule)args[1];
            Rule annonRule = (Rule)rule.makeVarsAnnon(annonUnif);

            // 2. Unify the goal with the head of the rule
            Literal ruleHead = annonRule.getHead();
            ruleHead.clearAnnots();
            Literal ruleBody = (Literal)rule.getBody();
            Unifier goalRuleUnif = new Unifier();
            goalRuleUnif.unifies(ruleHead, annonGoal);

            // 3. Apply unifier to the head and the body of the rule to build a new one
            Literal newHead = annonRule.headCApply(goalRuleUnif);
            Literal newBody = (Literal)ruleBody.capply(goalRuleUnif);
            Rule newRule = new Rule(newHead, newBody);

            return un.unifies(newRule, args[2]);

        } catch (Exception e) {
            throw new JasonException("Error in 'unify_goal_rule': " + e.toString());
        }
    }
    
}
