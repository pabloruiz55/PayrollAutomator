# PayrollAutomator
Ethereum Payroll Manager w/Ethereum Alarm Clock

# WIP

### Deposit salaries for employees once a month and automate the transfer of funds.

1. Deploy PayrollAutomator passing EAC's scheduler address
2. Add addresses to payroll by calling `addToPayroll`.
3. Deposit wages by calling `deposit(address _employee)`.
4. Automate the payment of salaries by calling `schedulePayment(uint _blocksTilPayday)`. EAC will execute the transaction starting on block set (now + _blocksTilPayday) transferring salaries deposited.
