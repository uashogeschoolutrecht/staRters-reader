presentation_list <- as_tibble(list.files("./presentations"))
write_csv(presentation_list, path = "./files_list_course.csv")

          