// ignore_for_file: file_names

class UserModel {
  String Name;
  String SicilNo;
  String phoneNum;
  String surname;

  UserModel(this.Name,this.SicilNo,this.phoneNum,this.surname);


  UserModel.fromMap(Map<String, dynamic>map)
  :
  Name = map['Name'],
  SicilNo = map['SicilNo'],
  phoneNum = map['phoneNum'],
  surname = map['surname'];

  String goString(){
    return 'UserModel{userName: $Name,sicilNo: $SicilNo,phoneNum: $phoneNum,surname: $surname,}';
  }

  getUserName(){
    return Name;
  }

}