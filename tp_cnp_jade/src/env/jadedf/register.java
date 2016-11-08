// Internal action code for project book_trading.mas2j

package jadedf;

import jade.domain.DFService;
import jade.domain.FIPAAgentManagement.DFAgentDescription;
import jade.domain.FIPAAgentManagement.ServiceDescription;
import jason.asSemantics.DefaultInternalAction;
import jason.asSemantics.TransitionSystem;
import jason.asSemantics.Unifier;
import jason.asSyntax.StringTerm;
import jason.asSyntax.Term;
import jason.infra.jade.*;

import java.util.logging.Logger;

import jason.*;
import jason.asSemantics.*;
import jason.asSyntax.*;

public class register extends DefaultInternalAction {

	private Logger logger = Logger.getLogger("JadeDF.jcm."+register.class.getName());

    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
		try{
			if(ts.getUserAgArch().getArchInfraTier() instanceof JasonBridgeArch) {
				//get reference to the Jade agent
				JadeAgArch infra = ((JasonBridgeArch)ts.getUserAgArch().getArchInfraTier()).getJadeAg();

				//0. get args from the AgentSpeak code
				StringTerm type = (StringTerm)args[0];
				StringTerm name = (StringTerm)args[1];

				//1. get current services
				DFAgentDescription dfd = new DFAgentDescription();
				dfd .setName(infra.getAID());

				DFAgentDescription list[] = DFService.search(infra, dfd);

				//2. deregister
				if(list.length>0){
					DFService.deregister(infra);
					dfd = list[0];
				}

				//3. add a new service
				ServiceDescription sd = new ServiceDescription();
				sd.setType(type.getString());
				sd.setName(name.getString());
				dfd.addServices(sd);

				//4. register again
				DFService.register(infra, dfd);

				return true;
			} else {
				logger.warning("jadefd.register can be used only with JADE infrastructure. Current arch is "+ts.getUserAgArch().getArchInfraTier().getClass().getName());
			}
		} catch (Exception e) {
			logger.warning("Error in internal action 'jadef.register'! "+e);
		} return false;
    }
}
