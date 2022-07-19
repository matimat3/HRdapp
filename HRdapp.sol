// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

//import "hardhat/console.sol"; // only to show console.log

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */
contract HRdapp {
    struct Employee {
        address ethAddress; // where employee is paid
        uint256 salary; // how much is employee paid
        uint256 employeeNumber; // +1 from last employee number who joined before
        uint256 startingDate; // date employee started / has been registered in the system
        uint256 daysOffLeft; // amount of holidays
        //uint235 votingPower; // linked to years in the company and position? ie: director and 1 year tenure vs support agent 5 years: 10 x 1 = 10 voting power vs 1 x 5 = 5 voting power
        string role; // position of the employee
        bool hrRights; // can act on HR related actions or not
    }

    struct Expense {
        string reasonExpense;
        uint256 price;
        uint256 expenseId;
        address employeeAddress;
    }

    Employee[] companyEmployees;
    Expense[] companyExpenses;

    mapping(address => Employee) fromAddressToEmployee;

    modifier onlyOwner() {
        // require(msg.sender == owner); // need to create variable
        _;
    }

    modifier onlyHR() {
        // require( == owner); // require that the employee has HR rights
        _;
    }

    function addEmployee(
        address _employeeEthAddress,
        uint256 _salary,
        string memory _role,
        bool _hrRights
    ) public onlyHR {
        uint256 employeeNumber = companyEmployees.length + 1;

        Employee memory newEmployee = Employee(
            _employeeEthAddress,
            _salary,
            employeeNumber,
            block.timestamp,
            0,
            _role,
            _hrRights
        );
        companyEmployees.push(newEmployee);
        //console.log("Employee added at ");
        //console.log(block.timestamp);
    }

    function removeEmployee(address _employeeEthAddress) public onlyHR {
        //find _employeeEthAddress in the companyEmployees array and remove it
    }

    function salaryRaise(Employee memory _employee, uint256 _newSalary)
        public
        pure
        onlyHR
    {
        _employee.salary = _newSalary;
    }

    function createVote(string memory _subject) public onlyHR {
        // add subject and create voting opportunity
    }

    function createExpense(string memory _reasonExpense, uint256 _price)
        public
        returns (uint256 _payToEmployee)
    {
        // log _expenseName and display it in the website
        uint256 expenseId = companyExpenses.length + 1;
        address requestorAddress = msg.sender;

        Expense memory newExpense = Expense(
            _reasonExpense,
            _price,
            expenseId,
            requestorAddress
        );
        companyExpenses.push(newExpense);
        //console.log("Expense added");

        return _payToEmployee;
    }

    function approveExpense(address _employeeEthAddress, uint256 _payToEmployee, uint256 _expensePrice)
        public
        payable
        onlyHR
    {
        _employeeEthAddress.transfer(_payToEmployee);
        // pay wallet that created the expense
    }

    function denyExpense(uint256 _expenseId) public onlyHR {
         delete companyExpenses[_expenseId];
        // close created expense
    }

    function askForDaysOff(
        address _employeeEthAddress,
        uint256 _daysOffRequested
    ) public view {
        // go with 30 days off / year
        Employee memory employee = fromAddressToEmployee[_employeeEthAddress];

        uint256 balanceDaysOffEmployee = (block.timestamp -
            employee.startingDate); // divisé par days off per year
        //console.log(balanceDaysOffEmployee); // result  1657816001 - super off, a regler

        require(
            balanceDaysOffEmployee >= _daysOffRequested,
            "You don't have enough days off!"
        );
    }
}
