import calendar
from datetime import datetime, time
import helpers
import mysql.connector as mysql


# The Database class is a parent model
# for ease of connection to the database.
class Database:

    # This constructor defines public attributes
    # such as conn for the database connection and cur for the cursor.
    def __init__(self):
        config = {
            "host": "localhost",
            "user": "root",
            "password": "123",
            "database": "db_s2p1",
        }
        self.conn = mysql.connect(**config)
        self.cur = self.conn.cursor()
        # A cursor in MySQL Connector is an object
        # that helps execute queries and fetch records from the database
        self.cur.execute("SET time_zone = '+07:00'")
        return


# The Lecturer class is a child model
# for the handling of all data related to the lecturer table.
class Lecturer(Database):
    # This consturctor acts as a login process
    def __init__(self, nid, password):

        super().__init__()
        # It is used to call the constructor of the parent class.
        # This allows the subclass to inherit and initialize superclass attributes.

        q = "SELECT * FROM lecturers WHERE nid = %s"
        self.cur.execute(q, (nid,))
        result = self.cur.fetchone()
        helpers.console_log(result)  # Print the value in debug mode

        if result is None:  # case when user not found
            self.login_status = None
            return
        elif password != result[-1]:  # case when password incorect
            self.login_status = False
            return
        else:
            (
                self.__nid,
                self.__full_name,
                self.__gender,
                self.__phone,
                self.__email,
                self.__adress,
                self.__password,
            ) = result  # insert all data to private attributes
            self.login_status = True
            return

    # Properties provide a way to encapsulate access
    # to instance variables, enabling validation and computation on access.
    # Property getter
    @property
    def nid(self):
        return self.__nid

    @property
    def full_name(self):
        return self.__full_name

    @property
    def gender(self):
        return self.__gender

    @property
    def phone(self):
        return self.__phone

    @property
    def email(self):
        return self.__email

    @property
    def adress(self):
        return self.__adress

    @property
    def classes(self):
        return self.__classes

    @classes.setter
    def classes(self, selected_class):
        self.__classes = selected_class
        return

    # Property setter
    def set_password(self, old, new):
        if old != self.__password:
            return False

        self.__reset_password(new)
        self.__password = new
        return True

    def __reset_password(self, new_password):
        q = """UPDATE lecturers
        SET password = %s
        WHERE nid = %s"""
        self.cur.execute(q, (new_password, self.__nid))
        self.conn.commit()
        return

    def __get_class(self):
        q = "SELECT * FROM classes WHERE nid = %s"
        self.cur.execute(q, (self.__nid,))
        results = self.cur.fetchall()
        helpers.console_log(results)

        classes = []
        # This code will reconstruct the data using obejct
        for result in results:
            classes.append({"class_id": result[0], "class_name": result[2]})
        return classes

    def print_class_list(self):
        class_list = self.__get_class()

        for i, item in enumerate(class_list):
            print(f"{i + 1}.", item["class_name"])

        return class_list

    def get_today_attendance(self):
        q = """
        SELECT timestamp
        FROM lecturer_attendance
        WHERE DATE(timestamp) = CURRENT_DATE
        AND class_id = %s
        AND nid = %s"""
        self.cur.execute(q, (self.__classes["class_id"], self.__nid))
        result = self.cur.fetchone()
        helpers.console_log(result)
        if result is None:
            return result
        else:
            return result[0].strftime("%H:%M")

    def store_today_attendance(self):
        q = """INSERT INTO
        lecturer_attendance (class_id, nid)
        VALUES (%s, %s)"""
        self.cur.execute(q, (self.__classes["class_id"], self.__nid))
        self.conn.commit()
        return self.get_today_attendance()

    def get_students(self):
        q = """
        SELECT nis, full_name
        FROM students
        WHERE class_id = %s
        ORDER BY full_name"""
        self.cur.execute(q, (self.__classes["class_id"],))
        results = self.cur.fetchall()

        student_list = []
        for result in results:
            student_list.append({"nis": result[0], "full_name": result[1]})
        helpers.console_log(student_list)
        return student_list

    def get_student_detail(self, nis):
        q = """
        SELECT *
        FROM students 
        WHERE nis = %s
        """
        self.cur.execute(q, (nis,))
        result = self.cur.fetchone()
        helpers.console_log(result)
        return result

    def __get_student_overview(self, nis):
        q = """
        SELECT 
        SUM(CASE WHEN status = 0 THEN 1 ELSE 0 END) AS attend_count,
        SUM(CASE WHEN status = 1 THEN 1 ELSE 0 END) AS sick_count,
        SUM(CASE WHEN status = 2 THEN 1 ELSE 0 END) AS permit_count
        FROM student_attendance
        WHERE nis = %s
        AND DATE_FORMAT(timestamp, '%m-%Y') = DATE_FORMAT(CURRENT_TIMESTAMP, '%m-%Y')
        """
        self.cur.execute(q, (nis,))
        results = self.cur.fetchone()
        helpers.console_log(results)
        return results

    def print_student_overview(self, nis):
        overviews = self.__get_student_overview(nis)

        Attend = 0 if overviews[0] is None else overviews[0]
        Sick = 0 if overviews[1] is None else overviews[1]
        Permit = 0 if overviews[2] is None else overviews[2]
        absent = calendar.monthrange(datetime.now().year, datetime.now().month)[1] - (
            Attend + Sick + Permit
        )

        print(
            "\nOVERVIEW THIS MONTH\n",
            "{}x Attend | {}x Sick | {}x Permit | {}x Absent".format(
                Attend, Sick, Permit, absent
            ),
        )
        return

    def get_attendance(self, date):
        q = """SELECT 
        COALESCE(sa.sa_id, null) as id,
        s.nis as nis, 
        s.full_name as name, 
        COALESCE(sa.status, null) AS status, 
        sa.timestamp as timestamp
        FROM students s
        LEFT JOIN student_attendance sa 
        ON s.nis = sa.nis 
        AND DATE(sa.timestamp) = DATE(%s)
        WHERE s.class_id = %s
        """
        self.cur.execute(q, (date, self.__classes["class_id"]))
        results = self.cur.fetchall()
        helpers.console_log(results)
        return results

    def __get_attendance_overview(self, date):
        q = """
        SELECT 
        SUM(CASE WHEN status = 0 THEN 1 ELSE 0 END) AS attend_count,
        SUM(CASE WHEN status = 1 THEN 1 ELSE 0 END) AS sick_count,
        SUM(CASE WHEN status = 2 THEN 1 ELSE 0 END) AS permit_count
        FROM student_attendance sa
        JOIN students s ON sa.nis = s.nis
        WHERE s.class_id = %s
        AND DATE(timestamp) = %s
        """
        self.cur.execute(q, (self.__classes["class_id"], date))
        results = self.cur.fetchone()
        helpers.console_log(results)
        return results

    def print_attendance_overview(self, date, student_count):
        overviews = self.__get_attendance_overview(date)

        Attend = 0 if overviews[0] is None else overviews[0]
        Sick = 0 if overviews[1] is None else overviews[1]
        Permit = 0 if overviews[2] is None else overviews[2]
        absent = student_count - (Attend + Sick + Permit)

        print(
            "\nTODAY OVERVIEW\n",
            "{}x Attend | {}x Sick | {}x Permit | {}x Absent".format(
                Attend, Sick, Permit, absent
            ),
        )
        return

    def update_attendace(self, status, sa_id, date):
        q = """
        UPDATE student_attendance
        SET status = %s, timestamp = %s
        WHERE sa_id = %s"""
        self.cur.execute(q, (status, date, sa_id))
        self.conn.commit()
        return

    def store_attendance(self, status, nis, date):
        q = """INSERT INTO student_attendance (nis, status, timestamp)
        VALUES (%s, %s, %s)"""
        self.cur.execute(q, (nis, status, date))
        self.conn.commit()
        return

    def delete_attendance(self, sa_id):
        q = """DELETE FROM student_attendance WHERE sa_id = %s"""
        self.cur.execute(q, (sa_id,))
        self.conn.commit()
        return


class main:
    # def __init__(self):
    #     self.cu = Lecturer("0885060416", "12346")
    #     self.cu.classes = {"class_id": "2CS1", "class_name": "2 CS 1"}

    def login_section(self):
        print("-- LOGIN --\n")
        id = input("Insert identity number: ")
        pw = input("Insert password: ")

        helpers.clear_terminal()

        # Calling the lecturer class,
        # the constructor in this class will run the login process,
        # and auto-populate the attributes in this class with the existing data.
        self.cu = Lecturer(id, pw)
        match self.cu.login_status:
            case True:
                print("Login successfully!\n")
                return self.class_section()
            case False:
                print("Password incorect!")
            case None:
                print("User not found!")

        return self.login_section()

    def class_section(self):
        print("-- AVAILABLE CLASS --\n")

        available_classes = self.cu.print_class_list()
        class_count = len(available_classes)
        option = "\n[{}] choose one\n> ".format(
            "1" if class_count <= 1 else f"1 - {class_count}"
        )

        choice = int(input(option))
        helpers.clear_terminal()
        if choice > class_count:
            print("Invalid!\n")
            return self.class_section()

        # Change the contents of the attribute
        # by calling the set property class with the selected class
        self.cu.classes = available_classes[(choice - 1)]
        helpers.console_log(self.cu.classes)
        return self.main_menu_section()

    def main_menu_section(self):
        # The code below will check whether the user
        # has been absent or not from the database.
        # if the user has not been absent,
        # the system will automatically save today's attendance time.
        today_attendance = self.cu.get_today_attendance()
        if today_attendance is None:
            today_attendance = self.cu.store_today_attendance()
            message = "Your attendance has been recorded!"
        else:
            message = "You have already recorded your attendance for today."

        print(
            "-- MAIN MENU --",
            "Welcome, {}!\n".format(self.cu.full_name),
            "TODAY ATTENDANCE IN CLASS {}: {}".format(
                self.cu.classes["class_name"], today_attendance
            ),
            message + "\n",
            "1. Student Attendance",
            "2. Student List",
            "3. Profile",
            sep="\n",
        )

        choice = int(input("\n[ctrl + c] to exit\n[1 - 3] choose one\n> "))
        helpers.clear_terminal()
        match choice:
            case 1:
                return self.student_attandence_section()
            case 2:
                return self.student_list_section()
            case 3:
                return self.profile_section()
            case _:
                print("Invalid choice!\n")
                return self.main_menu_section()

    def profile_section(self):
        print("-- LECTURER PROFILE --\n")

        print(
            "NIDN\t\t: {}".format(self.cu.nid),
            "Full Name\t: {}".format(self.cu.full_name),
            "Gender\t\t: {}".format("Male" if self.cu.gender else "female"),
            "Phone Number\t: {}".format(self.cu.phone),
            "Email\t\t: {}".format(self.cu.email),
            "Adress\t\t: {}".format(self.cu.adress),
            "",
            "CLASS LIST",
            sep="\n",
        )
        self.cu.print_class_list()

        choice = input(
            "\n[ctrl + c] to exit\n[0] back to main menu\n[r] to reset password\n> "
        )
        helpers.clear_terminal()
        match choice.lower():
            case "0":
                return self.main_menu_section()
            case "r":
                return self.reset_password_section()
            case _:
                print("Invalid!\n")
                return self.profile_section()

    def reset_password_section(self):
        print("-- RESET PASSWORD --\n")
        old = input("Insert Old Password: ")
        new = input("Insert New Password: ")
        conf = input("Password confirmation: ")

        helpers.clear_terminal()
        if new != conf:  # case when password and confirmation doesn't macth
            print("\nPassword not match!")
        else:
            result = self.cu.set_password(old, new)
            if result:
                print("\nPassword changed successfully!")
                return self.profile_section()
            else:
                print("\nFailed to change password")
        return self.reset_password_section()

    def student_list_section(self):
        print(f"-- LIST STUDENT IN {self.cu.classes['class_name']} --\n")

        available_students = self.cu.get_students()
        for i, item in enumerate(available_students):
            print(f"{(i + 1):2}.", item["full_name"])

        option_count = len(available_students)
        option = "\n[ctrl + c] to exit\n[0] back to main menu\n[{}] choose one to see the detail\n> ".format(
            "1" if option_count <= 1 else f"1 - {option_count}"
        )

        choice = int(input(option))
        helpers.clear_terminal()
        if choice == 0:
            return self.main_menu_section()
        elif choice > option_count:
            print("Invalid!\n")
            return self.student_list_section()

        selected_student = available_students[(choice - 1)]["nis"]
        return self.student_detail_section(selected_student)

    def student_detail_section(self, nis):
        print("-- STUDENT DETAIL --\n")

        detail = self.cu.get_student_detail(nis)
        print(
            "NIS\t\t: {}".format(detail[0]),
            "Full Name\t: {}".format(detail[2]),
            "Gender\t\t: {}".format("Male" if detail[3] else "female"),
            "Phone Number\t: {}".format(detail[4]),
            "Email\t\t: {}".format(detail[5]),
            "Adress\t\t: {}".format(detail[6]),
            sep="\n",
        )

        self.cu.print_student_overview(nis)

        choice = int(
            input(
                "\n[ctrl + c] to exit\n[0] back to main menu\n[1] back to student list\n> "
            )
        )
        helpers.clear_terminal()
        match choice:
            case 0:
                return self.main_menu_section()
            case 1:
                return self.student_list_section()
            case _:
                print("Invalid choice!\n")
                return self.student_detail_section(nis)

    def student_attandence_section(self):
        print(
            "-- STUDENT ATTENDANCE (PAGE 1) --\n",
            "[dd/mm/yyyy] to custom date insert using this format",
            "[enter] for today attendance",
            sep="\n",
        )

        selected_date = None
        try:
            inputed_date = input("> ")
            # Handle if the user does not input anything,
            # it will automatically retrieve today.
            selected_date = (
                datetime.strptime(inputed_date, "%d/%m/%Y")
                if inputed_date
                else datetime.now()
            )
        except ValueError:
            pass

        helpers.clear_terminal()

        # Handle if an incorrect format is entered
        if selected_date is None:
            print("Only this [dd/mm/yyyy] format are allowed\n")
            pass

        # Handle if the entered date is in the future
        elif selected_date > datetime.now():
            print("The date must be past or today\n")
            pass

        else:
            return self.student_attandence_section2(selected_date)

        return self.student_attandence_section()

    def student_attandence_section2(self, date):
        print(
            "-- STUDENT ATTENDANCE (PAGE 2) --\n",
            "Attendance date: {}".format(date.strftime("%d %B %Y")),
        )

        students = self.cu.get_attendance(date)
        student_count = len(students)
        self.cu.print_attendance_overview(date.date(), student_count)

        print("\nList of students in class: {}".format(self.cu.classes["class_name"]))
        for i, item in enumerate(students):
            match item[3]:
                case 0:
                    if item[4].time() > time(8):
                        status = "Late"
                    else:
                        status = "Present"
                case 1:
                    status = "Sick"
                case 2:
                    status = "Permit"
                case _:
                    status = "Absent"
            print(
                "{:2}. {} [ {} ] {}".format(
                    (i + 1),
                    item[2].ljust(30, "."),
                    status.ljust(7),
                    item[4].time() if status == "Late" else "",
                )
            )

        option = "\n[ctrl + c] to exit\n[0] back to main menu\n[{}] choose one or use space as separator\n> ".format(
            "1" if student_count <= 1 else f"1 - {student_count}"
        )

        inputed = input(option)
        helpers.clear_terminal()
        if inputed == "0":
            return self.main_menu_section()

        selected_students = []
        for choice in inputed.split(" "):
            try:
                choice = int(choice)
                if choice > student_count:
                    print(f"{choice} is invalid!")
                else:
                    selected = students[(choice - 1)]
                    selected_students.append((selected[0], selected[1]))
                    # print(selected)
            except ValueError:
                print(f"{choice} is not an integer, only integers are allowed!")
                pass

        uniqued = list(set(selected_students))
        # print(uniqued)
        return self.student_attandence_section3(date, uniqued)

    def student_attandence_section3(self, date, selected):
        print(
            "-- STUDENT ATTENDANCE (PAGE 3) --\n",
            "1. Present",
            "2. Sick",
            "3. Permit",
            "4. Absent\n",
            "[1 - 5] choose one",
            sep="\n",
        )
        choice = int(input("> "))
        helpers.clear_terminal()
        if choice > 4 or 1 > choice:
            print("Invalid choice!\n")
            return self.student_attandence_section3(date, selected)

        for item in selected:
            if choice == 4:
                # Delete data that has an id
                if item[0] is not None:
                    helpers.console_log("delete", item)
                    self.cu.delete_attendance(item[0])

                # Skip data that does not have an id
                else:
                    helpers.console_log("pass", item)
                    pass

            else:
                # Handles if the date entered is today, 
                # it will take time when entering attendance.
                date = datetime.now() if date.date() == datetime.now().date() else date
                match choice:
                    case 1:
                        status = 0
                    case 2:
                        status = 1
                    case 3:
                        status = 2

                # If there is an id, the existing data will be updated, 
                # otherwise it will save the data to the database.
                if item[0] is None:
                    helpers.console_log("insert", status, item)
                    self.cu.store_attendance(status, item[1], date)

                else:
                    helpers.console_log("update", status, item)
                    self.cu.update_attendace(status, item[0], date)

        return self.student_attandence_section2(date)


if __name__ == "__main__":
    helpers.clear_terminal()
    try:
        program = main()
        program.login_section()

    # handling inputs
    except ValueError:
        print("Only integers are allowed")
    # Dealing with forced stop programs
    except KeyboardInterrupt:
        print("Goodbye!")
    except Exception as e:
        print("Something Error!")
        print(e)
