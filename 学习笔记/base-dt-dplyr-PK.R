library(microbenchmark)
library(data.table)
library(dplyr)
set.seed(123)
dat <- data.frame(x = rnorm(1e6))
dat1 <- copy(dat)
dat2 <- copy(dat)
microbenchmark(
  setDT(dat1)[x < 0, x := NA],  # 直接修改
  dat %>% mutate(x = NA ^ (x < 0) * x),
  dat %>% mutate(x = replace(x, x < 0, NA)),
  dat2$x[dat2$x < 0] <- NA,  # 直接修改
  dat %>% mutate(x = replace(x, which(x < 0), NA)),
  dat %>% mutate(x = "is.na<-"(x, x < 0)),
  dat %>% mutate(x = ifelse(x < 0, NA, x))
)
head(dat)
head(dat1)
head(dat2)
