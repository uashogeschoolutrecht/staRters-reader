library(ggraph)
#> Loading required package: ggplot2
library(tidygraph)
#>
#> Attaching package: 'tidygraph'
#> The following object is masked from 'package:stats':
#>
#>     filter

# Create graph of highschool friendships
graph <- as_tbl_graph(highschool) %>%
  mutate(Popularity = centrality_degree(mode = 'in'))

# plot using ggraph
ggraph(graph, layout = 'kk') +
  geom_edge_fan(aes(alpha = ..index..), show.legend = FALSE) +
  geom_node_point(aes(size = Popularity, label = name,
repel = TRUE)) +
  facet_edges(~year) +
  theme_graph(foreground = 'steelblue', fg_text_colour = 'white')
