df <- tibble(
  numbers = c(1:5),
  capitals = c("A", "A", "B", "C", "C"),
  more_numbers = c(11:15)
  )


## summarize
df %>%
  group_by(capitals) %>%
  summarise(mean_numbers = mean(numbers),
            sd_numbers = sd(numbers),
            obs = n()) %>%
  ggplot(aes(x = capitals, y = mean_numbers)) +
  geom_bar(stat = 'identity') 
  




## mean of two columns
df %>% 
  dplyr::rowwise() %>%
  dplyr::mutate(
    mean_numbers = mean(c(numbers, more_numbers)),
    sum_numbers = sum(c(numbers, more_numbers))
    )
