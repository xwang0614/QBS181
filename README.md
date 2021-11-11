# Stock portfolio optimization
## Description
  Firstly, We want to identify the historical trends and price records for each stock from investment portfolio and figure out whether a stock is a good long-term investment target. We will compare the returns of these stocks as well as the volatility, because these are very important for an average person to be able to hold this stock for a long time. Then we will use the Markowitz Mean-Variance Model[1] to obtain the appropriate portfolio for people with different investment styles.
  
  Secondly, after knowing the appropriate portfolio, we can always hold it and keep an eye on the information related to the companies in your portfolio from time to time. Or you can choose to use some trading strategies to optimize your portfolio’s profitability. We are still cautiously optimistic about the the market afterwards due to the elevated government debt ceiling and uncertainty about when monetary tapering and reduced quantitative easing will occur. So in this group project, we will use a strategy called Momentum Trading[2] to optimize our portfolio, as this investment strategy is more friendly to one-sided upward market. The advantage of these trading strategies is that they can be run automatically, but of course in addition to the optimization of trading strategies, our own control of information also needs to be strengthened. Therefore, we will collate the time of stock spikes or plunges, combined with company-related or market-related news, so that we can, in the future, adjust our portfolio in time according to the market situation.
  
Aim 1: Analysis for each stock of our group’s stock portfolio and optimize the portfolio

  1.1. Calculate daily and monthly returns for each stock and visualize them.
  
  1.2. Calculate the cumulative return for each stock and visualize them.
  
  1.3. Calculate the mean and variance of daily and monthly return for each stock and visualize them. 
  
  1.4. Use Markowitz Mean-Variance Model to optimize my investment portfolio

Aim 2: Optimizing my trading strategy


  2.1. Make back test Momentum Strategy for my portfolio

  2.2. Find out when a stock spikes or plunges and get news about the stock within its time frame to guide future trading 
       decisions

## prerequisities
we need to use the R software and following library

library(zoo)

library(xts)

library(TTR)

library(quantmod)

library(PerformanceAnalytics)

library(fPortfolio)

library(curl)

library(SIT)

library(stringr)

library(tidyverse)

]library(tidytext)

library(magrittr)

library(ggplot2)

library(tidyquant)

library(timetk)

library(QBS181momentum)

## installation
You can use the "install.packages()" to install all of the packages above except library(QBS181momentum) and library(SIT) to install the library. Just add the library name into the ().

For the library(STI). Install Systematic Investor Toolbox (SIT) package. From following URL : 'github.com/systematicinvestor/SIT'


please first install SIT.date, use the folliowing code:

>devtools::install_github('systematicinvestor/SIT.date')
 
>library(curl)

>curl_download('https://github.com/systematicinvestor/SIT/raw/master/SIT.tar.gz', 'sit',mode = 'wb',quiet=T)

>install.packages('sit', repos = NULL, type='source')
## contact
ruce.shao.gr@dartmouth.edu

yuexi.liang.gr@dartmouth.edu

xinyu.wang.gr@dartmouth.edu

wentao.zhao.gr@dartmouth.edu
