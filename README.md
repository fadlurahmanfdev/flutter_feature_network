# Overview

`flutter_feature_network` is a library designed to simplify and enhance network operations in
Flutter applications.
This library provides a suite of tools and methods to manage network requests efficiently, including
Dio client setup, logging, request identification, and SSL security.

## Methods

#### Get Dio Client

Generate Dio Client For HTTP Transaction.

```dart
final dioClient = FeatureNetworkRepositoryImpl().getDioClient();
// or
final dioClient = FlutterFeatureNetwork.getDioClient();
```

| Parameter Name            | Type              | Required | Description                                                                                                                                                   |
|---------------------------|-------------------|----------|---------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `receiveTimeout`          | Duration          | no       | The maximum amount of time the client will wait to receive data from the server.                                                                              |
| `connectTimeout`          | Duration          | no       | The maximum amount of time allowed for the client to establish a connection to the server.                                                                    |
| `sendTimeout`             | Duration          | no       | The maximum amount of time allowed for the client to send the request data to the server.                                                                     |
| `baseUrl`                 | String            | no       | The base URL for all requests made by this client.                                                                                                            |
| `headers`                 | String            | no       | The default headers to be included in every request.                                                                                                          |
| `interceptors`            | List<Interceptor> | no       | A list of interceptors that will be added to the Dio client for request/response modifications.                                                               |
| `trustedCertificateBytes` | List<int>         | no       | A list of bytes representing trusted certificates for SSL pinning. <br> Only one of `trustedCertificateBytes` or `allowedFingerprints` allowed. </br>         |
| `allowedFingerprints`     | List<String>      | no       | A list of allowed SSL certificate SHA fingerprints for secure connections. <br> Only one of `trustedCertificateBytes` or `allowedFingerprints` allowed. </br> |

#### Is Connection Secure

This is will checked if the connection using certificate is secure.

if connection is secure, it will return true, otherwise it will return false.

```dart
final isSecure = FeatureNetworkRepositoryImpl().isConnectionSecure(
  serverUrl: 'https://jsonplaceholder.typicode.com/',
  sha: SHA.SHA_256,
  allowedSHAFingerprints: [
    '14f9996f9481eac7f9c005f6954c2f032d8e9cb13d4440ebed35f14bed22c43f',
  ],
);
// or
final isSecure = FlutterFeatureNetwork.isConnectionSecure(
  serverUrl: 'https://jsonplaceholder.typicode.com/',
  sha: SHA.SHA_256,
  allowedSHAFingerprints: [
    '14f9996f9481eac7f9c005f6954c2f032d8e9cb13d4440ebed35f14bed22c43f',
  ],
);
```

| Parameter Name        | Type         | Required | Description                                                                 |
|-----------------------|--------------|----------|-----------------------------------------------------------------------------|
| `baseUrl`             | String       | true     | The URL of the server to check the connection against.                      |
| `sha`                 | SHA          | true     | The hashing algorithm used (e.g., SHA_256) for the certificate fingerprint. |
| `allowedFingerprints` | List<String> | true     | A list of allowed SHA fingerprints for SSL certificates.                    |

#### Check HttpCertificatePinning

This is will checked if the connection using certificate is secure.

```dart
FeatureNetworkRepositoryImpl().checkHttpCertificatePinning(
  serverUrl: 'https://jsonplaceholder.typicode.com/',
  sha: SHA.SHA_256,
  allowedSHAFingerprints: [
    '14f9996f9481eac7f9c005f6954c2f032d8e9cb13d4440ebed35f14bed22c43f',
  ],
);
// or
FlutterFeatureNetwork.checkHttpCertificatePinning(
  serverUrl: 'https://jsonplaceholder.typicode.com/',
  sha: SHA.SHA_256,
  allowedSHAFingerprints: [
    '14f9996f9481eac7f9c005f6954c2f032d8e9cb13d4440ebed35f14bed22c43f',
  ],
);
```

| Parameter Name        | Type         | Required | Description                                                                 |
|-----------------------|--------------|----------|-----------------------------------------------------------------------------|
| `baseUrl`             | String       | true     | The URL of the server to check the connection against.                      |
| `sha`                 | SHA          | true     | The hashing algorithm used (e.g., SHA_256) for the certificate fingerprint. |
| `allowedFingerprints` | List<String> | true     | A list of allowed SHA fingerprints for SSL certificates.                    |

### Plugin FlutterFeatureNetwork

#### Get Http Certificate Bytes By Asset

This is will checked if the connection using certificate is secure.

```dart
final certificateBytes = FlutterFeatureNetwork.getCertificateBytesFromAsset(assethPath: 'asset/certificate.pem');
```

| Parameter Name | Type   | Required | Description                 |
|----------------|--------|----------|-----------------------------|
| `assethPath`   | String | true     | The location of asset path. |


### Others

#### Alice

Alice is an HTTP Inspector tool for Flutter which helps debugging http requests. It catches and
stores http requests and responses, which can be viewed via simple UI.
It's forked from: https://pub.dev/packages/alice

<table>
  <tr>
    <td>
		<img width="250px" src="https://raw.githubusercontent.com/fadlurahmanfdev/flutter_feature_network/master/media/alice_notification.png">
    </td>
    <td>
       <img width="250px" src="https://raw.githubusercontent.com/fadlurahmanfdev/flutter_feature_network/master/media/alice_page.png">
    </td>
  </tr>
</table>

```dart
// Setup Alice
final alice = Alice(showNotification: true, showInspectorOnShake: true);
// Put in Material App
@override
Widget build(BuildContext context) {
  return MaterialApp(
    navigatorKey: alice.getNavigatorKey(),
    title: 'Flutter Feature Network',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      useMaterial3: true,
    ),
    home: const MainPage(),
  );
}
```

#### Logger Interceptor

Logger interceptor is an interceptor for debugging request & response in terminal. It help developer to debugging HTTP.

<table>
  <tr>
    <td>
		<img width="250px" src="https://raw.githubusercontent.com/fadlurahmanfdev/flutter_feature_network/master/media/logger_interceptor_request.png">
    </td>
    <td>
       <img width="250px" src="https://raw.githubusercontent.com/fadlurahmanfdev/flutter_feature_network/master/media/logger_interceptor_response_success.png">
    </td>
  </tr>
</table>

```dart
final dio = FeatureNetworkRepositoryImpl().getDioClient(
  // ...
  interceptors: [
    LoggerInterceptor(),
  ],
  // ...
);
// or
final dio = FlutterFeatureNetwork.getDioClient(
  // ...
  interceptors: [
    LoggerInterceptor(),
  ],
  // ...
);
```

