
********************************************************************************************************************************
   *****************       SEYDINA JOUAHIBOU DIAME     ET      FALLOU SENE ********************************************
      **************************************************************************************************************

*EXERCICE 1;
* 1. Avec   la   commande   LIBNAME   créer   une   librairie   SAS   où   vous   mettrez   toutes   vos 
tables;
libname SAS "C:\ExamenFinal\SAS" ;
*2.Importer le ?chier IMC.xls sous SAS et créer une table SAS nommée IMC en y ra joutant une variable CODE contenant le numéro (code) de la Gironde et la date de 
naissance de chaque enfant;
proc import datafile="C:\ExamenFinal\SAS\IMC.xls"
out=SAS.base
dbms=xls
replace;
getname=yes;
run;
proc print data =base;
run;
data SAS.IMC;
SET SAS.base;
format date_entree date_naissance date_apr date9.;
date_entree = MDY(2,17,1997);
date_naissance=intnx('YEAR',date_entree,-an,'S');
date_apr = intnx('MONTH',date_naissance,-mois,'S');
CODE = cats('33-',put(date_apr,date9.));
DROP date_entree date_naissance date_apr;
run;
proc print data = SAS.IMC;
run;
* 3. A partir de cette table, créer la table feminin qui contient les données des individus 
dont la variable SEXE vaut F. De la même manière, créer la table masculin qui 
contient les données des individus dont la variable SEXE vaut G. La variable SEXE 
sera supprimée des tables feminin et masculin;
*table féminin;
data SAS.feminin;
set SAS.IMC;
where SEXE='F';
drop SEXE;
run;
proc print data = SAS.feminin;
run;

*table masculin;
data SAS.masculin;
set SAS.IMC;
where SEXE='G';
drop SEXE;
run;
proc print data = SAS.masculin;
run;

* 4 .Créer  la  table  zep  qui  contient  les  individus  en  zone  ZEP.;
data SAS.Zep;
set SAS.IMC;
where ZEP='O';
run;
proc print data = SAS.Zep;
run;

 * 5. Créer  la  table  selection1  qui  contient  les  individus  ayant  un  poids  strictement  supé- 
rieur  à  14  et  une  taille  strictement  inférieure  à  100; 

data SAS.selection1;
set SAS.IMC;
IF (poids < 14 AND taille < 100 ) ;
run;
proc print data = SAS.selection1;
run;

* 6. Fusionner   les   deux   tables   zep   et   selection1   en   fonction   du   numéro   d’identi?cation 
(ID) ; 
Proc sort data=SAS.zep; by ID ; run ;
Proc sort data=SAS.selection1; by ID ; run ;
Data SAS.fusion;
Merge SAS.zep SAS.selection1 ;
By ID ;
Run ;
proc print data = SAS.fusion;
run;

*Exercice2 
1 . Créer la table date en important le ?chier date.txt. Cette table est composée d’une 
variable prénom et d’une variable date. Faites attention à ce que les prénoms soient 
complets ;
DATA SAS.date1;
INFILE "C:\ExamenFinal\SAS\date - Copie.txt" dlm=";" ;
INPUT   prenom :$9.  date :DATE. ;
FORMAT date date9. ; 
RUN;
proc print data =SAS.date1;
run;

* 2. Créer  la  variable  Njours  qui  compte  le  nombre  de  jours  écoulés  entre  la  date  et  le  jour 
où  le  programme  sera  exécuté. ;
data SAS.new_table;
   set SAS.date1;
    Njours = intck('day', date, DATE(),'c');
run;
proc print data=SAS.new_table;

* 3. Créer la variable Nannees qui compte le nombre d’années écoulées entre la date et 
le jour où le programme sera exécuté. Vous donnerez une valeur arrondie à l’unité la 
plus près. ; 
data SAS.new_table2;
    set SAS.new_table;
   Nannees =intck('YEAR', date,DATE(), 'c');
   run;
proc print data=SAS.new_table2;

* 4. Créer   une   table   fevrier   qui   ne   conserve   que   le   prénom   des   individus   nés   en   Février 
accompagné  de  leur  année  de  naissance  (variable  annee);
data SAS.fevrier;
    set SAS.new_table2; 
    mn = MONTH(date);
    IF (mn=2 ) ;
	
RUN;
proc print data=SAS.fevrier;

* Exercice 3 
1. Le  montant  est  donné  sous  forme  de  décimale  française  ("virgule").  Créer  une  variable 
montant2  qui  donne  ce  montant  sous  sa  forme  américaine  ("point"). ; 

data SAS.achat1;
set SAS.achat; 
Montant2 = montant ;
run;
proc print data =SAS.achat1;

* 2. Créer  une  variable  cumul  qui  agrège  le  montant  de  chaque  produit.
proc print data = SampleData noobs; 

 data SAS.produit_montant;
 set SAS.achat1;
 Drop produit montant;
proc print data =SAS.produit_montant;
   
 DATA SAS.achat10;
 set SAS.produit_montant;
 RETAIN cumul 0 ; 
 cumul = cumul + Montant2;
 RUN;
 PROC PRINT DATA = SAS.achat10; RUN;

*3 Créer  une  table  totaux  composée  des  2  variables  type  et  total,  qui  donne  le  montant 
total  par  type  de  produit  (il  y  a  donc  autant  de  lignes  que  de  types) ;
 PROC SORT DATA = SAS.achat10 ; by type ;RUN;
 DATA SAS.totaux (DROP cumul);
 SET SAS.achat10; BY type;
 RETAIN total 0;
 IF FIRST.type THEN  total =0;
 total = total + montant2;
 If LAST.type THEN OUTPUT;
 RUN;
 PROC PRINT DATA = SAS.totaux ;RUN;

 * 4 Dans la table Achat, créer la variable lettres qui contient la première et la dernière 
lettre de chaque produit. Ces deux lettres seront séparées d’un trait d’union ( - ), sans 
blancs. ;
 Title "Création de variable lettres";
 DATA Achat ;
 SET SAS.achat1;
 lettres = CATX("-",SUBSTR(produit,1,1),SUBSTR(produit,LENGTH(produit),1));
 RUN;
 Proc print DATA =Achat ;RUN;
 
 * 5 Produire des représentations graphiques et des statistiques adaptées pour résumer votre 
tableau  de  données ;

 Title "Les statistiques";
 PROC SORT DATA = Achat;
 BY type;
 RUN;
 PROC MEANS DATA = Achat N Min Q1 MEAN Q3 MAX;
 By type;
 VAR Montant2;
 RUN;
 PROC SORT DATA = Achat;
 by type;
 RUN;
 Title2 "Les représentations  graphhiques";
 PROC BOXPLOT DATA = Achat;
 PLOT montant*type;
 RUN;

 

