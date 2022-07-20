package tomabd.misc;

import jason.*;
import jason.asSyntax.*;
import jason.asSemantics.*;

/**
 * Get the annotation list of a literal.
 * 
 * <b>Usage:</b>
 * 
 * <tt>tomabd.misc.get_annots(a [source(self), prob(0.5)], L)</tt>: <tt>L</tt>
 * unifies with <tt>[source(self), prob(0.5)]</tt>.
 */
public class get_annots extends DefaultInternalAction {

    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
        try {
            Literal l = (Literal)args[0];
            ListTerm annots = l.getAnnots();
            return un.unifies(annots, args[1]);
        } catch (Exception e) {
            throw new JasonException("Error in 'tomabd.misc.get_annots': " + e.toString());
        }
    }
    
}
