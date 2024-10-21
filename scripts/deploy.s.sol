// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// import {Script} from "../lib/forge-std/src/Script.sol";
// Ensure you have this import

import "forge-std/Script.sol";

import "../contracts/interfaces/IDiamondCut.sol";
import "../contracts/facets/DiamondCutFacet.sol";
import "../contracts/facets/DiamondLoupeFacet.sol";
import "../contracts/facets/OwnershipFacet.sol";
// import "../contracts/facets/Pool.sol";
// import "../contracts/facets/Staking.sol";

import "../contracts/facets/CourseFacet.sol";
import "../contracts/facets/EnrollStudentFacet.sol";
import "../contracts/facets/StudentFacet.sol";
import "../contracts/facets/TeacherFacet.sol";
import "../contracts/facets/CourseFacet.sol";

import "../contracts/Diamond.sol";

contract MyScript is Script {
    function run() external {
        // my address
        address owner = 0xc21cF5288Ff0A3b8D241C6859cA9d8FE7f0562b4;
        // switchSigner(owner);
        // uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(
            0x2164a2cf48d22734a3391c2246583f16e770e1807dd9ea97b5c573783ad2f54b
        );
        // vm.startBroadcast(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80);

        DiamondCutFacet dCutFacet = new DiamondCutFacet();
        Diamond diamond = new Diamond(owner, address(dCutFacet));
        DiamondLoupeFacet dLoupe = new DiamondLoupeFacet();
        OwnershipFacet ownerF = new OwnershipFacet();
        // Pool pool = new Pool();
        CourseFacet cfacet = new CourseFacet();
        EnrollStudentFacet enrollmentFacet = new EnrollStudentFacet();
        StudentFacet studentFacet = new StudentFacet();
        TeacherFacet teacherFacet = new TeacherFacet();

        //upgrade diamond with facets

        //build cut struct
        IDiamondCut.FacetCut[] memory cut = new IDiamondCut.FacetCut[](6);

        cut[0] = (
            IDiamondCut.FacetCut({
                facetAddress: address(dLoupe),
                action: IDiamondCut.FacetCutAction.Add,
                functionSelectors: generateSelectors("DiamondLoupeFacet")
            })
        );

        cut[1] = (
            IDiamondCut.FacetCut({
                facetAddress: address(ownerF),
                action: IDiamondCut.FacetCutAction.Add,
                functionSelectors: generateSelectors("OwnershipFacet")
            })
        );

        cut[2] = (
            IDiamondCut.FacetCut({
                facetAddress: address(cfacet),
                action: IDiamondCut.FacetCutAction.Add,
                functionSelectors: generateSelectors("CourseFacet")
            })
        );

        cut[3] = (
            IDiamondCut.FacetCut({
                facetAddress: address(enrollmentFacet),
                action: IDiamondCut.FacetCutAction.Add,
                functionSelectors: generateSelectors("EnrollStudentFacet")
            })
        );

        cut[4] = (
            IDiamondCut.FacetCut({
                facetAddress: address(studentFacet),
                action: IDiamondCut.FacetCutAction.Add,
                functionSelectors: generateSelectors("StudentFacet")
            })
        );

        cut[5] = (
            IDiamondCut.FacetCut({
                facetAddress: address(teacherFacet),
                action: IDiamondCut.FacetCutAction.Add,
                functionSelectors: generateSelectors("TeacherFacet")
            })
        );

        // i_diamond = IDiamond(address(diamond));

        //upgrade diamond
        IDiamondCut(address(diamond)).diamondCut(cut, address(0x0), "");

        //call a function
        DiamondLoupeFacet(address(diamond)).facetAddresses();

        vm.stopBroadcast();
    }

    function generateSelectors(
        string memory _facetName
    ) internal returns (bytes4[] memory selectors) {
        string[] memory cmd = new string[](3);
        cmd[0] = "node";
        cmd[1] = "scripts/genSelectors.js";
        cmd[2] = _facetName;
        bytes memory res = vm.ffi(cmd);
        selectors = abi.decode(res, (bytes4[]));
    }

    function switchSigner(address _newSigner) public {
        address foundrySigner = 0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38;
        if (msg.sender == foundrySigner) {
            vm.startPrank(_newSigner);
        } else {
            vm.stopPrank();
            vm.startPrank(_newSigner);
        }
    }
}
