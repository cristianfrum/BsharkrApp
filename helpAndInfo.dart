import 'package:flutter/material.dart';

import 'Client/globals.dart';
import 'colors.dart';

class HelpAndInfo extends StatefulWidget {
  @override
  HelpAndInfoState createState() => HelpAndInfoState();
}

class HelpAndInfoState extends State<HelpAndInfo>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
   
    super.initState();

    tabController = TabController(vsync: this, length: 2, initialIndex: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: secondaryColor,
        elevation: 0.0,
        title: Text(
          "Help & Info",
          style: TextStyle(
              fontFamily: 'Roboto',
              color: Colors.white,
              fontSize: 22 * prefs.getDouble('height'),
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        bottom: TabBar(
            indicatorColor: mainColor,
            controller: tabController,
            tabs: <Widget>[
              Tab(
                text: "Privacy",
              ),
              Tab(
                text: "Contact",
              )
            ]),
      ),
      body: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: TabBarView(
            controller: tabController,
            children: <Widget>[
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: 16 * prefs.getDouble('height'),
                        horizontal: 16 * prefs.getDouble('width')),
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                              fontSize: 15 * prefs.getDouble('height'),
                              fontFamily: 'Roboto',
                              letterSpacing: -0.24),
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  "            POLITICA PRIVIND PRELUCRAREA DATELOR CU CARACTER PERSONAL A BSHARKR Company S.R.L\n\n            Politica privind prelucrarea datelor cu caracter personal descrie categoriile de date pe care le prelucrăm, modalitatea și scopurile în care le colectăm, în ce situații transferăm date cu caracter personal și diversele drepturi și opțiuni de care dispuneți în acest sens. Politica noastră privind prelucrarea datelor cu caracter personal detaliază modul în care prelucrăm datele cu caracter personal în exercitarea activității specifice privind organizarea, desfășurarea și promovarea Bsharkr Company S.R.L. și cel mai adesea pentru conturile personale de client sau antrenor din aplicatia Bsharkr.\n\n            		OPERATORUL DATELOR DUMNEAVOASTRĂ CU CARACTER  PERSONAL\n\n            Bsharkr Company S.R.L., persoana juridica romana, cu sediul in Bucuresti, Sos. Oltenitei nr. 63, bloc 3, Sector 4 în calitate de proprietar al aplicatiei Bsharkr este operatorul datelor dumneavoastră cu caracter personal.\n\n            		OPERATORI ASOCIAȚI\n\n             În cazul în care doi sau mai mulţi operatori stabilesc în comun scopurile şi mijloacele de prelucrare, aceştia sunt operatori asociaţi. Ei stabilesc într-un mod transparent responsabilităţile fiecăruia în ceea ce priveşte îndeplinirea obligaţiilor care le revin în temeiul prezentului regulament, în special în ceea ce priveşte exercitarea drepturilor persoanelor vizate şi îndatoririle fiecăruia de furnizare a informaţiilor legale.\n            Datele cu caracter personal pe care le prelucrăm pot include:\n            		Informații de contact, cum ar fi numele dumneavoastră, denumirea postului, adresa poștală, inclusiv adresa de domiciliu, în cazul în care ne-ați comunicat-o, adresa profesională, numărul de telefon, numărul de telefon mobil, numărul de fax și adresa de e-mail;\n            		Informații suplimentare prelucrate în mod obligatoriu în vederea încheierii sau exercitării unui raport contractual sau comunicate în mod voluntar de către dumneavoastră, cum ar fi instrucțiuni acordate, plăți efectuate, solicitări și proiecte;\n            		Informații colectate din surse publice;\n            		Diploma sau acreditare de orice fel ce are ca scop dovedirea absolvirii unui curs pentru antrenori;\n            		Alte date cu caracter personal necesare în scopul informării dumneavoastră dacă se dovedesc relevante activității pe care o desfășurăm care se încadrează în interesul legitim al operatorului;\n            În situații limitate, în care pentru  desfășurarea activității noastre, trebuie să colectăm categorii speciale de date cu caracter personal astfel cum  sunt ele regăsite în cadrul art. 9 al Regulamentului privind protecția persoanelor fizice  în ceea ce privește prelucrarea datelor cu caracter personal și libera circulație a acestor date (”GDPR”), respectiv codul numeric personal,  imaginile dumneavoastră, date privind calitatea dumneavoastră de membru al unei asociații profesionale sau comerciale sau unui sindicat, date de sănătate cu caracter personal, date cu privire la opiniile dumneavoastră politice și date privind cazierul judiciar, prelucrarea se va face doar:\n            i. pe baza consimțământului prealabil expres al dumneavoastră sau pe baza dovezii juste a consimțământului dumneavoastră furnizate de o terță persoană care ne comunică aceste date;\n            ii. în baza unei obligații legală de prelucrare a acestor categorii de date;\n            iii.  în baza unei obligații care apără un drept legitim;\n            		Adrese IP. Site-urile colecționează adrese IP (Internet Protocol). O adresă IP este un număr, asignat calculatorului dvs. de către furnizorul dvs de internet, ce vă permite accesarea internetului. O adresă IP poate fi o dată personală. Folosim adrese IP pentru a diagnostica probleme cu servere, raportarea informațiilor sub formă agregată, determinarea celei mai eficiente conexiuni cu site-ul nostru și pentru administrarea și îmbunătățirea site-ului.\n            		Cookies. Site-urile folosesc “cookies”. Un cookie este un mic fișier text, păstrat pe calculatorul, tableta sau telefonul dvs. când deschideți un site web, ce ajută site-ul să vă recunoască, inclusiv preferințele dvs. Unele cookie-uri sunt șterse atunci când închideți browser-ul. Acestea se numesc session cookies. Altele rămân pe device-ul dvs până expiră sau până le ștergeți din cache-ul dvs. Acestea se numesc persistent cookies, ce ne permit să reținem informații despre vizitatori recurenți. Cookie-urile pe care le folosim ne permit să recunoaștem și să numărăm vizitatorii prezenți, și să vedem pe unde se duc vizitatorii pe site. Astfel, putem să îmbunătățim funcționarea site-urilor, de exemplu prin organizarea lor astfel încât utilizatorii găsesc ușor ce caută. Cookie-urile noastre ne permit de asemenea să personalizăm conținutul vizualizat de dvs, în funcție de preferințele indicate de dvs.\n            		Adresa e-mail. Dacă vă abonați la alertele trimise prin e-mail sau confirmati menținerea  abonarii anterioare datei de 17 iulie 2020, colectăm adresa dvs. de e-mail. Această adresă se folosește doar pentru informarea pe care ați cerut-o/confirmat-o. Dacă doriți să vă dezabonați, o puteți face în orice moment folosind indicațiile din fiecare e-mail pe care îl primiți, sau prin trimiterea unui e-mail la info@tiff.ro.\n            		MODALITATEA ÎN CARE COLECTĂM DATELE DUMNEAVOASTRĂ CU CARACTER PERSONA\n            Putem colecta date cu caracter personal cu privire la dumneavoastră în anumite împrejurări, inclusiv:\n            		În momentul în care dumneavoastră sau  organizația dumneavoastră se angajează în relații de natură contractuală cu noi;\n            		În momentul în care ne comunicați dumneavoastră sau organizația dumneavoastră voluntar, din orice motiv, datele dumneavoastră cu caracter personal;\n            		În momentul în care navigați, solicitați informații sau interacționați, sau organizația dumneavoastră navighează, solicită informații sau interacționează in aplicatia Bsharkr;\n            		În momentul în care participați la un  eveniment organizat de către noi care presupune oferirea din partea dumneavoastră a datelor cu caracter personal;\n            În anumite împrejurări, colectăm date cu caracter personal cu privire la dumneavoastră de la o sursă terță. Spre exemplu, putem colecta date cu caracter personal de la organizația dumneavoastră, alte organizații cu care aveți legături, agenții guvernamentale, birouri de credit, furnizori de informații sau servicii sau din arhive publice sau parteneri/colaboratori cu care avem stabilite relații de natură contractuală care presupun, printre altele partajarea bazelor noastre de date. \n            În anumite împrejurări, colectăm date cu caracter personal cu privire la dumneavoastră de la o sursă terță. Spre exemplu, putem colecta date cu caracter personal de la organizația dumneavoastră, alte organizații cu care aveți legături, agenții guvernamentale, birouri de credit, furnizori de informații sau servicii sau din arhive publice sau parteneri/colaboratori cu care avem stabilite relații de natură contractuală care presupun, printre altele partajarea bazelor noastre de date. \n            Orice operațiune care echivalează cu o prelucrare (colectare, stocare, înregistrare, structurare, adaptare sau modificare, extragere, consultare, utilizare, divulgare prin transmitere, distrugere) a datelor dumneavoastră cu caracter personal va fi efectuată pe baza unuia dintre temeiurile juridice de mai jos:\n            		Prelucrarea este necesară în vederea executării unui contract la care dumneavoastră sunteți parte sau organizația dumneavoastră este parte, sau prelucrarea respectivă este necesară în vederea încheierii unui contract cu dumneavoastră sau organizația dumneavoastră;\n            		Prelucrarea este necesară în vederea executării unui contract la care dumneavoastră sunteți parte sau organizația dumneavoastră este parte, sau prelucrarea respectivă este necesară în vederea încheierii unui contract cu dumneavoastră sau organizația dumneavoastră;\n            		Prelucrarea este efectuată în temeiul consimțământului dumneavoastră prin selectarea casutei la înregistrarea în aplicație;\n            		Prelucrarea este efectuată în temeiul consimțământului dumneavoastră prin selectarea casutei la înregistrarea în aplicație;\n            		Prelucrarea este necesară în scopul intereselor noastre legitime sau ale unui terț, cu excepția cazurilor în care interesele sau drepturile și libertățile dumneavoastră fundamentale prevalează asupra acestor interese.\n            În cazurile în care dispozițiile legale aplicabile impun consimțământul dumneavoastră prealabil și explicit pentru prelucrarea unor categorii speciale de date, vom prelucra datele respective doar în temeiul consimțământului dumneavoastră prealabil și explicit. În același timp, ne vom lua garanții suplimentare că orice persoană fizică sau entitate care ne comunică datele dumneavoastră speciale cu caracter personal a obținut în prealabil consimțământul dumneavoastră.\n\n            		POLITICĂ DE CONFIDENȚIALITATE PRIVIND UTILIZAREA APLICAȚIEI OFICIALE Bsharkr\n\n            Aplicația Bsharkr este dezvoltată și menținută de societatea Bsharkr Company S.R.L.\n            Aplicația Bsharkr este dezvoltată și menținută de societatea Bsharkr Company S.R.L.\n            Procesarea datelor personale în aplicație\n            Pentru a face tranzacții în interiorul aplicației cu scopul de a cumpăra trofee in vederea administrarii contului de antrenor, aplicația vă transmite către  partenerul de tranzacții pentru a asigura o comunicare securizată. Pentru mai multe informații, vă rugăm să consultați documentul Politica de confidențialitate a serviciului.\n            Datele generate de dvs. prin utilizarea aplicației sunt depersonalizate și stocate de către servicii externe pentru a putea îmbunătăți funcționalitățile aplicației și performanța acesteia.\n            Serviciile de monitorizare folosite pentru aplicație sunt:\n            Firebase - Politica de confidențialitate\n            Flutter - Politica de confidențialitate\n            Stocarea datelor personale\n            		COLECTAREA  DATELOR CU CARACTER PERSONAL ALE MINORILOR\n            		SCOPURILE ÎN CARE SE VOR PRELUCRA   DATELE DUMNEAVOASTRĂ CU CARACTER PERSONAL\n            Vă putem folosi datele cu caracter personal doar în următoarele scopuri („Scopuri Permise”): \n            ",
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w300,
                                fontSize: 11 * prefs.getDouble('height'),
                                letterSpacing: -0.408,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                            TextSpan(
                                text:
                                    "		Respectarea obligațiilor noastre legale (cum ar fi obligații de păstrare a evidențelor), obligații de verificare a conformității sau de înregistrare care ar putea include verificări automate ale datelor dumneavoastră de contact sau alte informații pe care ni le furnizați cu privire la identitatea dumneavoastră cu liste aplicabile ale persoanelor sancționate și contactarea dumneavoastră pentru confirmarea identității dumneavoastră în cazul unui posibil rezultat pozitiv, sau înregistrarea interacțiunii cu dumneavoastră care ar putea fi relevantă în scopuri de conformare;\n            		Pentru utilizarea conturilor din aplicatie, atat de client cat si de antrenor definite “Client” si “Trainer;\n            		Scopuri precum reclamă, marketing și publicitate, statistică exclusiv în interesul operatorului sau împuterniciților săi, organizarea de cursuri, seminarii, alte evenimente (inclusiv delegații, conferințe și târguri), în scop educațional pentru organizarea programelor de formare profesională, pentru emiterea oricăror documente financiar-contabile, încheierea de contracte ori alte acte necesare în activitatea Bsharkr;\n            		Analizarea și îmbunătățirea serviciilor și comunicărilor noastre către dumneavoastră;\n            		Protejarea securității și gestionarea accesului la sediul nostru, sistemele IT și de comunicare, platformele online, website-urile și celelalte sisteme, prevenirea și detectarea amenințărilor de securitate, fraudelor sau a altor activități infracționale sau malițioase;\n            		În scopuri de asigurare;\n            		În scopul monitorizării și evaluării conformității cu politicile și standardele noastre;\n            		În orice scop aferent și/sau auxiliar oricărora dintre cele de mai sus sau orice alt scop pentru care datele dumneavoastră cu caracter personal ne-au fost furnizate.  \n            În cazul în care ne-ați acordat consimțământul dumneavoastră, vă putem prelucra datele cu caracter personal și în următoarele scopuri:\n            		Comunicarea cu dumneavoastră prin canalele pe care le-ați aprobat pentru a vă ține la curent în ceea ce privește evenimente/informații cu privire la serviciile, produsele precum și evenimente și proiecte TIFF;\n            		Sondaje în rândul clienților/partenerilor/colaboratorilor, campanii de marketing, analiză de piață, tombole, concursuri sau alte activități sau evenimente promoționale.\n            În ceea ce privește comunicările legate de marketing/informare cu privire la evenimente, vă vom pune la dispoziție – dacă se impune în mod legal – informațiile respective doar după ce ați selectat această opțiune de a participa și vă vom oferi posibilitatea de a nu mai participa în orice moment, în cazurile în care nu doriți să mai primiți comunicări legate de marketing/informare cu privire la evenimente din partea noastră.\n            Nu vom folosi datele dumneavoastră cu caracter personal în luarea unor decizii automate care să vă afecteze sau să creeze alte profiluri decât cele descrise mai sus.  \n\n            		TRANSMITEREA DATELOR DUMNEAVOASTRĂ CU CARACTER PERSONAL\n\n            Vă putem partaja datele cu caracter personal obținute de la dumneavoastră în următoarele împrejurări:\n            		Vă putem comunica datele de contact cu titlu confidențial către terți în scopul obținerii unui feedback din partea dumneavoastră cu privire la prestarea serviciilor de către societate, pentru a ne ajuta la măsurarea performanței noastre și îmbunătățirea și promovarea serviciilor noastre;\n            		Vă putem partaja datele cu caracter personal cu societăți care prestează servicii pentru controale împotriva spălării banilor, reducerea riscului de credit și în alte scopuri de prevenire a fraudelor și infracțiunilor și societăți care prestează servicii similare, inclusiv instituții financiare, birouri de credit și autorități de reglementare cu care sunt partajate datele respective;\n            		Vă putem partaja datele cu caracter personal cu orice terț căruia îi cesionăm sau novăm orice drepturi sau obligații;\n            		De asemenea, putem folosi date cu caracter personal agreate și statistici în scopul monitorizării folosirii website-ului pentru a ne ajuta la dezvoltarea website-ului și serviciilor noastre.\n            De asemenea, vă putem partaja datele cu caracter personal cu persoanele noastre împuternicite - în principal prestatori de servicii din cadrul sau din afara Bsharkr, pe plan intern sau internațional, ex. centre de servicii comune, în vederea prelucrării datelor cu caracter personal în Scopurile Permise, în numele nostru și doar în conformitate cu instrucțiunile noastre. Vom păstra controlul asupra datelor dumneavoastră cu caracter personal și vom folosi măsuri corespunzătoare de protecție, conform legii aplicabile, pentru a asigura integritatea și securitatea datelor dumneavoastră cu caracter personal în momentul solicitării respectivilor prestatori de servicii;\n            Cu excepția celor de mai sus, vă vom divulga datele cu caracter personal doar când ne instruiți sau ne acordați permisiunea, când ni se impune prin legea aplicabilă sau reglementări sau cereri ale organelor judiciare sau oficiale să procedăm astfel, sau astfel cum se impune în vederea investigării unor activități frauduloase sau infracționale, efective sau suspectate.\n\n            		DATE CU CARACTER PERSONAL PE CARE NI LE FURNIZAȚI CU PRIVIRE LA ALTE PERSOANE FIZICE\n\n            În cazul în care ne furnizați date cu caracter personal cu privire la o altă persoană (cum ar fi unul dintre administratorii sau salariații dumneavoastră, sau o persoană cu care aveți relații profesionale), trebuie să vă asigurați că aveți dreptul de a ne divulga aceste date cu caracter personal și că, fără a mai lua alte măsuri, putem colecta, folosi și divulga acele date cu caracter personal, așa cum se descrie în prezenta Politică de prelucrare a datelor cu character personal.\n            În special, trebuie să vă asigurați că persoana fizică în cauză are cunoștință de aspectele diverse tratate în prezenta Politică de prelucrare a datelor cu caracter personal, așa cum acestea privesc persoana fizică respectivă, inclusiv identitatea noastră, modul în care ne poate contacta, scopurile în care colectăm, practicile noastre de divulgare a datelor cu caracter personal (inclusiv divulgarea către destinatari din străinătate), dreptul persoanei fizice de a obține acces la datele cu caracter personal și de a depune plângeri cu privire la gestionarea datelor cu caracter personal, și consecințele nefurnizării datelor cu caracter personal (cum ar fi imposibilitatea noastră de a presta servicii).  \n\n            		PĂSTRAREA SECURITĂȚII DATELOR DUMNEAVOASTRĂ CU CARACTER PERSONAL\n\n            Am implementat măsuri tehnice și organizatorice pentru păstrarea confidențialității și securității datelor dumneavoastră cu caracter personal, în conformitate cu procedurile noastre interne cu privire la stocarea, divulgarea și accesarea datelor cu caracter personal. Datele cu caracter personal pot fi păstrate pe sistemele noastre tehnologice de date cu caracter personal, acelea alea contractorilor noștri sau în format tipărit.\n\n            		TRANSFERUL DATELOR DUMNEAVOASTRĂ CU CARACTER PERSONAL ÎN STRĂINĂTATE\n\n            În situații excepționale, în temeiul Scopurilor Permise, vă putem transfera datele cu caracter personal în țări care nu au fost recunoscute de Comisia Europeană ca asigurând un nivel corespunzător de protecție.\n            Ne vom asigura că aceste transferuri internaționale sunt efectuate sub rezerva unor măsuri de protecție corespunzătoare sau potrivite, așa cum se impune prin Regulamentul General privind Protecția Datelor (UE) 2016/679 sau alte legi aplicabile. Aceasta include încheierea de Clauze Contractuale Standard UE. Ne puteți contacta în orice moment, folosind datele de contact de mai jos, dacă doriți informații suplimentare cu privire la aceste măsuri de protecție.\n\n            		ACTUALIZAREA DATELOR CU CARACTER PERSONAL CU PRIVIRE LA DUMNEAVOASTRĂ\n\n            În cazul în care oricare dintre datele cu caracter personal pe care ni le-ați furnizat suferă modificări, spre exemplu dacă vă schimbați prenumele, numele sau adresa de e-mail sau dacă doriți să anulați orice fel de cerere către noi, sau dacă luați cunoștință de faptul că deținem orice date cu caracter personal incorecte cu privire la dumneavoastră, vă rugăm să ne anunțați prin comunicarea unui e-mail la "
                                ,style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 11 * prefs.getDouble('height'),
                                    fontWeight: FontWeight.w300)),
                                    TextSpan(
                                text: " bhsarkr.on@gmail.com.",
                                style: TextStyle(
                                    color: mainColor,
                                    fontSize: 11 * prefs.getDouble('height'),
                                    fontWeight: FontWeight.w300)),
                             TextSpan(
                                text:
                                    " Nu vom fi răspunzători pentru nicio pierdere decurgând din Date cu Caracter Personal incorecte, neautentice, insuficiente sau incomplete pe care ni le furnizați.\n            În același timp, vom lua măsuri juste pentru actualizarea periodică a registrelor noastre cu privire la datele dumneavoastră cu caracter personal, dar nu vom fi răspunzători pentru nicio modificare neprevăzută a datelor dumneavoastră cu caracter personal.\n\n            		PERIOADA DE STOCARE A DATELOR  DUMNEAVOASTRĂ CU CARACTER PERSONAL\n\n            Datele dumneavoastră cu caracter personal vor fi șterse sau eliminate atunci când nu mai sunt necesare în mod rezonabil în Scopurile Permise sau atunci când vă retrageți consimțământul (în situația în care acesta a fost acordat) și nu mai există obligația legală de a continua operațiunea de  stocare a datelelor personale.\n            Cu excepția cazului în care ne solicitați în mod expres să stocăm datele dumneavoastră cu caracter personal pe termen mai lung, datele cu caracter personal vor fi șterse în termen de maximum 30 de zile de la data la care contul din aplicație este șters. \n\n            		DREPTURILE DUMNEAVOASTRĂ ÎN LEGĂTURĂ CU PRELUCRAREA DATELOR CU CARACTER PERSONAL\n\n            Potrivit dispozițiilor legale aplicabile și sub rezerva anumitor condiții legale, aveți următoarele drepturi în legătură cu prelucrarea datelor dumneavoastră cu caracter personal:  \n            		Dreptul de acces, care include dreptul de a ști dacă prelucrăm date despre dumneavoastră și  dreptul de a afla care sunt acestea, cui sunt transferate, cât timp vor fi păstrate, unde le-am obținut și dacă se folosesc pentru profilare/decizii automatizate.\n            ",
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 11 * prefs.getDouble('height'),
                                    fontWeight: FontWeight.w300)),
                            
                            TextSpan(
                                text:
                                    "		Dreptul la rectificare. Dacă datele pe care le avem sunt incorecte, trebuie să le corectăm (mai puțin în cazul în care le prelucrăm pentru altcineva. În acest caz, vă vom informa cui trebuie să trimiteți cererea dumneavoastră.).\n            		Dreptul la ștergere („dreptul de a fi uitat”) la cerere, vom șterge datele dumneavoastră personale cât mai repede posibil, dacă 1) nu mai sunt necesare pentru scopul în care sunt obținute sau 2) dacă vă retrageți consimțământul pentru prelucrarea acestor date/dacă aveți obiecții privind prelucrarea (mai puțin dacă ni le trebuie pentru un litigiu, executarea unui contract sau obligații legale). De asemenea, dacă descoperim că avem o obligație legală de ștergere sau dacă prelucrarea ar fi nelegală, le vom șterge. Dacă datele sunt prelucrate și de terți, vom lua măsuri rezonabile de a le informa despre cererea de ștergere.\n            		Dreptul la restrângerea procesării, dacă ele sunt nelegale, presupus incorecte, contestate, sau nu mai sunt necesare.\n            		Dreptul la informare.  Vă informăm cât mai clar despre drepturile dumneavoastră în domeniul datelor personale, și despre ce date prelucrăm despre dumneavoastră. sau (dacă e cazul) împărțim cu terți.  \n            		Dreptul la portare. Dacă vă prelucrăm datele personale în mod automatizat, în bază de consimțământ sau contract, ne puteți cere sa vi le dăm în format si vă vom răspunde solicitării într-un termen rezonabil.\n            		Dreptul de a obiecta. Ne puteți indica dacă doriți să nu mai prelucrăm datele dvs personale. Vom da curs cererii dvs dacă nu putem demonstra interese legitime suficiente. În orice caz, datele procesate pentru marketing direct vor fi șterse la cerere.\n            		Dreptul de a nu face obiectul unei decizii bazate exclusiv pe prelucrarea automată, inclusiv crearea de profiluri, cu excepția cazului în care ați dat un consimțământ explicit sau dacă ele sunt necesare pentru executarea unui contract.\n            		Dreptul de a depune o plângere la o autoritate de supraveghere, în România este vorba despre ANSPDCP (Autoritatea Națională de Supraveghere a Prelucrării Datelor cu Caracter Personal), web: www.dataprotection.ro, e-mail: anspdcp@dataprotection.ro.\n            De asemenea aveți și următoarele drepturi:\n            		dreptul de a solicita o copie a datelor cu caracter personal referitoare la dumneavoastră pe care le deținem; în cazul în care vă exercitați acest drept într-un mod care este evident abuziv sau nefondat, ne rezervăm dreptul la rambursarea costurilor necesare suportate pentru prelucrarea copiilor respective și pentru remiterea copiilor într-o perioadă de timp rezonabilă;\n            		dreptul la rectificarea oricăror date cu caracter personal incorecte și dreptul la opoziție sau la restricționarea utilizării de către noi a datelor dumneavoastră cu caracter personal;\n            		puteți de asemenea să faceți o plângere dacă sunteți preocupat de modul în care gestionăm datele dumneavoastră cu caracter personal;\n            		dreptul la ștergerea datelor dumneavoastră cu caracter personal, în situațiile în care v-ați retras consimțământul, prelucrarea nu mai este necesară sau prelucrarea respectivă este contrară legii.\n            Dacă doriți să procedați în sensul celor de mai sus, vă rugăm să ne transmiteți un e-mail la adresa ",
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 11 * prefs.getDouble('height'),
                                    fontWeight: FontWeight.w300)),
                            TextSpan(
                                text: " bhsarkr.on@gmail.com.",
                                style: TextStyle(
                                    color: mainColor,
                                    fontSize: 11 * prefs.getDouble('height'),
                                    fontWeight: FontWeight.w300)),
                            TextSpan(
                                text:
                                    " Este posibil să vă cerem să vă dovediți identitatea comunicându-ne o copie a unui mijloc valabil de identificare pentru a ne conforma cu obligațiile de securitate pe care le avem și a împiedica divulgarea neautorizată a datelor.\n            Vom lua în considerare orice solicitări sau plângeri pe care le primim și vă vom transmite un răspuns în timp util. Dacă nu sunteți mulțumit de răspunsul nostru, puteți înainta plângerea către Autoritatea Națională de Supraveghere a Prelucrării Datelor cu Caracter Personal – cu sediul în Bd. Gheorghe Magheru nr. 28-30, București, România. \n\n            		ACTUALIZĂRI ALE ACESTEI POLITICI DE PRELUCRARE A DATELOR CU CARACTER PERSONAL\n\n            Cea mai recentă actualizare a acestei Politici de prelucrare a datelor cu caracter personal a fost realizată în luna august 2020. Ne rezervăm dreptul de a actualiza și modifica periodic această Politică de prelucrare a date, pentru a reflecta orice modificări ale modului în care prelucrăm datele dumneavoastră cu caracter personal sau orice modificări ale cerințelor legale. În cazul oricărei astfel de modificări, vom afișa pe website-ul nostru versiunea modificată a Politicii privind datele cu caracter personal și/sau o vom pune la dispoziție în alt mod.\n\n            		DATE DE CONTACT\n\n            Dacă doriți să ne contactați în legătură cu orice întrebări, observații sau solicitări legate de Politica de prelucrare a datelor cu caracter personal, vă rugăm să ne transmiteți un e-mail la adresa",
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 11 * prefs.getDouble('height'),
                                    fontWeight: FontWeight.w300)),
                            TextSpan(
                                text: " bhsarkr.on@gmail.com.",
                                style: TextStyle(
                                    color: mainColor,
                                    fontSize: 11 * prefs.getDouble('height'),
                                    fontWeight: FontWeight.w300)),
                          ],
                        ),
                      ),
                    )),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 32 * prefs.getDouble('height'),
                  ),
                  Container(
                    height: 36 * prefs.getDouble('height'),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 32 * prefs.getDouble('width'),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Romania Support",
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              letterSpacing: -0.408,
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14 * prefs.getDouble('height'),
                            ),
                          ),
                          Text(
                            "ro.bsharkr.supp@gmail.com",
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                letterSpacing: -0.408,
                                fontSize: 14 * prefs.getDouble('height'),
                                color: mainColor),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 1.0 * prefs.getDouble('height'),
                    color: Color(0xff57575E),
                  ),
                  SizedBox(
                    height: 32 * prefs.getDouble('height'),
                  ),
                  Container(
                    height: 36 * prefs.getDouble('height'),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 32 * prefs.getDouble('width'),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Norway Support",
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              letterSpacing: -0.408,
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14 * prefs.getDouble('height'),
                            ),
                          ),
                          Text(
                            "no.bsharkr.supp@gmail.com",
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                letterSpacing: -0.408,
                                fontSize: 14 * prefs.getDouble('height'),
                                color: mainColor),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 1.0 * prefs.getDouble('height'),
                    color: Color(0xff57575E),
                  ),
                  SizedBox(
                    height: 32 * prefs.getDouble('height'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 32 * prefs.getDouble('width'),
                    ),
                    child: Text(
                      "App published by:",
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 13 * prefs.getDouble('height'),
                          letterSpacing: -0.078),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                        left: 32 * prefs.getDouble('width'),
                      ),
                      child: Text(
                        "BSHARKR Company S.R.L | CUI: 42637930",
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 13 * prefs.getDouble('height'),
                            letterSpacing: -0.078),
                      )),
                  Padding(
                      padding: EdgeInsets.only(
                        left: 32 * prefs.getDouble('width'),
                      ),
                      child: Text(
                        "Str. Oltenitei, no 63, Sector 4, Bucharest, Romania",
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 13 * prefs.getDouble('height'),
                            letterSpacing: -0.078),
                      )),
                  SizedBox(
                    height: 8 * prefs.getDouble('height'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 32 * prefs.getDouble('width'),
                    ),
                    child: Text(
                      "Copyright 2020 - BSHARKR Company S.R.L - All rights reserved",
                      style: TextStyle(
                          letterSpacing: 0.066,
                          color: Colors.white.withOpacity(0.4),
                          fontSize: 11 * prefs.getDouble('height'),
                          fontFamily: 'Roboto'),
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
