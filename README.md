# Cryptocurrency Trading Toolkit for q/kdb+ 

**q/kdb+ libraries for Binance and CoinbasePro API's** 

- Realtime streaming for Binance
- Trading on Binance
- Realtime streaming for Coinbase Pro
- Trading on Coinbase Pro

## Binance
#### Open realtime feed for one symbol
```
q)\l qBinanceStream.q
q).binance.stream["btcusdt"]
q).binance.tradesym
ex      sym     time                          price    size     
----------------------------------------------------------------
binance BTCUSDT 2021.02.19D12:13:18.008699000 54526.84 -0.04176 
binance BTCUSDT 2021.02.19D12:13:18.008699000 54526.84 -0.039618
binance BTCUSDT 2021.02.19D12:13:18.008699000 54526.89 0.001282 
binance BTCUSDT 2021.02.19D12:13:18.008699000 54526.84 -0.0275   
```

#### Open realtime price stream for all symbols
```
q).binance.allStreams[]
q).binance.trades
ex      sym         time                          price        size     
------------------------------------------------------------------------
binance ETHUSDT     2021.02.19D12:13:18.008699000 1959.87      5.034    
binance ICXUSDT     2021.02.19D12:13:18.008699000 2.2665       -238.23  
binance BNBBUSD     2021.02.19D12:13:18.008699000 300          1.33     
binance BNBUSDT     2021.02.19D12:13:18.008699000 300.5127     66.206   
binance XLMUSDT     2021.02.19D12:13:18.008699000 0.51083      737      
```

Other realtime streams available for 
- klines 
- depth 
- book ticker

### Binance Trading

Obtain Binance API credentials from https://www.binance.com/en/support/faq/360002502072-How-to-create-API

Update the .binance.settings dictionary in qBinanceTrade.q with API credentials.

**List Binance trading functions**
```
q)\l qBinanceTrade.q
"***** API Key and Secret set *****"
q).binance.listFunctions[]
accountInfo       | ,`
allBookTicker     | ,`
allTickerPrice    | ,`
bookTicker        | ,`symbol
cancelAllOrders   | ,`
cancelOrderID     | `orderid`symbol
cancelOrdersBySym | ,`symbol
checkcreds        | ,`x
exchangeInfo      | ,`
get24hrPriceChange| ,`symbol
getDepth          | `symbol`limit
getKlines         | `symbol`interval`limit`startTime`endTime
getparams         | ,`x
listFunctions     | ,`x
myTrades          | ,`symbol
openOrders        | ,`
orders            | ,`symbol
placeOrder        | `side`price`quantity`symbol`ordertype`recvWindow`timeInForce
recentTrades      | `symbol`limit
signHeaders       | `timestamp`message`api_secret`api_key
tickerPrice       | ,`symbol
time              | ,`
ts                | *[1000000]
uriEncode         | ,`d
```
**Get Account Information**

```
q).binance.accountInfo[]
```

**Place Order**

***Parameters example*** 
|Parameter	 |  Value|
|---|---|
| symbol	|   BTCUSDT|
| side	    |   BUY|
| ordertype	 |  LIMIT|
| timeInForce | GTC|
| quantity	  | 0.001|
| price	     |  50000|
| recvWindow |  5000|

```
q).binance.placeOrder["BUY";"50000";"0.001";"BTCUSDT";"LIMIT";"49000";"GTC"]
```
**Get All Orders**
```
q).binance.orders["BTCUSDT"]
```
**Cancel All Orders**
```
q).binance.cancelAllOrders[]
```

## Coinbase Pro
#### Open realtime price stream for all symbols

```
q)\l qCoinbaseFeed.q
q).coinbase.stream[]
q).coinbase.trades
ex          sym      time                          price      size       
-------------------------------------------------------------------------
coinbasepro LTCEUR   2021.02.19D12:15:54.681617000 193.57     0.2395598  
coinbasepro NMRUSD   2021.02.19D12:15:54.681617000 41.5387    -4         
coinbasepro LINKGBP  2021.02.19D12:15:54.681617000 24.88888   5.88       
coinbasepro KNCUSD   2021.02.19D12:15:54.681617000 2.2206     44.1       
coinbasepro BCHGBP   2021.02.19D12:15:54.681617000 512.17     -0.0317578 
```
### CoinbasePro Trading

Obtain CoinbasePro API credentials from https://docs.pro.coinbase.com/

Update the .coinbase.settings dictionary in qCoinbaseTrade.q with API credentials.

**List CoinbasePro trading functions**
```
q)\l qCoinbaseTrade.q
"***** API Key and Secret set *****"
q).coinbase.listFunctions[]
cancelAllOrders| ,`
cancelOrder    | ,`order_id
candles        | ,`productid
checkcreds     | ,`x
currencies     | ,`
fees           | ,`
get24hrStats   | ,`productid
getAccountBal  | ,`
getTrades      | ,`productid
getFills       | ,`productid
getparams      | ,`x
listFunctions  | ,`x
order          | ,`order_id
orderBook      | `productid`level
orders         | ,`
placeOrder     | `side`price`size`id`ordertype`stop`stop_price`time_in_force
products       | ,`
signHeaders    | `timestamp`message`passphrase`api_secret`api_key
ticker         | ,`productid
```

**Get Account Balances**

```
q).coinbase.getAccountBal[]
```

**Place Order**
```
q).coinbase.placeOrder["SELL";"55000";"0.001";"BTCUSDT";"LIMIT";"50000";"GTC"]
```

**Get All Orders**
```
q).coinbase.orders[]
```

**Cancel All Orders**
```
q).coinbase.cancelAllOrders[]
```
