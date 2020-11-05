CREATE TABLE tog(
  togNr INT PRIMARY KEY,
  startStasjon TEXT NOT NULL,
  endeStasjon TEXT NOT NULL,
  ankommstTid TIME NOT NULL--Evt DATETIME for dato + tid
);

CREATE TABLE togTabell(
  togNr Int,
  avgangsTid TIME,
  stasjon TEXT NOT NULL,

  PRIMARY KEY(togNr, avgangsTid),
  FOREIGN KEY (togNr) REFERENCES tog (togNr)
);

CREATE TABLE plass(
  dato DATE,
  togNr INT,
  vognNr INT,
  plassNr INT, --kan også være varchar for seter av typen A32, B32
  vindu BOOLEAN NOT NULL,
  ledig BOOLEAN NOT NULL,

  PRIMARY KEY(dato, togNr, vognNr, plassNr),
  FOREIGN KEY (togNr) REFERENCES tog (togNr)
);
