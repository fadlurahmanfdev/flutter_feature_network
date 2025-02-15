# Overview

Networking library to support API Request by dio package & simplified SSL Security operation.

# Table Of Content
* [Key Feature](#key-feature) 
* [Get Started](#get-started)
* [Import](#import)
* [Generate Dio Client](#generate-dio-client)
* [Check Whether Connection Secure](#check-whether-connection-secure) 
* [Get Pem Certificate](#get-pem-certificate-bytes-from-asset) 
* [Example](#example)

## Key Feature

- Get Dio client with custom configurable SSL security
- HTTP Certificate Pinning Check
- Pem File Certificate Check

## Get Started

### Import

```dart
import 'package:networx/networx.dart';
```

## Feature

### Generate Dio Client

Generate Dio Client For API Request.

```dart
final rawDio = NetworxDio.getClient(
  dio: Dio(BaseOptions(
    baseUrl: 'https://jsonplaceholder.typicode.com/',
    headers: {
      // HttpHeaders.userAgentHeader: userAgent,
    },
  )),
);
```

| Parameter Name                        | Type                                 | Required  | Description                                                                                                                                                   |
|---------------------------------------|--------------------------------------|-----------|---------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `dio`                                 | Dio                                  | yes       | The Dio client. The client can configure on their own for dio base option, `networx` just config for SSL Security.                                            |
| `prefixInterceptors`                  | List<Interceptor>                    | no        | The interceptors added in the first section before the other interceptor.                                                                                     |
| `suffixInterceptors`                  | List<Interceptor>                    | no        | The interceptors added in the last section after all the other interceptor.                                                                                   |
| `trustedCertificateBytes`             | List<int>                            | no        | The pem certificate for ssl checking in bytes type. <br> Only one of `trustedCertificateBytes` or `allowedFingerprints` allowed. </br>                        |
| `customHandshakeSSLInterceptor`       | NetworxHandshakeSSLInterceptor       | no        | Custom interceptor for pem certificate checking. <br> Only one of `trustedCertificateBytes` or `customHandshakeSSLInterceptor` allowed. </br>                 |
| `allowedFingerprints`                 | List<String>                         | no        | A list of allowed SSL certificate SHA fingerprints for secure connections. <br> Only one of `trustedCertificateBytes` or `allowedFingerprints` allowed. </br> |
| `customCertificatePinningInterceptor` | NetworxCertificatePinningInterceptor | no        | Custom interceptor for check http certificate pinning. <br> Only one of `allowedFingerprints` or `customCertificatePinningInterceptor` allowed. </br>         |

### Check Whether Connection Secure

This is will checked if the connection using certificate is secure.

if connection is secure, it will return true, otherwise it will return false.

```dart
final isSecure = NetworxSecurity.isConnectionSecure(
  serverUrl: 'https://jsonplaceholder.typicode.com/',
  sha: SHA.SHA_256,
  allowedSHAFingerprints: [
    '14f9996f9481eac7f9c005f6954c2f032d8e9cb13d4440ebed35f14bed22c43f',
  ],
);
```

| Parameter Name        | Type         | Required | Description                                                                 |
|-----------------------|--------------|----------|-----------------------------------------------------------------------------|
| `serverUrl`           | String       | true     | The URL of the server to check the connection against.                      |
| `sha`                 | SHA          | true     | The hashing algorithm used (e.g., SHA_256) for the certificate fingerprint. |
| `allowedFingerprints` | List<String> | true     | A list of allowed SHA fingerprints for SSL certificates.                    |
| `timeout`             | int          | yes      | how long it take to stop process.                                           |

### Get PEM Certificate Bytes from Asset

This is will checked if the connection using certificate is secure.

```dart
final certificateBytes = NetworxUtils.getCertificateBytesFromAsset(assethPath: 'asset/certificate.pem');
```

| Parameter Name | Type   | Required | Description                 |
|----------------|--------|----------|-----------------------------|
| `assethPath`   | String | true     | The location of asset path. |

# Example

For detail example, check the example app [example](https://github.com/fadlurahmanfdev/flutter_feature_network/blob/dev-split-networking/example/lib/main.dart)

