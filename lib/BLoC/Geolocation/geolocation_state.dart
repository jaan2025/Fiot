
part of  'geolocation_bloc.dart';



abstract class GeolocationState extends Equatable{
  const GeolocationState();

  @override
  List<Object> get props => [];


}

class GeolocationLoading extends GeolocationState {}

class GeolocationLoaded extends GeolocationState {
  final Address address;
  GeolocationLoaded( this.address);

  @override
  List<Object> get props => [address];
}
class GeolocationError extends GeolocationState {

}