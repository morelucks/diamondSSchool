// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "../libraries/SchoolAppStorage.sol";

contract TeacherFacet {
    SchoolAppStorage.Layout  s ;

    function addTeacher(string memory name, uint[] memory assignedCourses) external {
        SchoolAppStorage._incrementTeacherCount(s);
        uint teacherId = s.teacherCount;
        s.teachers[teacherId] = SchoolAppStorage.Teacher(name, assignedCourses, true);
        for (uint i = 0; i < assignedCourses.length; i++) {
            require(s.courses[assignedCourses[i]].exists, "Course does not exist.");
            s.courses[assignedCourses[i]].teacherId = teacherId;
        }
        emit SchoolAppStorage.TeacherAssigned(teacherId, name, assignedCourses);
    }

    function getTeacher(uint teacherId) external view returns (string memory, uint[] memory) {
        // SchoolAppStorage.Layout storage s = SchoolAppStorage.storaged();
        require(s.teachers[teacherId].exists, "Teacher does not exist.");
        SchoolAppStorage.Teacher storage teacher = s.teachers[teacherId];
        return (teacher.name, teacher.assignedCourses);
    }

    function getCoursesByTeacher(uint teacherId) external view returns (uint[] memory) {
        // SchoolAppStorage.Layout storage s = SchoolAppStorage.storaged();
        require(s.teachers[teacherId].exists, "Teacher does not exist.");
        return s.teachers[teacherId].assignedCourses;
    }
}
