import 'package:flutter/material.dart';

class ExpandableBox extends StatefulWidget {
  final String title;
  final String content;
  final IconData icon;
  final Color color;

  const ExpandableBox({
    Key? key,
    required this.title,
    required this.content,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  State<ExpandableBox> createState() => _ExpandableBoxState();
}

class _ExpandableBoxState extends State<ExpandableBox> {
  
  @override
  Widget build(BuildContext context) {
    double scrwidth = MediaQuery.of(context).size.width;
    double scrheight = MediaQuery.of(context).size.height;

    return Container(
      width: scrwidth*0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        // border: Border.all(),
        color: Colors.white,
      ),
      child: ExpansionTile(
        childrenPadding: EdgeInsets.all(20),
        tilePadding: EdgeInsets.only(left: 20,right: 20,top: 5,bottom: 5),
        iconColor: widget.color,
        title: Row(
          children: [
            Icon(widget.icon,
              color: widget.color,
              size: 40,
            ),
            SizedBox(width: 14.0),
            Text(widget.title,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: widget.color,
              ),
            
            ),
          ],
        ),
        // leading: Icon(Icons.arrow_forward),
        children: <Widget>[
          // Nội dung mở rộng
          Text(widget.content,
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w500,
              height: 1.5,
              color: widget.color,
            ),
          ),
        ],
      ),
    );
  }
}
