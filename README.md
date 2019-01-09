# A2L_Application 
L'A2L ou Association du Lycée Lurçat se modernise en informatisant ses cartes adhérents. Une application sera déployée sur iOS, et Android afin de permettre aux adhérents d'avoir accès à leur carte et ainsi pouvoir bénéficer d'avantages. Ce code est l'application qui sera déployée sur iOS. Elle sera en permamence connectée à un serveur avec lequel elle dialoguera. Le serveur devra gérer les connexions, les privilèges, les informations. Voici le repository du [serveur]. 
3 types d'utilisateurs pourront utiliser l'application : 
1) Les adhérents. Il ne dispose d'aucuns privilèges et n'ont pas de droits d'éctriture. Ils peuvent consulter leurs informations et générer un QR code donnant aux admin l'accès à leurs informations. 
2) Les membres du bureau. Ils disposent de quelques privilèges. Ils leurs sont accordés par les super-admin. Il pourront ainsi au maximum, visionner la liste des adhérents, scanner des QR Code, augmenter/dimunuer le nombre de point de fidelité.
3) Les super-admin ont tous les privilèges. Ils gèrent ceux des autres. Ils possèdent donc les privilèges des membres du bureau, ainsi qu'un droit de modification sur toutes les infromations, la possibilité de supprimer/ajouter des adhérents (en soi il gère les données du serveur), eux seuls peuvent nommer d'autre super-admin. Un super-admin ne pourra être destitué que par une majorité absolue des autres super-admin (voir les conditions dans les codes sources).

Cette application n'a pas pour vocation de remplacer la carte A2L mais de faciliter son utilité. 
Le code source est à la dispositon de tous. 

Toute contribution est bonne à prendre. Le developpeur détenteur de la liscence Apple, android et du serveur se réserve le droit de la publication des mise à jours. 

Contact : nathanstchepinsky@gmail.com 

Site : https://nathanstchepinsky--nathans1.repl.co
