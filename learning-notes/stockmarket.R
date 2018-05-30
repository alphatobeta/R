# 2017年5月15日安全概念股数据
library(tidyquant)
stkcds <- c("300369.SZ","002268.SZ","300352.SZ","300297.SZ","300188.SZ","002439.SZ",
  "600701.SS","300311.SZ","000547.SZ","300333.SZ","603232.SS")

market <- stkcds %>% 
  tq_get(get = "stock.prices",
         from = "2016-01-01")
table(market$symbol)

returns <- market %>%
  group_by(symbol) %>%
  tq_transmute(select = adjusted, mutate_fun = periodReturn,
               period = "daily", type = "log", col_rename = "daily_re") %>% ungroup()


returns %>% filter(date>as.Date("2017-03-01")) %>% ggplot(aes(date, daily_re)) + 
  geom_line(aes(colour = symbol))
# library(plotly)
# ggplotly(p)

returns %>% filter(symbol=="300369.SZ",date>as.Date("2017-01-01")) %>% 
  ggplot(aes(date, daily_re))+
  geom_line(aes(colour = symbol))
returns %>% filter(symbol=="000547.SZ",date>as.Date("2017-01-01")) %>% 
  ggplot(aes(date, daily_re))+
  geom_line(aes(colour = symbol))

# 交互式分析
library(dygraphs)
returns_xts <- as.xts(.[,c("symbol","daily_re")],as.Date(returns$date))
returns_xts[returns_xts$symbol=="300333.SZ",] %>% dygraph()
