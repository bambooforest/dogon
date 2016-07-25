# Dogon comparative wordlist manipulation (corrests, segmentizes and transforms wordlist data; a messy WIP)
# Steven Moran <steven.moran@uzh.ch>

# library(plyr)
library(dplyr)
library(reshape2)
library(ggplot2)
library(tidyr)

# Prerequistes:
# in2csv Dogon.comp.vocab.UNICODE-latest.xls > dogon.csv
# csvcut -c 15,18,19,20,21,22,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43 dogon.csv > temp.csv

### Setup ###
setwd("~/Dropbox/Github/dogon/working")

# Newest Dogon comparative spreadsheet - put into long format and drop empty cells
new <- read.csv("temp.csv", strip.white=TRUE, na.strings=c("", "NA"), comment.char="")
colnames(new) <- c("CONCEPT", "Toro_Tegu", "Ben_Tey", "Bankan_Tey", "Nanga", "Donno_So", "Jamsay_Douentza", "Perge_Tegu", "Gourou", "Jamsay_Mondoro", "Togo_Kan", "Yorno_So", "Tomo_Kan_Segue", "Tomo_Kan_Diangassagou", "Tommo_So", "Tommo_So", "Dogul_Dom", "Dogul_Dom", "Tebul_Ure", "Yanda_Dom", "Najamba", "Tiranige", "Mombo", "Ampari", "Bunoge", "Penange")
head(new); glimpse(new)
# Melt it into something useful
cdl <- melt(new, id.vars=c("CONCEPT"))
colnames(cdl) <- c("CONCEPT", "DOCULECT", "COUNTERPART")
head(cdl); dim(cdl)
length(unique(cdl$CONCEPT))
length(unique(cdl$DOCULECT))
cdl <- cdl[complete.cases(cdl),]
dim(cdl)
# cc <- complete.cases(cdl)
# table(cc)

# Dogon curated and segmentized wordlist for Lingpy
wl <- read.table("collapsed-dogon-wordlists.tsv", sep="\t", header=T, quote="", strip.white=TRUE, comment.char=""); head(wl)
glimpse(wl)


# Select just the data points in the Dogon comparative spreadsheet that are in the dogon wordlist
u <- as.data.frame(unique(wl$CONCEPT))
glimpse(u)
colnames(u) <- c("CONCEPT")
head(u)
u$in.dogon <- u$CONCEPT %in% cdl$CONCEPT
head(u); dim(u)
table(u$in.dogon)
u %>% filter(in.dogon==FALSE)


# Sum the coverage of concept by doculects for WL
head(wl)
# u <- unique(wl$CONCEPT); length(u)
d <- unique(wl$DOCULECT); length(d)
x <- wl %>% distinct(CONCEPT, DOCULECT) %>% group_by(CONCEPT) %>% summarize(doculect.count=n())
head(x)
x$coverage.doculects <- x$doculect.count/length(d)
x %>% arrange(desc(coverage.doculects))
table(x$coverage.doculects)


# Sum the coverage of concept by doculects for the new Dogon wordlist
head(cdl); dim(cdl)
u.cdl <- unique(cdl$CONCEPT); length(u.cdl)
d.cdl <- unique(cdl$DOCULECT); length(d.cdl)
y <- cdl %>% distinct(CONCEPT, DOCULECT) %>% group_by(CONCEPT) %>% summarize(doculect.count=n())
dim(y)
glimpse(y)
y$coverage.doculects <- y$doculect.count/length(d.cdl)
table(y$coverage.doculects)
dim(y)
glimpse(y)
summary(y)

y %>% arrange(desc(coverage.doculects))
table(y$coverage.doculects)
table(y$doculect.count)
glimpse(y)

head(x); dim(x)
head(y); glimpse(y)
f <- left_join(x, y, by=c("CONCEPT"))
head(f)
dim(f)
glimpse(f)
f %>% arrange(desc(coverage.doculects.y))
head(f)
f %>% arrange(desc(coverage.doculects.y))
f %>% filter(coverage.doculects.y > .85)
dim(f)

# colnames(f) <- c("CONCEPT", "")
f$diff <- f$coverage.doculects.y-f$coverage.doculects.x
head(f$coverage.doculects.y)
head(f$coverage.doculects.x)
head(f)
summary(f$diff)

f$extra_doculects <- lapply(f$CONCEPT, function(cpt) {
	doculents_in_cdl = filter(cdl, CONCEPT %in% cpt)$DOCULECT
  	doculents_in_wl = filter(wl, CONCEPT %in% cpt)$DOCULECT
  	
  	setdiff(doculents_in_cdl, doculents_in_wl)
})



# Combine the new concepts with the hand-curated wordlist
per_concept <- lapply(unique(wl$CONCEPT), function(concept) {
	wl0 <- filter(wl, CONCEPT %in% concept) # [, -1]
	cdl0 <- filter(cdl, CONCEPT %in% concept)
	
	cdl0 <- anti_join(cdl0, wl0, by='DOCULECT')
	if(nrow(cdl0)>0) {
		cdl0$TOKENS <- NA 
		cdl0$CONCEPT_LIST <- NA
	}
	
#	print(wl0)
#	print("----")
#	print(cdl0)
	
	rbind(cdl0, wl0)	
}) %>% bind_rows()

# Get just the new stuff
table(is.na(per_concept$CONCEPT_LIST))
clean <- per_concept %>% filter(is.na(CONCEPT_LIST))
dim(clean);head(clean) # 770 new concepts


# Stuff to remove (from manual inspection)
clean <- subset(clean, !grepl("none", clean$COUNTERPART))
clean <- subset(clean, !grepl("xxx", clean$COUNTERPART))
clean <- subset(clean, !grepl("-∅", clean$COUNTERPART))
clean <- subset(clean, !grepl("∅", clean$COUNTERPART))
clean <- clean[clean$COUNTERPART!="(bare stem, {L})",]
# clean <- subset(clean, !grepl("(bare stem, {L})", clean$COUNTERPART))
clean <- subset(clean, !grepl("(verbal derivation)", clean$COUNTERPART))
clean <- subset(clean, !grepl("(no)", clean$COUNTERPART))
clean <- subset(clean, !grepl("(various)", clean$COUNTERPART))
clean <- subset(clean, !grepl("[X bɔ̀] (or mediopassive verb)", clean$COUNTERPART))
clean <- subset(clean, !grepl("- ̀- (final L-tone)", clean$COUNTERPART))
clean <- subset(clean, !grepl(" -: (length, falling tone)", clean$COUNTERPART))
clean <- subset(clean, !grepl("[X ∴] [Y ∴]", clean$COUNTERPART))
clean <- subset(clean, !grepl("(same as accusative)", clean$COUNTERPART))
clean <- clean[clean$COUNTERPART!="({HL}, A/O-stem)",]
clean <- subset(clean, !grepl("X=: (length)", clean$COUNTERPART))
clean <- clean[clean$COUNTERPART!="({H}, final i → a)",]
clean <- clean[clean$COUNTERPART!="({L}, A/O-stem}",]
clean <- clean[clean$COUNTERPART!="(A/O-stem, {L}-toned after ǎⁿ)",]
clean <- clean[clean$COUNTERPART!="(bare stem except E-stem for 3Sg, {L})",]
clean <- subset(clean, !grepl("(clause initial á í, E-stem except -yⁿé ~ -yⁿɛ́ after monosyllabic)", clean$COUNTERPART))
clean <- subset(clean, !grepl("(E/I-stem)", clean$COUNTERPART))
clean <- subset(clean, !grepl("(floating L) X", clean$COUNTERPART))
clean <- subset(clean, !grepl("(non)", clean$COUNTERPART))
clean <- subset(clean, !grepl("(same as dual)", clean$COUNTERPART))
clean <- subset(clean, !grepl("(subject focus: 3Sg form in perfective pos, participles elsewhere)", clean$COUNTERPART))
clean <- subset(clean, !grepl("(verb-focus Cɔ̌:Cɔ̀, otherwise Cɔ̀Cɔ̀)", clean$COUNTERPART))
clean <- subset(clean, !grepl("[X ∴ ] [Y lèy]", clean$COUNTERPART))
clean <- clean[clean$COUNTERPART!="{LH}",]
clean <- clean[clean$COUNTERPART!="({HL}, stem similar to A/O-stem)",]
clean <- subset(clean, !grepl("(= Near-Distant, but without tone-dropping of noun)", clean$COUNTERPART))
clean <- clean[clean$COUNTERPART!="(A/O/U-stem, LH}",]
clean <- clean[clean$COUNTERPART!="(bare stem, {HL})",]
clean <- clean[clean$COUNTERPART!="(conjugated perfective, {LH} tone)",]
clean <- clean[clean$COUNTERPART!="(final a, {HL})",]
clean <- subset(clean, !grepl("(hortative plus ńdè), (VblN -ú after motion verb)", clean$COUNTERPART))
clean <- subset(clean, !grepl("(possible traces in noun-stem-final falling tones)", clean$COUNTERPART))
clean <- subset(clean, !grepl("(same as past)", clean$COUNTERPART))
clean <- clean[clean$COUNTERPART!="(unconjugated perfective, {LH} tone)",]
clean <- clean[clean$COUNTERPART!="){L}, A-stem)",]
clean <- subset(clean, !grepl("[X ∴] [Y ∴], [X bé] [X bé]", clean$COUNTERPART))
clean <- clean[clean$COUNTERPART!="{final a/o, {HL}, {L} after yá)",]
clean <- subset(clean, !grepl("→ (prolongation, final H-tone)", clean$COUNTERPART))
clean <- clean[clean$COUNTERPART!="({(L)HL}, A/O-stem)",]
clean <- clean[clean$COUNTERPART!="({L} after yá, presuffixal stem)",]
clean <- subset(clean, !grepl("(A-stem)", clean$COUNTERPART))
clean <- subset(clean, !grepl("(add clause-initial 2Pl pronoun á)", clean$COUNTERPART))
clean <- clean[clean$COUNTERPART!="(bare stem, {L}",]
clean <- subset(clean, !grepl("(dàgá after verbal noun), (final a on verb)", clean$COUNTERPART))
clean <- clean[clean$COUNTERPART!="(final nonhigh V, {L})",]
clean <- subset(clean, !grepl("(mediopassive verb)", clean$COUNTERPART))
clean <- subset(clean, !grepl("(same as 3Pl)", clean$COUNTERPART))
clean <- subset(clean, !grepl("(various, same as Pl)", clean$COUNTERPART))
clean <- clean[clean$COUNTERPART!="{I/U-stem, no suffix)",]
clean <- subset(clean, !grepl("→ (vowel prolongation, rising pitch)", clean$COUNTERPART))
clean <- subset(clean, !grepl("- ̀- (final L-tone)", clean$COUNTERPART))
clean <- clean[clean$COUNTERPART!="(bare stem, {L})",]
clean <- clean[clean$COUNTERPART!="({HL}, A/O-stem)",]
clean <- clean[clean$COUNTERPART!="X=: (length)",]
clean <- clean[clean$COUNTERPART!="({(L)HL}, A/O-stem)",]
clean <- clean[clean$COUNTERPART!="({L} after yá, presuffixal stem)",]
clean <- clean[clean$COUNTERPART!="(A/O/U-stem, LH}",]
clean <- clean[clean$COUNTERPART!="(bare stem, {L}",]
clean <- clean[clean$COUNTERPART!="(floating L) X",]
clean <- clean[clean$COUNTERPART!="(unconjugated perfective, {LH} tone)",]
clean <- clean[clean$COUNTERPART!="{LH}",]
clean <- clean[clean$COUNTERPART!="- ̀ (final L-tone)",]
clean <- clean[clean$COUNTERPART!="- ̀- (final L-tone)",]
clean <- clean[clean$COUNTERPART!="- ̀- (final L-tone)",]
clean <- clean[clean$COUNTERPART!="→ (prolongation, final H-tone)",]
clean <- clean[clean$COUNTERPART!="→ (vowel prolongation, rising pitch)",]
clean <- clean[clean$COUNTERPART!="(hortative plus ńdè), (VblN -ú after motion verb)",]
clean <- clean[clean$COUNTERPART!="(final L-tone), ma",]
clean <- clean[clean$COUNTERPART!="(stem, 3Sg -à, 3Pl -mmɔ̀), -d-à: sɛ̀,-nj-á: wɔ̀",]
clean <- clean[clean$COUNTERPART!=" -: (length, falling tone)",]
clean <- clean[clean$COUNTERPART!="=∴",]

#
clean$COUNTERPART <- gsub("\\s*X\\s*", "", clean$COUNTERPART)
clean$COUNTERPART <- gsub("\\s*Y\\s*", "", clean$COUNTERPART)
clean$COUNTERPART <- gsub("\\(.*\\)", "", clean$COUNTERPART)
clean$COUNTERPART <- gsub("\\]\\s*\\[", ",", clean$COUNTERPART)
clean$COUNTERPART <- gsub("\\]", "", clean$COUNTERPART)
clean$COUNTERPART <- gsub("\\[", "", clean$COUNTERPART)
clean$COUNTERPART <- gsub("-ⁿ ~ -wⁿ ", "", clean$COUNTERPART)
clean$COUNTERPART <- gsub("ADJ wɔ̀, ADJ=ŋ", "wɔ̀, ŋ", clean$COUNTERPART)

clean %>% filter(grepl("\\(", COUNTERPART))
clean %>% filter(grepl("\\]\\s*\\[", COUNTERPART))

sort(table(clean$COUNTERPART))
dim(clean);head(clean) # 477 cleaned and new concepts
table(clean$DOCULECT)
print(clean, n=30)

# Unpack the counterparts
test <- clean
head(test)
test$old <- NULL
test$old <- test$COUNTERPART
test <- test %>% mutate(COUNTERPART = strsplit(as.character(COUNTERPART), "//")) %>% unnest(COUNTERPART)
test <- test %>% mutate(COUNTERPART = strsplit(as.character(COUNTERPART), ",")) %>% unnest(COUNTERPART)
test <- test %>% mutate(COUNTERPART = strsplit(as.character(COUNTERPART), "\\\\")) %>% unnest(COUNTERPART)
test$COUNTERPART <- gsub("\\(.*\\)", "", test$COUNTERPART)
test <- test[test$COUNTERPART!="",]
test %>% filter(COUNTERPART=="") # remove empty rows introduced by unnest
trim <- function (x) gsub("^\\s+|\\s+$", "", x)
test$COUNTERPART <- trim(test$COUNTERPART)
head(test); dim(test)
print(test, n=100)
glimpse(test)
test <- test %>% mutate(COUNTERPART = strsplit(as.character(COUNTERPART), "~")) %>% unnest(COUNTERPART)
test <- 
print(test,n=100); dim(test)
rownames(test) <- NULL
ID <- rownames(test)
test <- cbind(ID, test)
head(test)
# with old
# test <- test[,c(1,2,3,6,7,4,5)]
# without
test <- test[,c(1,2,3,7,4,5)]

head(test)
head(wl)

write.csv(test, "per_concept.csv", row.names=F)
# Now run: python3 to_tokenize.py

tokenized <- read.csv("per_concept_tokenized.csv")
head(tokenized); dim(tokenized)
table(tokenized$CONCEPT_LIST)
tokenized$ID <- NULL
head(wl); dim(wl)
final <- rbind(wl, tokenized)
head(final); dim(final)
x <- final %>% arrange(CONCEPT)
head(x,n=20); dim(x)
lookup <- final %>% select(CONCEPT, CONCEPT_LIST) %>% distinct(CONCEPT)
x$CONCEPT_LIST[is.na(x$CONCEPT_LIST)] <- lookup$CONCEPT[lookup$CONCEPT_LIST]

table(x$CONCEPT_LIST)

dim*fin

#########

# Now extract just the appropriate CONCEPTS from the new CDL from the vector in WL
head(cdl)
length(unique(cdl$CONCEPT))
cdl$in.wl <- cdl$CONCEPT %in% u
head(cdl); table(cdl)
glimpse(cdl)
table(cdl$in.wl)
y <- cdl %>% filter(in.wl==T)
dim(y)
z <- cdl %>% distinct(CONCEPT, DOCULECT) %>% group_by(CONCEPT) %>% summarize(doculect.count=n())

head(z)
z$coverage.doculects <- z$doculect.count/length(d.cdl)
y %>% arrange(desc(coverage.doculects))
table(y$coverage.doculects)
table(y$doculect.count)
glimpse(y)



head(cdl$CONCEPT)
x <- cdl %>% filter(CONCEPT %in% u$CONCEPT)
head(x); dim(x)
y <- unique(x$CONCEPT)
head(y)


y <- cdl %>% filter(CONCEPT %in% cdl$CONCEPT)
head(y)
dim(y)

head(x)


head(x)

# Compare concept by doculect coverage to NEW master list (Donno So is new; Jeff has no Sangha So or Bangime)




colnames(x) <- c("DOCULECT", "FREQUENCY")
head(x)
x$COVERAGE <- x$FREQUENCY / length(u)

x <- aggregate(w$CONCEPT, w$DOCULECT, FUN=sum)
x <- aggregate(df$Precision, by=list(Corpus=df$Corpus), FUN=mean)
aggregate(w$DOCULECT, by=list(w$CONCENPT), FUN=sum)

# Subset the new Dogon comparative spreadsheet
# Get the coverage for each concept
# Compare to the comparative wordlist












# Prep the data: input data
# variable L1, L2, L3

# melt it
x <- head(df, n=1)
x
xm <- melt(x, id.vars=c("English"))
head(xm)

variable x1
variable x2

how many xs
coverage of each variable by language




x <- data.frame(w$DOCULECT, w$COUNTERPART)
head(x)
x$duplicated <- duplicated(x)
x$CONCEPT <- w$CONCEPT

x %>% filter(duplicated==FALSE)

unique(x$CONCEPT,x$duplicated)


x[duplicated(x), ]

u <- unique(w$CONCEPT)
head(u)

y <- data.frame(w$CONCEPT, w$DOCULECT)
head(y)

# Extract data frame from new data given unique
variable

# 559 levels
table(y$w.DOCULECT)

x <- melt(y, id.vars=c("w.CONCEPT"))
head(x)


counts <- ddply(w, .(w$DOCULECT, w$CONCEPT), nrow)
names(counts) <- c("y", "m", "Freq")
head(counts)
table(counts)

x <- unique(w$CONCEPT)
head(x)
x <- table(w$CONCEPT, w$DOCULECT)


aggregate(w$DOCULECT, by=list(w$CONCEPT), FUN=sum)


x <- aggregate(w$CONCEPT, w$DOCULECT, FUN=sum)
x <- aggregate(df$Precision, by=list(Corpus=df$Corpus), FUN=mean)
aggregate(w$DOCULECT, by=list(w$CONCENPT), FUN=sum)


### Extra stuff ###

# Code to find duplicates in English column in Dogon comparative #
x <- df$English
length(x)
class(x)
duplicated(x)
d <- as.data.frame(x)
d$duplicated <- duplicated(x)
head(d)
d %>% filter(duplicated==TRUE)
#





