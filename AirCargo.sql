CREATE DATABASE AirCargoAnalysis;
USE AirCargoAnalysis;

CREATE TABLE Flights (
    FlightID INT PRIMARY KEY,
    FlightNumber VARCHAR(10),
    SourceAirportCode VARCHAR(5),
    DestinationAirportCode VARCHAR(5),
    DepartureTime DATETIME,
    ArrivalTime DATETIME
);

CREATE TABLE Bookings (
    BookingID INT PRIMARY KEY,
    FlightID INT,
    PassengerName VARCHAR(100),
    BookingDate DATETIME,
    AmountPaid DECIMAL(10, 2),
    Status VARCHAR(10) CHECK (Status IN ('Confirmed', 'Cancelled')),
    FOREIGN KEY (FlightID) REFERENCES Flights(FlightID)
);

CREATE TABLE Airports (
    AirportCode VARCHAR(5) PRIMARY KEY,
    AirportName VARCHAR(100),
    City VARCHAR(50),
    Country VARCHAR(50)
);

CREATE TABLE CustomerFeedback (
    FeedbackID INT PRIMARY KEY,
    BookingID INT,
    ComplaintType VARCHAR(50),
    ComplaintDetails TEXT,
    FeedbackDate DATETIME,
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID)
);

-- Airports
INSERT INTO Airports VALUES ('BLR', 'Kempegowda International', 'Bengaluru', 'KA');
INSERT INTO Airports VALUES ('DEL', 'Indira Gandhi International', 'Delhi', 'Ind');
INSERT INTO Airports VALUES ('BOM', 'CSM International', 'Mumbai', 'MH');

-- Flights
INSERT INTO Flights VALUES (1, 'AA101', 'BLR', 'DEL', '2024-12-01 08:00:00', '2024-12-01 20:00:00');
INSERT INTO Flights VALUES (2, 'EK501', 'BOM', 'BLR', '2024-12-02 09:00:00', '2024-12-02 17:00:00');

-- Bookings
INSERT INTO Bookings VALUES (101, 1, 'Prashant', '2024-11-01 14:00:00', 1200.00, 'Confirmed');
INSERT INTO Bookings VALUES (102, 2, 'Hemant', '2024-11-03 15:00:00', 1500.00, 'Cancelled');

-- Customer Feedback
INSERT INTO CustomerFeedback VALUES (201, 101, 'Delay', 'Flight delayed by 3 hours', '2024-11-02 12:00:00');

SELECT 
    SourceAirportCode, 
    DestinationAirportCode, 
    COUNT(*) AS TotalBookings
FROM Bookings
JOIN Flights ON Bookings.FlightID = Flights.FlightID
WHERE Status = 'Confirmed'
GROUP BY SourceAirportCode, DestinationAirportCode
ORDER BY TotalBookings DESC;

SELECT 
    DATE(BookingDate) AS BookingDate, 
    SUM(AmountPaid) AS TotalSales
FROM Bookings
WHERE Status = 'Confirmed'
GROUP BY DATE(BookingDate)
ORDER BY BookingDate;

SELECT 
    ComplaintType, 
    COUNT(*) AS TotalComplaints
FROM CustomerFeedback
GROUP BY ComplaintType
ORDER BY TotalComplaints DESC;

SELECT 
    Status, 
    SUM(AmountPaid) AS TotalAmount
FROM Bookings
GROUP BY Status;
