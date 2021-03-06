# Open oec-atlas-data.Rproj before running this script

# RStudio server users: shiny apps don't work inside rstudio if you access via https://your.site/rstudio
# use ssh to create a tunnel and access via localhost:8787

if (!require("pacman")) install.packages("pacman")
p_load(data.table, dplyr)
p_load_gh("ropensci/tabulizer")

# 1: download book -----------------------------------------------------------

try(dir.create("1-book-in-pdf"))

url_atlas_part_1 <- "https://atlas.media.mit.edu/static/pdf/atlas/AtlasOfEconomicComplexity_Part_I.pdf"
pdf_atlas_part_1 <- "1-book-in-pdf/atlas-part-1.pdf"
pdf_atlas_part_1_zip <- "1-book-in-pdf/atlas-part-1.zip"

if (!file.exists(pdf_atlas_part_1) & !file.exists(pdf_atlas_part_1_zip)) {
  download.file(url_atlas_part_1, pdf_atlas_part_1)
}

if (file.exists(pdf_atlas_part_1) & !file.exists(pdf_atlas_part_1_zip)) {
  system(paste("7z a", pdf_atlas_part_1_zip, pdf_atlas_part_1))
}

if (!file.exists(pdf_atlas_part_1) & file.exists(pdf_atlas_part_1_zip)) {
  system(paste("7z e", pdf_atlas_part_1_zip, "-oc:1-book-in-pdf"))
}

url_atlas_part_2 <- "https://atlas.media.mit.edu/static/pdf/atlas/AtlasOfEconomicComplexity_Part_II.pdf"
pdf_atlas_part_2 <- "1-book-in-pdf/atlas-part-2.pdf"
pdf_atlas_part_2_zip <- "1-book-in-pdf/atlas-part-2.zip"

if (!file.exists(pdf_atlas_part_2) & !file.exists(pdf_atlas_part_2_zip)) {
  download.file(url_atlas_part_2, pdf_atlas_part_2)
}

if (file.exists(pdf_atlas_part_2) & !file.exists(pdf_atlas_part_2_zip)) {
  system(paste("7z a", pdf_atlas_part_2_zip, pdf_atlas_part_2))
}

if (!file.exists(pdf_atlas_part_2) & file.exists(pdf_atlas_part_2_zip)) {
  system(paste("7z e", pdf_atlas_part_2_zip, "-oc:1-book-in-pdf"))
}

# 2: pdf scraping ------------------------------------------------------------

# this part is not automatic, you need to select areas
# just omit the colored rows of the tables in the pdf selector to get tidy columns
# run the next subsections line by line when extract_areas appears

# * ranking 1 (p. 64-66, economic complexity) -----------------------------

table_p64 <- as_tibble(extract_areas(pdf_atlas_part_1, pages = 64)[[1]])
table_p65 <- as_tibble(extract_areas(pdf_atlas_part_1, pages = 65)[[1]])
table_p66 <- as_tibble(extract_areas(pdf_atlas_part_1, pages = 66)[[1]])

ranking_1 <- bind_rows(table_p64, table_p65, table_p66)

names(ranking_1) <- c(
  "rank_eci_complexity_2008",
  "regional_eci_ranking",
  "country_name",
  "iso_code",
  "eci_2008",
  "rank_income_2009_usd",
  "income_2009_usd",
  "region"
)

try(dir.create("2-scraped-tables"))

fwrite(ranking_1, "2-scraped-tables/ranking-1-economic-complexity-index.csv")

# * ranking 2 (p. 70-72, expected growth in per capita gdp 2020) ----------

table_p70 <- as_tibble(extract_areas(pdf_atlas_part_1, pages = 70)[[1]])
table_p71 <- as_tibble(extract_areas(pdf_atlas_part_1, pages = 71)[[1]])
table_p72 <- as_tibble(extract_areas(pdf_atlas_part_1, pages = 72)[[1]])

ranking_2 <- bind_rows(table_p70, table_p71, table_p72)

names(ranking_2) <- c(
  "rank_exp_growth_in_gdp_pc",
  "regional_ranking_exp_growth_in_gdp_pc",
  "country_name",
  "iso_code",
  "expected_growth_in_gdp_pc_2009_2020",
  "growth_in_gdp_pc_1999_2009",
  "rank_income_2009_usd",
  "income_2009_usd",
  "rank_income_2020",
  "expected_income_2020_usd",
  "region"
)

try(dir.create("2-scraped-tables"))

fwrite(ranking_2, "2-scraped-tables/ranking-2-expected-growth-in-per-capita-gdp-2020.csv")

# * ranking 3 (p. 76-78, expected gdp growth to 2020) ---------------------

table_p76 <- as_tibble(extract_areas(pdf_atlas_part_1, pages = 76)[[1]])
table_p77 <- as_tibble(extract_areas(pdf_atlas_part_1, pages = 77)[[1]])
table_p78 <- as_tibble(extract_areas(pdf_atlas_part_1, pages = 78)[[1]])

ranking_3 <- bind_rows(table_p76, table_p77, table_p78)

names(ranking_3) <- c(
  "rank_expected_gdp_growth",
  "regional_rank_expected_gdp_growth",
  "country_name",
  "iso_code",
  "expected_gdp_growth_2009_2020",
  "growth_1998_2008",
  "rank_income_2009_usd",
  "income_2009_usd",
  "rank_income_2020",
  "expected_income_2020_usd",
  "expected_population_growth",
  "region"
)

try(dir.create("2-scraped-tables"))

fwrite(ranking_3, "2-scraped-tables/ranking-3-expected-gdp-growth-to-2020.csv")

# * ranking 4 (p. 82-84, changes in economic complexity 1964-2008) --------

table_p82 <- as_tibble(extract_areas(pdf_atlas_part_1, pages = 82)[[1]])
table_p83 <- as_tibble(extract_areas(pdf_atlas_part_1, pages = 83)[[1]])
table_p84 <- as_tibble(extract_areas(pdf_atlas_part_1, pages = 84)[[1]])

ranking_4 <- bind_rows(table_p82, table_p83, table_p84)

names(ranking_4) <- c(
  "ranking_delta_eci_64_08",
  "regional_ranking_delta_eci_64_08",
  "country_name",
  "iso_code",
  "y1964",
  "y1968",
  "y1978",
  "y1988",
  "y1998",
  "y2008",
  "delta_eci_64_08",
  "delta_eci_98_08",
  "ranking_delta_eci_98_08",
  "regional_ranking_delta_eci_98_08",
  "region"
)

try(dir.create("2-scraped-tables"))

fwrite(ranking_4, "2-scraped-tables/ranking-4-change-in-economic-complexity-1964-2008.csv")

# * ranking 5 (p. 88-90, expected contribution to world gdp growth --------

table_p88 <- as_tibble(extract_areas(pdf_atlas_part_1, pages = 88)[[1]])
table_p89 <- as_tibble(extract_areas(pdf_atlas_part_1, pages = 89)[[1]])
table_p90 <- as_tibble(extract_areas(pdf_atlas_part_1, pages = 90)[[1]])

ranking_5 <- bind_rows(table_p88, table_p89, table_p90)

names(ranking_5) <- c(
  "ranking_contribution_to_world_gdp_growth_to_2020",
  "regional_ranking_contribution_to_world_gdp_growth_to_2020",
  "country_name",
  "iso_code",
  "contribution_to_world_gdp_growth_to_2020",
  "region"
)

try(dir.create("2-scraped-tables"))

fwrite(ranking_5, "2-scraped-tables/ranking-5-expected-contribution-to-world-gdp-growth-to-2020.csv")
