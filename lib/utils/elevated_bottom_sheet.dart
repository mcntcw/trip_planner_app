import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:place_repository/place_repository_library.dart';

void showElevatedBottomSheet(
    {required BuildContext context, required Widget body, double? height, double? padding, Color? backgroundColor}) {
  showModalBottomSheet(
    isScrollControlled: true,
    barrierColor: Theme.of(context).colorScheme.surface.withOpacity(0.4),
    backgroundColor: Colors.transparent,
    elevation: 0,
    context: context,
    builder: (context) {
      return SingleChildScrollView(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height:
              height == null ? MediaQuery.of(context).size.height * 0.5 : MediaQuery.of(context).size.height * height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(padding ?? 18),
          margin: const EdgeInsets.all(26),
          decoration: BoxDecoration(
            color: backgroundColor ?? Theme.of(context).colorScheme.onSurface,
            borderRadius: BorderRadius.circular(28),
          ),
          child: body,
        ),
      );
    },
  );
}

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
              style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 12),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(16),
                hintText: "name...",
                hintStyle: TextStyle(
                  fontSize: 12,
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
                          FocusScope.of(context).requestFocus(FocusNode());
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
