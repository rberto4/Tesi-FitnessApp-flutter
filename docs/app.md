# Requisiti
L'applicazione in oggetto, vuole essere un'sistema in grado di gestire tutti gli aspetti relativi alla creazione e distribuzione delle schede di allenamento da parte di un'utente "Coach", e la relativa visualizzazione da parte di un'utente di tipo "Cliente".
Ogni Scheda è composta da Allenamenti, caratterizzati da un nome, dalla lista di Esercizi di cui l'allenamento si compone, e da un riferimento sulle date (con, eventualmente, l'orario) assegnate a quel preciso Allenamento.
il Cliente deve avere la possibilità utilizzare l'applicazione installata sul proprio smartphone (su sistema operativo Android oppure iOS), per potersi effettivamente allenare con essa, sfruttando un'interfaccia che mostri lo stato di avanzamento dell' allenamento corrente, ma anche poter visualizzare allenamenti già completati e la progressione (Carichi e ripetizioni) dei singoli Esercizi in scheda.
Gli utenti, Coach e Cliente, possono comunicare tra loro tramite una chat testuale integrata all'interno dell'app.
il backend dell'applicazione sarà gestito tramite Firebase, utilizzando il database Firestore per salvare tutte le informazioni in raccolte di documenti NoSQL, con possibilità di sincronizzazione in tempo reale, salvataggio di dati offline e query.

## Account e autenticazione


