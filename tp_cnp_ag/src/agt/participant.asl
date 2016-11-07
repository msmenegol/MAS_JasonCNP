// Agent sample_agent in project tp_cnp_ag

/* Initial beliefs and rules */

/* Initial goals */

!start.

/* Plans */

+!start
  <-  +myService(math.ceil(math.random*3));
      +myStock(10);
      +myPrice(1);
      ?myService(I);
      .print("My service is ", I)
  .

+cfp(Ag,service(I)) : myService(I) & .my_name(Me) & myPrice(P)
  <-  .send(Ag, tell, propose(Me, service(I), P ));
      .print("Request for service received");
      .abolish(cfp(Ag, service(I)));
  .

+cfp(_,service(I)) : not myService(I)
  <-  .abolish(cfp(_,service(I)));
      .print("Taking cfp", I, " down.");
  .

+accept(Ag, service(I), P) : myService(I) & .my_name(Me) & myPrice(P) & myStock(S) & S>0
  <-  .send(Ag, tell, done(Me, service(I), P));
      .print("Accepting contract with ", Ag);
      -+myStock(S-1);
      .abolish(accept(Ag, service(I), P));
  .

+accept(Ag, service(I), P) : myStock(St) & not St>0
  <-  .send(Ag, tell, failed(Me, service(I)));
      .abolish(accept(Ag, service(I), P));
      .print("No more items to sell.");
  .



//{ include("$jacamoJar/templates/common-cartago.asl") }
//{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have a agent that always complies with its organization
//{ include("$jacamoJar/templates/org-obedient.asl") }
