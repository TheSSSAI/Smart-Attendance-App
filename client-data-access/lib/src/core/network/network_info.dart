/// An abstract contract for checking network connectivity.
///
/// This abstraction allows the data layer (repositories) to depend on a contract
/// rather than a concrete implementation of a connectivity package. This improves
/// testability by allowing network status to be easily mocked.
abstract class NetworkInfo {
  /// Returns `true` if the device is connected to the internet (WiFi or mobile data),
  /// otherwise returns `false`.
  Future<bool> get isConnected;
}