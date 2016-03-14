// Datastorage library

library Storage {
	struct Database{
		bool exist;
		bytes32 description;
		mapping(uint => Table) tables;
	}
	
	struct Table{
		bool exist;
		mapping(uint => Column) columns;
	}
	
	struct Column{
		bool exist;
		mapping(uint => Record) records;
	}
	
	struct Record{
		bool exist;
		mapping(uint => Column) data;
	}
}