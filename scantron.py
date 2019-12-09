from pathlib import Path

MAX_SCORE = 100


class Student:
    def __init__(self, line):
        l = line.split(" ")
        self.__id = l[0]
        self.__respond = l[1:]

    def calc_score(self, answer):
        unit = MAX_SCORE / len(answer)
        score = 0
        for i, v in enumerate(answer):
            if v == self.__respond[i]:
                score += unit

        self.__score = int(score)

    def get_score(self):
        return self.__score

    def print_score(self):
        print("{:14}{:3}".format(self.__id, self.__score))


class Students:
    def __init__(self):
        self.__students = []
        self.__frequency_array = [0] * (MAX_SCORE + 1)

    def add_student(self, student):
        score = student.get_score()
        self.__frequency_array[score] += 1
        self.__students.append(student)

    def print_students_score(self):
        print("Student ID    Score")
        print("===================")
        for student in self.__students:
            student.print_score()
        print("===================")
        print("Tests graded = {}".format(len(self.__students)))
        print("===================")

    def print_frequency_array(self):
        total = 0
        num = 0

        print("Score     Frequency")
        print("===================")
        for i, v in reversed(list(enumerate(self.__frequency_array))):
            if v != 0:
                total += i * v
                num += v
                print("{:3}{:12}".format(i, v))
        print("===================")
        print("Class Average = {}".format(int(total / num)))


if __name__ == "__main__":
    students = Students()

    while True:
        file_name = input("Enter file name: ")
        path = Path(file_name)
        try:
            with path.open(encoding="utf-8") as f:
                size = int(f.readline())
                answer = [x for x in f.readline().strip().split(" ")]

                for line in f:
                    student = Student(line.strip())
                    student.calc_score(answer)
                    students.add_student(student)

            students.print_students_score()
            students.print_frequency_array()
            break
        except FileNotFoundError:
            print("!! Wrong file name")
