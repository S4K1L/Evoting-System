import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/create_election_controller.dart';
import '../../utils/component/nominee_form.dart';
import '../../utils/component/rectangle_costom_button.dart';
import '../../utils/constant/colors.dart';

class CreateElection extends StatelessWidget {
  final CreateElectionController controller = Get.put(CreateElectionController());

  CreateElection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryColor,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new, color: kWhiteColor),
        ),
        title: Row(
          children: [
            const Text('CREATE', style: TextStyle(color: kRedColor)),
            const Text(' ELECTION'),
            const Spacer(),
            IconButton(
              onPressed: controller.uploadElectionData,
              icon:
                  const Icon(Icons.done_outline, color: kGreenColor, size: 26),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                controller: controller.electionNameController,
                decoration: const InputDecoration(
                  hintText: 'Election name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Obx(() => Column(
                  children: controller.nominees
                      .map((nominee) => NomineeForm(nominee))
                      .toList(),
                )),
            RectangleCustomButton(title: 'Add Nominee',onPress: controller.addNominee,),
          ],
        ),
      ),
    );
  }
}

