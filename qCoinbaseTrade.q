\l cryptoq/src/cryptoq_binary.q
\l cryptoq/src/cryptoq.q
\l simpleRest.q

\d .coinbase
\p 5010
\c 1000 1000

// Enter API credentials
settings: `Host`Key`Secret`Passphrase!("https://api.pro.coinbase.com";"";"";""); 
checkcreds:{$[.coinbase.settings[`Key]~""|.coinbase.settings[`Secret] ~""|.coinbase.settings[`Passphrase] ~""; show "***** Empty API Key, Secret or Passphrase value, please set in settings. *****";show "***** API Key, Secret and Passphrase set *****"]};
checkcreds[]

getparams:{k!{n[w][w2]!@'[;1] v 
	w2:where 0h=type each v:value/[{type[x] in y}[;t];] each f:f 
	w:where in[;(t:"h"$100,105+til 7)] type each f:get each `$".",/:"." sv/:string x,/:n:y x}[;m] each key m:k!system each "f .",/:string k:`,key `};

// .coinbase.listFunctions[]
listFunctions:{getparams[]`coinbase};

getAccountBal:{[] 
	//timestamp:string {`long$8.64e4*10957+x} .z.Z;
	timestamp:first system "date +%s";
	method:"GET";
	path:"/accounts";
	body:"";
	message: timestamp,method,path,body;
	auth:signHeaders[timestamp;message;.coinbase.settings`Passphrase;.coinbase.settings`Secret;.coinbase.settings`Key];
	:.j.k .rest.request[`GET;(.coinbase.settings`Host);path;auth;()];
	};

// .coinbase.placeOrder["SELL";"55000";"0.001";"BTCUSDT";"LIMIT";"50000";"GTC"]
// .coinbase.placeOrder["buy";"1800";"1";"ETH-USD";"limit";();();"GTC"]
placeOrder:{[side;price;size;id;ordertype;stop;stop_price;time_in_force]
    order:(!/) flip 2 cut (`size;size ; 
	`price; price ; 
	`side;side ; 
	`product_id;id;
	`type;ordertype;
	`stop;stop;
	`stop_price;stop_price;
	`time_in_force;time_in_force);
	body:.j.j order;
	timestamp:first system "date +%s";
	method:"POST";
	path:"/orders";
	message: timestamp,method,path,body;
	auth:signHeaders[timestamp;message;.coinbase.settings`Passphrase;.coinbase.settings`Secret;.coinbase.settings`Key];
	:.j.k .rest.request[`POST;(.coinbase.settings`Host);path;auth;body];
    };

cancelAllOrders:{[]
	body:"";
	timestamp:first system "date +%s";
	method:"DELETE";
	path:"/orders";
	message: timestamp,method,path,body;
	auth:signHeaders[timestamp;message;.coinbase.settings`Passphrase;.coinbase.settings`Secret;.coinbase.settings`Key];
	:.j.k .rest.request[`DELETE;(.coinbase.settings`Host);path;auth;()];
	};

cancelOrder:{[order_id]	
	body:"";
	timestamp:first system "date +%s";
	method:"DELETE";
	path:"/orders/",order_id;
	message: timestamp,method,path,"";
	auth:signHeaders[timestamp;message;.coinbase.settings`Passphrase;.coinbase.settings`Secret;.coinbase.settings`Key];
	:.j.k .rest.request[`DELETE;(.coinbase.settings`Host);path;auth;()];
	};

orders:{[] 
	timestamp:first system "date +%s";
	method:"GET";
	path:"/orders";
	body:"";
	message: timestamp,method,path,body;
	auth:signHeaders[timestamp;message;.coinbase.settings`Passphrase;.coinbase.settings`Secret;.coinbase.settings`Key];
	:.j.k .rest.request[`GET;(.coinbase.settings`Host);path;auth;()];
	};

order:{[order_id] 
	timestamp:first system "date +%s";
	method:"GET";
	path:"/orders/",order_id;
	message:timestamp,method,path,"";
	auth:signHeaders[timestamp;message;.coinbase.settings`Passphrase;.coinbase.settings`Secret;.coinbase.settings`Key];
	:.j.k .rest.request[`GET;(.coinbase.settings`Host);path;auth;()];
 };

// String - "BTC-USD"
getFills:{[productid] 
 	timestamp:first system "date +%s";	
 	method:"GET";
 	path:"/fills?product_id=",productid;
 	body:"";
 	message: timestamp,method,path,"";
 	auth:signHeaders[timestamp;message;.coinbase.settings`Passphrase;.coinbase.settings`Secret;.coinbase.settings`Key];
 	:.j.k .rest.request[`GET;(.coinbase.settings`Host);path;auth;()];
    };

fees:{[] 
 	timestamp:first system "date +%s";
 	method:"GET";
 	path:"/fees";
 	body:"";
 	message: timestamp,method,path,body;
 	auth:signHeaders[timestamp;message;.coinbase.settings`Passphrase;.coinbase.settings`Secret;.coinbase.settings`Key];
 	:.j.k .rest.request[`GET;(.coinbase.settings`Host);path;auth;()];
	};

products:{[] 
 	timestamp:first system "date +%s";
 	method:"GET";
 	path:"/products";
 	body:"";
 	message:timestamp,method,path,body;
 	auth:signHeaders[timestamp;message;.coinbase.settings`Passphrase;.coinbase.settings`Secret;.coinbase.settings`Key];
 	:.j.k .rest.request[`GET;(.coinbase.settings`Host);path;auth;()];
	};


/ Level	Description
/ 1		Only the best bid and ask
/ 2		Top 50 bids and asks (aggregated)
/ 3		Full order book (non aggregated)

// .coinbase.orderBook["BTC-USD";"3"]

orderBook:{[productid;level] 
 	timestamp:first system "date +%s";
 	method:"GET";
 	path:"/products/",productid,"/book?level=",level;
 	body:"";
 	message: timestamp,method,path,body;
 	auth:signHeaders[timestamp;message;.coinbase.settings`Passphrase;.coinbase.settings`Secret;.coinbase.settings`Key];
 	:.j.k .rest.request[`GET;(.coinbase.settings`Host);path;auth;()];
	};

// .coinbase.ticker["ETH-USD"]
ticker:{[productid] 
 	timestamp:first system "date +%s";
 	method:"GET";
 	path:"/products/",productid,"/ticker";
 	body:"";
 	message:timestamp,method,path,body;
 	auth:signHeaders[timestamp;message;.coinbase.settings`Passphrase;.coinbase.settings`Secret;.coinbase.settings`Key];
 	:.j.k .rest.request[`GET;(.coinbase.settings`Host);path;auth;()];
	};

// The trade side indicates the maker order side
// .coinbase.getTrades["ETH-USD"]
getTrades:{[productid] 
 	timestamp:first system "date +%s";
 	method:"GET";
 	path:"/products/",productid,"/trades";
 	body:"";
 	message:timestamp,method,path,body;
 	auth:signHeaders[timestamp;message;.coinbase.settings`Passphrase;.coinbase.settings`Secret;.coinbase.settings`Key];
 	:.j.k .rest.request[`GET;(.coinbase.settings`Host);path;auth;()];
	};

// .coinbase.candles["ETH-USD"]
candles:{[productid] 
 	timestamp:first system "date +%s";
 	method:"GET";
 	path:"/products/",productid,"/candles";
 	body:"";
 	message:timestamp,method,path,body;
 	auth:signHeaders[timestamp;message;.coinbase.settings`Passphrase;.coinbase.settings`Secret;.coinbase.settings`Key];
 	:.j.k .rest.request[`GET;(.coinbase.settings`Host);path;auth;()];
  };

// .coinbase.get24hrStats["ETH-USD"]
get24hrStats:{[productid] 
 	timestamp:first system "date +%s";
 	method:"GET";
 	path:"/products/",productid,"/stats";
 	body:"";
 	message:timestamp,method,path,body;
 	auth:signHeaders[timestamp;message;.coinbase.settings`Passphrase;.coinbase.settings`Secret;.coinbase.settings`Key];
 	:.j.k .rest.request[`GET;(.coinbase.settings`Host);path;auth;()];
  };

// .coinbase.currencies[]
currencies:{[] 
	timestamp:first system "date +%s";	
	method:"GET";
	path:"/currencies";
	body:"";
	message:timestamp,method,path,body;
	auth:signHeaders[timestamp;message;.coinbase.settings`Passphrase;.coinbase.settings`Secret;.coinbase.settings`Key];
	:.j.k .rest.request[`GET;(.coinbase.settings`Host);path;auth;()];
    };

signHeaders:{[timestamp;message;passphrase;api_secret;api_key]
	signature_b64:.cryptoq.b64_encode .cryptoq.hmac_sha256[.cryptoq.b64_decode api_secret;`int$message];
	header_auth:(!/) flip 2 cut ( 
	`$"Connection"; "close";
	`$"User-Agent";"kdb+/",string .Q.k;
	`$"CB-ACCESS-SIGN"; signature_b64;
	`$"CB-ACCESS-TIMESTAMP"; timestamp; 
	`$"CB-ACCESS-KEY" ; api_key;
	`$"CB-ACCESS-PASSPHRASE"; passphrase;
	`$"Content-Type"; "application/json" )
    };

\d .








