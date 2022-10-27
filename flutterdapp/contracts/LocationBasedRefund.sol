// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.13;

contract RefundContract {
    address[] public employees;
    address public employeer;

    struct ContractStatus {
        int8 latitude;
        int8 longitude;
        int8 maxRadius;
        uint8 payment;
        uint8 compCount;
        uint8 reqAmount;
    }
    mapping (address => ContractStatus) public empContractStatus;
    constructor() {
        employeer = msg.sender;
    }
    
    modifier onlyEmployeer() {
        require(msg.sender == employeer, "Only employeer has access to this function");
        _;
    }

    modifier onlyEmployee(address _addr) {
        require(msg.sender == _addr, "Only an employee has access to this function");
        bool exists = false;

        for (uint256 i = 0; i < employees.length; i++) {
            if (employees[i] == _addr) {
                exists = true;
                break;
            }
        }

        require(exists, "Only an  employee has access to this function");
        _;
    }
    
    // Modifiers can take inputs. This modifier checks that the
    // address passed in is not the zero address.
    modifier validAddress(address _addr) {
        require(_addr != address(0), "Not valid address");
        _;
    }

    function sqrt(int256 input) private pure returns (int256  output ) {
        int256 temp = (input + 1) / 2;
        output = input;
        while (temp < output) {
            output = temp;
            temp = ((input / output) * 2) / 2;
        }
    }

    function calculateDistance(int8 _latitude, int8 _longitude) private view  returns (int256 dist) {
        int256 x = _latitude - empContractStatus[msg.sender].latitude;
        int256 y = _longitude - empContractStatus[msg.sender].longitude;
        dist = sqrt(x**2 + y**2);
        return dist;
    }
    function updateCompCountStatus(
        int8 _latitude, 
        int8 _longitude
        ) public {
            int256 dist = calculateDistance(_latitude, _longitude);
            if (dist < empContractStatus[msg.sender].maxRadius) {
                empContractStatus[msg.sender].compCount = empContractStatus[msg.sender].compCount + 1;
            }
    }

    function payEmployee(address payable _to) public payable onlyEmployee(_to) {
        require(empContractStatus[_to].compCount > empContractStatus[_to].reqAmount);
        bool sent = _to.send(empContractStatus[_to].payment);
        require(sent, "Failed to send Ether");
    }

        ///////////////////////////////////////////////////////////////
    // only employer has access
    function setEmployeeAccount(
        address _empAddr,
        int8 _cenLat,
        int8 _cenLon,
        int8 _radius,
        uint8 _payAmount,
        uint8 _reqAmount
        // Should also set the duration the contract will be checking for
        ) public onlyEmployeer() {
            employees.push(_empAddr); // should delete if it is already in the list
            empContractStatus[_empAddr].latitude = _cenLat;
            empContractStatus[_empAddr].longitude = _cenLon;
            empContractStatus[_empAddr].maxRadius = _radius;
            empContractStatus[_empAddr].payment = _payAmount;
            empContractStatus[_empAddr].compCount = 0;
            empContractStatus[_empAddr].reqAmount = _reqAmount;
    }

    function getAdmin() public view returns(address) {
        return employeer;
    }
}