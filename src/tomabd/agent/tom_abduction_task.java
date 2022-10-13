package tomabd.agent;

import java.util.List;
import java.util.concurrent.TimeUnit;

import jason.*;
import jason.asSyntax.*;
import jason.asSemantics.*;
import com.google.common.base.Stopwatch;

/**
 * This internal action provides an interface from the agent's AgentSpeak
 * (.asl) code to the agent's \ref tomabd.agent.TomAbdAgent.tomAbductionTask
 * method.
 * 
 * <b>Usage:</b>
 * \code{.asl}
 * +!g : c
 *      <- ...;
 *      tomabd.agent.tom_abduction_task(
 *          ObserverViewpoint,               // a list
 *          ActingAgent,                     // an atom
 *          Action,                          // an atom
 *          ActorViewpointExplanation,       // a variable that is bound by the IA
 *          ObserverViewpointExplanations,   // a variable that is bound by the IA
 *          ActorAbductiveTomRule,           // a variable that is bound by the IA
 *          ObserverAbductiveTomRule         // a variable that is bound by the IA
 *      );
 *      ...
 * \endcode
 */
public class tom_abduction_task extends DefaultInternalAction {

    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
        try {
            TomAbdAgent ag = (TomAbdAgent)ts.getAg();
            ListTermImpl obsAgentLevelTerm = (ListTermImpl) args[0];
            List<Term> obsAgentLevel = obsAgentLevelTerm.getAsList();
            Atom actor = (Atom) args[1];
            Atom action = (Atom) args[2];

            Stopwatch timer = Stopwatch.createUnstarted();
            timer.start();
            Literal[] tomAbdRules = ag.tomAbductionTask(obsAgentLevel, actor, action);
            timer.stop();
            long et = timer.elapsed(TimeUnit.MICROSECONDS);

            if (tomAbdRules[0] != null) {
                un.unifies(tomAbdRules[0], args[3]);
            }
            if (tomAbdRules[1] != null) {
                un.unifies(tomAbdRules[1], args[4]);
            }
            if (tomAbdRules[2] != null) {
                un.unifies(tomAbdRules[2], args[5]);
            }
            if (tomAbdRules[3] != null) {
                un.unifies(tomAbdRules[3], args[6]);
            }
            NumberTermImpl etTerm = new NumberTermImpl(et);
            un.unifies(etTerm, args[7]);
            return true;
        } catch (Exception e) {
            throw new JasonException("Error in 'tomabd.agent.tom_abduction_task': " + e.toString());
        }
    }
    
}