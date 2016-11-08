// Internal action code for project book_trading.mas2j

package jadedf;

import jade.domain.DFService;
import jade.domain.FIPAAgentManagement.*;
import jason.asSemantics.DefaultInternalAction;
import jason.asSemantics.TransitionSystem;
import jason.asSemantics.Unifier;
import jason.asSyntax.StringTerm;
import jason.asSyntax.Term;
import jason.infra.jade.*;

import jason.*;
import jason.asSemantics.*;
import jason.asSyntax.*;

public class search extends DefaultInternalAction {

    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
		try{
				//get reference to the Jade agent
				JadeAgArch infra = ((JasonBridgeArch)ts.getUserAgArch().getArchInfraTier()).getJadeAg();
							
				//0. get args from the AgentSpeak code
				StringTerm type = (StringTerm)args[0];
				StringTerm name = (StringTerm)args[1];
				Term list = (Term)args[2];
				
				//1. set service description with args
				ServiceDescription sd = new ServiceDescription();
				
				sd.setType(type.getString());
				sd.setName(name.getString());
				//2. create empty dfd to be used on search
				DFAgentDescription dfd = new DFAgentDescription();
				dfd.addServices(sd);
				
				//3. set search constraints
				SearchConstraints sc = new SearchConstraints();
				sc.setMaxResults(-1L);//get all results
				
				DFAgentDescription[] result = DFService.search(infra, dfd, sc);
				String[] names = new String[result.length];
				
				//4. get only the names of seller agents
				for(int i=0; i<result.length; i++){
					names[i] = result[i].getName().getLocalName();
				}				
				
				//5. transform list of strings into list of terms
				Term[] nTerms = new Term[result.length];
				for(int i=0; i<result.length; i++){
					nTerms[i] = ASSyntax.parseTerm(names[i]);
				}	
				
				un.unifies(list, ASSyntax.createList(nTerms));			
				return true;
				
			} catch (Exception e) {
				e.printStackTrace();
		} return false;
    }
}
