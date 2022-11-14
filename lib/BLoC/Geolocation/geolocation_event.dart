


part of  'geolocation_bloc.dart';

abstract class GeolocationEvent extends Equatable {
  const GeolocationEvent();

  @override
  List<Object?> get props => [];

}
class  LoadGeolocation extends GeolocationEvent {}
class  UpdateGeolocation extends GeolocationEvent {

  final Address address;
  const UpdateGeolocation({required this.address});

  @override
  List<Object?> get props => [address];

}
