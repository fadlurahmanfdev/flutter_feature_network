# Overview

`flutter_feature_network` is a library designed to simplify and enhance network operations in Flutter
applications.
This library provides a suite of tools and methods to manage network requests efficiently, including
Dio client setup, logging, request identification, and SSL security.

## Methods

### Get Dio Client

Only one of `trustedCertificateBytes` or `allowedFingerprints` allowed.

```dart

final dioClient = FeatureNetworkRepositoryImpl().getDioClient();
```

| Parameter Name            | Type              | Required | Description                                                                                     |
|---------------------------|-------------------|----------|-------------------------------------------------------------------------------------------------|
| `receiveTimeout`          | Duration          | no       | The maximum amount of time the client will wait to receive data from the server.                |
| `connectTimeout`          | Duration          | no       | The maximum amount of time allowed for the client to establish a connection to the server.      |
| `sendTimeout`             | Duration          | no       | The maximum amount of time allowed for the client to send the request data to the server.       |
| `baseUrl`                 | String            | no       | The base URL for all requests made by this client.                                              |
| `headers`                 | String            | no       | The default headers to be included in every request.                                            |
| `interceptors`            | List<Interceptor> | no       | A list of interceptors that will be added to the Dio client for request/response modifications. |
| `trustedCertificateBytes` | List<int>         | no       | A list of bytes representing trusted certificates for SSL pinning.                              |
| `allowedFingerprints`     | List<String>      | no       | A list of allowed SSL certificate SHA fingerprints for secure connections.                      |

### Is Connection Secure

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
```

| Parameter Name        | Type         | Required | Description                                                                 |
|-----------------------|--------------|----------|-----------------------------------------------------------------------------|
| `baseUrl`             | String       | true     | The URL of the server to check the connection against.                      |
| `sha`                 | SHA          | true     | The hashing algorithm used (e.g., SHA_256) for the certificate fingerprint. |
| `allowedFingerprints` | List<String> | true     | A list of allowed SHA fingerprints for SSL certificates.                    |

### Check Is Connection Secure

This is will checked if the connection using certificate is secure.

```dart

final isSecure = FeatureNetworkRepositoryImpl().checkIsConnectionSecure(
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


