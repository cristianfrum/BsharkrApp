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
                                  "            POLITICA PRIVIND PRELUCRAREA DATELOR CU CARACTER PERSONAL A BSHARKR Company S.R.L\n\n            Politica privind prelucrarea datelor cu caracter personal descrie categoriile de date pe care le prelucr??m, modalitatea ??i scopurile ??n care le colect??m, ??n ce situa??ii transfer??m date cu caracter personal ??i diversele drepturi ??i op??iuni de care dispune??i ??n acest sens. Politica noastr?? privind prelucrarea datelor cu caracter personal detaliaz?? modul ??n care prelucr??m datele cu caracter personal ??n exercitarea activit????ii specifice privind organizarea, desf????urarea ??i promovarea Bsharkr Company S.R.L. ??i cel mai adesea pentru conturile personale de client sau antrenor din aplicatia Bsharkr.\n\n            		OPERATORUL DATELOR DUMNEAVOASTR?? CU CARACTER  PERSONAL\n\n            Bsharkr Company S.R.L., persoana juridica romana, cu sediul in Bucuresti, Sos. Oltenitei nr. 63, bloc 3, Sector 4 ??n calitate de proprietar al aplicatiei Bsharkr este operatorul datelor dumneavoastr?? cu caracter personal.\n\n            		OPERATORI ASOCIA??I\n\n             ??n cazul ??n care doi sau mai mul??i operatori stabilesc ??n comun scopurile ??i mijloacele de prelucrare, ace??tia sunt operatori asocia??i. Ei stabilesc ??ntr-un mod transparent responsabilit????ile fiec??ruia ??n ceea ce prive??te ??ndeplinirea obliga??iilor care le revin ??n temeiul prezentului regulament, ??n special ??n ceea ce prive??te exercitarea drepturilor persoanelor vizate ??i ??ndatoririle fiec??ruia de furnizare a informa??iilor legale.\n            Datele cu caracter personal pe care le prelucr??m pot include:\n            		Informa??ii de contact, cum ar fi numele dumneavoastr??, denumirea postului, adresa po??tal??, inclusiv adresa de domiciliu, ??n cazul ??n care ne-a??i comunicat-o, adresa profesional??, num??rul de telefon, num??rul de telefon mobil, num??rul de fax ??i adresa de e-mail;\n            		Informa??ii suplimentare prelucrate ??n mod obligatoriu ??n vederea ??ncheierii sau exercit??rii unui raport contractual sau comunicate ??n mod voluntar de c??tre dumneavoastr??, cum ar fi instruc??iuni acordate, pl????i efectuate, solicit??ri ??i proiecte;\n            		Informa??ii colectate din surse publice;\n            		Diploma sau acreditare de orice fel ce are ca scop dovedirea absolvirii unui curs pentru antrenori;\n            		Alte date cu caracter personal necesare ??n scopul inform??rii dumneavoastr?? dac?? se dovedesc relevante activit????ii pe care o desf????ur??m care se ??ncadreaz?? ??n interesul legitim al operatorului;\n            ??n situa??ii limitate, ??n care pentru  desf????urarea activit????ii noastre, trebuie s?? colect??m categorii speciale de date cu caracter personal astfel cum  sunt ele reg??site ??n cadrul art. 9 al Regulamentului privind protec??ia persoanelor fizice  ??n ceea ce prive??te prelucrarea datelor cu caracter personal ??i libera circula??ie a acestor date (???GDPR???), respectiv codul numeric personal,  imaginile dumneavoastr??, date privind calitatea dumneavoastr?? de membru al unei asocia??ii profesionale sau comerciale sau unui sindicat, date de s??n??tate cu caracter personal, date cu privire la opiniile dumneavoastr?? politice ??i date privind cazierul judiciar, prelucrarea se va face doar:\n            i. pe baza consim????m??ntului prealabil expres al dumneavoastr?? sau pe baza dovezii juste a consim????m??ntului dumneavoastr?? furnizate de o ter???? persoan?? care ne comunic?? aceste date;\n            ii. ??n baza unei obliga??ii legal?? de prelucrare a acestor categorii de date;\n            iii.  ??n baza unei obliga??ii care ap??r?? un drept legitim;\n            		Adrese IP. Site-urile colec??ioneaz?? adrese IP (Internet Protocol). O adres?? IP este un num??r, asignat calculatorului dvs. de c??tre furnizorul dvs de internet, ce v?? permite accesarea internetului. O adres?? IP poate fi o dat?? personal??. Folosim adrese IP pentru a diagnostica probleme cu servere, raportarea informa??iilor sub form?? agregat??, determinarea celei mai eficiente conexiuni cu site-ul nostru ??i pentru administrarea ??i ??mbun??t????irea site-ului.\n            		Cookies. Site-urile folosesc ???cookies???. Un cookie este un mic fi??ier text, p??strat pe calculatorul, tableta sau telefonul dvs. c??nd deschide??i un site web, ce ajut?? site-ul s?? v?? recunoasc??, inclusiv preferin??ele dvs. Unele cookie-uri sunt ??terse atunci c??nd ??nchide??i browser-ul. Acestea se numesc session cookies. Altele r??m??n pe device-ul dvs p??n?? expir?? sau p??n?? le ??terge??i din cache-ul dvs. Acestea se numesc persistent cookies, ce ne permit s?? re??inem informa??ii despre vizitatori recuren??i. Cookie-urile pe care le folosim ne permit s?? recunoa??tem ??i s?? num??r??m vizitatorii prezen??i, ??i s?? vedem pe unde se duc vizitatorii pe site. Astfel, putem s?? ??mbun??t????im func??ionarea site-urilor, de exemplu prin organizarea lor astfel ??nc??t utilizatorii g??sesc u??or ce caut??. Cookie-urile noastre ne permit de asemenea s?? personaliz??m con??inutul vizualizat de dvs, ??n func??ie de preferin??ele indicate de dvs.\n            		Adresa e-mail. Dac?? v?? abona??i la alertele trimise prin e-mail sau confirmati men??inerea  abonarii anterioare datei de 17 iulie 2020, colect??m adresa dvs. de e-mail. Aceast?? adres?? se folose??te doar pentru informarea pe care a??i cerut-o/confirmat-o. Dac?? dori??i s?? v?? dezabona??i, o pute??i face ??n orice moment folosind indica??iile din fiecare e-mail pe care ??l primi??i, sau prin trimiterea unui e-mail la info@tiff.ro.\n            		MODALITATEA ??N CARE COLECT??M DATELE DUMNEAVOASTR?? CU CARACTER PERSONA\n            Putem colecta date cu caracter personal cu privire la dumneavoastr?? ??n anumite ??mprejur??ri, inclusiv:\n            		??n momentul ??n care dumneavoastr?? sau  organiza??ia dumneavoastr?? se angajeaz?? ??n rela??ii de natur?? contractual?? cu noi;\n            		??n momentul ??n care ne comunica??i dumneavoastr?? sau organiza??ia dumneavoastr?? voluntar, din orice motiv, datele dumneavoastr?? cu caracter personal;\n            		??n momentul ??n care naviga??i, solicita??i informa??ii sau interac??iona??i, sau organiza??ia dumneavoastr?? navigheaz??, solicit?? informa??ii sau interac??ioneaz?? in aplicatia Bsharkr;\n            		??n momentul ??n care participa??i la un  eveniment organizat de c??tre noi care presupune oferirea din partea dumneavoastr?? a datelor cu caracter personal;\n            ??n anumite ??mprejur??ri, colect??m date cu caracter personal cu privire la dumneavoastr?? de la o surs?? ter????. Spre exemplu, putem colecta date cu caracter personal de la organiza??ia dumneavoastr??, alte organiza??ii cu care ave??i leg??turi, agen??ii guvernamentale, birouri de credit, furnizori de informa??ii sau servicii sau din arhive publice sau parteneri/colaboratori cu care avem stabilite rela??ii de natur?? contractual?? care presupun, printre altele partajarea bazelor noastre de date. \n            ??n anumite ??mprejur??ri, colect??m date cu caracter personal cu privire la dumneavoastr?? de la o surs?? ter????. Spre exemplu, putem colecta date cu caracter personal de la organiza??ia dumneavoastr??, alte organiza??ii cu care ave??i leg??turi, agen??ii guvernamentale, birouri de credit, furnizori de informa??ii sau servicii sau din arhive publice sau parteneri/colaboratori cu care avem stabilite rela??ii de natur?? contractual?? care presupun, printre altele partajarea bazelor noastre de date. \n            Orice opera??iune care echivaleaz?? cu o prelucrare (colectare, stocare, ??nregistrare, structurare, adaptare sau modificare, extragere, consultare, utilizare, divulgare prin transmitere, distrugere) a datelor dumneavoastr?? cu caracter personal va fi efectuat?? pe baza unuia dintre temeiurile juridice de mai jos:\n            		Prelucrarea este necesar?? ??n vederea execut??rii unui contract la care dumneavoastr?? sunte??i parte sau organiza??ia dumneavoastr?? este parte, sau prelucrarea respectiv?? este necesar?? ??n vederea ??ncheierii unui contract cu dumneavoastr?? sau organiza??ia dumneavoastr??;\n            		Prelucrarea este necesar?? ??n vederea execut??rii unui contract la care dumneavoastr?? sunte??i parte sau organiza??ia dumneavoastr?? este parte, sau prelucrarea respectiv?? este necesar?? ??n vederea ??ncheierii unui contract cu dumneavoastr?? sau organiza??ia dumneavoastr??;\n            		Prelucrarea este efectuat?? ??n temeiul consim????m??ntului dumneavoastr?? prin selectarea casutei la ??nregistrarea ??n aplica??ie;\n            		Prelucrarea este efectuat?? ??n temeiul consim????m??ntului dumneavoastr?? prin selectarea casutei la ??nregistrarea ??n aplica??ie;\n            		Prelucrarea este necesar?? ??n scopul intereselor noastre legitime sau ale unui ter??, cu excep??ia cazurilor ??n care interesele sau drepturile ??i libert????ile dumneavoastr?? fundamentale prevaleaz?? asupra acestor interese.\n            ??n cazurile ??n care dispozi??iile legale aplicabile impun consim????m??ntul dumneavoastr?? prealabil ??i explicit pentru prelucrarea unor categorii speciale de date, vom prelucra datele respective doar ??n temeiul consim????m??ntului dumneavoastr?? prealabil ??i explicit. ??n acela??i timp, ne vom lua garan??ii suplimentare c?? orice persoan?? fizic?? sau entitate care ne comunic?? datele dumneavoastr?? speciale cu caracter personal a ob??inut ??n prealabil consim????m??ntul dumneavoastr??.\n\n            		POLITIC?? DE CONFIDEN??IALITATE PRIVIND UTILIZAREA APLICA??IEI OFICIALE Bsharkr\n\n            Aplica??ia Bsharkr este dezvoltat?? ??i men??inut?? de societatea Bsharkr Company S.R.L.\n            Aplica??ia Bsharkr este dezvoltat?? ??i men??inut?? de societatea Bsharkr Company S.R.L.\n            Procesarea datelor personale ??n aplica??ie\n            Pentru a face tranzac??ii ??n interiorul aplica??iei cu scopul de a cump??ra trofee in vederea administrarii contului de antrenor, aplica??ia v?? transmite c??tre  partenerul de tranzac??ii pentru a asigura o comunicare securizat??. Pentru mai multe informa??ii, v?? rug??m s?? consulta??i documentul Politica de confiden??ialitate a serviciului.\n            Datele generate de dvs. prin utilizarea aplica??iei sunt depersonalizate ??i stocate de c??tre servicii externe pentru a putea ??mbun??t????i func??ionalit????ile aplica??iei ??i performan??a acesteia.\n            Serviciile de monitorizare folosite pentru aplica??ie sunt:\n            Firebase - Politica de confiden??ialitate\n            Flutter - Politica de confiden??ialitate\n            Stocarea datelor personale\n            		COLECTAREA  DATELOR CU CARACTER PERSONAL ALE MINORILOR\n            		SCOPURILE ??N CARE SE VOR PRELUCRA   DATELE DUMNEAVOASTR?? CU CARACTER PERSONAL\n            V?? putem folosi datele cu caracter personal doar ??n urm??toarele scopuri (???Scopuri Permise???): \n            ",
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
                                    "		Respectarea obliga??iilor noastre legale (cum ar fi obliga??ii de p??strare a eviden??elor), obliga??ii de verificare a conformit????ii sau de ??nregistrare care ar putea include verific??ri automate ale datelor dumneavoastr?? de contact sau alte informa??ii pe care ni le furniza??i cu privire la identitatea dumneavoastr?? cu liste aplicabile ale persoanelor sanc??ionate ??i contactarea dumneavoastr?? pentru confirmarea identit????ii dumneavoastr?? ??n cazul unui posibil rezultat pozitiv, sau ??nregistrarea interac??iunii cu dumneavoastr?? care ar putea fi relevant?? ??n scopuri de conformare;\n            		Pentru utilizarea conturilor din aplicatie, atat de client cat si de antrenor definite ???Client??? si ???Trainer;\n            		Scopuri precum reclam??, marketing ??i publicitate, statistic?? exclusiv ??n interesul operatorului sau ??mputernici??ilor s??i, organizarea de cursuri, seminarii, alte evenimente (inclusiv delega??ii, conferin??e ??i t??rguri), ??n scop educa??ional pentru organizarea programelor de formare profesional??, pentru emiterea oric??ror documente financiar-contabile, ??ncheierea de contracte ori alte acte necesare ??n activitatea Bsharkr;\n            		Analizarea ??i ??mbun??t????irea serviciilor ??i comunic??rilor noastre c??tre dumneavoastr??;\n            		Protejarea securit????ii ??i gestionarea accesului la sediul nostru, sistemele IT ??i de comunicare, platformele online, website-urile ??i celelalte sisteme, prevenirea ??i detectarea amenin????rilor de securitate, fraudelor sau a altor activit????i infrac??ionale sau mali??ioase;\n            		??n scopuri de asigurare;\n            		??n scopul monitoriz??rii ??i evalu??rii conformit????ii cu politicile ??i standardele noastre;\n            		??n orice scop aferent ??i/sau auxiliar oric??rora dintre cele de mai sus sau orice alt scop pentru care datele dumneavoastr?? cu caracter personal ne-au fost furnizate.  \n            ??n cazul ??n care ne-a??i acordat consim????m??ntul dumneavoastr??, v?? putem prelucra datele cu caracter personal ??i ??n urm??toarele scopuri:\n            		Comunicarea cu dumneavoastr?? prin canalele pe care le-a??i aprobat pentru a v?? ??ine la curent ??n ceea ce prive??te evenimente/informa??ii cu privire la serviciile, produsele precum ??i evenimente ??i proiecte TIFF;\n            		Sondaje ??n r??ndul clien??ilor/partenerilor/colaboratorilor, campanii de marketing, analiz?? de pia????, tombole, concursuri sau alte activit????i sau evenimente promo??ionale.\n            ??n ceea ce prive??te comunic??rile legate de marketing/informare cu privire la evenimente, v?? vom pune la dispozi??ie ??? dac?? se impune ??n mod legal ??? informa??iile respective doar dup?? ce a??i selectat aceast?? op??iune de a participa ??i v?? vom oferi posibilitatea de a nu mai participa ??n orice moment, ??n cazurile ??n care nu dori??i s?? mai primi??i comunic??ri legate de marketing/informare cu privire la evenimente din partea noastr??.\n            Nu vom folosi datele dumneavoastr?? cu caracter personal ??n luarea unor decizii automate care s?? v?? afecteze sau s?? creeze alte profiluri dec??t cele descrise mai sus.  \n\n            		TRANSMITEREA DATELOR DUMNEAVOASTR?? CU CARACTER PERSONAL\n\n            V?? putem partaja datele cu caracter personal ob??inute de la dumneavoastr?? ??n urm??toarele ??mprejur??ri:\n            		V?? putem comunica datele de contact cu titlu confiden??ial c??tre ter??i ??n scopul ob??inerii unui feedback din partea dumneavoastr?? cu privire la prestarea serviciilor de c??tre societate, pentru a ne ajuta la m??surarea performan??ei noastre ??i ??mbun??t????irea ??i promovarea serviciilor noastre;\n            		V?? putem partaja datele cu caracter personal cu societ????i care presteaz?? servicii pentru controale ??mpotriva sp??l??rii banilor, reducerea riscului de credit ??i ??n alte scopuri de prevenire a fraudelor ??i infrac??iunilor ??i societ????i care presteaz?? servicii similare, inclusiv institu??ii financiare, birouri de credit ??i autorit????i de reglementare cu care sunt partajate datele respective;\n            		V?? putem partaja datele cu caracter personal cu orice ter?? c??ruia ??i cesion??m sau nov??m orice drepturi sau obliga??ii;\n            		De asemenea, putem folosi date cu caracter personal agreate ??i statistici ??n scopul monitoriz??rii folosirii website-ului pentru a ne ajuta la dezvoltarea website-ului ??i serviciilor noastre.\n            De asemenea, v?? putem partaja datele cu caracter personal cu persoanele noastre ??mputernicite - ??n principal prestatori de servicii din cadrul sau din afara Bsharkr, pe plan intern sau interna??ional, ex. centre de servicii comune, ??n vederea prelucr??rii datelor cu caracter personal ??n Scopurile Permise, ??n numele nostru ??i doar ??n conformitate cu instruc??iunile noastre. Vom p??stra controlul asupra datelor dumneavoastr?? cu caracter personal ??i vom folosi m??suri corespunz??toare de protec??ie, conform legii aplicabile, pentru a asigura integritatea ??i securitatea datelor dumneavoastr?? cu caracter personal ??n momentul solicit??rii respectivilor prestatori de servicii;\n            Cu excep??ia celor de mai sus, v?? vom divulga datele cu caracter personal doar c??nd ne instrui??i sau ne acorda??i permisiunea, c??nd ni se impune prin legea aplicabil?? sau reglement??ri sau cereri ale organelor judiciare sau oficiale s?? proced??m astfel, sau astfel cum se impune ??n vederea investig??rii unor activit????i frauduloase sau infrac??ionale, efective sau suspectate.\n\n            		DATE CU CARACTER PERSONAL PE CARE NI LE FURNIZA??I CU PRIVIRE LA ALTE PERSOANE FIZICE\n\n            ??n cazul ??n care ne furniza??i date cu caracter personal cu privire la o alt?? persoan?? (cum ar fi unul dintre administratorii sau salaria??ii dumneavoastr??, sau o persoan?? cu care ave??i rela??ii profesionale), trebuie s?? v?? asigura??i c?? ave??i dreptul de a ne divulga aceste date cu caracter personal ??i c??, f??r?? a mai lua alte m??suri, putem colecta, folosi ??i divulga acele date cu caracter personal, a??a cum se descrie ??n prezenta Politic?? de prelucrare a datelor cu character personal.\n            ??n special, trebuie s?? v?? asigura??i c?? persoana fizic?? ??n cauz?? are cuno??tin???? de aspectele diverse tratate ??n prezenta Politic?? de prelucrare a datelor cu caracter personal, a??a cum acestea privesc persoana fizic?? respectiv??, inclusiv identitatea noastr??, modul ??n care ne poate contacta, scopurile ??n care colect??m, practicile noastre de divulgare a datelor cu caracter personal (inclusiv divulgarea c??tre destinatari din str??in??tate), dreptul persoanei fizice de a ob??ine acces la datele cu caracter personal ??i de a depune pl??ngeri cu privire la gestionarea datelor cu caracter personal, ??i consecin??ele nefurniz??rii datelor cu caracter personal (cum ar fi imposibilitatea noastr?? de a presta servicii).  \n\n            		P??STRAREA SECURIT????II DATELOR DUMNEAVOASTR?? CU CARACTER PERSONAL\n\n            Am implementat m??suri tehnice ??i organizatorice pentru p??strarea confiden??ialit????ii ??i securit????ii datelor dumneavoastr?? cu caracter personal, ??n conformitate cu procedurile noastre interne cu privire la stocarea, divulgarea ??i accesarea datelor cu caracter personal. Datele cu caracter personal pot fi p??strate pe sistemele noastre tehnologice de date cu caracter personal, acelea alea contractorilor no??tri sau ??n format tip??rit.\n\n            		TRANSFERUL DATELOR DUMNEAVOASTR?? CU CARACTER PERSONAL ??N STR??IN??TATE\n\n            ??n situa??ii excep??ionale, ??n temeiul Scopurilor Permise, v?? putem transfera datele cu caracter personal ??n ????ri care nu au fost recunoscute de Comisia European?? ca asigur??nd un nivel corespunz??tor de protec??ie.\n            Ne vom asigura c?? aceste transferuri interna??ionale sunt efectuate sub rezerva unor m??suri de protec??ie corespunz??toare sau potrivite, a??a cum se impune prin Regulamentul General privind Protec??ia Datelor (UE) 2016/679 sau alte legi aplicabile. Aceasta include ??ncheierea de Clauze Contractuale Standard UE. Ne pute??i contacta ??n orice moment, folosind datele de contact de mai jos, dac?? dori??i informa??ii suplimentare cu privire la aceste m??suri de protec??ie.\n\n            		ACTUALIZAREA DATELOR CU CARACTER PERSONAL CU PRIVIRE LA DUMNEAVOASTR??\n\n            ??n cazul ??n care oricare dintre datele cu caracter personal pe care ni le-a??i furnizat sufer?? modific??ri, spre exemplu dac?? v?? schimba??i prenumele, numele sau adresa de e-mail sau dac?? dori??i s?? anula??i orice fel de cerere c??tre noi, sau dac?? lua??i cuno??tin???? de faptul c?? de??inem orice date cu caracter personal incorecte cu privire la dumneavoastr??, v?? rug??m s?? ne anun??a??i prin comunicarea unui e-mail la "
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
                                    " Nu vom fi r??spunz??tori pentru nicio pierdere decurg??nd din Date cu Caracter Personal incorecte, neautentice, insuficiente sau incomplete pe care ni le furniza??i.\n            ??n acela??i timp, vom lua m??suri juste pentru actualizarea periodic?? a registrelor noastre cu privire la datele dumneavoastr?? cu caracter personal, dar nu vom fi r??spunz??tori pentru nicio modificare neprev??zut?? a datelor dumneavoastr?? cu caracter personal.\n\n            		PERIOADA DE STOCARE A DATELOR  DUMNEAVOASTR?? CU CARACTER PERSONAL\n\n            Datele dumneavoastr?? cu caracter personal vor fi ??terse sau eliminate atunci c??nd nu mai sunt necesare ??n mod rezonabil ??n Scopurile Permise sau atunci c??nd v?? retrage??i consim????m??ntul (??n situa??ia ??n care acesta a fost acordat) ??i nu mai exist?? obliga??ia legal?? de a continua opera??iunea de  stocare a datelelor personale.\n            Cu excep??ia cazului ??n care ne solicita??i ??n mod expres s?? stoc??m datele dumneavoastr?? cu caracter personal pe termen mai lung, datele cu caracter personal vor fi ??terse ??n termen de maximum 30 de zile de la data la care contul din aplica??ie este ??ters. \n\n            		DREPTURILE DUMNEAVOASTR?? ??N LEG??TUR?? CU PRELUCRAREA DATELOR CU CARACTER PERSONAL\n\n            Potrivit dispozi??iilor legale aplicabile ??i sub rezerva anumitor condi??ii legale, ave??i urm??toarele drepturi ??n leg??tur?? cu prelucrarea datelor dumneavoastr?? cu caracter personal:  \n            		Dreptul de acces, care include dreptul de a ??ti dac?? prelucr??m date despre dumneavoastr?? ??i  dreptul de a afla care sunt acestea, cui sunt transferate, c??t timp vor fi p??strate, unde le-am ob??inut ??i dac?? se folosesc pentru profilare/decizii automatizate.\n            ",
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 11 * prefs.getDouble('height'),
                                    fontWeight: FontWeight.w300)),
                            
                            TextSpan(
                                text:
                                    "		Dreptul la rectificare. Dac?? datele pe care le avem sunt incorecte, trebuie s?? le corect??m (mai pu??in ??n cazul ??n care le prelucr??m pentru altcineva. ??n acest caz, v?? vom informa cui trebuie s?? trimite??i cererea dumneavoastr??.).\n            		Dreptul la ??tergere (???dreptul de a fi uitat???) la cerere, vom ??terge datele dumneavoastr?? personale c??t mai repede posibil, dac?? 1) nu mai sunt necesare pentru scopul ??n care sunt ob??inute sau 2) dac?? v?? retrage??i consim????m??ntul pentru prelucrarea acestor date/dac?? ave??i obiec??ii privind prelucrarea (mai pu??in dac?? ni le trebuie pentru un litigiu, executarea unui contract sau obliga??ii legale). De asemenea, dac?? descoperim c?? avem o obliga??ie legal?? de ??tergere sau dac?? prelucrarea ar fi nelegal??, le vom ??terge. Dac?? datele sunt prelucrate ??i de ter??i, vom lua m??suri rezonabile de a le informa despre cererea de ??tergere.\n            		Dreptul la restr??ngerea proces??rii, dac?? ele sunt nelegale, presupus incorecte, contestate, sau nu mai sunt necesare.\n            		Dreptul la informare.  V?? inform??m c??t mai clar despre drepturile dumneavoastr?? ??n domeniul datelor personale, ??i despre ce date prelucr??m despre dumneavoastr??. sau (dac?? e cazul) ??mp??r??im cu ter??i.  \n            		Dreptul la portare. Dac?? v?? prelucr??m datele personale ??n mod automatizat, ??n baz?? de consim????m??nt sau contract, ne pute??i cere sa vi le d??m ??n format si v?? vom r??spunde solicit??rii ??ntr-un termen rezonabil.\n            		Dreptul de a obiecta. Ne pute??i indica dac?? dori??i s?? nu mai prelucr??m datele dvs personale. Vom da curs cererii dvs dac?? nu putem demonstra interese legitime suficiente. ??n orice caz, datele procesate pentru marketing direct vor fi ??terse la cerere.\n            		Dreptul de a nu face obiectul unei decizii bazate exclusiv pe prelucrarea automat??, inclusiv crearea de profiluri, cu excep??ia cazului ??n care a??i dat un consim????m??nt explicit sau dac?? ele sunt necesare pentru executarea unui contract.\n            		Dreptul de a depune o pl??ngere la o autoritate de supraveghere, ??n Rom??nia este vorba despre ANSPDCP (Autoritatea Na??ional?? de Supraveghere a Prelucr??rii Datelor cu Caracter Personal), web: www.dataprotection.ro, e-mail: anspdcp@dataprotection.ro.\n            De asemenea ave??i ??i urm??toarele drepturi:\n            		dreptul de a solicita o copie a datelor cu caracter personal referitoare la dumneavoastr?? pe care le de??inem; ??n cazul ??n care v?? exercita??i acest drept ??ntr-un mod care este evident abuziv sau nefondat, ne rezerv??m dreptul la rambursarea costurilor necesare suportate pentru prelucrarea copiilor respective ??i pentru remiterea copiilor ??ntr-o perioad?? de timp rezonabil??;\n            		dreptul la rectificarea oric??ror date cu caracter personal incorecte ??i dreptul la opozi??ie sau la restric??ionarea utiliz??rii de c??tre noi a datelor dumneavoastr?? cu caracter personal;\n            		pute??i de asemenea s?? face??i o pl??ngere dac?? sunte??i preocupat de modul ??n care gestion??m datele dumneavoastr?? cu caracter personal;\n            		dreptul la ??tergerea datelor dumneavoastr?? cu caracter personal, ??n situa??iile ??n care v-a??i retras consim????m??ntul, prelucrarea nu mai este necesar?? sau prelucrarea respectiv?? este contrar?? legii.\n            Dac?? dori??i s?? proceda??i ??n sensul celor de mai sus, v?? rug??m s?? ne transmite??i un e-mail la adresa ",
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
                                    " Este posibil s?? v?? cerem s?? v?? dovedi??i identitatea comunic??ndu-ne o copie a unui mijloc valabil de identificare pentru a ne conforma cu obliga??iile de securitate pe care le avem ??i a ??mpiedica divulgarea neautorizat?? a datelor.\n            Vom lua ??n considerare orice solicit??ri sau pl??ngeri pe care le primim ??i v?? vom transmite un r??spuns ??n timp util. Dac?? nu sunte??i mul??umit de r??spunsul nostru, pute??i ??nainta pl??ngerea c??tre Autoritatea Na??ional?? de Supraveghere a Prelucr??rii Datelor cu Caracter Personal ??? cu sediul ??n Bd. Gheorghe Magheru nr. 28-30, Bucure??ti, Rom??nia. \n\n            		ACTUALIZ??RI ALE ACESTEI POLITICI DE PRELUCRARE A DATELOR CU CARACTER PERSONAL\n\n            Cea mai recent?? actualizare a acestei Politici de prelucrare a datelor cu caracter personal a fost realizat?? ??n luna august 2020. Ne rezerv??m dreptul de a actualiza ??i modifica periodic aceast?? Politic?? de prelucrare a date, pentru a reflecta orice modific??ri ale modului ??n care prelucr??m datele dumneavoastr?? cu caracter personal sau orice modific??ri ale cerin??elor legale. ??n cazul oric??rei astfel de modific??ri, vom afi??a pe website-ul nostru versiunea modificat?? a Politicii privind datele cu caracter personal ??i/sau o vom pune la dispozi??ie ??n alt mod.\n\n            		DATE DE CONTACT\n\n            Dac?? dori??i s?? ne contacta??i ??n leg??tur?? cu orice ??ntreb??ri, observa??ii sau solicit??ri legate de Politica de prelucrare a datelor cu caracter personal, v?? rug??m s?? ne transmite??i un e-mail la adresa",
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
