# Dogon wordlist manipulation
# Steven Moran <steven.moran@uzh.ch>

library(dplyr)

setwd("~/Dropbox/Github/dogon")

db <- read.table("English.tsv", sep="\t", header=T, stringsAsFactors=F, fileEncoding="UTF-8", quote="", comment.char="")
lj <- read.table("Leipzig-Jakarta.tsv", sep="\t", header=T, stringsAsFactors=F, fileEncoding="UTF-8", quote="", comment.char="")
sw <- read.table("Swadesh-AH.tsv", sep="\t", header=T, stringsAsFactors=F, fileEncoding="UTF-8", quote="", comment.char="")

db$CONCEPT_LIST <- "DB"
lj$CONCEPT_LIST <- "LJ"
sw$CONCEPT_LIST <- "SW"

head(sw)
dim(sw)+dim(db)+dim(lj)

# Stack em together
x <- rbind(db, lj, sw)
head(x)
# x %>% filter(CONCEPT=="why?")
dim(x)
y <- aggregate.data.frame(x['CONCEPT_LIST'], list(x$CONCEPT, x$DOCULECT, x$COUNTERPART, x$TOKENS), FUN=c)
colnames(y) <- c("CONCEPT", "DOCULECT", "COUNTERPART", "TOKENS", "CONCEPT_LIST")
z <- y[order(y$CONCEPT, y$DOCULECT), ]
row.names(z) <- NULL
dim(z)
head(z)
glimpse(z)
c <- sapply(z$CONCEPT_LIST, paste0, collapse=",")
rownames(c) <- NULL
z$CC <- c
table(z$CC)

# Fix the overlaps
z$CC[z$CC=="DB,DB,LJ,LJ,SW,SW"] <- "DB,LJ,SW"
z$CC[z$CC=="DB,DB,SW,SW"] <- "DB,SW"
z$CC[z$CC=="LJ,LJ"] <- "LJ"
z$CC[z$CC=="LJ,LJ,LJ"] <- "LJ"
z$CC[z$CC=="DB,DB"] <- "DB"
z$CC[z$CC=="DB,LJ,LJ,SW"] <- "DB,LJ,SW"
z$CC[z$CC=="DB,LJ,LJ,LJ"] <- "DB,LJ"
z$CC[z$CC=="DB,LJ,LJ"] <- "DB,LJ"
z$CC[z$CC=="DB,DB,LJ,LJ"] <- "DB,LJ"

z$CONCEPT_LIST <- NULL
rownames(z) <- NULL
colnames(z) <- c("CONCEPT", "DOCULECT", "COUNTERPART", "TOKENS", "CONCEPT_LIST")
head(z)
table(z$CONCEPT_LIST)
dim(z)

z %>% group_by(CONCEPT) %>% distinct(DOCULECT) %>% select(CONCEPT, DOCULECT) %>% summarize(count=n()) %>% arrange(desc(count))

write.table(z, "collapsed-dogon-wordlists.tsv", sep="\t", col.names=T, quote=F)

