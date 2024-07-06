import 'dart:convert';

class DictDTO {
  final int dogCode;
  final String dogName;
  final String dogSize;
  final String dogSummary;
  final String dogHeightM;
  final String dogWeightM;
  final String dogHeightF;
  final String dogWeightF;
  final String dogChild;
  final String dogYouth;
  final String dogEld;
  final String dogDisease;
  final int dogDrool;
  final int dogSocial;
  final int dogShed;
  final int dogBark;
  final int dogPet;
  final int dogHot;
  final int dogCold;
  final int dogHouse;
  final int dogGroom;
  final int dogActi;
  final String dogImage;
  final String dogDetail;

  DictDTO(
      {required this.dogCode,
      required this.dogName,
      required this.dogSize,
      required this.dogSummary,
      required this.dogHeightM,
      required this.dogWeightM,
      required this.dogHeightF,
      required this.dogWeightF,
      required this.dogChild,
      required this.dogYouth,
      required this.dogEld,
      required this.dogDisease,
      required this.dogDrool,
      required this.dogSocial,
      required this.dogShed,
      required this.dogBark,
      required this.dogPet,
      required this.dogHot,
      required this.dogCold,
      required this.dogHouse,
      required this.dogGroom,
      required this.dogActi,
      required this.dogImage,
      required this.dogDetail});

  factory DictDTO.fromJson(var jsonData) {
    return DictDTO(
      dogCode: jsonData['dogCode'],
      dogName: jsonData['dogName'],
      dogSize: jsonData['dogSize'],
      dogSummary: jsonData['dogSummary'],
      dogHeightM: jsonData['dogHeightM'],
      dogWeightM: jsonData['dogWeightM'],
      dogHeightF: jsonData['dogHeightF'],
      dogWeightF: jsonData['dogWeightF'],
      dogChild: jsonData['dogChild'],
      dogYouth: jsonData['dogYouth'],
      dogEld: jsonData['dogEld'],
      dogDisease: jsonData['dogDisease'],
      dogDrool: jsonData['dogDrool'],
      dogSocial: jsonData['dogSocial'],
      dogShed: jsonData['dogShed'],
      dogBark: jsonData['dogBark'],
      dogPet: jsonData['dogPet'],
      dogHot: jsonData['dogHot'],
      dogCold: jsonData['dogCold'],
      dogHouse: jsonData['dogHouse'],
      dogGroom: jsonData['dogGroom'],
      dogActi: jsonData['dogActi'],
      dogImage: jsonData['dogImage'],
      dogDetail: jsonData['dogDetail'],
    );
  }
}
