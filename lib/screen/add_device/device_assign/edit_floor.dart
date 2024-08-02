import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/footer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditFloorName extends StatefulWidget {
  final String floorName;
  final String floorid;
  const EditFloorName({Key? key, required this.floorName, required this.floorid}) : super(key: key);

  @override
  EditFloorNameState createState() => EditFloorNameState();
}

class EditFloorNameState extends State<EditFloorName> {
  final TextEditingController _searchController = TextEditingController();

  bool isAssignedVisible = true;
  bool isUnAssignedVisible = true;

  void toggleAssignedVisibility() {
    setState(() {
      isUnAssignedVisible = false;
      isAssignedVisible = !isAssignedVisible;
    });
  }

  void toggleUnAssignedVisibility() {
    setState(() {
      isAssignedVisible = false;
      isUnAssignedVisible = !isUnAssignedVisible;
    });
  }

  @override
  void initState() {
    super.initState();
    isAssignedVisible = false;
    isUnAssignedVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColors.backgroundColor,
      bottomNavigationBar: Footer(),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset(
                    ImgPath.pngArrowBack,
                    height: 25,
                    width: 25,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TextFormField(
                initialValue: widget.floorName, 
                maxLines: 1,
                decoration: const InputDecoration(
                  labelText: "Add floor name",
                  suffixIcon: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.edit,
                      size: 20,
                      color: ConstantColors.mainlyTextColor,
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: ConstantColors.mainlyTextColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: ConstantColors.mainlyTextColor),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: isUnAssignedVisible
                          ? ConstantColors.whiteColor
                          : ConstantColors.lightBlueColor, backgroundColor: isUnAssignedVisible
                          ? ConstantColors.lightBlueColor
                          : ConstantColors.whiteColor, shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      side: const BorderSide(
                        color: ConstantColors.borderButtonColor,
                        width: 1.0,
                        style: BorderStyle.solid,
                      ),
                    ),
                    onPressed: () {
                      toggleUnAssignedVisibility();
                    },
                    child: Text(
                      "Unassigned",
                      style: GoogleFonts.roboto(
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: isAssignedVisible
                          ? ConstantColors.whiteColor
                          : ConstantColors.lightBlueColor, backgroundColor: isAssignedVisible
                          ? ConstantColors.lightBlueColor
                          : ConstantColors.whiteColor, shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      side: const BorderSide(
                        color: ConstantColors.borderButtonColor,
                        width: 1.0,
                        style: BorderStyle.solid,
                      ),
                    ),
                    onPressed: () {
                      toggleAssignedVisibility();
                    },
                    child: Text(
                      "Assigned",
                      style: GoogleFonts.roboto(
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search for device',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => _searchController.clear(),
                    ),
                    prefixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {},
                    ),
                    fillColor: ConstantColors.inputColor,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            if (isUnAssignedVisible)
              ListView.separated(
                shrinkWrap: true,
                itemCount: 10, // Change this to the number of items you have
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(
                  thickness: 2,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                      'Device Name $index\n',
                      style: GoogleFonts.roboto(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: ConstantColors.mainlyTextColor),
                    ),
                    subtitle: Text(
                      'Unassigned',
                      style: GoogleFonts.roboto(
                          fontSize: 14.0,
                          color: ConstantColors.mainlyTextColor),
                    ),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: ConstantColors.whiteColor, backgroundColor: ConstantColors.lightBlueColor, shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        side: const BorderSide(
                          color: ConstantColors.borderButtonColor,
                          width: 1.0,
                          style: BorderStyle.solid,
                        ),
                      ),
                      onPressed: () {
                        //Navigator.of(context).pop();
                      },
                      child: Text(
                        "Add",
                        style: GoogleFonts.roboto(
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    onTap: () {
                      // Add your onTap functionality here
                    },
                  );
                },
              ),
            if (isAssignedVisible)
              ListView.separated(
                shrinkWrap: true,
                itemCount: 10, // Change this to the number of items you have
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(
                  thickness: 2,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                      'Device Name $index\n',
                      style: GoogleFonts.roboto(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: ConstantColors.mainlyTextColor),
                    ),
                    subtitle: Text(
                      'assigned',
                      style: GoogleFonts.roboto(
                          fontSize: 14.0,
                          color: ConstantColors.mainlyTextColor),
                    ),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: ConstantColors.whiteColor, backgroundColor: ConstantColors.lightBlueColor, shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        side: const BorderSide(
                          color: ConstantColors.borderButtonColor,
                          width: 1.0,
                          style: BorderStyle.solid,
                        ),
                      ),
                      onPressed: () {
                        //Navigator.of(context).pop();
                      },
                      child: Text(
                        "Remove",
                        style: GoogleFonts.roboto(
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    onTap: () {
                      // Add your onTap functionality here
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
