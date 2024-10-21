// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

library SchoolAppStorage {
    // Events
    event StudentEnrolled(uint studentId, string name, uint age);
    event CourseCreated(uint courseId, string title, uint credits, uint teacherId);
    event StudentEnrolledInCourse(uint studentId, uint courseId);
    event TeacherAssigned(uint teacherId, string name, uint[] assignedCourses);
    event ClassSectionCreated(uint sectionId, string name, uint teacherId);
    event StudentAssignedToClass(uint studentId, uint sectionId);

    struct Student {
        string name;
        uint age;
        uint[] enrolledCourses;
        uint sectionId; 
        bool exists;
    }

    struct Course {
        string title;
        uint credits;
        uint teacherId;  
        uint[] studentIds; 
        bool exists;
    }

    struct Teacher {
        string name;
        uint[] assignedCourses; 
        bool exists;
    }

    struct ClassSection {
        string name;
        uint teacherId; 
        uint[] studentIds; 
        bool exists;
    }

    struct Layout {
        mapping(uint => Student) students;
        mapping(uint => Course) courses;
        mapping(uint => Teacher) teachers;
        mapping(uint => ClassSection) sections;
        uint studentCount;
        uint courseCount;
        uint teacherCount;
        uint sectionCount;
    }

    function storaged() internal pure returns (Layout storage l) {
        assembly {
            l.slot := 0
        }
    }

    function _incrementStudentCount(Layout storage l) internal {
        l.studentCount++;
    }

    function _incrementCourseCount(Layout storage l) internal {
        l.courseCount++;
    }

    function _incrementTeacherCount(Layout storage l) internal {
        l.teacherCount++;
    }

    function _incrementSectionCount(Layout storage l) internal {
        l.sectionCount++;
    }
}
