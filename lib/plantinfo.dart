import 'dart:convert';
import 'package:flutter/services.dart';


class PlantInfo {
  final int id;
  final String name;
  final String image;
  final String plantType;
  final String matureSize;
  final String bloomTime;
  final String color;
  final String soilType;
  final String soilPH;
  final String plantOverview;
  final String howToGrow;
  final String light;
  final String soil;
  final String water;

  PlantInfo({
    required this.id,
    required this.name,
    required this.image,
    required this.plantType,
    required this.matureSize,
    required this.bloomTime,
    required this.color,
    required this.soilType,
    required this.soilPH,
    required this.plantOverview,
    required this.howToGrow,
    required this.light,
    required this.soil,
    required this.water,
  });

  factory PlantInfo.fromJson(Map<String, dynamic> json) {
    return PlantInfo(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      plantType: json['Plant type'],
      matureSize: json['Mature size'],
      bloomTime: json['Bloom time'],
      color: json['Color'],
      soilType: json['Soil type'],
      soilPH: json['Soil PH'],
      plantOverview: json['Plant overview'],
      howToGrow: json['How to grow'],
      light: json['light'],
      soil: json['Soil'],
      water: json['Water'],
    );
  }


}
