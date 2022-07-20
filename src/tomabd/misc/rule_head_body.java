package tomabd.misc;

import jason.*;
import jason.asSyntax.*;
import jason.asSemantics.*;

/**
 * Separate/build a logical rule into/from its head and body.
 * 
 * <b>Usage:</b>
 *      - <tt>tomabd.misc.rule_head_body({a :- b & c}, H, B)</tt>: <tt>H</tt>
 *      unifies with <tt>a</tt> and <tt>B</tt> unifies with <tt>b & c</tt>.
 *      - <tt>tomabd.misc.rule_head_body(R, a, b & c)</tt>: <tt>R</tt>
 *      unifies with <tt>{a :- b & c}</tt>.
 */
public class rule_head_body extends DefaultInternalAction {

    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
        try {
            if (!args[0].isVar()) {
                // given a rule, return its head and its body
                Rule rule = (Rule)args[0];
                Literal head = rule.getHead();
                LogicalFormula body = rule.getBody();
                return (un.unifies(head, args[1]) && un.unifies(body, args[2]));
            } else {
                // given the head and the body, build the rule
                Literal head = (Literal)args[1];
                LogicalFormula body = (LogicalFormula)args[2];               
                Rule rule = new Rule(head, body);
                return un.unifies(rule, args[0]);
            }
        } catch (Exception e) {
            throw new JasonException("Error in 'tomabd.misc.rule_head_body': " + e.toString());
        }
    }
    
}
