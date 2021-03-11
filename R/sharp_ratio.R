# sharp ratio
# measure for calculating risk-adjusted return

# S = (rp - rf) / stdp
# rf... risk free return: bank account rates f.i., close to 0!?
# rp... avg return
# stdp... std return

# annualized sharp ratio
# asr = k * sr
# daily k = sqrt(252), weekly k = sqrt(52), monthly k=sqrt(12)

# allocation = cum return * allocation (distribution of money in portfolio)

# sr = mean(1dpc) / sd(1dpc)
# asr = sqrt(252) * sr


# correlations of 1dpc!!!! correlation matrix

# log daily percentage change for detrending time series -> log(xt/x(t-1))


# monte carlo
# set of weights (1 for each position), divide by sum of weights to scale between 0 and 1

# expected returns = sum(log_ret.mean * weights*252)
# expected volatility = sqrt(dotproduct( weigthts * dot product (log_ret.cov * 252) ))

# weights: marketcap_of_stock_i / sum(marketcap)


# capm capital asset pricing model
# ri(t) = betai*rm(t) + alphai(t)
# rm = return of market



# cumulative = close / close[1]



# beta: linear regression of stock daily percentage change vs market daily percentage change

# high beta value --> stock lines up with the market

