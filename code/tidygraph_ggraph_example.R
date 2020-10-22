tidygraph::play_islands(5, 10, 0.8, 3) %>%
  mutate(community = as.factor(group_infomap())) %>%
  ggraph(layout = 'kk') +
  geom_edge_link(aes(alpha = ..index..), show.legend = FALSE) +
  geom_node_point(aes(colour = community), size = 7) +
  theme_graph()


tidygraph::play_islands(5, 10, 0.8, 3) %>% typeof()
