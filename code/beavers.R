beaver_telemetry <- datasets::beaver1 %>% 
  ggplot(aes(x = time, y = temp)) +
  geom_point(aes(colour = as_factor(activ))) +
  ggtitle("Body temperature of beavers")

beaver_telemetry