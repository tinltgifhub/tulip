import 'package:flutter/material.dart';
import 'package:rose/ExpandableBox.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:rose/plantinfo.dart';
import 'package:rose/PlantInfoService.dart';


class RoseScreen extends StatefulWidget {
  final int idx;
  const RoseScreen({
    super.key,
    required this.idx,
  });

  @override
  State<RoseScreen> createState() => _RoseScreenState();
}


class _RoseScreenState extends State<RoseScreen> {
  // Khai báo một danh sách chứa dữ liệu PlantInfo
  List<PlantInfo> plantInfoList = [];

  @override
  void initState() {
    super.initState();
      PlantInfoService.loadPlantInfo(widget.idx).then((data) {  
      setState(() {
        plantInfoList = data;
        // print(plantInfoList[0].name);
      });
    });
  
  }


  PlantInfo getPlantInfo(int index) {
  // Nếu plantInfoList không rỗng và index hợp lệ, trả về phần tử tại index đó
  if (plantInfoList.isNotEmpty && index >= 0 && index < plantInfoList.length) {
    return plantInfoList[index];
  }
  // Nếu không, trả về một giá trị mặc định hoặc thông báo lỗi tùy thuộc vào yêu cầu của bạn
    return PlantInfo(
        id: -1,
        name: "Loading",
        image: "assets/images/detect.jpg",
        plantType: "Loading",
        matureSize: "Loading",
        bloomTime: "Loading",
        color: "Loading",
        soilType: "Loading",
        soilPH: "Loading",
        plantOverview: "Loading",
        howToGrow: "Loading",
        light: "Loading",
        soil: "Loading",
        water: "Loading",
    );
  }


  Widget build(BuildContext context) {

  List<Color> bg1cols=[
    Color.fromARGB(255, 255, 255, 235),
    Color.fromARGB(255, 229, 255, 230),
    Color.fromARGB(255, 253, 228, 228),
    Color.fromARGB(255, 246, 255, 117),
    Color.fromARGB(255, 255, 236, 251),
  ];
  List<Color> textcols=[
    Color.fromARGB(255, 176, 179, 38),
    Color.fromARGB(255, 38, 122, 53),
    Color.fromARGB(255, 151, 46, 46),
    Color.fromARGB(255, 192, 168, 50),
    Color.fromARGB(255, 170, 76, 120),
  ];
  List<Color> bg2cols=[
    Color.fromARGB(255, 255, 255, 214),
    Color.fromARGB(255, 208, 253, 209),
    Color.fromARGB(255, 253, 182, 182),
    Color.fromARGB(255, 235, 249, 35),
    Color.fromARGB(255, 255, 184, 241),
  ];

  Color bg1 = bg1cols[widget.idx];
  Color textcol = textcols[widget.idx];
  Color bg2 = bg2cols[widget.idx]; 

  double scrwidth = MediaQuery.of(context).size.width;
  double scrheight = MediaQuery.of(context).size.height;


  TableRow buildTableRow(List<String> cells,bool isdark) {
    double h=70;
    if(cells[1].length>40){
      h=140;
    }
    else if(cells[1].length>30){
      h=120;
    }else if(cells[1].length>14){
      h=90;
    }
  return 
    TableRow(
      children: cells.asMap().entries.map((entry) {
          final index = entry.key;
          final cell = entry.value;
        return TableCell(
          child: Container(
            height: h,
            decoration: BoxDecoration(
              color: isdark ? bg1: bg2,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.all(20.0),  
            child: Text(cell, style: TextStyle(
              fontWeight:  index % 2 == 1 ? FontWeight.bold:FontWeight.normal,
              fontSize: 20,
              color: textcol,
              )
            ),
          ),
        );
      }).toList(),
    );
    
  }
  
  return Scaffold(
    body: GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          // print('objdfsdfsect');
          Navigator.pop(context);
        }
       },

      child: Container(
        color: bg1,
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40,),
              Container(
                // color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [ 
                    // IconButton(
                    //   icon: Icon(Icons.arrow_back),
                    //   onPressed: ()=>{},
                    //   color: textcol,       
                    // ),
                    // SizedBox(width: 90,),
                    Text(getPlantInfo(0).name,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: textcol,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
        
              ClipRRect(
                borderRadius: BorderRadius.circular(26),
                child: Container(
                  // margin: EdgeInsetsDirectional.symmetric(horizontal: 10),
                  width: scrwidth*0.95,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      image: AssetImage(getPlantInfo(0).image),
                      fit:BoxFit.cover, 
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40,),
        
              Table(
                border: TableBorder.symmetric(inside: BorderSide.none, outside: BorderSide.none),
                defaultColumnWidth: FixedColumnWidth(scrwidth*0.475),
                children: [
                  buildTableRow(['Loại cây', getPlantInfo(0).plantType],false),
                  buildTableRow(['Kích thước', getPlantInfo(0).matureSize],true),
                  buildTableRow(['Thời điểm nở hoa', getPlantInfo(0).bloomTime],false),
                  buildTableRow(['Màu sắc', getPlantInfo(0).color],true),
                  buildTableRow(['Loại đất', getPlantInfo(0).soilType],false),
                  buildTableRow(['Loại PH', getPlantInfo(0).soilPH],true),
                ],
              ),
              SizedBox(height: 20,),
            
              ExpandableBox(
                title: 'Mô tả',
                content: getPlantInfo(0).plantOverview,
                icon: Icons.info,
                color: textcol,
              ),
              SizedBox(height: 10,),
              ExpandableBox(
                title: 'Cách trồng',
                content: getPlantInfo(0).howToGrow,
                color: textcol,
                icon: Icons.health_and_safety,
              ),       
              SizedBox(height: 10,),
                  
              ExpandableBox(
                title: 'Ánh sáng',
                content: getPlantInfo(0).light,
                color: textcol,
                icon: Icons.access_alarm_rounded,
              ), 
              SizedBox(height: 10,),
    
              ExpandableBox(
                title: 'Đất',
                content: getPlantInfo(0).soil,
                color: textcol,
                icon: Icons.landscape,
              ), 
              SizedBox(height: 10,),
    
              ExpandableBox(
                title: 'Tưới nước',
                content: getPlantInfo(0).water,
                color: textcol,
                icon: Icons.water,
              ), 
              SizedBox(height: 10,),
    
              SizedBox(height: 100,),
    
            ],
          ),
        ),
      ),
    
    
    
    ),
  );
}
}


