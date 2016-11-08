!start.
!pooling.

+!start : np(N)
  <-  time.timeNow(A);
  .
+!pooling : np(N)
  <-  if(N==0){time.timeNow(A);}else{!pooling}  
  .

+!kqml_received(_, tell, "no_stock", MsgId) : np(N)
  <- -+np(N-1);
  .
