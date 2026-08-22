enum ExampleFeature {
  fetchOk,
  correctCertificateHash,
  incorrectCertificateHash,
  correctSpkiHash,
  incorrectSpkiHash,
  correctCertBytes,
  incorrectCertBytes,
  burpSuite,
}

extension ExampleFeatureCopy on ExampleFeature {
  String get title {
    switch (this) {
      case ExampleFeature.fetchOk:
        return 'Fetch OK';
      case ExampleFeature.correctCertificateHash:
        return 'Correct certificate hash';
      case ExampleFeature.incorrectCertificateHash:
        return 'Incorrect certificate hash';
      case ExampleFeature.correctSpkiHash:
        return 'Correct SPKI hash';
      case ExampleFeature.incorrectSpkiHash:
        return 'Incorrect SPKI hash';
      case ExampleFeature.correctCertBytes:
        return 'Correct certificate bytes';
      case ExampleFeature.incorrectCertBytes:
        return 'Incorrect certificate bytes';
      case ExampleFeature.burpSuite:
        return 'Fetch via Burp Suite';
    }
  }

  String get message {
    switch (this) {
      case ExampleFeature.fetchOk:
        return 'GET a post with a normal client. No SSL pin is applied.';
      case ExampleFeature.correctCertificateHash:
        return 'Pin the matching SHA-256 hash of the server certificate, then GET a post.';
      case ExampleFeature.incorrectCertificateHash:
        return 'Pin a SHA-256 hash that does not belong to this server, then GET a post.';
      case ExampleFeature.correctSpkiHash:
        return 'Pin the matching public-key (SPKI) hash, then GET a post.';
      case ExampleFeature.incorrectSpkiHash:
        return 'Pin a public-key (SPKI) hash that does not belong to this server, then GET a post.';
      case ExampleFeature.correctCertBytes:
        return 'Trust the jsonplaceholder PEM file, then GET a post.';
      case ExampleFeature.incorrectCertBytes:
        return 'Trust a Wikipedia PEM against jsonplaceholder, then GET a post.';
      case ExampleFeature.burpSuite:
        return 'Send the same GET through a local Burp Suite proxy.';
    }
  }

  String get successTitle {
    switch (this) {
      case ExampleFeature.fetchOk:
        return 'Request completed';
      case ExampleFeature.burpSuite:
        return 'Request reached Burp';
      default:
        return 'Request allowed';
    }
  }

  String get successMessage {
    switch (this) {
      case ExampleFeature.fetchOk:
        return 'The app called jsonplaceholder with no certificate check. The server responded.';
      case ExampleFeature.correctCertificateHash:
        return 'The server certificate hash matched the pin, so the app allowed the request.';
      case ExampleFeature.incorrectCertificateHash:
        return 'Unexpected: the wrong certificate hash was accepted. The pin did not block this request.';
      case ExampleFeature.correctSpkiHash:
        return 'The server SPKI hash matched the pin, so the app allowed the request.';
      case ExampleFeature.incorrectSpkiHash:
        return 'Unexpected: the wrong SPKI hash was accepted. The pin did not block this request.';
      case ExampleFeature.correctCertBytes:
        return 'The trusted PEM matched the server certificate, so the app allowed the request.';
      case ExampleFeature.incorrectCertBytes:
        return 'Unexpected: the Wikipedia PEM was accepted for jsonplaceholder.';
      case ExampleFeature.burpSuite:
        return 'The app sent the request through the Burp Suite proxy and got a response.';
    }
  }

  String get blockedTitle {
    switch (this) {
      case ExampleFeature.fetchOk:
        return 'Request failed';
      case ExampleFeature.burpSuite:
        return 'Proxy request failed';
      default:
        return 'Request blocked';
    }
  }

  String get blockedMessage {
    switch (this) {
      case ExampleFeature.fetchOk:
        return 'The request did not complete. Check the network and try again.';
      case ExampleFeature.correctCertificateHash:
        return 'The server certificate hash did not match the pin, so the app blocked the request.';
      case ExampleFeature.incorrectCertificateHash:
        return 'The pinned certificate hash did not match this server, so the app blocked the request. That is the expected result.';
      case ExampleFeature.correctSpkiHash:
        return 'The server SPKI hash did not match the pin, so the app blocked the request.';
      case ExampleFeature.incorrectSpkiHash:
        return 'The pinned SPKI hash did not match this server, so the app blocked the request. That is the expected result.';
      case ExampleFeature.correctCertBytes:
        return 'The trusted PEM was not accepted for this server, so the handshake failed.';
      case ExampleFeature.incorrectCertBytes:
        return 'The Wikipedia PEM did not match jsonplaceholder, so the handshake failed. That is the expected result.';
      case ExampleFeature.burpSuite:
        return 'The proxy request failed. Confirm Burp is running and the proxy host is correct.';
    }
  }
}
