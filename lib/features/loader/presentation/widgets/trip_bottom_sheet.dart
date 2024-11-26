import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meka/core/extensions/context.extension.dart';
import 'package:meka/core/stateless/gaps.dart';
import 'package:meka/features/loader/presentation/blocs/loader_cubit.dart';
import 'package:meka/features/loader/presentation/blocs/loader_state.dart';
import 'package:meka/service_locator/service_locator.dart';

void showTripBottomSheet(BuildContext context, String address, String origin) {
  bool isSelected = true;
  String destination = '';
  final TextEditingController destinationController = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return BlocProvider.value(
        value:  sl<LoaderCubit>()..resetState(),
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            top: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'مكانك انت',
                style: context.textTheme.bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  const Icon(Icons.location_pin, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      address,
                      style: context.textTheme.bodyLarge!,
                    ),
                  ),
                ],
              ),
              Text(
                'ذاهب الي',
                style: context.textTheme.bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.blue),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: destinationController,
                      decoration: InputDecoration(
                        filled: true,
                        hintText: 'اكتب عنوان الوجهة هنا',
                        // Placeholder text
                        hintStyle: context.textTheme.bodyLarge,
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(12), // Add rounded corners
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Colors.blue), // Focused border color
                        ),
                      ),
                      style: context.textTheme.bodyLarge!,
                      onFieldSubmitted: (value) {},
                    ),
                  ),
                ],
              ),
              Gaps.v18(),
              Align(
                alignment: Alignment.center,
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return ToggleButtons(
                      isSelected: [isSelected, !isSelected],
                      onPressed: (index) {
                        // Toggle the selection
                        setState(() {
                          isSelected = index == 0;
                        });
                      },
                      borderRadius: BorderRadius.circular(12),
                      borderColor: Colors.grey,
                      selectedBorderColor: Colors.blue,
                      selectedColor: Colors.white,
                      fillColor: Colors.blue,
                      color: Colors.black,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'الونش',
                            style: context.textTheme.bodyLarge!,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'سيارة صيانة طوارئ',
                            style: context.textTheme.bodyLarge!,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Gaps.v18(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.w),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'تكلفه الونش',
                          style: context.textTheme.bodyLarge!.copyWith(
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '500ج',
                          style: context.textTheme.bodyLarge!.copyWith(
                              color: Colors.blue,
                              fontSize: 40.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Image.asset(
                    'assets/images/bottom_sheet_wensh.png',
                    // Replace with your image path
                    height: 50,
                  ),
                ],
              ),
              Gaps.v18(),
              Row(
                children: [
                  Expanded(
                    child: BlocListener<LoaderCubit, LoaderState>(
                      listener: (context, state) async {
                        if (state.isBolyline) {
                          await context.read<LoaderCubit>().getDirection(origin,
                              '${state.coordinate!.latitude},${state.coordinate!.longitude}');
                          if(context.mounted)context.pop();
                        }
                      },
                      child: BlocBuilder<LoaderCubit, LoaderState>(
                        builder: (context, state) {
                          if (state.isLoading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          return ElevatedButton(
                            onPressed: () async {
                              log('taped ${destinationController.text}');

                              destination = destinationController.text;
                              if (destination.isNotEmpty) {
                                // coordinates
                                await context
                                    .read<LoaderCubit>()
                                    .getCoordinates(
                                        destinationController.text.trim());
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    8), // Adjust the value as needed
                              ),
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Text(
                              'اطلب الان',
                              style: context.textTheme.bodyLarge!
                                  .copyWith(color: Colors.white),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: BlocBuilder<LoaderCubit, LoaderState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: () async {
                            context.pop();
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  8), // Adjust the value as needed
                            ),
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(
                            'الغاء',
                            style: context.textTheme.bodyLarge!
                                .copyWith(color: Colors.white),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
