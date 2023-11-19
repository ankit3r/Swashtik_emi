class DataModel {
  final int id;
  final int loanNo;
  final int branchID;
  final String branchName;
  final String state;
  final String product;
  final String customerName;
  final String assetDesc;
  final String regNum;
  final String engineNum;
  final String chasisNum;
  final String podNum;
  final String officeAddress;
  final int officePincode;
  final String supervisorName1;
  final String supervisorName2;
  final String supervisorName3;
  final String createdAt;
  final String updatedAt;

  DataModel({
    required this.id,
    required this.loanNo,
    required this.branchID,
    required this.branchName,
    required this.state,
    required this.product,
    required this.customerName,
    required this.assetDesc,
    required this.regNum,
    required this.engineNum,
    required this.chasisNum,
    required this.podNum,
    required this.officeAddress,
    required this.officePincode,
    required this.supervisorName1,
    required this.supervisorName2,
    required this.supervisorName3,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      id: json['id'] ?? 0,
      loanNo: json['loan_no'] ?? 0,
      branchID: json['branchID'] ?? 0,
      branchName: json['branchName'] ?? "",
      state: json['state'] ?? "",
      product: json['product'] ?? "",
      customerName: json['customerName'] ?? "",
      assetDesc: json['assetDesc'] ?? "",
      regNum: json['regNum'] ?? "",
      engineNum: json['engineNum'] ?? "",
      chasisNum: json['chasisNum'] ?? "",
      podNum: json['podNum'] ?? "",
      officeAddress: json['officeAddress'] ?? "",
      officePincode: json['officePincode'] ?? 0,
      supervisorName1: json['supervisorName_1'] ?? "",
      supervisorName2: json['supervisorName_2'] ?? "",
      supervisorName3: json['supervisorName_3'] ?? "",
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
    );
  }
}
