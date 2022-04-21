import sqlite3, sys

db = sys.argv[1]

try:
    sqliteConnection = sqlite3.connect(db)
    cursor = sqliteConnection.cursor()
    print("Connected to SQLite")

    sql_update_query = '''UPDATE ServerPorts 
                        SET port_number=443
                        WHERE servers_id in (SELECT servers_id 
                                            FROM ServerProjects 
                                            WHERE projects_id in (SELECT id
                                                                 FROM Projects
                                                                 WHERE proj_name='Project3'))
                        AND servers_id in (SELECT id 
                                            FROM Servers 
                                            WHERE servertypes_id in (SELECT id
                                                                    FROM ServerTypes
                                                                    WHERE type_name='apache'));        
                        '''

    result = cursor.execute(sql_update_query).fetchall()

    sqliteConnection.commit()
    cursor.close()

except sqlite3.Error as error:
    print("Error while working with SQLite", error)
finally:
    if sqliteConnection:
        print("Total Rows affected since the database connection was opened: ", sqliteConnection.total_changes)
        sqliteConnection.close()
        print("sqlite connection is closed")

# Executing:
# /usr/bin/python3 /home/eugenia/DevOpsChernivtsi/PythonForDevOps/Module5/hw5.py /home/eugenia/DevOpsChernivtsi/PythonForDevOps/Module5/demo.db
