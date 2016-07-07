library(dplyr)
library(tidyr)

#Load the data in RStudio
purchases <- read.csv("refine_original.csv")
 
#Make all observations in "company" lowercase
purchases$company <- tolower(purchases$company)

#Create column for first letter of company name
purchases$company_first_letter <- substr(purchases$company, 1, 1)

#Change comparny first letter to correct spelling of company name
purchases$company_first_letter <- gsub(pattern = "[p|f]", replacement = "philips", purchases$company_first_letter)
purchases$company_first_letter <- gsub(pattern = "a", replacement = "akzo", purchases$company_first_letter)
purchases$company_first_letter <- gsub(pattern = "v", replacement = "van houten", purchases$company_first_letter)
purchases$company_first_letter <- gsub(pattern = "^u", replacement = "unilever", purchases$company_first_letter)

#Replace company column with corrected spellings
purchases$company <- purchases$company_first_letter

purchases$company_first_letter <- NULL

#Separate product code and number
purchases <- separate(purchases, Product.code...number, c("product_code", "product_number"), sep = "-" )

#Add product catergories
purchases$product_category <- purchases$product_code

purchases$product_category <- gsub("p", "Smartphone", purchases$product_category)
purchases$product_category <- gsub("v", "TV", purchases$product_category)
purchases$product_category <- gsub("x", "Laptop", purchases$product_category)
purchases$product_category <- gsub("q", "Tablet", purchases$product_category)

#Add full address column
purchases <- unite(purchases, "full_address", address, city, country, sep = ", ")

#Create dummy variables for company
purchases$company_philips <- ifelse(purchases$company == "philips", 1, 0)
purchases$company_akzo <- ifelse(purchases$company == "akzo", 1, 0)
purchases$company_van_houten <- ifelse(purchases$company == "van houten", 1, 0)
purchases$company_unilever <- ifelse(purchases$company == "unilever", 1, 0)

#Create dummy variables for product catergory
purchases$product_smartphone <- ifelse(purchases$product_code == "p", 1, 0)
purchases$product_tv <- ifelse(purchases$product_code == "v", 1, 0)
purchases$product_laptop <- ifelse(purchases$product_code == "x", 1, 0)
purchases$product_tablet <- ifelse(purchases$product_code == "q", 1, 0)


View(purchases)

write.csv(purchases, "refine_clean.csv")