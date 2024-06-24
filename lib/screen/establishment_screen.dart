import 'package:flutter/material.dart';
import 'package:twins_front/services/establishments_service.dart';
import 'package:twins_front/services/offers_service.dart';
import 'package:twins_front/widget/featured_card.dart';

class EstablishmentScreen extends StatelessWidget {
  final Establishment establishment;
  final List<Offer> offers;

  const EstablishmentScreen(
      {super.key, required this.establishment, required this.offers});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Image.network(
                  establishment.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
                Positioned.fill(
                  child: Container(
                    color:
                        Colors.black.withOpacity(0.5), // Fond semi-transparent
                  ),
                ),
                Container(
                  height: 200,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        establishment.description,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 15),
          Center(
            child: Text(
              establishment.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on,
                  color: Theme.of(context).colorScheme.inversePrimary),
              const SizedBox(width: 5),
              Text(
                establishment.address,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          const Center(
            child: Text(
              "Offres",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 20),
          Container(
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 0.5),
              child: _buildOffers(context)),
        ],
      ),
    );
  }

  Widget _buildOffers(BuildContext context) {
    if (offers.isEmpty) {
      return const Center(
        child: Text("Aucune offre disponible"),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: offers.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return FeaturedCardOffer(offer: offers[index]);
      },
    );
  }
}
