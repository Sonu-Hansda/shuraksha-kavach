import 'package:flutter/material.dart';

class AddressFormFields extends StatelessWidget {
  final TextEditingController houseNameController;
  final TextEditingController streetController;
  final TextEditingController districtController;
  final TextEditingController stateController;
  final TextEditingController zipCodeController;
  final TextEditingController landmarkController;

  const AddressFormFields({
    super.key,
    required this.houseNameController,
    required this.streetController,
    required this.districtController,
    required this.stateController,
    required this.zipCodeController,
    required this.landmarkController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: houseNameController,
          decoration: InputDecoration(
            hintText: 'House Name/Number',
            prefixIcon: Icon(
              Icons.home,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.tertiary.withAlpha(51),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.tertiary.withAlpha(51),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.tertiary,
                width: 2,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: streetController,
          decoration: InputDecoration(
            hintText: 'Street',
            prefixIcon: Icon(
              Icons.location_on,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.tertiary.withAlpha(51),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.tertiary.withAlpha(51),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.tertiary,
                width: 2,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: districtController,
          decoration: InputDecoration(
            hintText: 'District',
            prefixIcon: Icon(
              Icons.location_city,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.tertiary.withAlpha(51),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.tertiary.withAlpha(51),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.tertiary,
                width: 2,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: stateController,
          decoration: InputDecoration(
            hintText: 'State',
            prefixIcon: Icon(
              Icons.public,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.tertiary.withAlpha(51),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.tertiary.withAlpha(51),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.tertiary,
                width: 2,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: zipCodeController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'ZIP Code',
            prefixIcon: Icon(
              Icons.pin_drop,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.tertiary.withAlpha(51),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.tertiary.withAlpha(51),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.tertiary,
                width: 2,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: landmarkController,
          decoration: InputDecoration(
            hintText: 'Landmark (Optional)',
            prefixIcon: Icon(
              Icons.place,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.tertiary.withAlpha(51),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.tertiary.withAlpha(51),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.tertiary,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
