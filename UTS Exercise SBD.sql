CREATE TABLE Hotel (
    hotelNo VARCHAR(10) PRIMARY KEY,
    hotelName VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL
);

CREATE TABLE Room (
    roomNo INT NOT NULL,
    hotelNo VARCHAR(10) NOT NULL,
    type VARCHAR(10) NOT NULL,
    price NUMERIC(8, 2) NOT NULL,
    PRIMARY KEY (roomNo, hotelNo),
    FOREIGN KEY (hotelNo) REFERENCES Hotel(hotelNo) ON DELETE CASCADE,
    CONSTRAINT check_room_type CHECK (type IN ('Single', 'Double', 'Family')),
    CONSTRAINT check_room_price CHECK (price BETWEEN 10.00 AND 100.00),
    CONSTRAINT check_room_no CHECK (roomNo BETWEEN 1 AND 100)
);

CREATE TABLE Guest (
    guestNo VARCHAR(10) PRIMARY KEY,
    guestName VARCHAR(100) NOT NULL,
    guestAddress VARCHAR(200) NOT NULL
);

CREATE TABLE Booking (
    hotelNo VARCHAR(10) NOT NULL,
    guestNo VARCHAR(10) NOT NULL,
    dateFrom DATE NOT NULL,
    dateTo DATE NOT NULL,
    roomNo INT NOT NULL,
    PRIMARY KEY (hotelNo, guestNo, dateFrom),
    FOREIGN KEY (hotelNo) REFERENCES Hotel(hotelNo) ON DELETE CASCADE,
    FOREIGN KEY (guestNo) REFERENCES Guest(guestNo) ON DELETE CASCADE,
    FOREIGN KEY (roomNo, hotelNo) REFERENCES Room(roomNo, hotelNo) ON DELETE CASCADE,
    CONSTRAINT check_booking_dates CHECK (dateFrom < dateTo),
    CONSTRAINT check_future_dates CHECK (dateFrom > CURRENT_DATE AND dateTo > CURRENT_DATE),
    CONSTRAINT no_room_double_booking EXCLUDE USING gist (
        hotelNo WITH =,
        roomNo WITH =,
        daterange(dateFrom, dateTo, '[)') WITH &&
    ),
    CONSTRAINT no_guest_overlapping_booking EXCLUDE USING gist (
        guestNo WITH =,
        daterange(dateFrom, dateTo, '[)') WITH &&
    )
);