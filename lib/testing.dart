import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:place_repository/place_repository_library.dart';
import 'package:trip_planner_app/utils/elevated_bottom_sheet.dart';

class TestingScren extends StatefulWidget {
  const TestingScren({super.key});

  @override
  State<TestingScren> createState() => _TestingScrenState();
}

class _TestingScrenState extends State<TestingScren> {
  List<Place> places = [];
  @override
  Widget build(BuildContext context) {
    //print(places);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              GestureDetector(
                onTap: () {
                  showElevatedBottomSheet(
                    context: context,
                    body: PlaceSearchBottomSheet(
                      addPlace: (place) {
                        setState(() {
                          places.add(place);
                        });
                      },
                    ),
                  );
                },
                child: Container(
                  height: 75,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSurface,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Center(
                    child: Icon(CupertinoIcons.location_fill, color: Theme.of(context).colorScheme.primary, size: 30),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              places.isNotEmpty
                  ? Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Places',
                            style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Expanded(
                            child: GridView.builder(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                              itemCount: places.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.onSurface,
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: 100,
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: FileImage(
                                              File(
                                                places[index].image!,
                                              ),
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            places[index].name,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Theme.of(context).colorScheme.primary,
                                                fontWeight: FontWeight.bold,
                                                overflow: TextOverflow.ellipsis),
                                          ),
                                          Text(
                                            places[index].country,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class PlaceSearchBottomSheet extends StatefulWidget {
  final Function(Place) addPlace;
  const PlaceSearchBottomSheet({
    super.key,
    required this.addPlace,
  });

  @override
  State<PlaceSearchBottomSheet> createState() => _PlaceSearchBottomSheetState();
}

class _PlaceSearchBottomSheetState extends State<PlaceSearchBottomSheet> {
  final _controller = TextEditingController();
  final googlePlacesRepository = GooglePlacesRepository();
  List<PlaceSearch> results = [];
  late Place place;
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.globe, color: Theme.of(context).colorScheme.primary, size: 26),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 14),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(16),
                hintText: "name...",
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                  fontWeight: FontWeight.w300,
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) async {
                List<PlaceSearch> autocomplete = await googlePlacesRepository.getAutocomplete(value);
                setState(() {
                  results = autocomplete;
                });
                if (value.length < 2) {
                  setState(() {
                    results.clear();
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: results.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: GestureDetector(
                        onTap: () async {
                          place = await googlePlacesRepository.getPlace(results[index].placeId!);
                          widget.addPlace(place);
                          if (context.mounted) Navigator.of(context).pop();
                        },
                        child: Text(
                          results[index].description!,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary, fontSize: 16, fontWeight: FontWeight.w300),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
