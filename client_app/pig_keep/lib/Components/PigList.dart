import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pig_keep/Components/DataTable_PigList.dart';
import 'package:pig_keep/Components/SearchBar_PigList.dart';
import 'package:pig_keep/Constants/color.constants.dart';
import 'package:pig_keep/Modals/ReusableDialogBox.dart';
import 'package:pig_keep/Providers/global_provider.dart';
import 'package:pig_keep/Services/pig-service.dart';
import 'package:pig_keep/main.dart';
import 'package:provider/provider.dart';

class PigList extends StatefulWidget {
  final void Function(Map<String, String> rowData) onRowSelected;

  const PigList({super.key, required this.onRowSelected});

  @override
  State<PigList> createState() => _PigListState();
}

class _PigListState extends State<PigList> {
  // controller
  final TextEditingController _pigDOBController = TextEditingController();
  final TextEditingController _pigParentController = TextEditingController();
  final TextEditingController _pigSexController = TextEditingController();
  final TextEditingController _pigPenController = TextEditingController();

  // pig db
  final pigService = globalLocator.get<PigService>();

  // pigs variables
  var selectedFarm;
  late String userOwner;
  var pigs = [];
  String searchValue = '';

  // fns
  Future<void> getPigs() async {
    final fetchPigs =
        await pigService.fetchPigs(selectedFarm['_id'], userOwner);
    setState(() {
      pigs = fetchPigs;
    });
  }

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (_picked != null) {
      setState(() {
        _pigDOBController.text = _picked.toString().split(" ")[0];
      });
    }
  }

  @override
  void initState() {
    context.read<GlobalProvider>().getCurrentUser().then((user) {
      selectedFarm = context.read<GlobalProvider>().getSelectedFarm();
      userOwner = user['username'];
      getPigs();
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final farm = context.watch<GlobalProvider>().getSelectedFarm();
    setState(() {
      selectedFarm = farm;
    });
    getPigs();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 20.w,
            ),
            Expanded(
              child: Container(
                height: 95.h,
                padding: EdgeInsets.only(left: 20.w, right: 20.w),
                decoration: BoxDecoration(
                  border: Border.all(color: appPrimary),
                  color: appPrimary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          pigs.length.toString(),
                          style: TextStyle(
                            color: appSecondary,
                            fontSize: 70.sp,
                            fontWeight: FontWeight.bold,
                            height: 0.9.h,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 9.w,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Total \nLiving Pig',
                          style: TextStyle(
                              color: appSecondary,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w300),
                        )
                      ],
                    ),
                    const Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 36.h,
                          width: 93.w,
                          padding: EdgeInsets.only(left: 9.w, right: 9.w),
                          decoration: BoxDecoration(
                            border: Border.all(color: appPrimary),
                            color: appSecondary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ReusableDialogBox(
                                    title: 'Add Pig',
                                    description:
                                        'Fill up the necessary information.',
                                    formFields: [
                                      RecyclableTextFormField(
                                        controller: _pigDOBController,
                                        keyboardType: TextInputType.datetime,
                                        labelText: 'Date of Birth',
                                        hintText: 'YYYY/MM/DD',
                                        hintTextSize: 14.sp,
                                        icon: Icons.email,
                                        textSize: 14.sp,
                                        height: 43.h,
                                        onTap: () {
                                          _selectDate();
                                        },
                                        readOnly: true,
                                      ),
                                      RecyclableTextFormField(
                                        controller: TextEditingController(),
                                        labelText: 'Parent Number',
                                        showDropdown: true,
                                        dropdownItems: const [
                                          'Parent 1',
                                          'Parent 2',
                                          'Parent 3'
                                        ],
                                        hintText: 'Parent Number',
                                        hintTextSize: 14.sp,
                                        icon: Icons.email,
                                        textSize: 14.sp,
                                        height: 43.h,
                                        readOnly: true,
                                      ),
                                      RecyclableTextFormField(
                                        controller: TextEditingController(),
                                        labelText: 'Sex',
                                        showDropdown: true,
                                        dropdownItems: const [
                                          'Male',
                                          'Female',
                                        ],
                                        hintText: 'Sex',
                                        hintTextSize: 14.sp,
                                        icon: Icons.email,
                                        textSize: 14.sp,
                                        height: 43.h,
                                        readOnly: true,
                                      ),
                                      RecyclableTextFormField(
                                        controller: TextEditingController(),
                                        labelText: 'Pen Number',
                                        showDropdown: true,
                                        dropdownItems: const [
                                          'EditPen 1',
                                          'EditPen 2',
                                          'EditPen 3'
                                        ],
                                        hintText: 'Pen Number',
                                        hintTextSize: 14.sp,
                                        icon: Icons.email,
                                        textSize: 14.sp,
                                        height: 43.h,
                                        readOnly: true,
                                      ),
                                    ],
                                    onSave: () {
                                      // Handle the save action, e.g., validate and save data
                                      print('Form saved');
                                      Navigator.of(context).pop();
                                    },
                                    saveButtonText: 'Add Pig',
                                    saveButtonColor: appPrimary,
                                  );
                                },
                              );
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.add_circle_rounded,
                                  color: appTertiary,
                                  size: 20.h,
                                ),
                                SizedBox(width: 3.h),
                                Text(
                                  'Add Pig',
                                  style: TextStyle(
                                    color: appTertiary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 20.w,
            ),
          ],
        ),
        SizedBox(
          height: 11.h,
        ),
        Row(
          // QR code & Search
          children: [
            SizedBox(
              width: 20.w,
            ),
            Column(
              children: [
                Container(
                  height: 34.h,
                  width: 100.w,
                  padding: EdgeInsets.only(left: 6.w, right: 8.w),
                  decoration: BoxDecoration(
                    color: appOrange,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                    onTap: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.download,
                          color: appSecondary,
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        Text(
                          'QR Codes',
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: appSecondary),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            const Spacer(),
            SearchBar_PigList(), // SearchBar_PigList.dart
            InkWell(
              // Filter
              onTap: () {},
              child: Icon(
                Icons.filter_alt_outlined,
                size: 35,
                color: appTertiary,
              ),
            ),
            SizedBox(
              width: 18.w,
            ),
          ],
        ),
        Column(
          children: [
            MyDataTable(onRowSelected: widget.onRowSelected),
          ],
        ),
      ],
    );
  }
}
