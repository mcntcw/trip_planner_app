import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_route_animator/page_route_animator.dart';
import 'package:trip_planner_app/features/trips/bloc/trips_bloc.dart';
import 'package:trip_planner_app/features/trips/view/screens/add_trip_screen.dart';
import 'package:trip_planner_app/features/trips/view/screens/trip_details_screen.dart';
import 'package:trip_planner_app/utils/elevated_bottom_sheet.dart';

class TripsScreen extends StatelessWidget {
  const TripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height * 0.1),
        child: const CustomAppBar(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'TRIPS',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteAnimator(
                          child: BlocProvider.value(
                            value: BlocProvider.of<TripsBloc>(context),
                            child: const AddTripScreen(),
                          ),
                          routeAnimation: RouteAnimation.bottomToTop,
                          duration: const Duration(milliseconds: 100),
                          reverseDuration: const Duration(milliseconds: 100),
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
                            'assets/images/trip.png',
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
                builder: (context, state) {
                  if (state is TripsSuccess) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: state.trips.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteAnimator(
                                  child: BlocProvider.value(
                                    value: BlocProvider.of<TripsBloc>(context),
                                    child: TripDetailsScreen(
                                      trip: state.trips[index],
                                    ),
                                  ),
                                  routeAnimation: RouteAnimation.rightToLeft,
                                  duration: const Duration(milliseconds: 100),
                                  reverseDuration: const Duration(milliseconds: 100),
                                ),
                              );
                            },
                            onLongPress: () {
                              showElevatedBottomSheet(
                                height: 0.1,
                                backgroundColor: Theme.of(context).colorScheme.error,
                                padding: 0,
                                context: context,
                                body: GestureDetector(
                                  onTap: () async {
                                    if (context.mounted) {
                                      context.read<TripsBloc>().add(DeleteTrip(trip: state.trips[index]));
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
                              height: 120,
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.all(26),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.onSurface,
                                borderRadius: BorderRadius.circular(60),
                              ),
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Image.asset(
                                      'assets/images/trip.png',
                                      height: double.maxFinite,
                                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/images/signature.png',
                                            height: 16,
                                            color: Theme.of(context).colorScheme.primary,
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                state.trips[index].name,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Theme.of(context).colorScheme.primary,
                                                  fontWeight: FontWeight.bold,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/images/flag.png',
                                            height: 16,
                                            color: Theme.of(context).colorScheme.primary,
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                '${state.trips[index].stops[0].name}, ${state.trips[index].stops[0].country}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: 0,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            height: 120,
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onSurface,
                              borderRadius: BorderRadius.circular(60),
                            ),
                          );
                        },
                      ),
                    );
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

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: MediaQuery.of(context).size.height * 0.1,
      backgroundColor: Colors.transparent,
      scrolledUnderElevation: 0.0,
      title: Container(
        padding: const EdgeInsets.all(32),
        child: Image.asset(
          'assets/images/logo.png',
          height: 36,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      centerTitle: true,
    );
  }
}
