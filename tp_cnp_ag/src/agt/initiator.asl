contracts(3).
amountPaid(0).

!initContracts.

//inicia os contratos iniciais
+!initContracts : contracts(NC) & .my_name(Me)
  <-  for (.range(I,1,NC)) {
        .broadcast(tell,cfp(Me,service(I)))
      }
  .

//a cada resposta, manda uma proposta
//possível TODO: fazer um método de seleção de proposta. Atual é 1st come 1st served
+propose(Sender,service(I),Price) : not contracted(service(I)) & .my_name(Me)
  <-  -proposal(_,service(I),_); //remove todas as propostas relacionadas
      .send(Sender, tell, accept(Me, service(I), Price));
      +contracted(service(I));// ao aceitar, adiciona como contratado
  .

//no caso de sucesso
+done(Sender, service(I), Price) : amountPaid(A) & .my_name(Me)
  <-  -+amountPaid(A+Price); //pagamento fictício
      -contracted(service(I)); //remove o contrato
      .broadcast(tell, cfp(Me,service(I))); //reinicia contratação daquele serviço
  .
//no caso de falha, reinicia o procedimento de contratação
+failed(Sender, service(I))
  <-  -contracted(service(I));
      .broadcast(tell, cfp(Me,service(I)));
  .

//lida com os cfps dos outros initiators
+cfp(_) <- -cfp(_).
