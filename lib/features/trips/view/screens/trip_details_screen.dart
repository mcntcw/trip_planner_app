import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:page_route_animator/page_route_animator.dart';
import 'package:trip_planner_app/features/trips/bloc/trips_bloc.dart';
import 'package:trip_planner_app/features/trips/view/screens/trip_map_screen.dart';
import 'package:trip_planner_app/features/trips/view/widgets/stop_info_tile.dart';
import 'package:trip_planner_app/utils/elevated_bottom_sheet.dart';
import 'package:trip_planner_app/utils/show_date_picker.dart';
import 'package:trip_repository/trip_repository_library.dart';

class TripDetailsScreen extends StatefulWidget {
  final Trip trip;
  const TripDetailsScreen({super.key, required this.trip});

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height * 0.1),
        child: AppBar(
          backgroundColor: Colors.transparent,
          scrolledUnderElevation: 0.0,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                CupertinoIcons.back,
                size: 20,
              ),
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteAnimator(
                    child: BlocProvider.value(
                      value: BlocProvider.of<TripsBloc>(context),
                      child: TripMapScreen(
                        trip: widget.trip,
                      ),
                    ),
                    routeAnimation: RouteAnimation.rightToLeft,
                    duration: const Duration(milliseconds: 100),
                    reverseDuration: const Duration(milliseconds: 100),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurface,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/images/google-maps.png',
                  height: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
          foregroundColor: Theme.of(context).colorScheme.primary,
          toolbarHeight: MediaQuery.of(context).size.height * 0.1,
          centerTitle: true,
          title: BlocBuilder<TripsBloc, TripsState>(
            builder: (context, state) {
              if (state is TripsSuccess) {
                return Column(
                  children: [
                    Text(
                      widget.trip.name,
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'TRIP',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<TripsBloc, TripsState>(
                builder: (context, state) {
                  if (state is TripsSuccess) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ' ${DateFormat('dd.MM.yyyy').format(widget.trip.startDate)} - ${DateFormat('dd.MM.yyyy').format(widget.trip.endDate)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Currencies: ${widget.trip.currencies.join(', ')}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Languages: ${widget.trip.languages.join(', ')}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Total: \$${widget.trip.totalCost}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Container();
                  }
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'STOPS',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showElevatedBottomSheet(
                        context: context,
                        body: PlaceSearchBottomSheet(
                          addPlace: (value) async {
                            widget.trip.stops.add(value);
                            if (context.mounted) {
                              context.read<TripsBloc>().add(UpdateTrip(trip: widget.trip));
                            }
                          },
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 18),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(180),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/place.png',
                            height: 22,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          Icon(
                            Icons.add,
                            size: 18,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              BlocBuilder<TripsBloc, TripsState>(
                builder: (tripsBlocContext, tripsBlocState) {
                  if (tripsBlocState is TripsSuccess) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: widget.trip.stops.length,
                        itemBuilder: (BuildContext ctx, int idx) {
                          if (idx == 0) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.all(26),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.onSurface,
                                borderRadius: BorderRadius.circular(60),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  widget.trip.stops[idx].image != null
                                      ? Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                showElevatedBottomSheet(
                                                  padding: 0,
                                                  context: context,
                                                  body: ClipRRect(
                                                    borderRadius: BorderRadius.circular(28),
                                                    child: Image.file(
                                                      File(widget.trip.stops[idx].image!),
                                                      width: MediaQuery.of(context).size.width,
                                                      height: MediaQuery.of(context).size.height * 0.2,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: ClipOval(
                                                child: Image.file(
                                                  File(widget.trip.stops[idx].image!),
                                                  width: MediaQuery.of(context).size.width * 0.15,
                                                  height: MediaQuery.of(context).size.width * 0.15,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                Image.asset(
                                                  'assets/images/flag.png',
                                                  height: 22,
                                                  color: Theme.of(context).colorScheme.primary,
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  DateFormat('dd.MM.yyyy').format(widget.trip.startDate),
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Theme.of(context).colorScheme.primary,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : const Text('no image'),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 10),
                                          Text(
                                            widget.trip.stops[idx].name,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Theme.of(context).colorScheme.primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            widget.trip.stops[idx].country,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return StopInfoTile(
                              trip: widget.trip,
                              idx: idx,
                              tripsBlocContext: tripsBlocContext,
                              tripsBlocState: tripsBlocState,
                            );
                          }
                        },
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
        ),
      ),
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
