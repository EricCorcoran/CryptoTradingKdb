\l cryptoq/src/cryptoq_binary.q
\l cryptoq/src/cryptoq.q
\l simpleRest.q

\c 1000 1000
\d .binance

settings:`Host`Key`Secret!("https://api.binance.com";"";"") 
//If there are any performance issues with accessing api.binance.com please try any of the following instead:
//https://api1.binance.com/api/v3/*
//https://api2.binance.com/api/v3/*
//https://api3.binance.com/api/v3/*

checkcreds:{$[.binance.settings[`Key]~""|.binance.settings[`Secret] ~""; show "***** Empty API Key or Secret value, please set in settings. *****";show "***** API Key and Secret set *****"]};
checkcreds[]

getparams:{k!{n[w][w2]!@'[;1] v 
	w2:where 0h=type each v:value/[{type[x] in y}[;t];] each f:f 
	w:where in[;(t:"h"$100,105+til 7)] type each f:get each `$".",/:"." sv/:string x,/:n:y x}[;m] each key m:k!system each "f .",/:string k:`,key `};
// .binance.listFunctions[]
listFunctions:{getparams[]`binance};

accountInfo:{[] 
	timestamp:first system "date +%s000";
	path:"/api/v3/account";
	query:uriEncode `timestamp`recvWindow!(timestamp;"5000");
	auth:signHeaders[timestamp;query;.binance.settings`Secret;.binance.settings`Key];
	str: "?",query,"&signature=",raze string auth[`signature];
    :.j.k .rest.request[`GET;(.binance.settings`Host);path,str;auth;()];
 };
	
time:{[] 
	timestamp:first system "date +%s000";	
	path: "/api/v3/time";
	query:uriEncode `timestamp`recvWindow!(timestamp;"20000");
	auth:signHeaders[timestamp;query;.binance.settings`Secret;.binance.settings`Key];
	str: "?",query,"&signature=",raze string auth[`signature];
	:.j.k .rest.request[`GET;(.binance.settings`Host);path;auth;()];
 };

exchangeInfo:{[] 
	timestamp:first system "date +%s000";	
	path: "/api/v3/exchangeInfo";
	query:uriEncode `timestamp`recvWindow!(timestamp;"20000");
	auth:signHeaders[timestamp;query;.binance.settings`Secret;.binance.settings`Key];
	str: "?",query,"&signature=",raze string auth[`signature];
	:.j.k .rest.request[`GET;(.binance.settings`Host);path;auth;()];
 };

//
// .binance.placeOrder["BUY";"12000";"0.001";"BTCUSDT";"LIMIT";"5000";"GTC"]
/ Parameter	   Value
/ symbol	   LTCBTC
/ side	       BUY
/ ordertype	   LIMIT
/ timeInForce  GTC
/ quantity	   1
/ price	       0.1
/ recvWindow   5000
//
placeOrder:{[side;price;quantity;symbol;ordertype;recvWindow;timeInForce]
	timestamp:first system "date +%s000";
	path: "/api/v3/order";
	query:uriEncode `symbol`side`type`timeInForce`quantity`price`recvWindow`timestamp!(symbol;side;ordertype;timeInForce;quantity;price;recvWindow;timestamp);
	auth:signHeaders[timestamp;query;.binance.settings`Secret;.binance.settings`Key];
	str: "?",query,"&signature=",raze string auth[`signature];
	:enlist trades: .j.k .rest.request[`POST;(.binance.settings`Host);path,str;auth;()];
 };

// .binance.cancelOrderID["w8PdslC2QzS40gFaxTPUUy";"BTCUSDT"]
cancelOrderID:{[orderid;symbol]
	timestamp:first system "date +%s000";	
	path: "/api/v3/order";
	query:uriEncode `symbol`origClientOrderId`timestamp!(symbol;orderid;timestamp);
	//query:"symbol=",symbol,"&origClientOrderId=",orderid,"&timestamp=",timestamp;
	auth:signHeaders[timestamp;query;.binance.settings`Secret;.binance.settings`Key];
	str: "?",query,"&signature=",raze string auth[`signature];
	:.j.k .rest.request[`DELETE;(.binance.settings`Host);path,str;auth;()];	
 };

cancelAllOrders:{[]
 	open:openOrders[];
 	openid:open`clientOrderId`symbol;
 	:cancelOrderID'[openid[0];openid[1]];
 };

cancelOrdersBySym:{[symbol] 
	timestamp:first system "date +%s000";
	path: "/api/v3/openOrders";
	query:uriEncode `symbol`timestamp!(symbol;timestamp);
	auth:signHeaders[timestamp;query;.binance.settings`Secret;.binance.settings`Key];
	str: "?",query,"&signature=",raze string auth[`signature];
	:.j.k .rest.request[`DELETE;(.binance.settings`Host);path,str;auth;()];		
 };


//Get all account orders; active, canceled, or filled. 
// .binance.orders["BTCUSDT"]
orders:{[symbol] 
	timestamp:first system "date +%s000";
	method: "GET";	
	path: "/api/v3/allOrders";
	query:uriEncode `symbol`timestamp!(symbol;timestamp);
	auth:signHeaders[timestamp;query;.binance.settings`Secret;.binance.settings`Key];
	str: "?",query,"&signature=",raze string auth[`signature];
	:.j.k .rest.request[`GET;(.binance.settings`Host);path,str;auth;()];	
 };

// .binance.openOrders[]
openOrders:{[] 
	timestamp:first system "date +%s000";
	method: "GET";	
	path: "/api/v3/openOrders";
	query:"timestamp=",timestamp;
	auth:signHeaders[timestamp;query;.binance.settings`Secret;.binance.settings`Key];
	str: "?",query,"&signature=",raze string auth[`signature];
	:.j.k .rest.request[`GET;(.binance.settings`Host);path,str;auth;()];	
 };

//default 500, max 1000
// .binance.recentTrades["BTCUSDT";"750"]
recentTrades:{[symbol;limit] 
	timestamp:first system "date +%s000";
	path: "/api/v3/trades";
	query:uriEncode `symbol`limit!(symbol;limit);
	auth:signHeaders[timestamp;query;.binance.settings`Secret;.binance.settings`Key];
	str: "?",query;
	:.j.k .rest.request[`GET;(.binance.settings`Host);path,str;auth;()];		
 };

// .binance.myTrades["BTCUSDT"]
myTrades:{[symbol] 
	timestamp:first system "date +%s000";
	method: "GET";	
	path: "/api/v3/myTrades";
	query:uriEncode `symbol`timestamp!(symbol;timestamp);
	auth:signHeaders[timestamp;query;.binance.settings`Secret;.binance.settings`Key];
	str: "?",query,"&signature=",raze string auth[`signature];
	:.j.k .rest.request[`GET;(.binance.settings`Host);path,str;auth;()];		
 };

// .binance.tickerPrice["BTCUSDT"]
tickerPrice:{[symbol] 
	timestamp:first system "date +%s000";
	method: "GET";	
	path: "/api/v3/ticker/price";
	query:uriEncode (enlist `symbol)!(enlist symbol);
	auth:signHeaders[timestamp;query;.binance.settings`Secret;.binance.settings`Key];
	:.j.k .rest.request[`GET;(.binance.settings`Host);path,"?",query;auth;()];	
 };

// .binance.allTickerPrice[]
allTickerPrice:{[] 
	timestamp:first system "date +%s000";
	method: "GET";	
	path: "/api/v3/ticker/price";
	query:"";
	auth:signHeaders[timestamp;query;.binance.settings`Secret;.binance.settings`Key];
	:.j.k .rest.request[`GET;(.binance.settings`Host);path;auth;()];	
 };

 // .binance.bookTicker["BTCUSDT"]
bookTicker:{[symbol] 
	timestamp:first system "date +%s000";
	method: "GET";	
	path: "/api/v3/ticker/bookTicker";
	query:"symbol=",symbol;
	auth:signHeaders[timestamp;query;.binance.settings`Secret;.binance.settings`Key];
	str: "?",query;
	:.j.k .rest.request[`GET;(.binance.settings`Host);path,str;auth;()];	
 };

// .binance.allBookTicker[]
allBookTicker:{[] 
	timestamp:first system "date +%s000";
	method: "GET";
	path: "/api/v3/ticker/bookTicker";
	query:"";
	auth:signHeaders[timestamp;query;.binance.settings`Secret;.binance.settings`Key];
	:.j.k .rest.request[`GET;(.binance.settings`Host);path;auth;()];	
 };

// .binance.get24hrPriceChange["BTCUSDT"]
get24hrPriceChange:{[symbol] 
	timestamp:first system "date +%s000";
	method: "GET";	
	path: "/api/v3/ticker/24hr";
	query:"symbol=",symbol;
	auth:signHeaders[timestamp;query;.binance.settings`Secret;.binance.settings`Key];
	str: "?",query;
	:.j.k .rest.request[`GET;(.binance.settings`Host);path,str;auth;()];	
 };

//.binance.getKlines["BTCUSDT";"5m";"600";();()]
//.binance.getKlines["BTCUSDT";"1m";"50";"1610484600000";"1610486700000"]
/ //startTime, endTime as milliseconds
getKlines:{[symbol;interval;limit;startTime;endTime] 
	timestamp:first system "date +%s000";
	path: "/api/v3/klines";
	params:`symbol`interval`limit`startTime`endTime!(symbol;interval;limit;startTime;endTime);
	$[startTime~()|endTime~();params:`symbol`interval`limit#params;params];
	query:uriEncode params;
	auth:signHeaders[timestamp;query;.binance.settings`Secret;.binance.settings`Key];
	klines:.j.k .rest.request[`GET;(.binance.settings`Host);path,"?",query;auth;()];	
	(`openTime`open`high`low`close`volume`closeTime`quoteAssetVol`noTrades`takerBBase`takerBQuote`ignore!)each klines
 };

//Default 100; max 5000. Valid limits:[5, 10, 20, 50, 100, 500, 1000, 5000]
// .binance.getDepth["BTCUSDT";"500"]
getDepth:{[symbol;limit] 
	timestamp:first system "date +%s000";	
	path:"/api/v3/depth";
    query:uriEncode `symbol`limit!(symbol;limit);
	auth:signHeaders[timestamp;query;.binance.settings`Secret;.binance.settings`Key];
	str:"?",query;
	:flip depth:.j.k .rest.request[`GET;(.binance.settings`Host);path,str;auth;()];	
 };

signHeaders:{[timestamp;message;api_secret;api_key]
	signature: .cryptoq.hmac_sha256[api_secret;message]; 
	header_auth:(!/) flip 2 cut ( 
	`$"signature"; raze string signature;
	`$"TIMESTAMP"; timestamp; 
	`$"X-MBX-APIKEY" ; api_key;
	`$"Content-Type"; "application/x-www-form-urlencoded")
 };

uriEncode:{[d]
  k:key d;
  k:enlist each $[all 10=type each k;k;string k]; 
  v:value d;                                                                
  v:enlist each (.h.hug .Q.an,"-.~") each {$[10=type x;x;string x]}'[v];                                                        
  "&" sv "=" sv' k,'v                                                            
  };

// convert from unix time
ts:1970.01.01D+1000000*

\d .







