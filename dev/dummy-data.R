# Generating dummy data for use in app
# Uses data and functions from the utValidateR package

library(dplyr)
library(utValidateR)

# Load data ---------------------------------------------------------------

data("checklist")
data("aux_info")

data("fake_buildings_validation")
data("fake_course_validation")
data("fake_graduation_validation")
data("fake_rooms_validation")
data("fake_student_course_validation")
data("fake_student_df")


# Run checks on dummy datasets --------------------------------------------

student_checks <- checklist %>%
  filter(file == "Student", type == "Database")

student_res <- do_checks(df_tocheck = fake_student_df,
                         checklist = student_checks,
                         aux_info = aux_info)


course_checks <- checklist %>%
  filter(file == "Course", type == "Database")

course_res <- do_checks(fake_course_validation, course_checks, aux_info = aux_info)


graduation_checks <- checklist %>%
  filter(file == "Graduation", type == "Database")

graduation_res <- do_checks(fake_graduation_validation, graduation_checks, aux_info = aux_info)


student_course_checks <- checklist %>%
  filter(file == "Student Course", type == "Database")

student_course_res <- do_checks(fake_student_course_validation,
                                student_course_checks,
                                aux_info = aux_info)

building_checks <- checklist %>%
  filter(file == "Buildings", type == "Database")

building_res <- do_checks(fake_buildings_validation,
                          checklist = building_checks,
                          aux_info = aux_info)


# Save in dev-data/  ------------------------------------------------------

saveRDS(student_res, "inst/dev-data/student_res.rds")
saveRDS(course_res, "inst/dev-data/course_res.rds")
saveRDS(graduation_res, "inst/dev-data/graduation_res.rds")
saveRDS(student_course_res, "inst/dev-data/student_course_res.rds")
saveRDS(building_res, "inst/dev-data/building_res.rds")
