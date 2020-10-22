
  now <- lubridate::now("UTC-2:00")
  now <- unlist(stringr::str_split(now, pattern = " "))
  now <- now[2]
  
  if(now <= "12:00:00" & now >= "05:00:00"){cat("####################### \n Good Morning Class! Welcome to the R-course.")}
  if(now > "12:00:00" & now <= "18:00:00"){cat("####################### \n Good Afternoon Class! Welcome to the R-course.")}
  if(now > "18:00:00" & now <= "23:00:00"){cat("####################### \n Good Evening Class! Welcome to the R-course.")}
  if(now > "23:00:00" & now < "05:00:00"){cat("####################### \n Good Night Class!, Welcome to the R-course.")}

cat("You can download or `git clone` the materials from 
www.github.com/uashogeschoolutrecht/r_course_students")
