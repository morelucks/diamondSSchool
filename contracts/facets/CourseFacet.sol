// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "../libraries/SchoolAppStorage.sol";

contract CourseFacet {
    function createCourse(string memory title, uint credits, uint teacherId) external {
        SchoolAppStorage.Layout storage s = SchoolAppStorage.storaged();
        require(s.teachers[teacherId].exists, "Teacher does not exist.");
        SchoolAppStorage._incrementCourseCount(s);
        uint courseId = s.courseCount;
        // s.courses, true);
        s.teachers[teacherId].assignedCourses.push(courseId);  // Assign course to teacher
        emit SchoolAppStorage.CourseCreated(courseId, title, credits, teacherId);
    }

    function getCourse(uint courseId) external view returns (string memory, uint, uint, uint[] memory) {
        SchoolAppStorage.Layout storage s = SchoolAppStorage.storaged();
        require(s.courses[courseId].exists, "Course does not exist.");
        SchoolAppStorage.Course storage course = s.courses[courseId];
        return (course.title, course.credits, course.teacherId, course.studentIds);
    }

    function enrollStudentInCourse(uint studentId, uint courseId) external {
        SchoolAppStorage.Layout storage s = SchoolAppStorage.storaged();
        require(s.students[studentId].exists, "Student does not exist.");
        require(s.courses[courseId].exists, "Course does not exist.");
        s.courses[courseId].studentIds.push(studentId);
        s.students[studentId].enrolledCourses.push(courseId);
        emit SchoolAppStorage.StudentEnrolledInCourse(studentId, courseId);
    }
}
