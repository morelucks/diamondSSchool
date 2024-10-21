// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "../libraries/SchoolAppStorage.sol";

contract StudentFacet {
    function enrollStudent(string memory name, uint age) external {
        SchoolAppStorage.Layout storage s = SchoolAppStorage.storaged();
        SchoolAppStorage._incrementStudentCount(s);
        uint newStudentId = s.studentCount;
        // s.students, 0, true);
        emit SchoolAppStorage.StudentEnrolled(newStudentId, name, age);
    }

    function getStudent(uint studentId) external view returns (string memory, uint, uint[] memory, uint) {
        SchoolAppStorage.Layout storage s = SchoolAppStorage.storaged();
        require(s.students[studentId].exists, "Student does not exist.");
        SchoolAppStorage.Student storage student = s.students[studentId];
        return (student.name, student.age, student.enrolledCourses, student.sectionId);
    }

    function getStudentCourses(uint studentId) external view returns (string[] memory, uint[] memory, uint[] memory) {
        SchoolAppStorage.Layout storage s = SchoolAppStorage.storaged();
        require(s.students[studentId].exists, "Student does not exist.");
        SchoolAppStorage.Student storage student = s.students[studentId];

        uint courseCount = student.enrolledCourses.length;
        string[] memory courseTitles = new string[](courseCount);
        uint[] memory courseCredits = new uint[](courseCount);
        uint[] memory teacherIds = new uint[](courseCount);

        for (uint i = 0; i < courseCount; i++) {
            SchoolAppStorage.Course storage course = s.courses[student.enrolledCourses[i]];
            courseTitles[i] = course.title;
            courseCredits[i] = course.credits;
            teacherIds[i] = course.teacherId;
        }

        return (courseTitles, courseCredits, teacherIds);
    }
}
