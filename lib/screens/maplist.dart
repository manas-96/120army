import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_places_flutter/model/prediction.dart';

import '../exports.dart';
import '../global.dart';
import '../statemanagment/locationtagfriends/locationtagfriends_bloc.dart';
import 'widget/toast.dart';

class Maplist extends StatefulWidget {
  const Maplist({super.key});

  @override
  State<Maplist> createState() => _MaplistState();
}

class _MaplistState extends State<Maplist> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  List<Prediction> _predictions = [];
  Timer? _debounce;
  bool _isLoading = false; // ✅ loader state

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  Future<void> _searchPlaces(String input) async {
    input = input.trim();

    if (input.isEmpty) {
      setState(() {
        _predictions.clear();
        _isLoading = false;
      });
      return;
    }

    setState(() => _isLoading = true);

    const apiKey =
        "AIzaSyBJVqEl3htu0t8mUFvAbEefukYzIpZDRv8"; // 🔑 replace with valid key
    // final url =
    //     "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&components=country:in&key=$apiKey";
    final url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["status"] == "OK") {
          final List predictions = data["predictions"];
          setState(() {
            _predictions =
                predictions
                    .map((p) => Prediction.fromJson(p))
                    .toList()
                    .cast<Prediction>();
          });
        } else {
          setState(() => _predictions.clear());
          showGlobalSnackBar(message: "Places API error: ${data["status"]}");
        }
      } else {
        showGlobalSnackBar(message: "HTTP error: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      setState(() => _isLoading = false); // ✅ hide loader
    }
  }

  // ✅ debounce wrapper
  void _onSearchChanged(String input) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      _searchPlaces(input);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: SizedBox(
          height: 45,
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Search your location",
              hintStyle: const TextStyle(color: Colors.white60),
              prefixIcon: const Icon(Icons.search, color: Colors.white),
              suffixIcon:
                  _searchController.text.isNotEmpty
                      ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white),
                        onPressed: () {
                          _searchController.clear();
                          _searchPlaces(""); // clear results
                        },
                      )
                      : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Colors.white60),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Colors.white),
              ),
              filled: true,
              fillColor: kPrimaryColor.withValues(alpha: 0.3),
            ),
            onChanged: _onSearchChanged,
          ),
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator()) // ✅ loader
              : _predictions.isEmpty
              ? const Center(child: Text("Start typing to search places"))
              : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _predictions.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final prediction = _predictions[index];
                  return ListTile(
                    leading: const Icon(
                      Icons.location_on,
                      color: kPrimaryColor,
                    ),
                    title: Text(prediction.description ?? ""),
                    onTap: () {
                      context.read<LocationtagfriendsBloc>().add(
                        UpdateUserLocation(
                          _getMainLocationTitle(prediction.description),
                        ),
                      );

                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
    );
  }
}

String _getMainLocationTitle(String? description) {
  if (description == null || description.trim().isEmpty) return "";
  return description.split(',').first.trim();
}
