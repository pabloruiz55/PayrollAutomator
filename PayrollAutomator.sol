pragma solidity ^0.4.23;

import "./SchedulerInterface.sol";

/// Example of using the Scheduler from a smart contract to delay a payment.
contract PayrollAutomator {
    
    struct Employee {
        uint monthlySalary;
        uint balance;
        uint dateAdded;
    }

    SchedulerInterface public scheduler;
    
    uint payBlock;
    address public scheduledTransaction;
    
    address[] public employeeIds;
    mapping (address => Employee) public employees;

    constructor (
        address _scheduler
    )  public payable {
        scheduler = SchedulerInterface(_scheduler);
    }

    function schedulePayment(uint _blocksTilPayday) public payable {
        require(msg.value >= 0.1 ether, "Please send eth to pay for EAC costs");
        payBlock = block.number + _blocksTilPayday;
        scheduledTransaction = scheduler.schedule.value(msg.value)( // ether is to pay for gas, bounty and fee
            this,                   // send to self
            "",                     // and trigger function
            [
                200000,             // The amount of gas to be sent with the transaction.
                0,                  // The amount of wei to be sent.
                1000,                // The size of the execution window.
                payBlock,        // The start of the execution window.
                20000000000 wei,    // The gasprice for the transaction (aka 20 gwei)
                20000000000 wei,    // The fee included in the transaction.
                20000000000 wei,         // The bounty that awards the executor of the transaction.
                30000000000 wei     // The required amount of wei the claimer must send as deposit.
            ]
        );
    }
    
    function addToPayroll(address _employee, uint _monthlySalary) public {
        require(employees[_employee].dateAdded == 0, "Employee already exists in payroll");
        Employee memory employee = Employee(_monthlySalary,0, now);
        employees[_employee] = employee;
        employeeIds.push(_employee);
    }
    
    //TBD
    function removeFromPayroll() public {
        
    }
    
    function deposit(address _employee) public payable {
        Employee storage employee = employees[_employee];
        require(employee.dateAdded != 0, "Employee does not exist in payroll");
        require(msg.value <= employee.monthlySalary, "Can't deposit more than the employee's salary");

        employee.balance = msg.value;
    }
    
        // TBD
    function cancelDeposit() public{
        
    }
    
    function() public {
        for(uint i = 0; i< employeeIds.length ; i++)
        {
            Employee storage employee = employees[employeeIds[i]];
            uint _payment = employee.balance;
            employee.balance = 0;
            employeeIds[i].transfer(_payment); 
        }
        
    }
    
    // TBD
    function makePaymentManual() public{
        
    }

}
