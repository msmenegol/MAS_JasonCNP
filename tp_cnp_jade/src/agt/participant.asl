/* Initial goals */

!start.

/* Plans */

+!start
  <-  +myService(math.ceil(math.random*10));
      +myStock(10);
      +myPrice(1);
      ?myService(I);
      .print("My service is ", I);
      jadedf.register("tp_cnp_jade","JADE-participant") //Register on the DF
  .

//handle CFP performatives
//CEP
+!kqml_received(Sender, cfp, service(I), MsgId) : myService(I) & myStock(S) & S>0	// if I have the service
	<-	?myPrice(P);
      .send(Sender, propose, [service(I),P], MsgId).	//propose

+!kqml_received(Sender, cfp, service(I), MsgId)
	<-	.send(Sender, refuse, "not-available", MsgId). //refuse

//Accept Proposal
+!kqml_received(Sender, accept_proposal, [service(I),Price], MsgId)
	:	myService(I) & myStock(S) & S>0 // If I still have the book
	<- -+myStock(S-1);	//change stock
		.print("New stock for service ", I, "is ", S-1);
    if(S<=1){//if it's the last piece
      jadedf.deregister("tp_cnp_jade","JADE-participant");
    }
		.send(Sender, tell, service(I), MsgId); //confirm
  .

+!kqml_receieved(Sender, accept_proposal, _, MsgId)
	<- .send(Sender, failure, "not available", MsgId).

+!kqml_received(Sender, reject_proposal, _, _).//if proposal is rejected, do nothing
