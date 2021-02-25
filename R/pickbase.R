#library(RSQLite)
#library(dplyr)
library(DBI)

conn <- DBI::dbConnect(
  drv = RSQLite::SQLite(),
  path = "portfolio.sqlite"
  #path = "./data/portfolio.sqlite"
)
getwd()

#methods::setOldClass(c("tbl_df", "data.frame"))


DBI::dbWriteTable(
  conn = conn,
  name = "PRICES",
  value = data
)

DBI::dbListTables(conn = conn)

test_query <- DBI::dbGetQuery(
  conn = conn,
  statement = "select * from prices"
)


DBI::dbDisconnect(conn = conn)

data %>% head




write.csv(data, file = "./data/test.csv", dec = ".")
