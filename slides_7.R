library(reshape2)
library(stringr)
library(plyr)

getwd()
list.files()

raw <- read.delim("./data/pew.txt", check.names=FALSE, stringsAsFactors=FALSE)
head(raw)

tidy <- melt(raw, "religion")
head(tidy)

names(tidy) <- c("religion", "income", "n")
head(tidy)

raw <- read.csv("./data/tb.csv", stringsAsFactors=FALSE)
raw$new_sp <- NULL
names(raw) <- str_replace(names(raw), "new_sp_", "")
head(raw)
str(raw)

tidy <- melt(raw, id=c("iso2", "year"), na.rm=TRUE)
names(tidy)[4] <- "cases"
head(tidy)

tidy <- arrange(tidy, iso2, variable, year)
head(tidy)

str_sub(tidy$variable, 1,1)
str_sub(tidy$variable, 2)

ages <- c("04" = "0-4", "514" = "5-14", "014" = "0-14", "1524" = "15-24", "2534" = "25-34",
          "3544" = "35-44", "4554" = "45-54", "5564" = "55-64", "65" = "65+", "u" = NA)
ages[str_sub(tidy$variable, 2)]
tidy$sex <- str_sub(tidy$variable, 1, 1)
tidy$age <- factor(ages[str_sub(tidy$variable, 2)], levels = ages)
tidy$variable <- NULL

head(tidy)
tidy <- tidy[c("iso2", "year", "sex", "age", "cases")]

raw <- read.delim("./data/weather.txt", stringsAsFactors = FALSE)
raw1 <- melt(raw, id=1:4, na.rm=TRUE); raw1
raw1$day <- as.integer(
              str_replace(raw1$variable, "d", ""))
raw1$variable <- NULL
raw1$element <- tolower(raw1$element)

raw1 <- raw1[c("id", "year", "month", "day", "element", "value")]
head(raw1)
raw1 <- arrange(raw1, year, month, day, element)

tidy <- dcast(raw1, ... ~ element)
head(tidy)

raw <- read.csv("./data/billboard.csv", stringsAsFactors = FALSE)
raw$date.peaked <- NULL
raw$artist.inverted <- iconv(raw$artist.inverted, 'MAC', 'UTF-8')
raw$track <- str_replace(raw$track, " \\(,*?\\)", "")
names(raw)[-(1:6)] <- 1:76

head(raw)

tidy <- melt(raw, 1:6, na.rm=TRUE)
head(tidy)

tidy$week <- as.integer(as.character(tidy$variable))
tidy$variable <- NULL
head(tidy)

library(lubridate)
tidy$date.entered <- ymd(tidy$date.entered)
tidy$date <- tidy$date.entered + weeks(tidy$week-1)
head(tidy)
tidy$date.entered <- NULL

tidy <- rename(tidy, c("value" = "rank", "artist.inverted" = "artist"))
str(tidy)

tidy <- tidy[c("year", "artist", "track", "time", "genre", "week", "date", "rank")]
str(tidy)

tidy <- arrange(tidy, year, artist, track, week)
head(tidy)

tidy <- tidy[c("year", "date", "artist", "track", "time", "genre", "week", "rank")]
tidy <- arrange(tidy, year, date, artist, track)
head(tidy)

song <- unrowname(unique(tidy[c("artist", "track", "genre", "time")])); song$song_id <- 1:nrow(song)
rank <- join(tidy, song, match="first")
head(rank)
rank <- rank[c("song_id","date","rank")]
head(rank)

files <- dir("./data", pattern=".csv", full=TRUE)
files

names(files) <- basename(files)
files
str(files)

a
