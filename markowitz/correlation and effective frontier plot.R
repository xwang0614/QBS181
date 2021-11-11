library(zoo)
library(xts)
library(TTR)
library(quantmod)
library(PerformanceAnalytics)
#get the historical price data from yahoo finance
getSymbols(c("AAPL", "GOOGL", "NFLX", "SQ", "TSLA"),from = "2016-01-01",to = "2021-10-01")


#get the daily return for each stock
AAPL_ret <- dailyReturn(AAPL)
GOOGL_ret <- dailyReturn(GOOGL)
NFLX_ret <- dailyReturn(NFLX)
SQ_ret <- dailyReturn(SQ)
TSLA_ret <- dailyReturn(TSLA)

#merge daily returns together and do the correlation analysis
dailyreturn.data <- merge(AAPL_ret, GOOGL_ret, NFLX_ret, SQ_ret, TSLA_ret)
colnames(dailyreturn.data) <- c("AAPL","GOOGL","NFLX","SQ","TSLA")

chart.Correlation(dailyreturn.data)#


#function of plotting effective frontier
efficient.frontier <- function(return){
  covariance <- cov(return) 
  ret <- colMeans(return)
  covariance1 <- rbind(covariance,rep(1,5),ret)
  covariance1 <- cbind(covariance1,rbind(t(tail(covariance1,2)),matrix(0,2,2))) 
  rbase <- seq(min(ret),max(ret),length=100) 
  s <- sapply(rbase,function(x){  
    y <-head(solve(covariance1,c(rep(0,5),1,x)),5)
    y %*% covariance %*% y
  })  
  plot(s,rbase) 
}

efficient.frontier(dailyreturn.data)

#use the existing library fPortfolio and do the analysis on effective frontier
library(fPortfolio)
merged.daily.return <- as.timeSeries(dailyreturn.data)

#Get the summary of effective frontier
Efficient.Frontier <- portfolioFrontier(merged.daily.return)
Efficient.Frontier
#Plot the efficient frontier
#Different selections provide different plots:
#1.Plot Efficient Frontier
#2.Add Minimum Risk Portfolio
#3.Add Risk/Return of Single Assets
#4.Add Equal Weights Portfolio
#5.Add Two Asset Frontiers [LongOnly Only]
#6.Add Monte Carlo Portfolios
#7.Add Sharpe Ratio [Markowitz PF Only]
plot(Efficient.Frontier)

#get the summary of minimum risk portfolio
minriskPortfolio(merged.daily.return, spec = portfolioSpec(), constraints = "LongOnly")

#get the weights plot for our portfolio
weightsPlot(Efficient.Frontier)

#get the summary of highest return/risk ratio portfolio
tangencyPortfolio(merged.daily.return, spec = portfolioSpec(), constraints = "LongOnly")


