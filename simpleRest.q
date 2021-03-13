\d .rest

request:{[method;url;query;headers;body]
  headers:merge_headers[headers;"Host";.Q.hap[url]2];
  if[method=`POST; headers:merge_headers[headers;"Content-Length";string count body]];
  request:(string method)," ",query, " HTTP/1.1\r\n",(("\r\n" sv ": " sv/: flip (string key headers;value headers)),"\r\n\r\n",body); 
  res:parseResp (hsym `$url) request;
  `.rest.debug insert (.z.p;enlist url;enlist request;enlist res;enlist res[0];enlist res[1]);
  :res[1];
  };

merge_headers:{[h;k;v]
  if[10h = type k;k:`$k];
  @[h;k;:;v]
  };

parseResp:{[resp]
  split:cut[(0,4+first ss[resp;"\r\n\r\n"]);resp];                                                                                              
  dict:trim(!/)0:[("S:\n");"status: ",split[0]except"\r"];                                   
  :(dict;split[1]);                                                                      
  };

debug:([] time:"p"$(); url:(); request:(); rawResponse:(); headers:(); responseBody:());

\d .