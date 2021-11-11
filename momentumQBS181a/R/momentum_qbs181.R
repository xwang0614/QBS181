#' A momentum function
#'
#' This function allows you to calculate the stocks returns based on 30/60/120
#' days momentum strategies, and will plot the return curves.
#' @param tickers The names of tickers you want to read from yahoo.(like:'AAPL,GOOGL,NFLX,SQ,TSLA') 
#' @param from_ the starting time of the tickers
#' @param to_ the ending time of the tickers
#' @example momentum_qbs181('AAPL,GOOGL,NFLX,SQ,TSLA','2016-01-01','2021-10-01')
#' @author Zhang, Shao, Wang, Liang




momentum_qbs181=function(ticker,from_,to_){
  library(SIT)
  data = new.env()
  getSymbols.extra(ticker, src = 'yahoo', from = from_, 
                   to = to_, env = data, set.symbolnames = T, 
                   auto.assign = T)
  #adjust open,high,low,close prices for splits and dividends and setting back test preparation
  for(i in data$symbolnames) data[[i]] = adjustOHLC(data[[i]], use.Adjusted=T)
  bt.prep(data, align='keep.all', dates='2016::', fill.gaps=T)
  
  #Setting up the rebalance frequency
  prices = data$prices
  n = ncol(prices)
  nperiods = nrow(prices)
  frequency = 'months'
  period.ends = endpoints(prices, frequency)
  period.ends1 = period.ends - 1 # lag by one day
  period.ends1 = period.ends1[period.ends1 > 0]
  period.ends0 = period.ends1 + 1
  
  #Setting up our model
  models = list()
  
  #Setting the commission for trading stocks
  commission = list(cps = 0.01, fixed = 10.0, percentage = 0.0)
  
  #Trade based on 30 days momentum
  return = prices / mlag(prices,30) - 1
  position.score = iif(return < 0, NA, return)
  data$weight[] = NA
  data$weight[period.ends0,] = ntop(position.score[period.ends1,], 1)
  models$mom30 = bt.run.share(data, clean.signal=F, commission = commission, trade.summary=T, silent=T)
  
  #Trade based on 30/60 days momentum
  return = prices / mlag(prices,30) - 1 + prices / mlag(prices,60) - 1
  position.score = iif(return < 0, NA, return)
  data$weight[] = NA
  data$weight[period.ends0,] = ntop(position.score[period.ends1,], 1)
  models$mom60 = bt.run.share(data, clean.signal=F, commission = commission, trade.summary=T, silent=T)
  
  #Trade based on 30/60/120 days momentum
  return = prices / mlag(prices,30) - 1 + prices / mlag(prices,60) - 1 + prices / mlag(prices,120) - 1 
  position.score = iif(return < 0, NA, return)
  data$weight[] = NA
  data$weight[period.ends0,] = ntop(position.score[period.ends1,], 1)
  models$mom120 = bt.run.share(data, clean.signal=F, commission = commission, trade.summary=T, silent=T)
  
  #plot the cumulative return for each strategy
  plotbt(models, plotX = T, log = 'y', LeftMargin = 3, main = "Trading Strategy Based On Different Momentum ")
  mtext('Cumulative Return', side = 2, line = 1)
  
  #print the summary of performance for each strategy
  print(plotbt.strategy.sidebyside(models, make.plot=F, return.table=T, perfromance.fn=engineering.returns.kpi))
  
  
  print(last.trades(models$mom120, make.plot=F, return.table=T))
  
  return(0)
}
