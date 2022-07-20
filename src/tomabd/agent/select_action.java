package tomabd.agent;

import jason.*;
import jason.asSyntax.*;
import jason.asSemantics.*;

/**
 * This internal action provides an interface from the agent's AgentSpeak
 * (.asl) code to the agent's \ref tomabd.agent.TomAbdAgent.selectAction
 * method.
 * 
 * <b>Usage:</b>
 * \code{.asl}
 * +!g : c
 *      <- ...;
 *      tomabd.agent.select_action(
 *          Action,         // a variable that is bound by the IA
 *          Priority        // a variable that is bound by the IA
 *      );
 *      ...;
 *      Action;             // if the action is modelled as an action on the environment, or
 *      !Action;            // if the action is modelled as an achievement goal
 *      ...
 * \endcode
 */
public class select_action extends DefaultInternalAction {

    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
        try {
            TomAbdAgent ag = (TomAbdAgent) ts.getAg();
            Object[] actionPrio = ag.selectAction();
            Atom action = (Atom) actionPrio[0];
            Double priority = (Double) actionPrio[1];
            NumberTermImpl priorityTerm = new NumberTermImpl(priority);
            return un.unifies(action, args[0]) && un.unifies(priorityTerm, args[1]);
        } catch (Exception e) {
            throw new JasonException("Error in 'tomabd.agent.select_action': " + e.toString());
        }
    }
    
}