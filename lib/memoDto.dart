class MemoDTO {
  final int myDogCode;
  final String myDogDate;
  final String myDogLocation;
  final String myDogMemo;

  MemoDTO({
    required this.myDogCode,
    required this.myDogDate,
    required this.myDogLocation,
    required this.myDogMemo,
  });

  factory MemoDTO.fromJson(var jsonData) {
    return MemoDTO(
      myDogCode: jsonData['myDogCode'],
      myDogDate: jsonData['myDogDate'],
      myDogLocation: jsonData['myDogLocation'],
      myDogMemo: jsonData['myDogMemo'],
    );
  }
}
