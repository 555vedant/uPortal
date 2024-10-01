# Import/Export Documentation for uPortal 5

## Overview
The Import/Export tool in uPortal 5 allows users to transfer configuration data and settings between instances, facilitating data migration and backup.

## Supported Operations
- **IMPORT**: Adds or updates entities from XML files in the portal database.
- **LIST**: Lists supported data types and existing entities.
- **EXPORT**: Creates XML files of specified entities and saves them to a location.
- **DELETE**: Removes specified entities and their dependencies from the portal database.

## Importing Data

### Import Multiple Files
```bash
ant data-import -Ddir={path-to-directory} [-Dpattern={ant-pattern}]
```

### Import Single File
```bash
ant data-import -Dfile={path-to-file}
```

### Import Single File (uPortal 4.3+)
```bash
ant data-import -Dfiles={comma-separated-list-of-files}
```

### Import List File (uPortal 4.3+)
```bash
ant data-import -DfilesListFile={path-to-file}
```

## Listing Data

### List Types
```bash
ant data-list
```

### List Data of a Specific Type
```bash
ant data-list -Dtype={entity-type}
```


## Exporting Data
```bash
ant data-export -Ddir={path-to-directory} -Dtype={entity-type} [-Dsysid={entity-identifier}]
```


## Deleting Data
```bash
ant data-delete -Dtype={entity-type} [-Dsysid={entity-identifier}]
```


## Import/Export Logs
Logs for Import/Export operations can be found in the `UPORTAL_ROOT/target/data-import-reports` directory. Look for `data-import.txt` for summary reports. If errors occur, individual error report files will also be generated for each failed object.

## Troubleshooting
Refer to the logs for detailed error messages if operations fail.

## Additional Resources
- [uPortal 4.1 Importing and Exporting Data](https://apereo.atlassian.net/wiki/spaces/UPM41/pages/103942373/Importing+and+Exporting+data)


