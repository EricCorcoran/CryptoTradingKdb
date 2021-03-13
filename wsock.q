\d .wsock
clients:([h:`int$()] hostname:`$())                                     
servers:([h:`int$()] hostname:`$())                                    

onmessage.client:{x}                                                   
onmessage.server:{x}                                                   

.z.ws:{.wsock.onmessage[$[.z.w in key servers;`server;`client]]x}          
.z.wo:{clients,:(.z.w;.z.h)}                                            
.z.wc:{{delete from y where h=x}[.z.w] each `.wsock.clients`.wsock.servers}   

w:([h:`int$()] hostname:`$();callback:`$())                             
.wsock.onmessage.server:{value[w[.z.w]`callback]x}  

open:{[u;q;cb]
    s:first r:.wsock.switchProto[u;q;`GET];
    servers,:(s;`$u);                                                     
    w,:(s;`$u;cb);                                                         
    :neg first r;
 };

//wsget:{[u] .wsock.httpMsg[u;`GET]};
debug:([]time:"p"$();sym:`$();url:();request:();response:());

switchProto:{[url;query;method]
  host:first ":" vs .Q.hap[url] 2;
  headers:(("Host";"Origin")!(host;url,query)); 
  endpoint:.Q.hap[url] 3;
  request:(string method)," ", endpoint,query, " HTTP/1.1\r\n",(("\r\n" sv ": " sv/: flip (key headers;value headers)),"\r\n\r\n");
  sendUrl:hsym `$url;
  response:sendUrl request;
  `.wsock.debug insert (.z.p;sendUrl;enlist url;enlist request;enlist last response);   
  :response;
  };
\d .
