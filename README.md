# Networx

Networx is a extended add-on for Dio, current main capabilities is to validate SPKI (Subject Public Key Pinning Info) & Certificate from Server.

## Install

Add the package to your app, then import it:

```dart
import 'package:networx/networx.dart';
```

## Pin with a certificate hash

Use this when you want the connection to match **one exact certificate**. If the server issues a new cert, update the hash.

```dart
final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));
dio.httpClientAdapter = NetworxPinningClientAdapter(
  pinningHash: [
    '5c5106f35c5fd16f524258c4635db8b55ba89bf262ccca72e1dc0b7be5580231',
  ],
);

final response = await dio.get('/profile');
```

## Pin with a public-key (SPKI) hash

Use this when certificates rotate, but the same key is reused. The pin stays valid until the server changes its key.

```dart
final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));
dio.httpClientAdapter = NetworxPinningClientAdapter(
  pinningHash: [
    'fj/LGYZh+mUuNimcCT6b6V6MLFW1SIzcsM4hgwSwVB4=',
  ],
);

final response = await dio.get('/profile');
```

The adapter accepts both formats in the same list. A request is allowed when **either** the certificate hash or the SPKI pin matches.

## Trust a PEM file

Use this when you already have the server certificate and want the app to trust that file only — not the full public CA list.

```dart
final pem = await NetworxPinningUtils.getCertificateBytesFromAsset(
  assetPath: 'assets/api_cert.pem',
);

final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));
dio.httpClientAdapter = NetworxPinningClientAdapter(
  certificateBytes: pem,
);

final response = await dio.get('/profile');
```

Declare the PEM in `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/api_cert.pem
```

## Read hashes from a live certificate

When you have an `X509Certificate` from a TLS handshake, turn it into pins you can store and reuse.

```dart
final certHash = NetworxPinningUtils.getHash(certificate);
final spkiPin = NetworxPinningUtils.getSpkiPin(certificate);
```

- `getHash` is the SHA-256 of the full certificate. Best when the cert itself must not change.
- `getSpkiPin` is the public-key pin. Best when you expect the cert to renew with the same key.

## Log API traffic

Use this in development to see what left the device and what came back. Turn flags off before you ship if logs should not include payloads.

```dart
final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));
dio.interceptors.add(
  LoggerInterceptor(
    showLogRequest: true,
    showLogResponse: true,
    showLogError: true,
  ),
);
```

## Put it together

A typical production client pins the public key and keeps logs for debug builds only:

```dart
import 'package:flutter/foundation.dart';
import 'package:networx/networx.dart';

final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));
dio.httpClientAdapter = NetworxPinningClientAdapter(
  pinningHash: ['fj/LGYZh+mUuNimcCT6b6V6MLFW1SIzcsM4hgwSwVB4='],
);

if (kDebugMode) {
  dio.interceptors.add(LoggerInterceptor());
}
```

## Try the sample app

The example app walks through each flow: a normal request, a matching pin, a wrong pin, a matching PEM, and a wrong PEM. Open [example/lib/main.dart](https://github.com/fadlurahmanfdev/flutter_feature_network/blob/dev-split-networking/example/lib/main.dart) and run it to see what the user would see when a request is allowed or blocked.
