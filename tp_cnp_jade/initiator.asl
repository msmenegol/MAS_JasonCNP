/* Initial beliefs and rules */

contracts(10).
amountPaid(0).

/* Initial goals */

!initContracts.

/* Plans */
+!initContracts : contracts(NC) & .my_name(Me)
  <-  for (.range(I,1,NC)) {
        .broadcast(cfp,service(I));
        .print("Requesting service ", I);
      }
  .

+!acquire(service(I))
  <-  !find_vendors;
		  !ask_prices(service(I));
		  //!select_cheapest(service(I));
      !buy_cheapest(service(I)).

+!find_vendors
	<-	jadedf.search("tp_cnp_jade","JADE-participant",List);
  		if (.empty(List)){
  			!find_vendors;
  		}else{
  			+vendorList(List);
  		}
  .

+!ask_prices(service(I)) : vendorList(List)
  <-  for (.member(S, List)){
        .print("Asking if ", S, " has service ", I);
			  .send(S, cfp , service(I));
      }
  .

// handle KQML proposals
+!kqml_received(Sender, propose, [service(I),Price], MsgId)
  : .desire(acquire(service(I))) & not prop(_,service(I),_)
  <-  +prop(Sender,service(I),Price);
      .send(Sender, accept_proposal , [service(I),Price], MsgId);
  .

+!kqml_received(Sender, propose, [service(I),Price], MsgId)
  <-  .send(Sender, reject_proposal , [service(I),Price], MsgId);
  .

+!kqml_received(Sender, refuse, _, _).

// handle KQML gift/purchases

+!kqml_received(Sender, tell, service(I), MsgId) : amountPaid(A)
  <-  .abolish(vendorList(_));
      .abolish(prop(_,service(I),_));
      -+amountPaid(A+1);
      !acquire(service(I));
	.
