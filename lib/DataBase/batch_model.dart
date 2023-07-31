import 'package:cloud_firestore/cloud_firestore.dart';

class BatchModel{
  final String? id;
  final String Date;
  final String BatchName;
  final String Breed;
  final String NumberOfBirds;
  final String CostPerBird;
  final String Supplier;

  const BatchModel({
    this.id,
    required this.Date,
    required this.BatchName,
    required this.Breed,
    required this.NumberOfBirds,
    required this.CostPerBird,
    required this.Supplier,

});

  toJson(){
    return {
      "BatchName":BatchName,
      "Breed":Breed,
      "CostPerBird":CostPerBird,
      "NoOfBirds":NumberOfBirds,
      "Supplier":Supplier,
      "date":Date};
  }

  factory BatchModel.fromSnapshot(DocumentSnapshot<Map<String,dynamic>> document){

    final data = document.data()!;

    return BatchModel(
        Date: data["date"],
        BatchName: data["BatchName"],
        Breed: data["Breed"],
        NumberOfBirds: data["NoOfBirds"],
        CostPerBird: data["CostPerBird"],
        Supplier: data["Supplier"]);
  }
  
}

