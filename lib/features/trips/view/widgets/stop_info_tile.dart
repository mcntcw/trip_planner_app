import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:trip_planner_app/features/trips/bloc/trips_bloc.dart';
import 'package:trip_planner_app/utils/elevated_bottom_sheet.dart';
import 'package:trip_planner_app/utils/show_date_picker.dart';
import 'package:trip_repository/trip_repository_library.dart';

class StopInfoTile extends StatelessWidget {
  final Trip trip;
  final int idx;
  final BuildContext tripsBlocContext;
  final TripsState tripsBlocState;
  const StopInfoTile(
      {super.key, required this.trip, required this.idx, required this.tripsBlocContext, required this.tripsBlocState});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.width * 0.02,
                width: MediaQuery.of(context).size.width * 0.02,
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, shape: BoxShape.circle),
              ),
              Container(
                height: MediaQuery.of(context).size.width * 0.08,
                width: MediaQuery.of(context).size.width * 0.007,
                color: Theme.of(context).colorScheme.primary,
              ),
              Container(
                height: MediaQuery.of(context).size.width * 0.02,
                width: MediaQuery.of(context).size.width * 0.02,
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, shape: BoxShape.circle),
              ),
            ],
          ),
        ),
        GestureDetector(
          onLongPress: () {
            showElevatedBottomSheet(
              height: 0.1,
              backgroundColor: Theme.of(context).colorScheme.error,
              padding: 0,
              context: context,
              body: GestureDetector(
                onTap: () async {
                  trip.stops.removeAt(idx);
                  if (context.mounted) {
                    tripsBlocContext.read<TripsBloc>().add(UpdateTrip(trip: trip));
                  }
                  Navigator.pop(context);
                },
                child: Icon(
                  CupertinoIcons.trash_fill,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(26),
            margin: EdgeInsets.only(bottom: idx == trip.stops.length - 1 ? 20 : 0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface,
              borderRadius: BorderRadius.circular(60),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    trip.stops[idx].image != null
                        ? GestureDetector(
                            onTap: () {
                              showElevatedBottomSheet(
                                padding: 0,
                                context: context,
                                body: ClipRRect(
                                  borderRadius: BorderRadius.circular(28),
                                  child: Image.file(
                                    File(trip.stops[idx].image!),
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height * 0.2,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                            child: ClipOval(
                              child: Image.file(
                                File(trip.stops[idx].image!),
                                width: MediaQuery.of(context).size.width * 0.15,
                                height: MediaQuery.of(context).size.width * 0.15,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : const Text('no image'),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PickDateInStop(
                          trip: trip,
                          index: idx,
                          tripsBlocContext: context,
                          tripsBlocState: tripsBlocState,
                          text: 'arrival',
                        ),
                        Container(
                          height: MediaQuery.of(context).size.width * 0.005,
                          width: MediaQuery.of(context).size.width * 0.04,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        PickDateInStop(
                          trip: trip,
                          index: idx,
                          tripsBlocContext: context,
                          tripsBlocState: tripsBlocState,
                          text: 'departure',
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      trip.stops[idx].name,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      trip.stops[idx].country,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                MiniSectionList(
                  trip: trip,
                  section: 'attractions',
                  idx: idx,
                  tripsBlocContext: tripsBlocContext,
                  tripsBlocState: tripsBlocState,
                ),
                const SizedBox(height: 20),
                MiniSectionList(
                  trip: trip,
                  section: 'accommodations',
                  idx: idx,
                  tripsBlocContext: tripsBlocContext,
                  tripsBlocState: tripsBlocState,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class MiniSectionList extends StatefulWidget {
  final Trip trip;
  final String section;
  final int idx;
  final BuildContext tripsBlocContext;
  final TripsState tripsBlocState;

  const MiniSectionList({
    super.key,
    required this.trip,
    required this.section,
    required this.idx,
    required this.tripsBlocContext,
    required this.tripsBlocState,
  });

  @override
  State<MiniSectionList> createState() => _MiniSectionListState();
}

class _MiniSectionListState extends State<MiniSectionList> {
  @override
  Widget build(BuildContext context) {
    final sectionItems = widget.section == 'attractions'
        ? widget.trip.stops[widget.idx].attractions
        : widget.trip.stops[widget.idx].accommodations;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.section.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.03,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: sectionItems?.length == null ? 1 : sectionItems!.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return GestureDetector(
                  onTap: () {
                    showElevatedBottomSheet(
                      context: context,
                      body: PlaceSearchBottomSheet(
                        addPlace: (value) {
                          if (widget.section == 'attractions') {
                            widget.trip.stops[widget.idx].attractions ??= [];
                            widget.trip.stops[widget.idx].attractions!.add(value);
                          } else if (widget.section == 'accommodations') {
                            widget.trip.stops[widget.idx].accommodations ??= [];
                            widget.trip.stops[widget.idx].accommodations!.add(value);
                          }

                          if (context.mounted) {
                            widget.tripsBlocContext.read<TripsBloc>().add(UpdateTrip(trip: widget.trip));
                          }
                        },
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 5),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/${widget.section.substring(0, widget.section.length - 1)}.png',
                          height: 14,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '+',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                final TextEditingController costController = TextEditingController();
                index = index - 1;
                return GestureDetector(
                  onTap: () {
                    final cost = widget.section == 'attractions'
                        ? widget.trip.stops[widget.idx].attractions![index].cost
                        : widget.trip.stops[widget.idx].accommodations![index].cost;
                    if (cost != null) {
                      Future.delayed(Duration.zero, () {
                        if (mounted) {
                          costController.text = cost.toString();
                        }
                      });
                    }
                    showElevatedBottomSheet(
                        context: context,
                        padding: 0,
                        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                        body: Column(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(28.0),
                                    topRight: Radius.circular(28.0),
                                  ),
                                  child: Image.file(
                                    File(sectionItems[index].image!),
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height * 0.2,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        sectionItems[index].name,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Theme.of(context).colorScheme.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 4),
                                        width: MediaQuery.of(context).size.width * 0.35,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.surface,
                                          borderRadius: BorderRadius.circular(60),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Icon(
                                              CupertinoIcons.money_dollar,
                                              size: 18,
                                              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                                            ),
                                            Expanded(
                                              child: TextField(
                                                controller: costController,
                                                style: TextStyle(
                                                    color: Theme.of(context).colorScheme.primary,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold),
                                                decoration: InputDecoration(
                                                  hintText: "cost...",
                                                  hintStyle: TextStyle(
                                                    fontSize: 12,
                                                    color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                  border: const OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                  ),
                                                ),
                                                inputFormatters: [
                                                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                                                ],
                                                keyboardType: TextInputType.number,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                if (widget.section == 'attractions') {
                                                  widget.trip.stops[widget.idx].attractions![index].cost =
                                                      double.parse(costController.text);
                                                  FocusScope.of(context).requestFocus(FocusNode());
                                                } else if (widget.section == 'accommodations') {
                                                  widget.trip.stops[widget.idx].accommodations![index].cost =
                                                      double.parse(costController.text);
                                                  FocusScope.of(context).requestFocus(FocusNode());
                                                }

                                                if (context.mounted) {
                                                  widget.tripsBlocContext
                                                      .read<TripsBloc>()
                                                      .add(UpdateTrip(trip: widget.trip));
                                                }
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.all(6),
                                                child: const Icon(
                                                  CupertinoIcons.checkmark_alt,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: Row(
                      children: [
                        ClipOval(
                          child: Image.file(
                            File(sectionItems![index].image!),
                            width: MediaQuery.of(context).size.width * 0.05,
                            height: MediaQuery.of(context).size.width * 0.05,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          sectionItems[index].name,
                          style: TextStyle(
                            fontSize: 10,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class PickDateInStop extends StatefulWidget {
  final Trip trip;
  final int index;
  final BuildContext tripsBlocContext;
  final TripsState tripsBlocState;

  final String text;
  DateTime? pickedDate;

  PickDateInStop({
    super.key,
    required this.trip,
    required this.index,
    required this.tripsBlocContext,
    required this.tripsBlocState,
    required this.text,
    this.pickedDate,
  });

  @override
  State<PickDateInStop> createState() => _PickDateInStopState();
}

class _PickDateInStopState extends State<PickDateInStop> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final date =
        widget.text == 'arrival' ? widget.trip.stops[widget.index].arrival : widget.trip.stops[widget.index].departure;
    if (date != null) {
      Future.delayed(Duration.zero, () {
        if (mounted) {
          _controller.text = DateFormat('dd.MM.yyyy').format(date);
        }
      });
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.025,
      width: MediaQuery.of(context).size.width * 0.2,
      child: TextField(
        controller: _controller,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 5),
          hintText: widget.text,
          hintStyle: TextStyle(
            fontSize: 11,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            fontWeight: FontWeight.w300,
          ),
          filled: false,
          fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
        onTap: () async {
          widget.pickedDate = await showCustomDatePicker(
            context: context,
            initialDate: widget.trip.startDate,
            firstDate: widget.trip.startDate,
            lastDate: DateTime(2040),
          );

          if (widget.pickedDate != null) {
            String formattedDate = DateFormat('dd.MM.yyyy').format(widget.pickedDate!);
            _controller.text = formattedDate;
            if (widget.text == 'arrival') {
              widget.trip.stops[widget.index].arrival = widget.pickedDate;
            }

            if (widget.text == 'departure') {
              widget.trip.stops[widget.index].departure = widget.pickedDate;
            }
            if (context.mounted) widget.tripsBlocContext.read<TripsBloc>().add(UpdateTrip(trip: widget.trip));
          }
        },
        keyboardType: TextInputType.none,
        enableInteractiveSelection: false,
        showCursor: false,
      ),
    );
  }
}
