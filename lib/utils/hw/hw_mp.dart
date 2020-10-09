/// https://dart.dev/guides/libraries/create-library-packages

export 'hw_none.dart' // Stub implementation
    if (dart.library.io) 'hw_io.dart' // dart:io implementation
    if (dart.library.html) 'hw_html.dart'; // dart:html implementation
