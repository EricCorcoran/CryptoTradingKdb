\l wsock.q
\d .coinbase
\p 5010
\c 1000 1000

// trades table schema for websocket updates
trades:([]ex:`$(); sym:`$(); time:`timestamp$(); price:`float$();size:`float$());

// Set up websocket feed for trades
stream:{[]
  productInfo:.j.k raze .Q.hg `:https://api.pro.coinbase.com/products;
  ccyPairs:productInfo[`id];   
  h:.wsock.open["wss://ws-feed.pro.coinbase.com";();`.coinbase.upd];
  h .j.j `type`channels!(`subscribe;enlist(`name`product_ids!(`ticker;(ccyPairs))));
  };

setTime:`local`utc!(.z.P;.z.p);
rd:{x except "-"};

upd:{[json]
  data: .j.k json;
  if[`price in key data;qty:"F"$data[`last_size];
  if["sell" like data[`side];qty:neg[qty];];
  `.coinbase.trades insert (ex:`coinbasepro; sym:`$rd data[`product_id]; time:setTime`local;price:"F"$data[`price];size:qty);
  ];};