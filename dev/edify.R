#Pulls data from Edify and runs checks.
# Saves check results to the sensitive folder.
# Run this to update data from Edify manually

library(utHelpR)
library(utValidateR)

print("running Edify.R Script")

student <- utHelpR::get_data_from_sql_file(file_name = 'student.sql',
                                           dsn = 'edify',
                                           context = 'shiny'
)

courses <- utHelpR::get_data_from_sql_file(file_name = 'course.sql',
                                           dsn = 'edify',
                                           context = 'shiny'
)

student_courses <- utHelpR::get_data_from_sql_file(file_name = 'student_courses.sql',
                                                   dsn = 'edify',
                                                   context = 'shiny'
)



buildings <- utHelpR::get_data_from_sql_file(file_name = 'buildings.sql',
                                             dsn = 'edify',
                                             context = 'shiny'
)

rooms <- utHelpR::get_data_from_sql_file(file_name = 'rooms.sql',
                                         dsn = 'edify',
                                         context = 'shiny'
)

graduation <- utHelpR::get_data_from_sql_file(file_name = 'graduation.sql',
                                              dsn = 'edify',
                                              context = 'shiny')

# Run and save checks
student_res <- do_checks(df_tocheck = student,
                               checklist = get_checklist("student", "database"),
                               aux_info = aux_info,
                               verbose = TRUE)

course_res <- do_checks(df_tocheck = courses,
                              checklist = get_checklist("course", "database"),
                              aux_info = aux_info,
                              verbose = TRUE)

student_course_res <- do_checks(df_tocheck = student_courses,
                                checklist = get_checklist("student course", "database"),
                                aux_info = aux_info)

graduation_res <- do_checks(df_tocheck = graduation,
                            checklist = get_checklist("graduation", "database"),
                            aux_info = aux_info)

room_res <- do_checks(df_tocheck = rooms,
                      checklist = get_checklist("rooms", "database"),
                      aux_info = aux_info)

building_res <- do_checks(df_tocheck = buildings,
                          checklist = get_checklist("buildings", "database"),
                          aux_info = aux_info)


#Saves pull as rds files to the sensitive folder
df_names <- c("student_res", "course_res", "student_course_res", "building_res", "room_res", "graduation_res")

dir.create(here::here("sensitive"))

# Saving as rds files to sensitive
for (i in 1:length(df_names)) {
  saveRDS(get(df_names[i]), here::here("sensitive", paste0(df_names[i], ".rds")),)
}
