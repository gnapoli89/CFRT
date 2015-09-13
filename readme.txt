SimpleDos
- Per eseguire SimpleDos, richiamare la classe Test.java (o l'eseguibile .jar) con i seguenti parametri:
	- http://[server_address] [port_number] [base_uri] [MALICIOUS_MODE]
		-[server_address] è l'indirizzo IP (o l'url base del server)
		- [base_uri] è la uri di base (nel caso di LittleS3 sarà del tipo littleS3-2.3.0/nome_bucket)
		- [MALICIOUS_MODE] può essere 0 o 1:
			-	0 for Normal client: it makes an HTTP request every 5 seconds with probability of 40% on a file choose randomly among the set of created files. The type of request will be chosen at random between GET (70% of requests) or PUT/DELETE (30% or requests);
			-	1 for Malicious client, it acts as a normal client, every hour, the malicious routine is lauched. It makes a pool of 10 threads, each one makes PUT requests sending the biggest file among the set of provided files;

Parser Perl
Una volta recuperati gli access log di Tomcat bisogna tradurli in access log di S3.
- All'interno del terminale, richiamare lo script con il seguente comando:
	perl parser.pl [access_log_file] > [output_file.txt]
	[access_log_file] è il log di Tomcat e [output_file.txt] il file destinazione in cui le informazioni verratto scritte come un access log di S3
	
CFRS (o CFRT)
- Importare il progetto con Eclipse
- Far partire Mongo DB server in locale con le impostazioni di default (gli eseguibili sono scaricabili da https://www.mongodb.org/);
- Far partire MySQL server ed importare il backup delle informazioni estratte da GATE dal file backup.sql;
- Modificare, se necessario, il file config.txt all'interno della cartella di CFRS con i nuovi path (ATTENZIONE al path del file di log.);
	- Se fosse necessario rieseguire GATE per l'aquisizione delle informazioni dagli SLA settare la variabile GATE_used=0.
	- Se fosse necessario ricaricare i log all'interno di mongoDB, basta svuotare la collection logs da un terminale MongoDB con il comando db.logs.drop(). (si consiglia di eseguire lo stesso comando anche sulle altre collection [data e violations])
- Eseguire MainFrame.java

DatasetBuilder
- una volta aggregati i log in MongoDB con CFRT eseguire DatasetBuilder, che prendendo le informazioni da Mongo produrrà il file dataset.csv
- I nuovo dataset sarà disponibile nella cartella della soluzione.
	