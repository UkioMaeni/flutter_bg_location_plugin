class LocationServiceMeta{
  int tickerSeconds;
  int  tickersCount;
  String  hash;
  int  orderId;
  LocationServiceMeta({
    required this.tickerSeconds,
    required this.tickersCount,
    required this.hash,
    required this.orderId,
  });

  factory LocationServiceMeta.fromMap(Map<String,dynamic> meta){
    return LocationServiceMeta(
      tickerSeconds: meta["tickerSeconds"]??0,
      tickersCount: meta["tickersCount"]??0,
      hash: meta["hash"]??"",
      orderId: meta["orderId"]??0,
    );
  }
  
  factory LocationServiceMeta.nullable(){
    return LocationServiceMeta(
      tickerSeconds: 0,
      tickersCount: 0,
      hash: "",
      orderId:0,
    );
  }
}