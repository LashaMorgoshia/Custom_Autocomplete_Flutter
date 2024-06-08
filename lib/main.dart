import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Autocomplete Example'),
        ),
        body: AutocompleteExample(),
      ),
    );
  }
}

class AutocompleteExample extends StatefulWidget {
  @override
  _AutocompleteExampleState createState() => _AutocompleteExampleState();
}

class _AutocompleteExampleState extends State<AutocompleteExample> {
  final List<String> _options = [
    'Apple',
    'Banana',
    'Cherry',
    'Date',
    'Elderberry',
    'Fig',
    'Grape',
    'Honeydew',
  ];

  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Iterable<String> _filteredOptions = const Iterable<String>.empty();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {});
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _filterOptions(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredOptions = _options;
      } else {
        _filteredOptions = _options.where((String option) {
          return option.toLowerCase().contains(query.toLowerCase());
        });
      }
    });
  }

  void _clearTextField() {
    setState(() {
      _textEditingController.clear();
      _filteredOptions = _options;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onTap: () {
                _textEditingController.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: _textEditingController.value.text.length);
              },
              controller: _textEditingController,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: 'Type a fruit name',
                border: OutlineInputBorder(),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        _filterOptions("");
                      },
                    ),
                    if (_textEditingController.text.isNotEmpty)
                      IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: _clearTextField,
                      ),
                  ],
                ),
              ),
              onChanged: (String value) {
                _filterOptions(value);
              },
              onSubmitted: (String value) {
                _focusNode.unfocus();
              },
            ),
            if (_filteredOptions.isNotEmpty)
              Expanded(
                child: Scrollbar(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(7.0),
                        bottomRight: Radius.circular(7.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.01),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.all(8.0),
                      itemCount: _filteredOptions.length,
                      itemBuilder: (BuildContext context, int index) {
                        final String option = _filteredOptions.elementAt(index);
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _textEditingController.text = option;
                                  _filteredOptions =
                                  const Iterable<String>.empty();
                                  FocusScope.of(context).unfocus();
                                });
                              },
                              child: ListTile(
                                title: Text(option),
                              ),
                            ),
                            Divider(), // Add horizontal line
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
