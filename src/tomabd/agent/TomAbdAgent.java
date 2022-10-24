/**
 * \mainpage tomabd documentation
 * 
 * This package provides a <a href="http://jason.sourceforge.net">Jason</a>
 * agent that combines Theory of Mind and abductive reasoning to interpret and
 * extract information from the actions of other agents.
 * 
 * The main class of this package is \ref tomabd.agent.TomAbdAgent, since it
 * contains the methods that implement the actual computations. Other
 * classes in the \ref tomabd.agent package are
 * <a href="http://jason.sourceforge.net/api/jason/stdlib/package-summary.html">
 * Jason internal actions</a> (IAs) that provide an interface to the public
 * methods of the \ref tomabd.agent.TomAbdAgent class that are most likely to
 * be invoked from the AgentSpeak code.
 * Other IAs in the \ref tomabd.misc package provide manipulations of
 * AgentSpeak constructs, such as literals, logical formulas and Prolog-like
 * rules. These are particularly handy for writing the Theory of Mind
 * clauses with head <tt>believes(Ag, Fact)</tt> (see \ref viewpoint).
 * 
 * @author Nieves Montes
 * 
 * \section model Agent model
 * 
 * For an example to help understand the discussion that follows, the reader is
 * directed to the <a href="...">examples folder</a>.
 * 
 * The agent model that this package implements revolves around <b>Theory of
 * Mind + abduction (Tom+Abd) task</b>. One task is composed of roughly these
 * steps:
 *      -# Adopt the <ins>acting agent viewpoint</ins>.
 *      -# Generate abductive explanations.
 *      -# Refine abductive explanations from the acting agent viewpoint.
 *      -# Adopt the <ins>observer agent viewpoint</ins>.
 *      -# Refine abductive explanations from the observer agent viewpoint.
 * 
 * Steps 1 and 4 are covered in \ref viewpoint. Steps 2, and 3 and 5 are 
 * covered in abduction.
 * 
 * To set the scene, consider the following:
 *      - Agent \f$i\f$ operating with logic program \f$T_i\f$. refer to agent
 *      \f$i\f$ as the <b>observer agent</b>. Agent \f$i\f$ will be the one
 *      performing a ToM+Abd task.
 *      - Agent \f$j\f$, operating with logic program \f$T_j\f$. We refer to
 *      agent \f$j\f$ as the <b>actor</b> or <b>acting agent</b>.
 * 
 * In BDI terms, the agents' logic programs correspond to their belief bases, 
 * i.e. a set of symbolic facts and rules.
 * 
 * An underlying assumption of this agent model is that agents select their
 * actions according to a set of <b>action selection clauses</b>. This is a set
 * of Prolog-like rules: <tt>action(Agent, Action) :- ...</tt> . These clauses
 * indicate what action should be taken by every agent given their current
 * perception of the system. These clauses are necessary because actions are
 * the queries that need to be explained by the abductive reasoning process
 * (see \ref abduction).
 * 
 * \subsection viewpoint Adopting a different viewpoint
 * 
 * At some time-step, the acting agent \f$j\f$ selects an action \f$a_j\f$ to
 * be executed. Observer agent \f$i\f$ comes to learn that \f$j\f$ has indeed
 * selected \f$a_j\f$. The particular mechanism by which this happens is left
 * as a domain-specific choice for the developer (see \ref usage section).
 * 
 * <b>Note:</b> The action \f$a_j\f$ <i>does not necessarily correspond to an
 * agent action on the environment</i>. It can also be, for example, an
 * achievement goal that is pursued by a plan composed of several atomic
 * actions on the environment. Whichever way \f$a_j\f$ is actually implemented
 * is left as a domain-specific choice to be made by the MAS developer.
 * 
 * When \f$i\f$ learns about \f$j\f$'s action choice, \f$i\f$ seeks to
 * <i>understand</i> the reasons and motivations behind this decision. To do
 * so, \f$i\f$ embarks on a <b>ToM+Abd task</b>.
 * 
 * First, \f$i\f$ engages in Theory of Mind and substitutes its view of the
 * world by <i>the view that it estimates \f$j\f$ has of the world</i>. By
 * doing so, the observer agent \f$i\f$ is putting itself in the shoes of the
 * acting agent \f$j\f$. Computationally, \f$i\f$ substitutes its program
 * \f$T_i\f$ by the program it <i>estimates that \f$j\f$ is operating
 * with</i>. We denote \f$i\f$'s estimation of \f$j\f$'s program by \f$T_{i,j}\f$.
 * \f$T_{i,j}\f$ is computed as follows:
 * \f{equation}{
 *      T_{i,j} = \{\phi \mid T_{i} \models \texttt{believes}(j, \phi)\}
 *      \label{eq:tom}
 * \f}
 * 
 * Note that eq. \f$\eqref{eq:tom}\f$ makes a reference to a <tt>believes/2</tt>
 * predicate. These predicates are specified in a component of the agents'
 * program known as <i>Theory of Mind (ToM) clauses</i>. These clauses specify
 * what the <i>agent believes about what other agents believe</i>, hence they have 
 * head <tt>believes(Agent, Fact)</tt>. ToM clauses are domain-specific rules and
 * they are queried to build an approximation of other agent's programs. Hence,
 * they operate as a meta-interpreter on the program \f$T_i\f$ of the agent
 * performing the ToM+Abd task.
 * 
 * Eq. \f$\eqref{eq:tom}\f$ formulates <i>first-order</i> Theory of Mind.
 * This means that agent \f$i\f$ tries to view the world the way that it thinks
 * \f$j\f$ is perceiving it. However, eq. \f$\eqref{eq:tom}\f$ can be
 * recursively extended to any arbitrary level of Theory of Mind:
 * \f{equation}{
 *      T_{i,k, ..., l, j} = \{\phi \mid
 *          T_{i, k, ..., l} \models \texttt{believes}(j, \phi)\}
 *      \label{eq:tom-recursion}
 * \f}
 * 
 * For example, \f$i\f$ might want to know how \f$j\f$ is estimating that
 * \f$k\f$ is perceiving the world. This corresponds to \f$T_{i,j,k}\f$, a
 * <i>second-order</i> Theory of Mind substitution. In particular, it might be
 * the case that \f$i\f$ wants to know how \f$j\f$ is estimating its own
 * (\f$i\f$'s) view. This corresponds to \f$T_{i,j,i}\f$.
 * 
 * For the discussion that follows, we use the following notation in reference
 * to the symbols in \f$\eqref{eq:tom-recursion}\f$:
 *      - The sequence \f$[k, ..., l, j]\f$ is the <i>actor viewpoint</i>
 *      (excluding the first index of the original agent \f$i\f$).
 *      - The last element of the sequence (\f$j\f$) is the
 *      <i>acting agent</i>.
 *      - The sequence excluding the last element (the actor),
 *      \f$[j, ..., k]\f$, is the <i>observer viewpoint</i>.
 * 
 * In order for the observer agent \f$i\f$ to interpret tha acting agent
 * \f$j\f$'s action, \f$i\f$ needs to switch its perspective to that of the
 * agent. This may mean adopting its direct estimation of \f$j\f$'s program
 * (\f$T_{i,j}\f$) in a <b>first-order</b> ToM+abd task, or through several
 * intermediaries (\f$T_{i,k, ..., l, j}\f$) in a <b>higher-order</b> ToM+abd
 * task. Either way, the substitution of the original agent program by a new
 * (arbitrary) viewpoint is implemented by the
 * \ref tomabd.agent.TomAbdAgent.adoptViewpoint method.
 * 
 * \subsection abduction Generating and refining abductive explanations
 * 
 * Once observer \f$i\f$ has adopted acting agent viewpoint, the observer is
 * in a position to <i>explain</i> why the actor selected action \f$a_j\f$,
 * in hopes that this newly derived knowledge will be useful for his own later
 * decision-making. This <i>inference to the best explanation</i> is called
 * <b>abductive reasoning</b>. In order to compute abductive explanations, it
 * is necessary to specify, in a domain-specific way the set of
 * <b>abducible facts</b>. These are the facts that can possibly compliment a
 * belief base. These are specified through a set of clauses with head
 * <tt>abducible(Fact)</tt>.
 * 
 * The \ref tomabd.agent.TomAbdAgent class automatically loads an abductive
 * meta-interpreter. Given query \f$Q = \texttt{action}(j, a_j)\f$, the
 * abductive meta-interpreter generates a set of <i>raw explanations</i>
 * \f$\Phi\f$, composed of <i>ground</i> abducible facts. This set of raw
 * explanations can be represented in <i>disjunctive normal form</i> (DNF):
 * \f{equation}{
 *      \Phi = (\phi_{11} \; \land \; ... \; \land \; \phi_{1n_1})
 *              \; \lor \; ... \; \lor \;
 *             (\phi_{m1} \; \land \; ... \; \land \; \phi_{mn_m})
 *      \label{eq:dnf}
 * \f}
 * where all \f$\phi_{rs}\f$ are derivable from the current belief base,
 * i.e. \f$T_{i, k, ..., l, j} \models \texttt{abducible}(\phi_{rs})\f$.
 * Within the agent class, this DNF is implemented as a list of lists.
 * 
 * The raw explanations \f$\Phi\f$ need to be <i>refined</i>, first of all,
 * with respect to the viewpoint of the acting agent (i.e. the viewpoint from
 * which they were generated in the first place). This steps allos the
 * opportunity to further modify the raw abductive explanations to, for
 * example, check for inconsistencies with respect to the current agent
 * program \f$T_{i,j,...,k,l}\f$. This <b>explanation refinement step</b> is
 * implemented by the method \ref tomabd.agent.TomAbdAgent.erf.
 * The default computation performs the two following refinement steps:
 *      -# First, for every potential explanation (i.e. every disjunct in
 *      \f$\eqref{eq:dnf}\f$), uninformative atoms are removed.
 *      -# Second, disjuncts that are incompatible with the <i>impossibility
 *      constraints</i> in the current program\f$T_{i,j,...,k,l}\f$ (i.e. at
 *      the acting agent viewpoint) are removed.
 * 
 * The refined explanations with respect to the observer viewpoint are denoted
 * by \f$\Phi^{obs}\f$:
 * \f{equation}{
 *      \Phi^{obs} = (\phi_{11}' \; \land \; ... \; \land \; \phi_{1n_1'}')
 *                   \; \lor \; ... \; \lor \;
 *                   (\phi_{m'1}' \; \land \; ... \; \land \; \phi_{m'n_{m'}'}')
 * \f}
 * 
 * The refined abductive explanation has to hold true. Consequently, <b>its
 * negation must be false</b>. We take advantage of this statement to
 * integrate the \f$\Phi^{Obs}\f$ into the agent program, as logical formulas
 * cannot be added to a Jason belief base, only ground literals. From the
 * negation of \f$\Phi^{Obs}\f$, we build a new <i>impossibility
 * constraint</i> (IC):
 * \f{equation}{
 *      \texttt{imp [source(abduction)] :- }
 *          (\sim\phi_{11}' \; \texttt{|} \; ... \; \texttt{|} \;
 *              \sim\phi_{1n_1'}')
 *          \; \texttt{&} \; ... \; \texttt{&} \;
 *          (\sim\phi_{m'1}' \; \texttt{|} \; ... \; \texttt{|} \;
 *              \sim\phi_{m'n_{m'}'}').
 *      \label{eq:ic-actor}
 * \f}
 * 
 * Note the <tt>source(abduction)</tt> annotation to indicate that this IC
 * is derived from an abductive reasoning process and is <i>not</i> a 
 * domain-dependent IC.
 * 
 * However, eq. \f$\eqref{eq:ic-actor}\f$ cannot be directly added to the 
 * original agent's program \f$T_i\f$. Some extra step has to account for
 * the fact that this explanation has been generated from viewpoint
 * \f$[k, l, ..., j]\f$. To achieve this, the following <tt>believes/2</tt> is
 * recursively built:
 * \f{equation}{
 *      \texttt{believes($k$, ..., believes($l$, believes($j$, imp [source(abduction)]
 *          :- ... )) ... )}
 *      \label{eq:ic-observer}
 * \f}
 * 
 * To allow for flexibility, the method responsible for the Tom+Abd task
 * (\ref tomabd.agent.TomAbdAgent.tomAbductionTask) does not add the
 * generated abductive impossibility constraints in eqs.
 * \f$\eqref{eq:ic-actor}\f$ and \f$\eqref{eq:ic-observer}\f$. That is left as
 * an implementation-dependent choice.
 * 
 * This process allows to update the original agent's (\f$i\f$'s) model of
 * the actor viewpoint. However, the ultimate goal is to update the model of
 * the world from the perspective of the <i>observer</i>. To do so, the whole
 * process of (i) refining the raw explanations; (ii) building the abductive
 * impossibility constraint; and (iii) building a new <tt>believes/2</tt> literal,
 * is repeated, this time from the viewpoint of the <i>observer</i> agent. In
 * case the viewpoint of the observer corresponds directly to the original
 * agent \f$i\f$ (which happens if the Theory of Mind task is first-order), the
 * returned literal is directly of the form in eq. \f$\eqref{eq:ic-actor}\f$.
 * 
 * \subsection euf Updating abductive explanation
 * 
 * Abductive explanation, once generated, will not be valid <i>forever</i>.
 * Therefore, the \ref tomabd.agent.TomAbdAgent has a custom belief
 * update function that includes a call to te <b>explanation update
 * function</b> (euf). The default implementation follows these steps:
 * -# Update the belief base according to <tt>buf()</tt>.
 * -# For every literal originated in an abductive reasoning process
 *    (annotated with <tt>source(abduction)</tt>):
 *      -# Extract the <i>viewpoint</i> at which it was generated and the
 *         associated explanation.
 *      -# Adopt the <i>viewpoint</i> in question.
 *      -# If the associated explanation can now be derived from the current
 *         program, drop the abductive literal from \f$T_i\f$, since it is no
 *         longer informative.
 * 
 * This default explanation update function is implemented in the 
 * \ref tomabd.agent.TomAbdAgent.euf method, and can be overridden by the MAS
 * developer in a custom subclass.
 * 
 * \subsection action-selection Action selection
 * 
 * The whole purpose of the ToM+Abd task is to have the observer agent \f$i\f$
 * in a <i>better informed position</i> when it is \f$i\f$'s turn to act,
 * thanks to the additional knowledge contained in the abductive ICs. Hence,
 * this package also implements a basic action selection function that takes 
 * into account impossibility constraints derived from previous abduction
 * tasks. The default implementation uses all ICs (abductive and 
 * domain-specific) to perform <i>possible worlds reasoning</i>. When
 * querying the action selection rules, the interpreter may come across a 
 * sub-goal that, according to \f$T_i\f$, is <i>abducible</i>. Then,
 * the action selection function looks for all the possible
 * instantiations of this abducible sub-goal. If all of the possible
 * instantiations lead to the same being selected, that action is returned.
 * This is a fairly restrictive action selection mechanisms, however it can
 * be overridden by the MAS developer easily.
 * 
 * This default action selection is implemented in the agent method
 * \ref tomabd.agent.TomAbdAgent.selectAction. The internal action
 * \ref tomabd.agent.select_action is an interface to this method,
 * so that it can be called from the AgentSpeak code (see the following
 * section).
 * 
 * \section usage Usage
 * 
 * This package should be used in multi-agent systems developed using
 * <a href="http://jason.sourceforge.net">Jason</a>. It is also compatible
 * with <a href="http://jacamo.sourceforge.net">JaCaMo</a> (since JaCaMo is
 * an integration of Jason with other agent-oriented programming tools).
 * The recommended way to use this package is to download a copy of the jar
 * file and add it to your project's class-path.
 * 
 * In Jason (.mas2j file):
 * \code{.mas2j}
 * MAS myMAS {
 * 
 *      agents: ...
 *      
 *      environment: ...
 * 
 *      classpath: "path/to/tomabd.jar";
 * 
 * }
 * \endcode
 * 
 * In JaCaMo (.jcm file):
 * \code{.jcm}
 * mas myMAS {
 * 
 *      // agents configuration
 *      ...
 *      
 *      // environment configuration
 *      ...
 * 
 *      // organizations configuration
 *      ...
 * 
 *      // execution configuration
 *      class-path: path/to/tomabd.jar
 *      ...
 *      
 * }
 * \endcode
 * 
 * To trigger a Theory of Mind plus abduction task from the AgentSpeak code,
 * invoke the internal action \ref tomabd.agent.tom_abduction_task :
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
 *          ObserverAbductiveTomRule,        // a variable that is bound by the IA
 *          ElapsedTime                      // a variable that is bound by the IA
 *      );
 *      ...
 * \endcode
 * 
 * The decision on when to invoke this IA is domain-specific and is left to
 * the MAS developer. For example, in the Hanabi game a custom KQML
 * performative <tt>publicAction</tt> is used to announce the selected action.
 * A reception of a message with this performative triggers a Theory of Mind --
 * abduction task:
 * \code{.asl}
 * !kqml_received(KQML_Sender_Var, publicAction, Action, KQML_MsgId)
 *      <- ...
 *      // first-order Theory of Mind -- abduction task
 *      tomabd.agent.tom_abduction_task(
 *          [], KQML_Sender_Var, Action, ActExpls, ObsExpls, ActTomTule, ObsTomRule
 *      );
 *      ...
 * \endcode
 * 
 * If one wishes to use the \ref tomabd.agent.TomAbdAgent.selectAction method
 * to select some or all of an agent's actions or goals to achieve next,
 * the IA \ref tomabd.agent.select_action acts as an interface to this method.
 * Its usage is as follows:
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

/**
 * \namespace tomabd.agent
 * 
 * \brief Includes the main agent class and auxiliary internal actions.
 */
package tomabd.agent;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.TreeMap;
import java.util.logging.Level;

import jason.JasonException;
import jason.NoValueException;
import jason.asSemantics.Agent;
import jason.asSemantics.Unifier;
import jason.asSyntax.Atom;
import jason.asSyntax.ListTerm;
import jason.asSyntax.ListTermImpl;
import jason.asSyntax.Literal;
import jason.asSyntax.LogExpr;
import jason.asSyntax.LogicalFormula;
import jason.asSyntax.NumberTerm;
import jason.asSyntax.NumberTermImpl;
import jason.asSyntax.Rule;
import jason.asSyntax.SetTermImpl;
import jason.asSyntax.Term;
import jason.asSyntax.VarTerm;
import jason.bb.DefaultBeliefBase;

/**
 * Represent a Jason agent capable of Theory of Mind, i.e. switching its
 * perspective to the estimated perspective of other agents (possibly in a
 * recursive fashion).
 */
public class TomAbdAgent extends Agent {

    /**
     * Store a copy of the current belief base while adopting a different
     * viewpoint.
     */
    private DefaultBeliefBase backUp = new DefaultBeliefBase();

    @Override
    public void initAg() {
        super.initAg();

        // include abduction meta-interpreter
        InputStream abductionASL = getClass().getResourceAsStream("abduction.asl");
        try {
            parseAS(abductionASL, "abd-meta-interpreter");
        } catch (Exception e) {
            logger.log(Level.SEVERE, e.toString());
        }
    }

    /**
     * Make a copy of the current belief base in the back-up.
     * 
     * @throws JasonException if the back-up belief base is not empty.
     */
    private final void backUpBeliefs() throws JasonException {
        boolean isBackUpEmpty = (backUp.size() == 0);
        if (!isBackUpEmpty) {
            throw new JasonException("Error in tomabd.agent.TomAbdAgent.backUpBeliefs(): Back-up BB is not empty");
        }
        for (Literal l : bb) {
            backUp.add(l);
        }
    }

    /**
     * Copy the beliefs in the back-up back into the main belief base.
     * 
     * @throws JasonException if the back-up belief base is empty or the main
     *                        belief base is not clear.
     */
    private final void recoverBeliefs() throws JasonException {
        if (backUp.size() == 0) {
            throw new JasonException(
                    "Error in tomabd.agent.TomAbdAgent.recoverBeliefs(): No beliefs in the back-up BB to be copied back to the main BB");
        }
        if (bb.size() != 0) {
            throw new JasonException("Error in tomabd.agent.TomAbdAgent.recoverBeliefs(): The main BB is not empty");
        }
        for (Literal l : backUp) {
            bb.add(l);
        }
        backUp.clear();
    }

    private final void removeBeliefs() {
        bb.clear();
    }

    /**
     * Adopt a different viewpoint for the agent.
     * 
     * @param viewpoint
     * @throws JasonException
     */
    private final void adoptViewpoint(List<Term> viewpoint) throws JasonException {
        try {
            backUpBeliefs();
            if (viewpoint.isEmpty()) {
                return;
            }
            for (Term next : viewpoint) {
                Literal query = Literal.parseLiteral(String.format("believes(%s,Phi)", next.toString()));
                VarTerm phi = (VarTerm) query.getTerm(1);
                Unifier u = new Unifier();
                Iterator<Unifier> queryBindings = query.logicalConsequence(this, u);
                ArrayList<Literal> nextProgram = new ArrayList<Literal>();
                while (queryBindings.hasNext()) {
                    nextProgram.add((Literal) phi.capply(queryBindings.next()));
                }
                removeBeliefs();
                for (Literal l : nextProgram) {
                    bb.add(l);
                }
                u.clear();
            }
        } catch (Exception e) {
            throw new JasonException(String.format("Error in tomabd.agent.TomAbdAgent.adoptViewpoint(%s): %s",
                    viewpoint.toString(), e.toString()));
        }
    }

    /**
     * Get the subset of facts that are not entailed by the current belief
     * base.
     * 
     * @param e
     * @return ListTermImpl
     */
    private ListTermImpl removeUninformativeFacts(ListTermImpl e) {
        ListTermImpl ePrime = new ListTermImpl();
        Unifier u = new Unifier();

        for (Term t : e) {
            Literal f = (Literal) t;
            boolean alreadyBelieves = believes(f, u);
            if (!alreadyBelieves) {
                ePrime.add(f);
            }
            u.clear();
        }

        return ePrime;
    }

    /**
     * Check whether an explanation \f$\Phi\f$ is incompatible with the current
     * belief base.
     * 
     * @param e
     * @return boolean
     */
    private boolean checkImpossibleExplanation(ListTermImpl e) {
        Atom query = new Atom("imp");
        Literal aux = Literal.parseLiteral("aux");

        for (Term t : e) {
            Literal f = (Literal) t;
            f.addAnnot(aux);
            bb.add(f);
        }

        Unifier u = new Unifier();
        boolean impossible = believes(query, u);
        u.clear();

        for (Term t : e) {
            Literal f = (Literal) t;
            bb.remove(f);
            f.delAnnot(aux);
        }

        return impossible;
    }

    /**
     * Explanation revision function. In this default implementation, it
     * returns an explanation where:
     * -# Uninformative facts are removed
     * -# Impossible explanations are removed
     * 
     * @param expls
     * @return ListTermImpl
     * @see \ref tomabd.agent.TomAbdAgent.removeUninformativeFacts,
     *      \ref tomabd.agent.TomAbdAgent.checkImpossibleExplanation
     */
    private ListTermImpl erf(ListTermImpl expls) {

        // 1. Remove uninformative facts from explanations
        ListTermImpl infExpls = new ListTermImpl();
        for (Term t : expls) {
            ListTermImpl e = (ListTermImpl) t;
            ListTermImpl infE = removeUninformativeFacts(e);
            if (infE.size() > 0) {
                infExpls.add(infE);
            }
        }

        // 2. Remove impossible explanations
        ListTermImpl possExpls = new ListTermImpl();
        for (Term t : infExpls) {
            ListTermImpl e = (ListTermImpl) t;
            boolean impossible = checkImpossibleExplanation(e);
            if (!impossible) {
                possExpls.add(e);
            }
        }

        return possExpls;
    }

    /**
     * Build an abductive impossibility constraint clause from a set of
     * explanations.
     * 
     * @param explanations
     * @return Rule
     */
    private Rule buildAbductiveIC(ListTermImpl explanations) {
        // build the disjunctive normal form
        List<Term> listOfConjunctions = new ArrayList<Term>();
        for (Term t : explanations) {
            ListTermImpl e = (ListTermImpl) t;
            listOfConjunctions.add(list2formula(e.getAsList(), LogExpr.LogicalOp.and, false));
        }
        LogicalFormula dnf = list2formula(listOfConjunctions, LogExpr.LogicalOp.or, false);
        if (dnf == null) {
            return null;
        }

        // build the negated disjunctive normal form
        List<Term> listOfNegatedConjunctions = new ArrayList<Term>();
        for (Term t : explanations) {
            ListTermImpl e = (ListTermImpl) t;
            listOfNegatedConjunctions.add(list2formula(e.getAsList(), LogExpr.LogicalOp.or, true));
        }
        LogicalFormula negDnf = list2formula(listOfNegatedConjunctions, LogExpr.LogicalOp.and, false);

        Literal head = Literal.parseLiteral("imp");
        Atom abduction = new Atom("abduction");
        Rule rule = new Rule(head, negDnf);
        rule.addSource(abduction);
        Literal explanation = Literal.parseLiteral(String.format("expl(%s)", dnf.toString()));
        rule.addAnnot(explanation);

        return rule;
    }

    /**
     * Given a viewpoint and an abductive \f$\texttt{imp}\f$ clause, build
     * the corresponding recursive <tt>believes/2</tt> literal.
     * 
     * @param viewpoint
     * @param abductiveIC
     * @return Literal
     */
    private Literal buildTomRule(List<Term> viewpoint, Rule abductiveIC) {
        if (abductiveIC == null) {
            return null;
        }

        if (viewpoint.size() == 0) {
            return abductiveIC;
        }

        ListTerm annots = abductiveIC.getAnnots();
        Literal previous = abductiveIC.clone();
        Literal next = Literal.parseLiteral("believes");
        next.setAnnots(annots);

        for (int i = viewpoint.size() - 1; i >= 0; i--) {
            Atom ag = (Atom) viewpoint.get(i);
            next.addTerm(ag);
            next.addTerm(previous);
            previous = next.copy();
            next.delTerm(1);
            next.delTerm(0);
        }

        return previous;
    }

    /**
     * Remove duplicates from a set of explanations.
     * 
     * @param rawExpls
     * @return ListTermImpl
     */
    private ListTermImpl removeRedundantExplanations(ListTermImpl rawExpls) {
        SetTermImpl compactExpls = new SetTermImpl();
        for (Term t : rawExpls) {
            SetTermImpl compactE = new SetTermImpl();
            for (Term te : (ListTermImpl) t) {
                compactE.add(te);
            }
            compactExpls.add(compactE);
        }
        SetTermImpl resSet = new SetTermImpl();
        for (Term hs : compactExpls) {
            resSet.add((SetTermImpl) hs);
        }
        ListTermImpl resList = new ListTermImpl();
        for (Term t : resSet) {
            ListTermImpl e = (ListTermImpl) ((SetTermImpl) t).getAsListTerm();
            resList.add(e);
        }
        return resList;
    }

    /**
     * Perform a complete Theory of Mind + abductive reasoning task.
     * 
     * @param obsAgentLevel
     * @param actor
     * @param action
     * @return Literal[]
     * @throws JasonException
     * @see tomabd.agent.tom_abduction_task
     */
    public final Literal[] tomAbductionTask(List<Term> obsAgentLevel, Atom actor, Atom action) throws JasonException {
        try {
            // go to the viewpoint of the acting agent
            ArrayList<Term> actAgentLevel = new ArrayList<Term>(obsAgentLevel);
            actAgentLevel.add(actor);
            adoptViewpoint(actAgentLevel);
            Literal curActorViewpoint = Literal.parseLiteral("viewpoint(actor)");
            bb.add(curActorViewpoint);

            // compute abductive explanations
            Literal abductionQuery = Literal
                    .parseLiteral(String.format("abduce(action(%s, %s), [], Delta)", actor, action));
            VarTerm delta = (VarTerm) abductionQuery.getTerm(2);
            Unifier un = new Unifier();
            Iterator<Unifier> abdIU = abductionQuery.logicalConsequence(this, un);
            ListTermImpl rawExplanations = new ListTermImpl();
            while (abdIU.hasNext()) {
                Unifier ans = abdIU.next();
                rawExplanations.add((ListTermImpl) delta.capply(ans));
            }
            ListTermImpl rawExplanationsUnique = removeRedundantExplanations(rawExplanations);

            // post-processing from the perspective of the actor
            ListTermImpl refinedExplanationsActor = erf(rawExplanationsUnique);
            Rule actorAbductiveIC = buildAbductiveIC(refinedExplanationsActor);
            Literal actorAbductiveTomRule = buildTomRule(actAgentLevel, actorAbductiveIC);

            // transition to the viewpoint of the observer
            removeBeliefs();
            recoverBeliefs();
            adoptViewpoint(obsAgentLevel);
            Literal curObsViewpoint = Literal.parseLiteral("viewpoint(observer)");
            bb.add(curObsViewpoint);

            // post-processing from the perspective of the observer
            // take as a starting point the refined explanations from the
            // actor's perspective
            ListTermImpl refinedExplanationsObs = erf(rawExplanationsUnique);
            Rule obsAbductiveIC = buildAbductiveIC(refinedExplanationsObs);
            Literal obsAbductiveTomRule = buildTomRule(obsAgentLevel, obsAbductiveIC);

            removeBeliefs();
            recoverBeliefs();

            Literal[] result = new Literal[4];
            result[0] = refinedExplanationsActor;
            result[1] = refinedExplanationsObs;
            result[2] = actorAbductiveTomRule;
            result[3] = obsAbductiveTomRule;

            return result;

        } catch (Exception e) {
            throw new JasonException("Error in tomabd.TomAbdAgent.tomAbductionTask: " + e.toString());
        }
    }

    /**
     * The Jason default belief update function is overridden to include a
     * call to the explanation update function.
     * 
     * @param percepts
     * @return int
     * @see \ref tomabd.agent.TomAbdAgent.euf
     */
    @Override
    public int buf(Collection<Literal> percepts) {
        int changes = super.buf(percepts);
        euf();
        return changes;
    }

    /**
     * Explanation update function. Remove abductive explanations that are no
     * longer informative <i>in the viewpoint where they held</i>.
     */
    public void euf() {
        Atom abduction = new Atom("abduction");
        List<Literal> abductiveLits = getBeliefsWithSource(abduction);
        Unifier u = new Unifier();

        try {
            for (Literal abdLit : abductiveLits) {

                Object components[] = getAbdToMRuleComponents(abdLit);
                ListTermImpl viewpoint = (ListTermImpl) components[0];
                LogicalFormula explanation = (LogicalFormula) components[1];

                adoptViewpoint(viewpoint.getAsList());

                // check that the abductive explanation is not a logical consequence
                // of the current BB. If it is, it will have to be removed
                boolean uninformative = believes(explanation, u);
                u.clear();

                removeBeliefs();
                recoverBeliefs();

                if (uninformative) {
                    bb.remove(abdLit);
                }
            }

        } catch (Exception e) {
            getLogger().log(Level.SEVERE, e.toString());
        }
    }

    /**
     * Get the beliefs with the given <tt>source</tt> annotation.
     * 
     * @param source
     * @return List<Literal>
     */
    private List<Literal> getBeliefsWithSource(Term source) {
        List<Literal> belsWithSource = new ArrayList<Literal>();
        for (Literal l : bb) {
            if (l.hasSource(source)) {
                belsWithSource.add(l);
            }
        }
        return belsWithSource;
    }

    /**
     * Get the viewpoint and the set of explanations of an abductive IC or
     * <tt>believes/2</tt> literal.
     * 
     * @param l
     * @return Object[]
     * @see \ref tomabd.agent.TomAbdAgent.tomAbductionTask
     */
    private Object[] getAbdToMRuleComponents(Literal l) {
        ListTermImpl viewpoint = new ListTermImpl();
        while (l.getFunctor().equals("believes")) {
            Term next = l.getTerm(0);
            viewpoint.add(next);
            l = (Literal) l.getTerm(1);
        }
        Object result[] = new Object[2];
        result[0] = viewpoint;

        if (l.isRule()) {
            Rule aic = (Rule) l;
            result[1] = (LogicalFormula) aic.getHead().getAnnot("expl").getTerm(0);
        } else {
            result[1] = null;
        }

        return result;
    }

    /**
     * Interpret the default action selection function, considering abductive
     * impossibility constraints and literals.
     * 
     * @return Object[]
     * @throws JasonException
     */
    public Object[] selectAction() throws JasonException {
        try {
            Collection<Rule> sortedActionRules = getSortedActionRules();
            Atom agName = new Atom(getTS().getAgArch().getAgName());
            Atom impossible = new Atom("imp");
            Atom auxiliary = new Atom("aux");
            Object[] result = new Object[2];

            for (Rule rule : sortedActionRules) {

                // bind Agent variable to the name of the agent
                Literal head = rule.getHead();
                VarTerm agVar = (VarTerm) head.getTerm(0);
                Unifier u = new Unifier();
                u.bind(agVar, agName);

                // get the priority
                double priority = ((NumberTermImpl) head.getAnnot("priority").getTerm(0)).solve();

                // get the action with (possibly) free variables
                Literal action = (Literal) head.getTerm(1);

                // get the possible atomic actions
                Unifier un = new Unifier();
                Iterator<Unifier> atomicActionBindings = action.logicalConsequence(this, un);

                // loop over "atomized" action selection rules
                while (atomicActionBindings.hasNext()) {

                    Unifier atomicActionUn = atomicActionBindings.next();
                    Atom atomicAction = (Atom) action.capply(u).capply(atomicActionUn);
                    Rule ruleAtomicAction = (Rule) rule.capply(u).capply(atomicActionUn);

                    List<Object[]> actionsInPossibleWorlds = new ArrayList<Object[]>();
                    List<Term> abducibles = getAbducibles((LogExpr) ruleAtomicAction.getBody());

                    // there are some abducibles: there are (generally) more than one possible world
                    // to consider
                    if (abducibles.size() > 0) {
                        LogicalFormula abdQuery = list2formula(abducibles, LogExpr.LogicalOp.and, false);

                        // find all the potential possible worlds (concerning the current abducibles)
                        Unifier emptyU = new Unifier();
                        Iterator<Unifier> potentialBindings = abdQuery.logicalConsequence(this, emptyU);
                        emptyU.clear();

                        while (potentialBindings.hasNext()) {
                            Unifier potentialWorldBinding = potentialBindings.next();

                            // assert this possible world
                            List<Literal> possibleWorld = new ArrayList<Literal>();
                            for (Term t : abducibles) {
                                Literal possibleFact = (Literal) ((Literal) t).getTerm(0).capply(potentialWorldBinding);
                                possibleWorld.add(possibleFact.addSource(auxiliary));
                            }

                            // check whether the possible world is compatible with impossibility constraints
                            for (Literal l : possibleWorld) {
                                bb.add(l);
                            }
                            boolean isWorldImpossible = believes(impossible, emptyU);
                            emptyU.clear();

                            // skip the current world if it is not consistent with ICs
                            if (isWorldImpossible) {
                                for (Literal l : possibleWorld) {
                                    bb.remove(l);
                                }
                                continue;
                            }

                            Object[] returnedAction = queryAction();
                            actionsInPossibleWorlds.add(returnedAction);
                            for (Literal l : possibleWorld) {
                                bb.remove(l);
                            }
                        }

                    } else {
                        Object[] returnedAction = queryAction();
                        actionsInPossibleWorlds.add(returnedAction);
                    }

                    boolean allPossWorldsLeadToAction = checkActionsInPossibleWorlds(priority, atomicAction,
                            actionsInPossibleWorlds);
                    if (allPossWorldsLeadToAction) {
                        result[0] = atomicAction;
                        result[1] = priority;
                        return result;
                    }
                }
            }

        } catch (Exception e) {
            getLogger().log(Level.SEVERE, e.toString());
        }
        return null;
    }

    /**
     * Get the set of action selection rules sorted by their <tt>priority</tt>
     * annotation.
     * 
     * @return Collection<Rule>
     */
    private Collection<Rule> getSortedActionRules() {
        TreeMap<Double, Rule> sortedActionRules = new TreeMap<Double, Rule>();
        for (Literal l : bb) {
            if (l.isRule()) {
                Rule r = (Rule) l;
                Literal h = r.getHead();
                if (h.getFunctor().equals("action")) {
                    NumberTermImpl p = (NumberTermImpl) h.getAnnot("priority").getTerm(0);
                    sortedActionRules.put(p.solve(), r);
                }
            }
        }
        return sortedActionRules.values();
    }

    /**
     * Get the set of abducibles in a logical conjunction.
     * 
     * @param logicalFormula
     * @return List<Term>
     */
    private List<Term> getAbducibles(LogExpr logicalFormula) {
        List<Term> abducibles = new ArrayList<Term>();
        Unifier u = new Unifier();
        while (logicalFormula.getOp().equals(LogExpr.LogicalOp.and)) {
            LogicalFormula lhs = logicalFormula.getLHS();
            LogicalFormula rhs = logicalFormula.getRHS();
            Literal l = (Literal) lhs;
            Literal abdL = Literal.parseLiteral(String.format("abducible(%s)", l.toString()));
            if (believes(l, u)) {
                ;
            } else if (believes(abdL, u)) {
                abducibles.add(abdL);
            }
            u.clear();

            // move to the next conjunct
            try {
                logicalFormula = (LogExpr) rhs;
            } catch (ClassCastException e) {
                break;
            }
        }

        Literal l = (Literal) logicalFormula.getRHS();
        Literal abdL = Literal.parseLiteral(String.format("abducible(%s)", l.toString()));
        if (believes(abdL, u)) {
            abducibles.add(abdL);
        }

        return abducibles;
    }

    /**
     * Query the action selection rules in ascending order of priority.
     * 
     * @return Object[]
     */
    private Object[] queryAction() {
        Object[] result = new Object[2];

        String agName = getTS().getAgArch().getAgName();
        Literal q = Literal.parseLiteral(String.format("action(%s,Action) [priority(P)]", agName));
        Atom selectedAction = null;
        Unifier un = new Unifier();
        Iterator<Unifier> answers = q.logicalConsequence(this, un);
        Double selectedActionPriority = Double.MAX_VALUE;

        while (answers.hasNext()) {
            Unifier a = answers.next();
            try {
                Double p = ((NumberTerm) a.get("P")).solve();
                if (p < selectedActionPriority) {
                    selectedActionPriority = p;
                    selectedAction = (Atom) a.get("Action");
                }
            } catch (NoValueException e) {
                break;
            }
        }

        result[0] = selectedActionPriority;
        result[1] = selectedAction;
        return result;
    }

    /**
     * For a set of possible worlds, check that the selected action in each of
     * them matches the input.
     * 
     * @param priority
     * @param action
     * @param actionsInPossWorlds
     * @return boolean
     */
    private boolean checkActionsInPossibleWorlds(double priority, Atom action, List<Object[]> actionsInPossWorlds) {
        for (Object[] o : actionsInPossWorlds) {
            double p = (double) o[0];
            if (p != priority) {
                return false;
            }
            Atom act = (Atom) o[1];
            if (!act.equals(action)) {
                return false;
            }
        }
        return true;
    }

    /**
     * Convert a set of explanation from <i>list of lists</i> form to
     * <i>disjunctive normal form</i> (a logical formula).
     * 
     * @param args
     * @param operator
     * @param negateArgs
     * @return LogicalFormula
     */
    private LogicalFormula list2formula(List<Term> args, LogExpr.LogicalOp operator, boolean negateArgs) {
        try {
            LogicalFormula first = (LogicalFormula) args.get(args.size() - 1);
            LogExpr expr;
            if (negateArgs) {
                Literal litFirst = (Literal) first.clone();
                litFirst = litFirst.setNegated(litFirst.negated());
                expr = new LogExpr(LogExpr.LogicalOp.none, litFirst);
            } else {
                expr = new LogExpr(LogExpr.LogicalOp.none, first);
            }

            // populate logical expression with subsequent literals
            for (int i = args.size() - 2; i >= 0; i--) {
                LogicalFormula lf = (LogicalFormula) args.get(i);
                LogExpr newExpr;
                if (negateArgs) {
                    Literal l = (Literal) lf.clone();
                    l = l.setNegated(l.negated());
                    newExpr = new LogExpr(l, operator, expr);
                } else {
                    newExpr = new LogExpr(lf, operator, expr);
                }
                expr = newExpr;
            }

            return LogExpr.parseExpr(expr.toString());

        } catch (IndexOutOfBoundsException exc) {
            return null;
        }
    }

}
