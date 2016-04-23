# Airbnb 파생변수 생성

setwd("C:/Users/urime/Documents/r_temp/kaggler/Airbnb")
getwd()

#### 나이대별, 언어별 컴퓨터기기 타입 ####

session_OS_cast = read.csv("session_OS_cast.csv", stringsAsFactors = FALSE)
session_PC_cast = read.csv("session_PC_cast.csv", stringsAsFactors = FALSE)
train = read.csv("train_users_2.csv", stringsAsFactors = FALSE)
language_codes = read.csv("language_codes.csv", stringsAsFactors = FALSE)

head(language_codes)

# join하기
library("dplyr")

OS_join = left_join(session_OS_cast, train, by = c("user_id" = "id"))
head(OS_join)
t(t(colnames(OS_join)))

OS_join = OS_join[, c(1:6, 10:11, 14)]
head(OS_join)

# language_codes, language join
OS_join = left_join(OS_join, language_codes, by= c("language" = "language_codes"))
OS_join = OS_join[,-9]
colnames(OS_join)[9] = "language" 
head(OS_join)

# 언어별 OS type
age_os_join = OS_join[,c(1:6, 9)]
head(age_os_join)

# 결측치있는 language 제거
age_os_join = na.omit(age_os_join)

# 언어별 합계, total row 추가
age_os_cast = aggregate(data = age_os_join, cbind(Android, etc, iOS, windows, num_OS) 
                        ~ language, FUN = "sum")
age_os_cast = rbind(age_os_cast, c("total", colSums(age_os_cast[,2:6])))
age_os_cast

# character => numeric
age_os_cast$Android = as.numeric(age_os_cast$Android)
age_os_cast$etc = as.numeric(age_os_cast$etc)
age_os_cast$iOS = as.numeric(age_os_cast$iOS)
age_os_cast$windows = as.numeric(age_os_cast$windows)
age_os_cast$num_OS = as.numeric(age_os_cast$num_OS)
str(age_os_cast)

# 비율
for(n in 2:5)
{
  # n = 5
  age_os_cast[, n] = round( age_os_cast[, n]/age_os_cast$num_OS, 2)
}
age_os_cast

# write.csv(age_os_cast, "age_OS_cast.csv", row.names = FALSE)
