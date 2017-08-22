#!/usr/bin/env Rscript --vanilla

######################################################
# Transform Dogon wordlist data into LingPy format
# Steven Moran <steven.moran@uzh.ch>
#
#
######################################################
cat('Loading packages\n\n')
chooseCRANmirror(74,graphics=FALSE) # ETHZ
if(!require(tidyr)) {install.packages("tidyr", dependencies=T); library(tidyr)}
if(!require(reshape2)) {install.packages("reshape2", dependencies=T); library(reshape2)}
if(!require(dplyr)) {install.packages("dplyr", dependencies=T); library(dplyr)}

######################################################
# Load Dogon wordlist CSV wide data format

df <- read.csv("data/dogon-wordlist.csv", strip.white=TRUE, na.strings=c("", "NA"), comment.char="", stringsAsFactors = FALSE)
colnames(df) <- c("CONCEPT", "Toro_Tegu", "Ben_Tey", "Bankan_Tey", "Nanga", "Donno_So", "Jamsay_Douentza", "Perge_Tegu", "Gourou", "Jamsay_Mondoro", "Togo_Kan", "Yorno_So", "Tomo_Kan_Segue", "Tomo_Kan_Diangassagou", "Tommo_So", "Tommo_So", "Dogul_Dom", "Dogul_Dom", "Tebul_Ure", "Yanda_Dom", "Najamba", "Tiranige", "Mombo", "Ampari", "Bunoge", "Penange")

######################################################
# Melt wide-data into long-data
df.long <- melt(df, id.vars=c("CONCEPT"))
colnames(df.long) <- c("CONCEPT", "DOCULECT", "COUNTERPART")

######################################################
# Remove NAs and other stuff (from manual inspection)
clean <- df.long %>% filter(!is.na(COUNTERPART))
clean <- subset(clean, !grepl("none", clean$COUNTERPART))
clean <- subset(clean, !grepl("xxx", clean$COUNTERPART))
clean <- subset(clean, !grepl("-∅", clean$COUNTERPART))
clean <- subset(clean, !grepl("∅", clean$COUNTERPART))
clean <- subset(clean, !grepl("(bare stem, \\{L\\})", clean$COUNTERPART))
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
clean$COUNTERPART <- gsub("\\s*X\\s*", "", clean$COUNTERPART)
clean$COUNTERPART <- gsub("\\s*Y\\s*", "", clean$COUNTERPART)
clean$COUNTERPART <- gsub("\\(.*\\)", "", clean$COUNTERPART)
clean$COUNTERPART <- gsub("\\]\\s*\\[", ",", clean$COUNTERPART)
clean$COUNTERPART <- gsub("\\]", "", clean$COUNTERPART)
clean$COUNTERPART <- gsub("\\[", "", clean$COUNTERPART)
clean$COUNTERPART <- gsub("-ⁿ ~ -wⁿ ", "", clean$COUNTERPART)
clean$COUNTERPART <- gsub("ADJ wɔ̀, ADJ=ŋ", "wɔ̀, ŋ", clean$COUNTERPART)

######################################################
# Tests (should be 0 length)
# clean %>% filter(grepl("\\(", COUNTERPART))
# clean %>% filter(grepl("\\]\\s*\\[", COUNTERPART))

######################################################
# Unpack the counterparts that are separted by various delimiters 
unpacked <- clean
unpacked$ORIGINAL <- NULL
unpacked$ORIGINAL <- unpacked$COUNTERPART
unpacked <- unpacked %>% mutate(COUNTERPART = strsplit(as.character(COUNTERPART), "//")) %>% unnest(COUNTERPART)
unpacked <- unpacked %>% mutate(COUNTERPART = strsplit(as.character(COUNTERPART), ",")) %>% unnest(COUNTERPART)
unpacked <- unpacked %>% mutate(COUNTERPART = strsplit(as.character(COUNTERPART), "\\\\")) %>% unnest(COUNTERPART)
unpacked <- unpacked %>% mutate(COUNTERPART = strsplit(as.character(COUNTERPART), "~")) %>% unnest(COUNTERPART)
unpacked$COUNTERPART <- gsub("\\(.*\\)", "", unpacked$COUNTERPART)
unpacked <- unpacked[unpacked$COUNTERPART!="",]
trim <- function (x) gsub("^\\s+|\\s+$", "", x)
unpacked$COUNTERPART <- trim(unpacked$COUNTERPART)
unpacked <- unpacked %>% filter(!COUNTERPART=="") # remove empty rows introduced by unnest

######################################################
# Write LingPy format to disk for segmentation
unpacked$ORIGINAL <- NULL
rownames(unpacked) <- NULL
ID <- rownames(unpacked)
final <- cbind(ID, unpacked)
write.csv(final, "data/dogon-wordlist-long.csv", row.names=F)




