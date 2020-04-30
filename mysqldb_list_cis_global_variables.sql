SELECT 'log_error_verbosity' as name_variable,
	   'The log_error_verbosity system variable provides additional information to the MySQL log. A value of 1 enables logging of error messages. A value of 2 enables logging of error and warning messages, and a value of 3 enables logging of error, warning and note messages.' as description_variable,
       @@global.log_error_verbosity as value_variable,
       case @@global.log_error_verbosity 
            when null then 'NOK - log_error_verbosity is not defined'
            when 1 then 'OK - log_error_verbosity 1 enables logging of error messages'
            when 2 then 'OK - log_error_verbosity 2 enables logging of error and warning messages'
            else 'OK - log_error_verbosity 3 enables logging of error, warning and note messages'
       end as diagnostic,
       case when @@global.log_error_verbosity is null 
            then 'SET GLOBAL log_error_verbosity=1;'
            else 'no action needed'
       end as action_cmd     
union
SELECT 'sql_mode' as name_variable, 
	   'NO_AUTO_CREATE_USER is an option for sql_mode that prevents a GRANT statement from automatically creating a user when authentication information is not provide.' as description_variable,
       @@global.sql_mode as value_variable, 
       CASE WHEN @@session.sql_mode LIKE '%NO_AUTO_CREATE_USER%' 
            then 'OK -  no_auto_create_user is set in sql_mode' 
            else 'NOK - no_auto_create_user is NOT set in sql_mode' 
       END diagnostic,
       CASE WHEN @@session.sql_mode not LIKE '%NO_AUTO_CREATE_USER%' 
            then (select CONCAT("SET GLOBAL sql_mode = ", @@global.sql_mode , ",NO_AUTO_CREATE_USER"))
            else 'no action needed' 
       end as action_cmd
union        
select 'log_error' as name_variable,
       'The error log contains information about events such as mysqld starting and stopping, when a table needs to be checked or repaired, and, depending on the host operating system, stack traces when mysqld fails.' as description_variable,
       @@global.log_error as value_variable,
       case when @@global.log_error = 'stderr'
            then 'NOK - log_error is writes the error log to the console'
            else 'OK - log_error is writes the erros log to the file defined'
       end diagnostic,
       case when @@global.log_error = 'stderr'
            then 'SET GLOBAL log_error= .\$name_file.err;'
            else 'no action needed'
       end as action_cmd  
union  
select 'datadir' as name_variable,
        'It is generally accepted that host operating systems should include different filesystem partitions for different purposes.  One set of filesystems are typically called system partitions, and are generally reserved for host system/application operation. The other set of filesystems are typically called non-system partitions, and such locations are generally reserved for storing data.' as description_variable,
       @@global.datadir as value_variable,
        'OK_NOK - Check location and access control' as diagnostic,
       'set global datadir = {new directory different from the system};' as action_cmd
union
select 'log_bin_basename' as name_variable,
       'MySQL can operate using a variety of log files, each used for different purposes.  These are the binary log, error log, slow query log, relay log, and general log.  Because these are files on the host operating system, they are subject to the permissions structure provided by the host and may be accessible by users other than the MySQL user.' as description_variable,
       @@global.log_bin_basename as value_variable,
       'OK_NOK - Check location and access control' as diagnostic,
       'set global log_bin_basename = {new location different from the /var or /usr or root ' as action_cmd      
union       
select 'slow_query_log' as name_variable,
	   'MySQL can operate using a variety of log files, each used for different purposes.  These are the binary log, error log, slow query log, relay log, and general log.  Because these are files on the host operating system, they are subject to the permissions structure provided by the host and may be accessible by users other than the MySQL user' as description_variable,
	   @@global.slow_query_log as value_variable,
	   case when @@global.slow_query_log = 0 
	        then 'OK - slow_query_log is disable'
	        else 'NOK - slow_query_log is enable. Verify need and check directory and access control configured in the variable slow_query_log_file'
	        end as diagnostic,
	   case when @@global.slow_query_log = 0 
	        then 'no action needed'
	        else 'SET GLOBAL slow_query_log = 0;'
	   end as action_cmd   
union	   
select 'slow_query_log_file' as name_variable,
	   'MySQL can operate using a variety of log files, each used for different purposes. These are the binary log, error log, slow query log, relay log, and general log.  Because these are files on the host operating system, they are subject to the permissions structure provided by the host and may be accessible by users other than the MySQL user' as description_variable,
	   @@global.slow_query_log_file as value_variable,
	   'OK_NOK - Check directory and access control configured in the variable slow_query_log_file' as diagnostic,
	   'SET GLOBAL slow_query_log_file = {new_location};' as action_cmd      
union
select 'relay_log_basename' as name_variable,
	   'MySQL can operate using a variety of log files, each used for different purposes.  These are the binary log, error log, slow query log, relay log, and general log.  Because these are files on the host operating system, they are subject to the permissions structure provided by the host and may be accessible by users other than the MySQL user' as description_variable,
	   @@global.relay_log_basename as value_variable,
	   'OK_NOK - Check directory and access control configured in the variable relay_log_basename' as diagnostic,
	   'SET GLOBAL relay_log_basename = {new_location};' as action_cmd
union 	   
select 'general_log' as name_variable,
	   'MySQL can operate using a variety of log files, each used for different purposes.  These are the binary log, error log, slow query log, relay log, and general log.  Because these are files on the host operating system, they are subject to the permissions structure provided by the host and may be accessible by users other than the MySQL user' as description_variable,
	   @@global.general_log as value_variable,
	   CASE WHEN @@global.general_log = 0
	        THEN 'OK - general_log is disable (0=OFF, 1=ON)'
	        else 'NOK - general_log is enable. Check access control directory and file defined in general_log_file variable' 
	   end as diagnostic,
	   CASE WHEN @@global.general_log = 0
	        THEN 'no action needed'
	        ELSE CONCAT("set global general_log = ","'OFF';")
       END AS action_cmd      
union            
select 'general_log_file' as name_variable,
	   'MySQL can operate using a variety of log files, each used for different purposes.  These are the binary log, error log, slow query log, relay log, and general log.  Because these are files on the host operating system, they are subject to the permissions structure provided by the host and may be accessible by users other than the MySQL user' as description_variable,
	   @@global.general_log_file as value_variable,
	   'OK_NOK - Check directory and access control configured in the variable general_log_file' as diagnostic,
	   'SET GLOBAL general_log_file = {new_location};' as action_cmd
union 	   
select 'local_infile' as name_variable,
	   'The local_infile parameter dictates whether files located on the MySQL clients computer can be loaded or selected via LOAD DATA INFILE or SELECT local_file' as description_variable,
	   @@global.local_infile as value_variable,
	   CASE WHEN @@global.local_infile = 0
	        THEN 'OK - local_infile is disable'
	        else 'NOK - local_infile is enable. Check directory and access control configured in the variable secure_file_priv ' 
	   end as diagnostic,
	   CASE WHEN @@global.local_infile = 0
	        THEN 'no action needed'
	        ELSE CONCAT("set global local_infile = ","'OFF';")
            END AS action_cmd  
union 
SELECT 'daemon_memcached' as name_variable,
       'The InnoDB memcached Plugin allows users to access data stored in InnoDB with the memcached protocol. By default the plugin doesnt do authentication, which means that anyone with access to the TCP/IP port of the plugin can access and modify the data.' as description_variable,
       (select PLUGIN_STATUS FROM INFORMATION_SCHEMA.PLUGINS WHERE PLUGIN_NAME = 'daemon_memcached') as value_variable,
       case when (select count(1) FROM INFORMATION_SCHEMA.PLUGINS WHERE PLUGIN_NAME = 'daemon_memcached' and PLUGIN_STATUS = 'ACTIVE') > 0
            then 'NOK - The InnoDB memcached Plugin is active. He is vulnerable.'
            else 'OK - The InnoDB memcached Plugin is not installed'
       end as diagnostic,
       case when (select count(1) FROM INFORMATION_SCHEMA.PLUGINS WHERE PLUGIN_NAME = 'daemon_memcached' and PLUGIN_STATUS = 'ACTIVE') > 0
            then 'uninstall plugin daemon_memcached;'
            else 'no action needed'
       end as action_cmd  
union 
select 'secure_file_priv' as name_variable,
	   'The secure_file_priv option restricts to paths used by LOAD DATA INFILE or SELECT local_file. It is recommended that this option be set to a file system location that contains only resources expected to be loaded by MySQL' as description_variable,
	   @@global.secure_file_priv as value_variable,
	   CASE WHEN @@global.secure_file_priv = ''
	        THEN 'NOK - No secure directories are set for uploading files'
	        else 'OK - Just check the directory access control ' 
	   end as diagnostic,
	   CASE WHEN @@global.secure_file_priv = '' and @@global.local_infile = 0
	        THEN 'no action needed'
	        ELSE 'set global secure_file_priv = {secure directory};'
            END AS action_cmd  
union 
SELECT 'File_priv' as name_variable,
       'The File_priv privilege found in the mysql.user table is used to allow or disallow a user from reading and writing files on the server host.' as description_variable,
       (select file_priv from mysql.user where File_priv = 'Y' and User <> 'root' limit 1) as value_variable,
       case when (select count(1) from mysql.user where File_priv = 'Y' and User <> 'root') = 0
            then 'OK - The File_priv privilege is not enabled for common users'
            else 'NOK - The File_priv privilege is enabled for common users'
       end as diagnostic,
       case when (select count(1) from mysql.user where File_priv = 'Y' and User <> 'root') = 0
            then 'no action needed'
            else CONCAT("select user, host from mysql.user where File_priv = ", "'Y';", "/* update mysql.user set file_priv = 'N' where user = $user and host = $host;*/")  
       end as action_cmd  
union 
SELECT 'Super_priv' as name_variable,
       'The SUPER privilege found in the mysql.user table governs the use of a variety of MySQL features. These features include, CHANGE MASTER TO, KILL, mysqladmin kill option, PURGE BINARY LOGS, SET GLOBAL, mysqladmin debug option, logging control, and more' as description_variable,
       (select super_priv from mysql.user where super_priv = 'Y' and User <> 'root' limit 1) as value_variable,
       case when (select count(1) from mysql.user where Super_priv = 'Y' and user <> 'root') = 0
            then 'OK - The super_priv privilege is not enabled for common users'
            else 'NOK - The super_priv privilege is enabled for common users'
       end as diagnostic,
       case when (select count(1) from mysql.user where Super_priv = 'Y' and user <> 'root') = 0
            then 'no action needed'
            else CONCAT("select user, host from mysql.user where super_priv = ", "'Y';", "/* update mysql.user set file_priv = 'N', plugin = 'mysql_native_password' where user = $user and host = $host;*/")  
       end as action_cmd 
union             
SELECT 'shutdown_priv' as name_variable,
       'The SHUTDOWN privilege simply enables use of the shutdown option to the mysqladmin command, which allows a user with the SHUTDOWN privilege the ability to shut down the MySQL server.' as description_variable,
       (select shutdown_priv from mysql.user where shutdown_priv = 'Y' and User <> 'root' limit 1) as value_variable,
       case when (select count(1) from mysql.user where shutdown_priv = 'Y' and user <> 'root') = 0
            then 'OK - The shutdown privilege is not enabled for common users'
            else 'NOK - The shutdown privilege is enabled for common users'
       end as diagnostic,
       case when (select count(1) from mysql.user where shutdown_priv = 'Y' and user <> 'root') = 0
            then 'no action needed'
            else CONCAT("select user, host from mysql.user where shutdown_priv = ", "'Y';", "/* update mysql.user set shutdown_priv = 'N', plugin = 'mysql_native_password' where user = $user and host = $host;*/")  
       end as action_cmd 
union             
SELECT 'create_user_priv' as name_variable,
       'The CREATE USER privilege governs the right of a given user to add or remove users, change existing users names, or revoke existing users privileges.' as description_variable,
       (select create_user_priv from mysql.user where create_user_priv = 'Y' and User <> 'root' limit 1) as value_variable,
       case when (select count(1) from mysql.user where create_user_priv = 'Y' and user <> 'root') = 0
            then 'OK - The create_user_priv privilege is not enabled for common users'
            else 'NOK - The create_user_priv privilege is enabled for common users'
       end as diagnostic,
       case when (select count(1) from mysql.user where create_user_priv = 'Y' and user <> 'root') = 0
            then 'no action needed'
            else CONCAT("select user, host from mysql.user where create_user_priv = ", "'Y';", "/* update mysql.user set create_user_priv = 'N', plugin = 'mysql_native_password' where user = $user and host = $host;*/")  
       end as action_cmd 
union             
SELECT 'grant_priv' as name_variable,
       'The GRANT OPTION privilege exists in different contexts (mysql.user, mysql.db) for the purpose of governing the ability of a privileged user to manipulate the privileges of other users names, or revoke existing users privileges.' as description_variable,
       (select grant_priv from mysql.user where grant_priv = 'Y' and User <> 'root' limit 1) as value_variable,
       case when (select count(1) from mysql.user where grant_priv = 'Y' and user <> 'root') = 0
            then 'OK - The create_user_priv privilege is not enabled for common users'
            else 'NOK - The create_user_priv privilege is enabled for common users'
       end as diagnostic,
       case when (select count(1) from mysql.user where grant_priv = 'Y' and user <> 'root') = 0
            then 'no action needed'
            else CONCAT("select user, host from mysql.user where grant_priv = ", "'Y';", "/* update mysql.user set grant_priv = 'N', plugin = 'mysql_native_password' where user = $user and host = $host;*/")  
       end as action_cmd 
union             
SELECT 'repl_slave_priv' as name_variable,
       'The REPLICATION SLAVE privilege governs whether a given user (in the context of the master server) can request updates that have been made on the master server names, or revoke existing users privileges.' as description_variable,
       (select repl_slave_priv from mysql.user where repl_slave_priv = 'Y' and User <> 'root' limit 1) as value_variable,
       case when (select count(1) from mysql.user where repl_slave_priv = 'Y' and user <> 'root') = 0
            then 'OK - The repl_slave_priv privilege is not enabled for common users'
            else 'NOK - The repl_slave_priv privilege is enabled for common users'
       end as diagnostic,
       case when (select count(1) from mysql.user where repl_slave_priv = 'Y' and user <> 'root') = 0
            then 'no action needed'
            else CONCAT("select user, host from mysql.user where repl_slave_priv = ", "'Y';", "/* update mysql.user set repl_slave_priv = 'N', plugin = 'mysql_native_password' where user = $user and host = $host;*/")  
       end as action_cmd 
union             
SELECT 'password_blank' as name_variable,
       'A user can create a blank password. Having a blank password is risky as anyone can just assume the user’s identity, enter the user’s loginID and connect to the server. This bypasses authentication, which is bad.' as description_variable,
        '' as value_variable,
        case when (SELECT COUNT(1) FROM mysql.user WHERE authentication_string='') = 0
            then 'OK - No user has no password set'
            else 'NOK - There are users with no password set. Check.'
       end as diagnostic,
       case when (SELECT COUNT(1) FROM mysql.user WHERE authentication_string='') = 0
            then 'no action needed'
            else CONCAT("select user, host from mysql.user where authentication_string='';", "/* UPDATE mysql.user SET plugin = 'mysql_native_password', authentication_string = PASSWORD('$pwd') where user = $user and host = $host;*/")  
       end as action_cmd 
union             
SELECT 'mysql_native_password' as name_variable,
       'The mysql_native_password is the traditional method of authentication' as description_variable,
        '' as value_variable,
        case when (SELECT COUNT(1) FROM mysql.user WHERE plugin <> 'mysql_native_password') = 0
            then 'OK - All users are using the recommended password policy mysql_native_password'
            else 'NOK - There are users who are not using the recommended password policy mysql_native_password. Check.'
       end as diagnostic,
       case when (SELECT COUNT(1) FROM mysql.user WHERE plugin <> 'mysql_native_password') = 0
            then 'no action needed'
            else CONCAT("select user, host from mysql.user where plugin <> 'mysql_native_password';", "/* UPDATE mysql.user SET plugin = 'mysql_native_password' where user = $user and host = $host;*/")  
       end as action_cmd 
union             
SELECT 'anonymous accounts' as name_variable,
       'Users can have an anonymous (empty or blank) username. These anonymous usernames have no passwords and any other user can use that anonymous username to connect to the MySQL server. Removal of these anonymous accounts ensures only identified and trusted users can access the MySQL server' as description_variable,
        '' as value_variable,
        case when (SELECT COUNT(1) FROM mysql.user WHERE user = '') = 0
            then 'OK - No user is configured with anonymous usernames'
            else 'NOK - There are users with anonymous usernames configuration. Check.'
       end as diagnostic,
       case when (SELECT COUNT(1) FROM mysql.user WHERE user = '') = 0
            then 'no action needed'
            else CONCAT("select user, host from mysql.user where user = '';", "/* UPDATE mysql.user SET user = $user where user = '' and host = $host; or DELETE mysql.user where user = '' and host = $host;*/")  
       end as action_cmd 
union 
SELECT 'wildcard_host' as name_variable,
       'Users with wildcard hostnames (%) are granted permission to any location. It is best to avoid creating wildcard hostnames. Instead, create users and give them specific locations from which a given user may connect to and interact with the database.' as description_variable,
        '%' as value_variable,
        case when (SELECT COUNT(1) FROM mysql.user WHERE host = '%') = 0
            then 'OK - No user is configured with wildcard hostname'
            else 'NOK - There are users with wildcard hostname configuration. Check.'
       end as diagnostic,
       case when (SELECT COUNT(1) FROM mysql.user WHERE host = '%') = 0
            then 'no action needed'
            else CONCAT("select user, host from mysql.user where host = '%';", " /* UPDATE mysql.user SET host = $host where user = $user and host = '%';*/")  
       end as action_cmd 
union
SELECT 'wildcard_host' as name_variable,
       'Users with wildcard hostnames (%) are granted permission to any location. It is best to avoid creating wildcard hostnames. Instead, create users and give them specific locations from which a given user may connect to and interact with the database.' as description_variable,
        '%' as value_variable,
        case when (SELECT COUNT(1) FROM mysql.user WHERE host = '%') = 0
            then 'OK - No user is configured with wildcard hostname'
            else 'NOK - There are users with wildcard hostname configuration. Check.'
       end as diagnostic,
       case when (SELECT COUNT(1) FROM mysql.user WHERE host = '%') = 0
            then 'no action needed'
            else CONCAT("select user, host from mysql.user where host = '%';", "/* UPDATE mysql.user SET host = $host where user = $user and host = '%';*/")  
       end as action_cmd 
union 
SELECT 'grant_all' as name_variable,
       'It is necessary to ensure that only administrative users have full access to the database' as description_variable,
        '' as value_variable,
        case when (SELECT count(1) FROM mysql.user WHERE ((Select_priv = 'Y') OR (Insert_priv = 'Y') OR (Update_priv = 'Y') OR (Delete_priv = 'Y') OR (Create_priv = 'Y') OR (Drop_priv = 'Y')) and user <> 'root') = 0
            then 'OK - There are not users commons have all privileges'
            else 'NOK - There are users commons have all privileges. Check.'
       end as diagnostic,
       case when (SELECT count(1) FROM mysql.user WHERE ((Select_priv = 'Y') OR (Insert_priv = 'Y') OR (Update_priv = 'Y') OR (Delete_priv = 'Y') OR (Create_priv = 'Y') OR (Drop_priv = 'Y')) and user <> 'root') = 0
            then 'no action needed'
            else CONCAT("SELECT USER, HOST FROM mysql.user WHERE ((Select_priv = 'Y') OR (Insert_priv = 'Y') OR (Update_priv = 'Y') OR (Delete_priv = 'Y') OR (Create_priv = 'Y') OR (Drop_priv = 'Y')) and user <> 'root';", "/* UPDATE mysql.user SET Drop_priv = 'N' where user = $user and host = $host;*/")  
       end as action_cmd 
union 
select 'have_ssl' as name_variable,
	   'All network traffic must use SSL/TLS when traveling over untrusted networks.' as description_variable,
	   @@global.have_ssl as value_variable,
	   CASE WHEN @@global.have_ssl = 'YES'
	        THEN 'OK - Secure Sockets Layer is enable'
	        else 'NOK - Secure Sockets Layer is disable. All network traffic must use SSL/TLS when traveling over untrusted networks' 
	   end as diagnostic,
	   CASE WHEN @@global.have_ssl = 'YES'
	        THEN 'no action needed'
	        ELSE CONCAT("set global have_ssl = ", "'YES';")
            END AS action_cmd  
union  
SELECT 'ssl_type' as name_variable,  
       'All network traffic must use SSL / TLS when traveling over untrusted networks. SSL / TLS must be enforced per user for users entering the system through the net' as description_variable, 
       ''  as value_variable,
       case when (select count(1) from mysql.user WHERE NOT HOST IN ('::1', '127.0.0.1', 'localhost') and ssl_type ='') >= 1
            then 'NOK - There are users without any specific SSL certificate.'
            else 'OK - All business users have an SSL certificate set'
       end as diagnostic,
       case when (select count(1) from mysql.user WHERE NOT HOST IN ('::1', '127.0.0.1', 'localhost') and ssl_type ='') >= 1
            then concat("select user, host, ssl_type FROM mysql.user WHERE NOT HOST IN (","'::1,'", "'127.0.0.1',","'localhost');", "/* RUN */", "GRANT USAGE ON *.* TO ", "'user'@'host' REQUIRE SSL;'")
            else 'no action needed'
       end as action_cmd     
union 
select 'old_passwords' as name_variable,
	   'The purpose of the old_passwords system variable is to permit backward compatibility with pre-4.1 clients under circumstances where the server would otherwise generate long password hashes' as description_variable,
	   @@global.old_passwords as value_variable,
	   CASE WHEN @@global.old_passwords = 0
	        THEN 'OK - 0 the authenticate with the mysql_native_password. Recommended.'
	        else 'NOK - different of 0 - this authentication method uses a vulnerable algorithm hash' 
	   end as diagnostic,
	   CASE WHEN @@global.old_passwords = 0
	        THEN 'no action needed'
	        ELSE 'set global old_passwords = 0;'
            END AS action_cmd  
union 
select 'secure_auth' as name_variable,
	   'If this variable is enabled, the server blocks connections by clients that attempt to use accounts that have passwords stored in the old (pre-4.1) format. Enable this variable to prevent all use of passwords employing the old format (and hence insecure communication over the network).' as description_variable,
	   @@global.secure_auth as value_variable,
	   CASE WHEN @@global.secure_auth = 1
	        THEN 'OK - 1 is ON - The server blocks passwords in old formats'
	        else 'NOK - different of 1 OFF - The server does not block passwords in old formats' 
	   end as diagnostic,
	   CASE WHEN @@global.secure_auth = 1
	        THEN 'no action needed'
	        ELSE 'set global secure_auth = 1;'
            END AS action_cmd  
union 
SELECT 'validate_password' as name_variable,
       'Password complexity includes password characteristics such as length, case, length, and character sets. This recommendation prevents users from choosing weak passwords which can easily be guessed. ' as description_variable,
       (select PLUGIN_STATUS FROM INFORMATION_SCHEMA.PLUGINS WHERE PLUGIN_NAME = 'validate_password') as value_variable,
       case when (select count(1) FROM INFORMATION_SCHEMA.PLUGINS WHERE PLUGIN_NAME = 'validate_password' and PLUGIN_STATUS = 'ACTIVE') > 0
            then 'OK - Policies security password is active'
            else 'NOK - Policies security password is not installed'
       end as diagnostic,
       case when (select count(1) FROM INFORMATION_SCHEMA.PLUGINS WHERE PLUGIN_NAME = 'validate_password' and PLUGIN_STATUS = 'ACTIVE') > 0
            then 'no action needed'
            else concat("INSTALL PLUGIN validate_password SONAME ","'validate_password.so'; /* Run script mysqldb_alter_validate_password.sql*/")
       end as action_cmd  
union             
select 'default_password_lifetime' as name_variable,
	  'Password expiry for specific users provides user passwords with a unique time bounded lifetime.' as description_variable,	   
	   @@global.default_password_lifetime as value_variable,
	  CASE WHEN @@global.default_password_lifetime >= 90
	        THEN 'OK - Control of requires password change every 90 days is defined'
	        else 'NOK - Control of requires password change every 90 days is NOT defined' 
	   end as diagnostic,
	   CASE WHEN @@global.default_password_lifetime >= 90
	        THEN 'no action needed'
	        ELSE 'SET GLOBAL default_password_lifetime=90;'
            END AS action_cmd 
union             
SELECT 'audit_log' as name_variable,
       'Password complexity includes password characteristics such as length, case, length, and character sets. This recommendation prevents users from choosing weak passwords which can easily be guessed. ' as description_variable,
       (select PLUGIN_STATUS FROM INFORMATION_SCHEMA.PLUGINS WHERE PLUGIN_NAME = 'audit_log') as value_variable,
       case when (select count(1) FROM INFORMATION_SCHEMA.PLUGINS WHERE PLUGIN_NAME = 'audit_log' and PLUGIN_STATUS = 'ACTIVE') > 0
            then 'OK - Policies security password is active'
            else 'NOK - Policies security password is not installed'
       end as diagnostic,
       case when (select count(1) FROM INFORMATION_SCHEMA.PLUGINS WHERE PLUGIN_NAME = 'audit_log' and PLUGIN_STATUS = 'ACTIVE') > 0
            then 'no action needed'
            else concat("INSTALL PLUGIN audit_log SONAME ","'audit_log.so'; /* Run script mysqldb_alter_audit_log.sql */")
       end as action_cmd  
union             
select 'MASTER_SSL_VERIFY_SERVER_CERT' as name_variable,
       'In the MySQL slave context the setting MASTER_SSL_VERIFY_SERVER_CERT indicates whether the slave should verify the masters certificate. This configuration item may be set to Yes or No, and unless SSL has been enabled on the slave the value will be ignored.' as description_variable,
       (select ssl_verify_server_cert  from mysql.slave_master_info) AS value_variable,
       case when (select ssl_verify_server_cert  from mysql.slave_master_info) = 1
            then 'OK - Use of SSL certificate for authentication between master / slave is defined'
	        else 'NOK - Use of SSL certificate for authentication between master / slave is NOT defined' 
	   end as diagnostic,
	   CASE WHEN (select ssl_verify_server_cert  from mysql.slave_master_info) = 1
	        THEN 'no action needed'
	        ELSE 'STOP SLAVE; CHANGE MASTER TO MASTER_SSL_VERIFY_SERVER_CERT=1; START SLAVE;'
            END AS action_cmd ;