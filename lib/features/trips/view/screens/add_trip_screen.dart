import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:place_repository/place_repository_library.dart';
import 'package:trip_planner_app/features/trips/bloc/trips_bloc.dart';
import 'package:trip_planner_app/utils/elevated_bottom_sheet.dart';
import 'package:trip_planner_app/utils/show_date_picker.dart';
import 'package:trip_repository/trip_repository_library.dart';

class AddTripScreen extends StatefulWidget {
  const AddTripScreen({super.key});

  @override
  State<AddTripScreen> createState() => _AddTripScreenState();
}

class _AddTripScreenState extends State<AddTripScreen> {
  late Place place;
  DateTime? pickedDate;

  final _controller = TextEditingController();
  final _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    place = Place.empty;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TripsBloc, TripsState>(
      listener: (context, state) {
        if (state is TripAddSuccess) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height * 0.1),
          child: AppBar(
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.onSurface, shape: BoxShape.circle),
                child: const Icon(
                  CupertinoIcons.xmark,
                  size: 20,
                ),
              ),
            ),
            foregroundColor: Theme.of(context).colorScheme.primary,
            toolbarHeight: MediaQuery.of(context).size.height * 0.1,
            centerTitle: true,
            title: Text(
              'NEW TRIP',
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FormTile(
                  icon: 'assets/images/signature.png',
                  text: 'name',
                  body: TextField(
                    controller: _controller,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary, fontSize: 12, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(16),
                      hintText: "type name of the trip...",
                      hintStyle: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                        fontWeight: FontWeight.w300,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.4),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                FormTile(
                  icon: 'assets/images/flag.png',
                  text: 'beginning',
                  body: GestureDetector(
                    onTap: () {
                      showElevatedBottomSheet(
                        context: context,
                        body: PlaceSearchBottomSheet(
                          addPlace: (value) {
                            setState(() {
                              place = value;
                            });
                          },
                        ),
                      );
                    },
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: place == Place.empty
                            ? Text(
                                'choose place...',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                                  fontWeight: FontWeight.w300,
                                ),
                              )
                            : Text(
                                place.name,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                  ),
                ),
                const SizedBox(height: 20),
                FormTile(
                  icon: 'assets/images/calendar.png',
                  text: 'start date',
                  body: TextField(
                    controller: _dateController,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary, fontSize: 12, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(16),
                      hintText: "pick a date",
                      hintStyle: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                        fontWeight: FontWeight.w300,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.4),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onTap: () async {
                      pickedDate = await showCustomDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2040),
                      );

                      if (pickedDate != null) {
                        setState(() {
                          String formattedDate = DateFormat('dd.MM.yyyy').format(pickedDate!);
                          _dateController.text = formattedDate;
                        });
                      }
                    },
                    keyboardType: TextInputType.none,
                    enableInteractiveSelection: false,
                    showCursor: false,
                  ),
                ),
                const Spacer(),
                Visibility(
                  visible: _controller.text.isNotEmpty && place != Place.empty && pickedDate != null,
                  child: GestureDetector(
                    onTap: () {
                      Trip trip = Trip.newTrip(name: _controller.text, beginning: place, startDate: pickedDate!);
                      context.read<TripsBloc>().add(AddTrip(trip: trip));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.width * 0.4,
                      margin: const EdgeInsets.all(40),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Theme.of(context).colorScheme.onSurface, shape: BoxShape.circle),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface.withOpacity(0.4), shape: BoxShape.circle),
                        child: const Icon(
                          CupertinoIcons.checkmark_alt,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FormTile extends StatelessWidget {
  final String icon;
  final String text;
  final Widget body;
  const FormTile({
    super.key,
    required this.icon,
    required this.text,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          body,
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                icon,
                height: 24,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 5),
              Text(
                text,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
