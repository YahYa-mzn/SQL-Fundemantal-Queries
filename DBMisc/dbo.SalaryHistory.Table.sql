USE [DBMisc];
GO

IF OBJECT_ID('dbo.SalaryHistory', 'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[SalaryHistory](
        [HistoryID] INT IDENTITY(1,1) PRIMARY KEY,
        [EmployeeID] INT NOT NULL FOREIGN KEY REFERENCES dbo.Employees(EmployeeID),
        [OldSalary] SMALLMONEY NOT NULL,
        [NewSalary] SMALLMONEY NOT NULL,
        [ChangeDate] DATETIME NOT NULL DEFAULT GETDATE()
    );

    INSERT INTO dbo.SalaryHistory (EmployeeID, OldSalary, NewSalary, ChangeDate) VALUES
    (1, 3000.00, 3200.00, '2024-01-15'),
    (1, 3200.00, 3500.00, '2025-01-15'),
    (4, 4000.00, 4300.00, '2024-06-01'),
    (4, 4300.00, 4600.00, '2025-06-01'),
    (5, 4800.00, 5100.00, '2025-03-10');
END
GO