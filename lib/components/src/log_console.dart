import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:logger/logger.dart';

bool _initialized = false;
ValueChanged _outputEvent;

class LogConsole extends StatefulWidget {
  final bool dark;

  LogConsole({this.dark = false})
      : assert(_initialized, "Please call LogConsole.init() first.");

  static void init() {
    if (_initialized) return;
    _initialized = true;
    streamOutput.stream.listen((event) => _outputEvent);
  }

  @override
  _LogConsoleState createState() => _LogConsoleState();
}

class RenderedEvent {
  final int id;
  final Level level;
  final TextSpan span;
  final String lowerCaseText;

  RenderedEvent(this.id, this.level, this.span, this.lowerCaseText);
}

class _LogConsoleState extends State<LogConsole> {
  ListQueue<RenderedEvent> _renderedBuffer = ListQueue();
  List<RenderedEvent> _filteredBuffer = [];

  var _scrollController = ScrollController();
  var _filterController = TextEditingController();

  Level _filterLevel = Level.verbose;
  double _logFontSize = 14;

  var _currentId = 0;
  bool _scrollListenerEnabled = true;
  bool _followBottom = true;

  @override
  void initState() {
    super.initState();

    _outputEvent = (event) {
      _refreshFilter();
    };

    _scrollController.addListener(() {
      if (!_scrollListenerEnabled) return;
      var scrolledToBottom = _scrollController.offset >=
          _scrollController.position.maxScrollExtent;
      setState(() {
        _followBottom = scrolledToBottom;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _renderedBuffer.clear();
    for (var event in memoryOutput.buffer) {
      _renderedBuffer.add(_renderEvent(event));
    }
    _refreshFilter();
  }

  void _refreshFilter() {
    var newFilteredBuffer = _renderedBuffer.where((it) {
      var logLevelMatches = it.level.index >= _filterLevel.index;
      if (!logLevelMatches) {
        return false;
      } else if (_filterController.text.isNotEmpty) {
        var filterText = _filterController.text.toLowerCase();
        return it.lowerCaseText.contains(filterText);
      } else {
        return true;
      }
    }).toList();
    setState(() {
      _filteredBuffer = newFilteredBuffer;
    });

    if (_followBottom) {
      Future.delayed(Duration.zero, _scrollToBottom);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: widget.dark
          ? ThemeData(
              brightness: Brightness.dark,
              accentColor: Colors.blueGrey,
            )
          : ThemeData(
              brightness: Brightness.light,
              accentColor: Colors.lightBlueAccent,
            ),
      home: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildTopBar(),
              Expanded(
                child: _buildLogContent(),
              ),
              _buildBottomBar(),
            ],
          ),
        ),
        floatingActionButton: AnimatedOpacity(
          opacity: _followBottom ? 0 : 1,
          duration: Duration(milliseconds: 150),
          child: Padding(
            padding: EdgeInsets.only(bottom: 60),
            child: FloatingActionButton(
              mini: true,
              clipBehavior: Clip.antiAlias,
              child: Icon(
                Icons.arrow_downward,
                color: widget.dark ? Colors.white : Colors.lightBlue[900],
              ),
              onPressed: _scrollToBottom,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogContent() {
    return Container(
      color: widget.dark ? Colors.black : Colors.grey[150],
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: 1600,
          child: ListView.builder(
            shrinkWrap: true,
            controller: _scrollController,
            itemBuilder: (context, index) {
              var logEntry = _filteredBuffer[index];
              return Text.rich(
                logEntry.span,
                key: Key(logEntry.id.toString()),
                style: TextStyle(fontSize: _logFontSize),
              );
            },
            itemCount: _filteredBuffer.length,
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return LogBar(
      dark: widget.dark,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(
            "Log Console",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.developer_mode),
            onPressed: () {
              if (!isAppDebugFlag) {
                return;
              }
              showSelectBaseURLTypeAlert().then((success) {
                if (success) {
                  if (baseURLChangedCallback != null) {
                    baseURLChangedCallback();
                  }
                }
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              setState(() {
                _logFontSize++;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: () {
              setState(() {
                _logFontSize--;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return LogBar(
      dark: widget.dark,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: TextField(
              style: TextStyle(fontSize: 20),
              controller: _filterController,
              onChanged: (s) => _refreshFilter(),
              decoration: InputDecoration(
                labelText: "Filter log output",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(width: 20),
          DropdownButton(
            value: _filterLevel,
            items: [
              DropdownMenuItem(
                child: Text("VERBOSE"),
                value: Level.verbose,
              ),
              DropdownMenuItem(
                child: Text("DEBUG"),
                value: Level.debug,
              ),
              DropdownMenuItem(
                child: Text("INFO"),
                value: Level.info,
              ),
              DropdownMenuItem(
                child: Text("WARNING"),
                value: Level.warning,
              ),
              DropdownMenuItem(
                child: Text("ERROR"),
                value: Level.error,
              ),
              DropdownMenuItem(
                child: Text("WTF"),
                value: Level.wtf,
              )
            ],
            onChanged: (value) {
              _filterLevel = value;
              _refreshFilter();
            },
          )
        ],
      ),
    );
  }

  void _scrollToBottom() async {
    _scrollListenerEnabled = false;

    setState(() {
      _followBottom = true;
    });

    var scrollPosition = _scrollController.position;
    await _scrollController.animateTo(
      scrollPosition.maxScrollExtent,
      duration: new Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );

    _scrollListenerEnabled = true;
  }

  RenderedEvent _renderEvent(OutputEvent event) {
    var parser = AnsiParser(widget.dark);
    var text = event.lines.join('\n');
    parser.parse(text);
    return RenderedEvent(
      _currentId++,
      event.level,
      TextSpan(children: parser.spans),
      text.toLowerCase(),
    );
  }
}

class LogBar extends StatelessWidget {
  final bool dark;
  final Widget child;

  LogBar({this.dark, this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: dark
              ? null
              : [
                  BoxShadow(
                    color: Colors.grey[400],
                    blurRadius: 3,
                  ),
                ],
        ),
        child: Material(
          color: dark ? Colors.blueGrey[900] : Colors.white,
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 8, 15, 8),
            child: child,
          ),
        ),
      ),
    );
  }
}

class AnsiParser {
  static const TEXT = 0, BRACKET = 1, CODE = 2;

  final bool dark;

  AnsiParser(this.dark);

  Color foreground;
  Color background;
  List<TextSpan> spans;

  void parse(String s) {
    spans = [];
    var state = TEXT;
    StringBuffer buffer;
    var text = StringBuffer();
    var code = 0;
    List<int> codes;

    for (var i = 0, n = s.length; i < n; i++) {
      var c = s[i];

      switch (state) {
        case TEXT:
          if (c == '\u001b') {
            state = BRACKET;
            buffer = StringBuffer(c);
            code = 0;
            codes = [];
          } else {
            text.write(c);
          }
          break;

        case BRACKET:
          buffer.write(c);
          if (c == '[') {
            state = CODE;
          } else {
            state = TEXT;
            text.write(buffer);
          }
          break;

        case CODE:
          buffer.write(c);
          var codeUnit = c.codeUnitAt(0);
          if (codeUnit >= 48 && codeUnit <= 57) {
            code = code * 10 + codeUnit - 48;
            continue;
          } else if (c == ';') {
            codes.add(code);
            code = 0;
            continue;
          } else {
            if (text.isNotEmpty) {
              spans.add(createSpan(text.toString()));
              text.clear();
            }
            state = TEXT;
            if (c == 'm') {
              codes.add(code);
              handleCodes(codes);
            } else {
              text.write(buffer);
            }
          }

          break;
      }
    }

    spans.add(createSpan(text.toString()));
  }

  void handleCodes(List<int> codes) {
    if (codes.isEmpty) {
      codes.add(0);
    }

    switch (codes[0]) {
      case 0:
        foreground = getColor(0, true);
        background = getColor(0, false);
        break;
      case 38:
        foreground = getColor(codes[2], true);
        break;
      case 39:
        foreground = getColor(0, true);
        break;
      case 48:
        background = getColor(codes[2], false);
        break;
      case 49:
        background = getColor(0, false);
    }
  }

  Color getColor(int colorCode, bool foreground) {
    switch (colorCode) {
      case 0:
        return foreground ? Colors.black : Colors.transparent;
      case 12:
        return dark ? Colors.lightBlue[300] : Colors.indigo[700];
      case 208:
        return dark ? Colors.orange[300] : Colors.orange[700];
      case 196:
        return dark ? Colors.red[300] : Colors.red[700];
      case 199:
        return dark ? Colors.pink[300] : Colors.pink[700];
    }
    return Colors.white;
  }

  TextSpan createSpan(String text) {
    return TextSpan(
      text: text,
      style: TextStyle(
        color: foreground,
        backgroundColor: background,
      ),
    );
  }
}
