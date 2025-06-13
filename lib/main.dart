import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran/quran.dart' as quran;
import 'package:just_audio/just_audio.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Flutter Projects"),
          bottom: TabBar(
            indicatorColor: Colors.red,
            labelColor: Colors.red,
            unselectedLabelColor: Colors.grey,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(text: "Mushaf"),
              Tab(text: "Pdf Quranic Books "),
            ],
          ),
        ),
        body: TabBarView(children: [SurahScreen(), BookListSCR()]),
      ),
    );
  }
}

class SurahScreen extends StatefulWidget {
  const SurahScreen({super.key});

  @override
  State<SurahScreen> createState() => _SurahScreenState();
}

class _SurahScreenState extends State<SurahScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          "assets/QURAN.png",
          width: 100,
          height: 100,
        ),
      ),
      body: ListView.builder(
        itemCount: 114,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => detailsurah(index + 1),
                ),
              );
            },
            leading: CircleAvatar(
                      backgroundColor: Color(0xFF00ACC2),
                foregroundColor: Colors.white,
              child: Text("${index + 1}"),
            ),
            title:Text(quran.getSurahNameArabic(index+1),style: GoogleFonts.amiriQuran(),),
            subtitle: Text(quran.getSurahName(index+1)),
            trailing: Column(
              children: [
                quran.getPlaceOfRevelation(index+1)=="kaaba"?
                Image.asset("assets/kaaba.png",width: 30,
                          height: 30,):
                          Image.asset("assets/madina.png", 
                           width: 30,
                          height: 30,),
                        Text("verses"+quran.getVerseCount(index+1).toString()),
              ],),
          );
        },
      ),
    );
  }
}
class detailsurah extends StatefulWidget {
 var surahnumber;

  
  detailsurah(this.surahnumber, {super.key});

  @override
  State<detailsurah> createState() => _detailsurahState();
}

class _detailsurahState extends State<detailsurah> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          quran.getSurahNameArabic(widget.surahnumber),
          style: GoogleFonts.amiriQuran(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: ListView.builder(
            itemCount: quran.getVerseCount(widget.surahnumber),
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  quran.getVerse(widget.surahnumber, index + 1, verseEndSymbol: true),
                  textAlign: TextAlign.right,
                  style: GoogleFonts.amiri(),
                ),
                subtitle: Text(
                  quran.getVerseTranslation(widget.surahnumber, index + 1,
                      translation: quran.Translation.urdu),
                  textAlign: TextAlign.right,
                  style: GoogleFonts.notoNastaliqUrdu(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
class audio extends StatefulWidget {
  var surahnumber;
 audio(this.surahnumber,{super.key});

  @override
  State<audio> createState() => _audioState();
}

class _audioState extends State<audio> {
  AudioPlayer audioPlayer = AudioPlayer();
  IconData playpausebtn =Icons.play_arrow_rounded;
  bool isplaying = true;

  ToggleButton()async{
    final audiourl = await quran.getAudioURLBySurah(widget.surahnumber);
    audioPlayer.setUrl(audiourl);
if(isplaying){
  audioPlayer.play();
  setState(() {
    isplaying=false;
     playpausebtn = Icons.pause;
  });
}else{
  audioPlayer.pause();
  setState(() {
    isplaying=true;
     playpausebtn = Icons.play_arrow_rounded;
  });
}
  }
 @override
 void dispose(){
  super.dispose();
  audioPlayer.dispose();
 }
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(quran.getSurahNameArabic(widget.surahnumber),style: GoogleFonts.amiriQuran(fontSize: 30),
          ),
          CircleAvatar(radius: 100,  backgroundColor: Color(0xFF2596BE),backgroundImage: AssetImage("assets/alafasy.jpg"),),
          Container(width: double.infinity,color: Color(0xFF2596BE),child: IconButton(onPressed: ToggleButton, icon: Icon(
            playpausebtn,color: Colors.white,
          )),),
          ],
        ),
      ),
    );
  }
}
class buttonscreen extends StatefulWidget {
  const buttonscreen({super.key});

  @override
  State<buttonscreen> createState() => _buttonscreenState();
}

class _buttonscreenState extends State<buttonscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>SurahScreen(),));},
           child: Text("Read Quran")),SizedBox(height: 16,),

          ElevatedButton(onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (context)=>audioscreen()));}, 
          child: Text("listen Quran")),SizedBox(height: 16,),
        ],
        ),
      ),
    );
  }
}

class audioscreen extends StatefulWidget {
  const audioscreen({super.key});

  @override
  State<audioscreen> createState() => _audioscreenState();
}

class _audioscreenState extends State<audioscreen> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          "assets/QURAN.png",
          width: 100,
          height: 100,
        ),
      ),
      body: ListView.builder(
        itemCount: 114,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => audio(index + 1),
                ),
              );
            },
            leading: CircleAvatar(
               backgroundColor: Color(0xFF00ACC2),
                foregroundColor: Colors.white,
              child: Text("${index + 1},"),
            ),
            
            title:Text(quran.getSurahNameArabic(index+1),style: GoogleFonts.amiriQuran(),), 
            subtitle: Text("Sheikh Mishary",style: GoogleFonts.openSans(fontSize: 14, color: Colors.grey[700]),),
            trailing: Column(
              children: [
                quran.getPlaceOfRevelation(index+1)=="kaaba"?
                Image.asset("assets/kaaba.png",width: 30,
                          height: 30,):
                          Image.asset("assets/madina.png", 
                           width: 30,
                          height: 30,),
                        Text("verses"+quran.getVerseCount(index+1).toString()),
              ],),
          );
        },
      ),
    );
  }
}


class BookListSCR extends StatefulWidget {
  const BookListSCR({super.key});

  @override
  State<BookListSCR> createState() => _BookListSCRState();
}
class _BookListSCR extends State<BookListSCR> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BookListSCR(), 
    );
  }
}

class _BookListSCRState extends State<BookListSCR> {
  List bookList = [
    {"name": "Tafseer of Suratul Fatihah ", "location": "assets/Book1.pdf"},
    {"name": "Foundation Of The Sunnah", "location": "assets/Book2.pdf"},
    {"name": "The Compilation Of Hadeeth", "location": "assets/Book3.pdf"},
    {"name": "Why do we pray?", "location": "assets/Book4.pdf"},
    {"name": "Men Around The Messenger ", "location": "assets/Book5.pdf"},
    {"name": "Adorning Knowlege with Actions", "location": "assets/Book6.pdf"},
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: bookList.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PdfSCR(index)),
              );
            },
            leading: CircleAvatar(child: Text("${index + 1}")),
            title: Text(bookList[index]["name"]),
          );
        },
      ),
    );
  }
}

class PdfSCR extends StatefulWidget {
  var bookNumber;
  PdfSCR(this.bookNumber, {super.key});

  @override
  State<PdfSCR> createState() => _PdfSCRState();
}

class _PdfSCRState extends State<PdfSCR> {
  List bookList = [
    {"name": "Tafseer of Suratul Fatihah ", "location": "assets/Book1.pdf"},
    {"name": "Foundation Of The Sunnah", "location": "assets/Book2.pdf"},
    {"name": "The Compilation Of Hadeeth", "location": "assets/Book3.pdf"},
    {"name": "Why do we pray?", "location": "assets/Book4.pdf"},
    {"name": "Men Around The Messenger ", "location": "assets/Book5.pdf"},
    {"name": "Adorning Knowlege with Actions", "location": "assets/Book6.pdf"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfPdfViewer.asset(bookList[widget.bookNumber]["location"]),
    );
   

  }
}