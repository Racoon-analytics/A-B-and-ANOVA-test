library(tidyverse)
library(ggpubr)
library(broom)
library(pwr)

set.seed(387)

num_users_A <- 5000
num_users_B <- 5000
conv_rate_A <- 0.10
conv_rate_B <- 0.115

traffic_sources <- c("Organic", "Paid", "Referral")
device_types <- c("Mobile", "Desktop", "Tablet")
time_of_day <- c("Morning", "Afternoon", "Evening", "Night")

simulate_users <- function(n, group, conv_rate){
  tibble(
    user_id = paste0(group, "_", 1:n),
    group = group,
    traffic_source = sample(traffic_sources, n, replace = TRUE),
    device_type = sample(device_types, n, replace = TRUE),
    time_of_day = sample(time_of_day, n, replace = TRUE),
    converted = rbinom(n, 1, conv_rate),
    spent_usd = round(rnorm(n, mean = 50 + 2*(group=="B"), sd = 10 + 2*(group=="B")) * converted, 2)
  )
}

users_A <- simulate_users(num_users_A, "A", conv_rate_A)
users_B <- simulate_users(num_users_B, "B", conv_rate_B)
ab_data <- bind_rows(users_A, users_B)


conversion_summary <- ab_data |>
  group_by(group, traffic_source) |>
  summarise(
    users = n(),
    conversions = sum(converted),
    conversion_rate = mean(converted),
    avg_spent = mean(spent_usd[converted==1], na.rm=TRUE),
    sd_spent = sd(spent_usd[converted==1], na.rm=TRUE)
  )
print(conversion_summary)



conv_plot <- ab_data |>
  group_by(group) |>
  ggplot(aes(x=group, y=conv_rate, fill=group)) +
  geom_col(alpha=0.7) +
  geom_text(aes(label=scales::percent(conv_rate)), vjust=-0.5) +
  ylim(0,0.2) +
  labs(title="Конверсія по групах з 95% CI", y="Conversion Rate", x="Group") +
  theme_minimal()
print(conv_plot)


conv_table <- table(ab_data$group, ab_data$converted)
prop_test_result <- prop.test(conv_table, alternative="greater") 
tidy_result <- broom::tidy(prop_test_result)
print(tidy_result)

if(tidy_result$p.value < 0.05){
  cat("Результат статистично значущий: тестова група показала збільшену конверсію.\n")
} else {
  cat("Результат статистично не значущий: немає чіткої переваги тестової групи.\n")
}


alpha <- 0.05
power_test <- pwr.2p.test(h = ES.h(conv_rate_B, conv_rate_A),
                          n = num_users_A, sig.level = alpha, alternative="greater") 
cat("Type II error (β) приблизно:", 1 - power_test$power, "\n")
cat("Потужність тесту:", power_test$power, "\n")


anova_model <- aov(spent_usd ~ group + device_type + traffic_source + time_of_day + group:device_type, 
                   data = ab_data |> filter(converted==1))
summary(anova_model)
TukeyHSD(anova_model)


glm_model <- glm(converted ~ group + device_type + traffic_source + time_of_day + group:device_type, 
                 data=ab_data, family=binomial)
print(broom::tidy(glm_model))
