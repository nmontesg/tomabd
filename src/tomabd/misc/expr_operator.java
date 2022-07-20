/**
 * \namespace tomabd.misc
 * 
 * \brief Additional internal actions.
 * 
 * This package provides additional internal actions to manipulate Jason
 * elements (logical formulas, rules, and literals) from the AgentSpeak code.
 */
package tomabd.misc;

import jason.*;
import jason.asSyntax.*;
import jason.asSemantics.*;

/**
 * Extract the operator of a logical internal action.
 * 
 * <b>Usage:</b>
 *      - <tt>tomabd.misc.expr_operator(a & b, Op)</tt>: <tt>Op</tt> unifies
 *      with <tt>"and"</tt>.
 *      - <tt>tomabd.misc.expr_operator(a | b, Op)</tt>: <tt>Op</tt> unifies
 *      with <tt>"or"</tt>.
 *      - <tt>tomabd.misc.expr_operator(not a, Op)</tt>: <tt>Op</tt> unifies
 *      with <tt>"not"</tt>.
 *      - <tt>tomabd.misc.expr_operator(a & b, Op)</tt>: <tt>Op</tt> unifies
 *      with <tt>"none"</tt>.
 */
public class expr_operator extends DefaultInternalAction {

    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
        try {
            LogExpr expr = (LogExpr)args[0];
            StringTermImpl operator;

            switch (expr.getOp()) {
                case and:
                    operator = new StringTermImpl("and");
                    break;
                
                case or:
                    operator = new StringTermImpl("or");
                    break;

                case not:
                    operator = new StringTermImpl("not");
                    break;
             
                default:
                    operator = new StringTermImpl("none");
            }
            
            return un.unifies(operator, args[1]);

        } catch (ClassCastException e) {
            return false;
        } catch (Exception e) {
            throw new JasonException("Error in 'tomabd.misc.expr_operator': " + e.toString());
        }
    }   
}
