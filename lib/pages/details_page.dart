import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/app_color.dart';
import 'package:restaurant_app/common/app_fonts.dart';
import 'package:restaurant_app/data/provider/details_provider.dart';
import 'package:restaurant_app/data/provider/review_provider.dart';
import 'package:restaurant_app/data/utils/image_helpers.dart';
import 'package:restaurant_app/data/utils/result_state.dart';
import 'package:restaurant_app/widgets/error_widget.dart';
import 'package:restaurant_app/widgets/loading_widget.dart';

import '../data/models/detail_resto_model.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({Key? key}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  /// add komentar
  bool isAddingReview = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController reviewController = TextEditingController();

  /// id restaurant
  String restaurantId = '';

  @override
  Widget build(BuildContext context) {
    /// get id
    restaurantId = ModalRoute
        .of(context)!
        .settings
        .arguments as String;
    log(restaurantId);


    /// enter id to provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DetailRestoProvider>(context, listen: false)
          .fetchDetailResto(restaurantId);
    });


    return Scaffold(
      appBar: _header(),
      body: Consumer<DetailRestoProvider>(
        builder: (context, detailRestoProvider, child) {
          /// Check the state of the provider and build accordingly
          switch (detailRestoProvider.state) {
            case ResultState.loading:

            /// Display a loading indicator or placeholder
              return const Loading();
            case ResultState.hasData:

            /// Display the data from the provider
              return _buildDetails(
                context,
                detailRestoProvider.detailResto!.restaurantInfo,
              );
            case ResultState.error:
              return ErrorMessageWidget(
                message: detailRestoProvider.errorMessage,
              );
            default:
              return const Text('Unexpected state');
          }
        },
      ),
    );
  }

  /// Appbar
  AppBar _header() {
    return AppBar(
      backgroundColor: AppColor.secondary,
      centerTitle: true,
      elevation: 0,
      title: Text(
        "Restaurant Details",
        style: whiteTextstyle,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }

  /// Detail Content
  Widget _buildDetails(BuildContext context, RestaurantInfo detailResto) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: ListView(
        children: [
          const SizedBox(height: 24),

          /// Picture
          Hero(
            tag: detailResto.pictureId,
            child: _buildRestaurantImage(detailResto.pictureId),
          ),
          const SizedBox(height: 16),

          /// Name
          _buildName(context, detailResto),

          /// Categories
          _buildCategories(context, detailResto.categories),
          const SizedBox(height: 16),

          /// Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              detailResto.description,
              textAlign: TextAlign.justify,
            ),
          ),

          /// Menu Food and Drink
          _buildMenu(detailResto.menus, context),

          /// Comment
          _buildCustomerReviews(context, detailResto.customerReviews),
        ],
      ),
    );
  }

  /// Show image
  Widget _buildRestaurantImage(String imageUrl) {
    return SizedBox(
      height: 180,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            ImageHelper.getImageUrl(
              imageUrl,
              ImageResolution.medium,
            ),
            fit: BoxFit.cover,
            height: 180,
            width: 240,
          ),
        ),
      ),
    );
  }

  /// Show categories
  Widget _buildCategories(BuildContext context, List<Category> categories) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Row(
            children: categories
                .map((category) => _buildSingleCategory(category))
                .toList(),
          ),
        ],
      ),
    );
  }

  /// Column Categories
  Widget _buildSingleCategory(Category category) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(
          category.name,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColor.secondary,
      ),
    );
  }

  /// Show nama, city, rating
  Padding _buildName(BuildContext context, RestaurantInfo restaurant) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurant.name,
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${restaurant.address}, ${restaurant.city}',
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(
                    fontWeight: light,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.star_rate_rounded,
            color: Colors.amber,
          ),
          const SizedBox(width: 4),
          Text(
            restaurant.rating.toString(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          )
        ],
      ),
    );
  }

  /// Show menu food and drink
  Widget _buildMenu(Menu menu, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 24,
        right: 24,
        bottom: 24,
        top: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// menu Food
          Text(
            "Food Menu:",
            style: Theme
                .of(context)
                .textTheme
                .titleMedium!
                .copyWith(
              fontWeight: semiBold,
            ),
          ),
          _buildMenuList(menu.foods),

          /// menu drink
          const SizedBox(
            height: 8,
          ),
          Text(
            "Drink Menu:",
            style: Theme
                .of(context)
                .textTheme
                .titleMedium!
                .copyWith(
              fontWeight: semiBold,
            ),
          ),
          _buildMenuList(menu.drinks),
        ],
      ),
    );
  }

  /// menampilkan nama menu pengkondisian
  Widget _buildMenuList(List<Category> items) {
    return SizedBox(
      height: 45,
      child: ListView.builder(
        itemCount: items.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.fromLTRB(
              index == 0 ? 0 : 6,
              0,
              index == items.length - 1 ? 0 : 6,
              0,
            ),
            child: Material(
              color: AppColor.secondary,
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  _showSnackbar(context, items[index].name);
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    items[index].name,
                    style: whiteTextstyle.copyWith(
                      fontWeight: semiBold,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Menampilkan SnackBar dari menu food and drink
  void _showSnackbar(BuildContext context, String menuName) {
    Future.microtask(() {
      final snackBar = SnackBar(
        content: Text('You selected : $menuName'),
        duration: const Duration(seconds: 1),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  /// Customer Review
  Widget _buildCustomerReviews(BuildContext context,
      List<CustomerReview> customerReviews) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Customer Reviews:",
                style: Theme
                    .of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(
                  fontWeight: semiBold,
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      AppColor.secondary),
                ),
                onPressed: () {
                  _showAddReviewDialog(context);
                },
                child: Text('Add Review',
                  style: whiteTextstyle.copyWith(
                    fontWeight: semiBold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: customerReviews
                .map((review) => _buildSingleCustomerReview(context, review))
                .toList(),
          ),
        ],
      ),
    );
  }

  /// Colum CustomerReview
  Widget _buildSingleCustomerReview(BuildContext context,
      CustomerReview review) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${review.name} - ${review.date}",
          style: Theme
              .of(context)
              .textTheme
              .bodySmall!
              .copyWith(
            fontWeight: semiBold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          review.review,
          textAlign: TextAlign.justify,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  /// Add Form Reviews
  void _showAddReviewDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Review'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Your Name'),
              ),
              TextField(
                controller: reviewController,
                decoration: const InputDecoration(labelText: 'Your Review'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    AppColor.secondary),
              ),
              onPressed: () {
                setState(() {
                  _addReview(context);
                });
              },
              child: Text(
                'Add Review',
                style: whiteTextstyle.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Function Button
  void _addReview(BuildContext context) {
    String name = nameController.text;
    String review = reviewController.text;

    if (name.isNotEmpty && review.isNotEmpty) {
      Provider.of<ReviewProvider>(context, listen: false).addReview(
          restaurantId, name, review);
      nameController.text = '';
      reviewController.text = '';
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Name and review cannot be empty'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}