## Requisiti e funzionalità
L'applicazione in oggetto, vuole essere un'sistema in grado di gestire tutti gli aspetti relativi alla creazione e distribuzione delle schede di allenamento da parte di un'utente "Coach", e la relativa visualizzazione da parte di un'utente di tipo "Cliente".
Ogni Scheda è composta da Allenamenti, caratterizzati da un nome, dalla lista di Esercizi di cui l'allenamento si compone, e da un riferimento sulle date (con, eventualmente, l'orario di svolgimento) assegnate a quel preciso Allenamento.
il Cliente deve avere la possibilità utilizzare l'applicazione installata sul proprio smartphone (su sistema operativo Android oppure iOS), per potersi effettivamente allenare con essa, sfruttando un'interfaccia che mostri lo stato di avanzamento dell' allenamento corrente, ma anche poter visualizzare allenamenti già completati e la progressione (Carichi e ripetizioni) dei singoli Esercizi in scheda.
Gli utenti, Coach e Cliente, possono comunicare tra loro tramite una chat testuale integrata all'interno dell'app.
il backend dell'applicazione sarà gestito tramite Firebase, utilizzando il database Firestore per salvare tutte le informazioni in raccolte di documenti NoSQL, con possibilità di sincronizzazione in tempo reale, salvataggio di dati offline e query.
La decisione sull'utilizzo di Flutter, è stata finalizzata sulla base della sua forte propensione al cross platform e quindi, al supporto di tutte le piattaforme alle quali eravamo interessati, in un unico progetto e senza dover riscrivere codice nativo per ognuna di esse.

L'applicazione è strutturata in 3 fondamentali aree :
- Schermata di autenticazione
- Schermata Cliente, ottimizzata per l'utilizzo in ambienti mobile
- Dashboard Coach, ottimizzata per gli ambienti Desktop

## Account e autenticazione
La prima schermata, comune a ogni utente, è quella di autenticazione in cui vengono rischiesti indirizzo Email e una password di almeno 6 caratteri per poter accedere al proprio account.
Qualora la form di accesso non sia completa e/o le informazioni nei campi di testo non siano valide, il sistema di validazione della form darà esito negativo e mostrarà dei messaggi di errore.
In caso contrario, l'applicazione è in grado di indirizzare automaticamente l'utente intento ad autenticarsi, alla macro area dell'applicazione pertinente alla propria categoria di account: se si tratta di un'Cliente verrà indirizzato alla schermata principale del cliente, altrimenti alla dashboard del coach
Per quanto riguarda la registrazione di nuovi utenti, l'applicazione non prevede l'utilizzo di tale funzionalità in autonomia da parte di nuovi clieni, in quanto si è pensato di affidarne il compito direttamente all'utente coach, intento ad iniziare una collaborazione con il nuovo cliente e fornirne quindi,le credenziali di accesso.
Questo approccio, oltre ad evitare l'inutile registrazione di utenti randomici non collegati a nessun coach, semplifica anche l'accesso ai clienti e offre un'enumarazione dei personali clienti di ciascun coach.

## Schermata Cliente 

### homepage 
la schermata home si presenta ad ogni avvio dell'applicazione, una volta che viene eseguito l'accesso al proprio account, ed è composta da 4 sezioni principali:
- Calendario
- Progressi
- Archivio
- Chat
  
L'utente può liberamente passare da una sezione all'altra attraverso l'uso della barra di navigazione inferiore, che mostrerà le sezione attualmente selezionata.
la sezione Calendario fa riferimento alla scheda attualmente in uso dal cliente, la sua funzione principale è quella di mostrare l'allenamento (anche più di uno) previsto per la giornata corrente,  oppure l'eventuale giornata di riposo.
Sempre nella stessa schermata, un date picker a scorrimento permette di selezionare una determinata giornata e di mostrare il relativo allenamento; se si tratta di una giornata in cui l'utente si è già allenato, allora è possibile visualizzare un resoconto dell'allenamento, con i carichi utilizzati e le ripetizioni di ogni esercizio, altrimenti l'utente può avviare l'allenamento previsto per la data selezionata.
la seconda sezione presente nella homepage è quella dedicata ai progressi e ai miglioramenti dell'utente; si presenta come un elenco in cui vengono mostrati tutti gli esercizi che l'utente svolge nella propria scheda, con la possibilità di filtrare per allenamento.
Per ogni esercizio l'utente può visualizzarne i dettagli relativi ad ogni seduta di allenamento in cui esso viene svolto, tenere traccia della progressione dei carichi e del carico massimale attuale, anche atraverso la visione di un grafico animato.

