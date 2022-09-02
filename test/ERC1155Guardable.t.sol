// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/tokens/ERC1155Guardable.sol";

contract ERC1155GuardableTest is Test {
    ERC1155Guardable public guardable;
    function setUp() public {
        guardable = new ERC1155Guardable("test");
    }

    function testTokenLocks(address guardAddress, address ownerAddress, address failAddress) public {
        // Sender will never be zero address
        vm.assume(
            ownerAddress != failAddress &&
            ownerAddress != guardAddress &&
            guardAddress != failAddress &&
            guardAddress != address(0)
        );

        // Guardian should be 0 address to start
        assertTrue(guardable.guardianOf(ownerAddress) == address(0));
        startHoax(ownerAddress);

        // Try to set self as guardian
        vm.expectRevert(abi.encodeWithSelector(IGuardable.InvalidGuardian.selector));
        guardable.setGuardian(ownerAddress);

        // Set an address as guardian
        guardable.setGuardian(guardAddress);
        assertTrue(guardable.guardianOf(ownerAddress) == guardAddress);

        // try unlocking from address that's not guardian
        changePrank(failAddress);
        vm.expectRevert(abi.encodeWithSignature("CallerGuardianMismatch(address,address)", failAddress, guardAddress));
        guardable.removeGuardianOf(ownerAddress);

        // Use guardian address to unlock approvals
        changePrank(guardAddress);
        guardable.removeGuardianOf(ownerAddress);

        // Guardian should now be 0 address again
        assertTrue(guardable.guardianOf(ownerAddress) == address(0));
    }

    function testSupportsInterface() public {
        bytes4 selector = Guardable.setGuardian.selector
            ^ Guardable.removeGuardianOf.selector
            ^ Guardable.guardianOf.selector;

        assertTrue(selector == 0x126f5523);
        assertTrue(guardable.supportsInterface(bytes4(0x126f5523)));
    }
}
