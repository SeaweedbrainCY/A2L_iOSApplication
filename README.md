# A2L_Application 
L'A2L ou Association du Lycée Lurçat se modernise en informatisant ses cartes adhérents. Une application sera déployée sur iOS, et via un site internet afin de permettre aux adhérents d'avoir accès à leur carte et ainsi pouvoir bénéficer d'avantages. Ce code est l'application qui sera déployée sur iOS. Elle sera en permamence connectée à un serveur avec lequel elle dialoguera. Le serveur devra gérer les connexions, les privilèges, les informations. Voici le repository du serveur [https://github.com/DevNathan/A2L_BackEnd]. 
3 types d'utilisateurs pourront utiliser l'application : 


1) Les adhérents. Ils ne disposent d'aucun privilège particulié et n'ont pas de droits d'écriture. Ils peuvent consulter leurs informations et générer un QR code donnant aux admin l'accès à leurs informations. 


2) Les membres du bureau. Ils disposent de quelques privilèges. Ils leurs sont accordés par les super-admin. Il pourront ainsi visionner la liste des adhérents, scanner des QR Code, augmenter/diminuer le nombre de point de fidelité.


3) Les super-admin ont tous les privilèges. Ils gèrent ceux des autres. Ils possèdent donc les privilèges des membres du bureau, ainsi qu'un droit de modification sur toutes les infromations, la possibilité de supprimer/ajouter des adhérents (en soi il gère les données du serveur), eux seuls peuvent nommer d'autre super-admin, et modifier des données en général. Ils ont accès à des données confidentielles qui ne sont pas présentes sur ce github.


4) Les développeurs : ils disposent de tous les privileges des super-admin et gardent le controlle de l’application. Ainsi ils ne peuvent pas êtres dégradé ni supprimé de la base de donnée. Ils disposeront d’un accès privé au serveur via l’application ainsi que les codes du serveurs.

La sécurité de l'application et du serveur est détaillé dans ce docuement. La sécurité minimum sera fournis dès la première version distribuée et les mises à jours permettront d'apporter tous les protocles de sécurités nécessaires. (https://github.com/DevNathan/A2L_BackEnd/blob/master/README.md)
L’application se veut être autonome et doit donc être capable de réagir toute seule à tout type de menace.

Cette application n'a pas pour vocation de remplacer la carte A2L mais de faciliter son utilité. 
Le code source est à la dispositon de tous. 

Toute contribution est bonne à prendre. Le developpeur détenteur de la liscence Apple, android et du serveur se réserve le droit de la publication des mise à jours. 

Liste des developpeurs : [Stchepinsky Nathan (devloppeur principal)] 

Contact : nathanstchepinsky@gmail.com 

Site : https://nathanstchepinsky--nathans1.repl.co
