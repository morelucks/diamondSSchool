// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../libraries/SchoolAppStorage.sol";

contract EnrollStudentFacet {
    function enrollInCourse(uint studentId, uint courseId) external {
        SchoolAppStorage.Layout storage s = SchoolAppStorage.storaged();
        require(s.students[studentId].exists, "Student does not exist.");
        require(s.courses[courseId].exists, "Course does not exist.");
        s.students[studentId].enrolledCourses.push(courseId);
        s.courses[courseId].studentIds.push(studentId);
        emit SchoolAppStorage.StudentEnrolledInCourse(studentId, courseId);
    }
}
