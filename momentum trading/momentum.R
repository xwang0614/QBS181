#Required to install Systematic Investor Toolbox(SIT) package

# Install Systematic Investor Toolbox (SIT) package
# github.com/systematicinvestor/SIT

#
# please first install SIT.date
# devtools::install_github('systematicinvestor/SIT.date')
# 
# library(curl)
# curl_download('https://github.com/systematicinvestor/SIT/raw/master/SIT.tar.gz', 'sit',mode = 'wb',quiet=T)
# install.packages('sit', repos = NULL, type='source')

library(SIT)
library(quantmod)
tickers = 'AAPL,GOOGL,NFLX,SQ,TSLA'
data = new.env()
getSymbols.extra(tickers, src = 'yahoo', from = '2016-01-01', to = '2021-10-01', env = data, set.symbolnames = T, auto.assign = T)

for(i in data$symbolnames) data[[i]] = adjustOHLC(data[[i]], use.Adjusted=T)
bt.prep(data, align='keep.all', dates='2016::', fill.gaps=T)

prices = data$prices
n = ncol(prices)
nperiods = nrow(prices)

frequency = 'months'
period.ends = endpoints(prices, frequency)
period.ends1 = period.ends - 1 # lag by one day
period.ends1 = period.ends1[period.ends1 > 0]
period.ends0 = period.ends1 + 1

models = list()

commission = list(cps = 0.01, fixed = 10.0, percentage = 0.0)

return = prices / mlag(prices,30) - 1
position.score = iif(return < 0, NA, return)
data$weight[] = NA
data$weight[period.ends0,] = ntop(position.score[period.ends1,], 1)
models$mom30 = bt.run.share(data, clean.signal=F, commission = commission, trade.summary=T, silent=T)




return = prices / mlag(prices,30) - 1 + prices / mlag(prices,60) - 1 
position.score = iif(return < 0, NA, return)
data$weight[] = NA
data$weight[period.ends0,] = ntop(position.score[period.ends1,], 1)
models$mom60 = bt.run.share(data, clean.signal=F, commission = commission, trade.summary=T, silent=T)

return = prices / mlag(prices,30) - 1 + prices / mlag(prices,60) - 1 + prices / mlag(prices,120) - 1 
position.score = iif(return < 0, NA, return)
data$weight[] = NA
data$weight[period.ends0,] = ntop(position.score[period.ends1,], 1)
models$mom120 = bt.run.share(data, clean.signal=F, commission = commission, trade.summary=T, silent=T)



plotbt(models, plotX = T, log = 'y', LeftMargin = 3, main = NULL)
mtext('Cumulative Performance', side = 2, line = 1)

print(plotbt.strategy.sidebyside(models, make.plot=F, return.table=T, perfromance.fn=engineering.returns.kpi))

print(last.trades(models$mom120, make.plot=F, return.table=T))






