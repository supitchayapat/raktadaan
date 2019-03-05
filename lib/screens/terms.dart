import 'package:flutter/material.dart';

class TermsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms and Conditions'),
        leading: IconButton(
          icon: Icon(
            Icons.clear,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
                      child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Eligibles'),
                ),
                Text(
                    '1. Any donor, who is healthy, fit and not suffering from any transmittable diseases can donate blood.\n2. Donor must be 18 -60 years age and having a minimum weight of 50Kg can donate blood.\n3. Donor’s Hemoglobin level is 12.5% minimum.\n4. A donor can again donate blood after 3 months of your last donation of blood.\n5. Pulse rate must be between 50 to 100mm without any irregularities.\n6. BP Diastolic 50 to 100 mm Hg and Systolic 100 to 180 mm Hg.\n7. Body temperature should be normal and oral temperature should not exceed 37.5 degree Celsius.\n'),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Non Eligibles'),
                ),
                Text(
                    'Donors should not suffer from Cardiac arrest, hypertension, kidney alignments, epilepsy or diabetics.\n1. Ladies with a bad miscarriage should avoid donating blood for the next 6 months.\n2. If donor already donated blood or have been treated for malaria within the last three months.\n3. If donor undergone any immunization within the past one month.\n4. If donor consumed alcohol within the last 24 hours.\n5. If you are HIV+.\n6. If donor had a dental work for next 24 hours and wait for one month if donor had a major dental procedure.')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
