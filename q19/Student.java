package WT_Lab_Atmik.q19;

public class Student {
    private String studentName;
    private String rollNo;
    private String deptName;

    // Constructor
    public Student(String studentName, String rollNo, String deptName) {
        this.studentName = studentName;
        this.rollNo = rollNo;
        this.deptName = deptName;
    }

    // Getters
    public String getStudentName() {
        return studentName;
    }

    public String getRollNo() {
        return rollNo;
    }

    public String getDeptName() {
        return deptName;
    }

    // Optionally, you can also define toString() method to display information in a readable format
    @Override
    public String toString() {
        return "Student [Name=" + studentName + ", Roll No=" + rollNo + ", Department=" + deptName + "]";
    }
}
