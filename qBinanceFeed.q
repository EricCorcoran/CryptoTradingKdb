\l wsock.q

\d .binance
\p 5010
\c 1000 1000

setTime:`local`utc!(.z.P;.z.p);

// table schemas for websocket feeds
trades:([]ex:`$();sym:`$();time:`timestamp$();price:`float$();size:`float$());
tradesym:([]ex:`$();sym:`$();time:`timestamp$();price:`float$();size:`float$());
klines:([]klineStartTime:();klineCloseTime:();symbol:();interval:();firstTradeID:();lastTradeID:();open:();close:();high:();low:();baseAssetVol:();noTrades:();klineClosed:();quoteAssetVol:();takerBuyBaseAssetVol:();takerBuyQuoteAssetVol:();ignore:());
depth:([]lastUpdateId:();bids:();asks:());
bookticker:([]updateId:();symbol:();bidPrice:();bidQty:();askPrice:();askQty:());

// Stream one ccy pair via websockets
// symbol String - "btcusdt"
// .binance.streamFeed["btcusdt"]
streamFeed:{[symbol]
  host:":https://api.binance.com/api/v1/exchangeInfo";
  $[4f~.z.K;exInfo:.j.k -35! .Q.hg host;exInfo:.j.k .Q.hg host];
  Allpairs:select lower symbol from exInfo[`symbols] where status like "TRADING";
	h:.wsock.open["wss://stream.binance.com:9443";"stream?streams=",-1_raze {x,"@aggTrade/"} lower symbol;`.binance.updsym];
 };

updsym:{[msg]
  data: .j.k msg; 
  if[`data in key data;content:data[`data];qty:"F"$content[`q];
  if[1b~content[`m];qty:neg[qty];];
  `.binance.tradesym insert (ex:`binance; sym:`$content[`s]; time:setTime`local;price:"F"$content[`p];size:qty);
  ];  
 };

// Stream all ccy pairs via websockets
allStreamsFeed:{[]
	host:":https://api.binance.com/api/v1/exchangeInfo";
  $[4f~.z.K;exInfo:.j.k -35! .Q.hg host;exInfo:.j.k .Q.hg host];
  Allpairs:select lower symbol from exInfo[`symbols] where status like "TRADING";
	h:.wsock.open["wss://stream.binance.com:9443";"stream?streams=",-1_raze {x,"@aggTrade/"} each Allpairs`symbol;`.binance.updall];
 };

updall:{[msg]
  data: .j.k msg; 
  if[`data in key data;
    content:data[`data];
    qty:"F"$content[`q];
  if[1b~content[`m];qty:neg[qty];
    ];
  `.binance.trades insert (ex:`binance; sym:`$content[`s]; time:setTime`local;price:"F"$content[`p];size:qty);
  ];  
 };

// Start kline feed
// .binance.klineFeed["btcusdt";"5m"]
klineFeed:{[symbol;interval]
	h:.wsock.open["wss://stream.binance.com:9443";"stream?streams=",symbol,"@kline_",interval;`.binance.updklines];
 };

updklines:{[msg]
  res: .j.k msg; 
  if[`data in key res;
    data:res[`data]`k;
  `.binance.klines insert (klinestarttime:`timestamp$data`t;klineclosetime:`timestamp$data`T;symbol:`$data`s;interval:`$data`i;firstTradeID:`int$data`f;lastTradeID:`int$data`L;open:"F"$data`o;close:"F"$data`c;high:"F"$data`h;low:"F"$data`l;baseAssetVol:data`v;noTrades:`int$data`n;klineClosed:data`x;quoteAssetVol:data`q;takerBuyBaseAssetVol:data`V;takerBuyQuoteAssetVol:data`Q;ignore:data`B);
  ];  
 };

// start depth feed
// .binance.depthFeed["btcusdt";"5";"100"]
// Levels are 5, 10 or 20 
// Speed in ms - 1000ms or 100ms
depthFeed:{[symbol;level;speed]
	h:.wsock.open["wss://stream.binance.com:9443";"stream?streams=",symbol,"@depth",level,"@",speed,"ms";`.binance.upddepth];
 };

upddepth:{[msg]
  res: .j.k msg; 
  if[`data in key res;
    `.binance.depth insert (lastUpdateId:res[`data]`lastUpdateId;bids:res[`data]`bids;asks:res[`data]`asks);
  ];  
 };

// .binance.bookTickerFeed["btcusdt"]
bookTickerFeed:{[symbol]
	h:.wsock.open["wss://stream.binance.com:9443";"stream?streams=",symbol,"@bookTicker";`.binance.updbt];
 };

updbt:{[msg]
  res: .j.k msg; 
  if[`data in key res;
    `.binance.bookticker insert (updateId:res[`data]`u;symbol:`$res[`data]`s;bidPrice:"F"$res[`data]`b;bidQty:"F"$res[`data]`B;askPrice:"F"$res[`data]`a;askQty:"F"$res[`data]`A);
  ];  
 };

\d .