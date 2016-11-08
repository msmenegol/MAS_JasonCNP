// Internal action code for project book_trading.mas2j

package time;

import jason.asSemantics.DefaultInternalAction;
import jason.asSemantics.TransitionSystem;
import jason.asSemantics.Unifier;
import jason.asSyntax.StringTerm;
import jason.asSyntax.Term;
import jason.infra.jade.*;

import jason.*;
import jason.asSemantics.*;
import jason.asSyntax.*;

public class timeNow extends DefaultInternalAction {

    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
		try{
          long time = System.nanoTime();
				  System.out.println(time);
			} catch (Exception e) {
				e.printStackTrace();
		} return false;
    }
}
