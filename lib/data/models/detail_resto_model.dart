class DetailResto {
  bool error;
  String message;
  RestaurantInfo restaurantInfo;

  DetailResto({
    required this.error,
    required this.message,
    required this.restaurantInfo,
  });

  factory DetailResto.fromJson(Map<String, dynamic> json) => DetailResto(
        error: json["error"],
        message: json["message"],
        restaurantInfo: RestaurantInfo.fromJson(json["restaurant"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "restaurant": restaurantInfo.toJson(),
      };
}

class RestaurantInfo {
  final String id;
  final String name;
  final String description;
  final String city;
  final String address;
  final String pictureId;
  final List<Category> categories;
  final Menu menus;
  final double rating;
  final List<CustomerReview> customerReviews;

  RestaurantInfo({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.pictureId,
    required this.categories,
    required this.menus,
    required this.rating,
    required this.customerReviews,
  });

  factory RestaurantInfo.fromJson(Map<String, dynamic> json) {
    return RestaurantInfo(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      city: json['city'],
      address: json['address'],
      pictureId: json['pictureId'],
      categories: List<Category>.from(
        json['categories'].map((x) => Category.fromJson(x)),
      ),
      menus: Menu.fromJson(json['menus']),
      rating: json['rating']?.toDouble(),
      customerReviews: List<CustomerReview>.from(
        json['customerReviews'].map((x) => CustomerReview.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "city": city,
        "address": address,
        "pictureId": pictureId,
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
        "menus": menus.toJson(),
        "rating": rating,
        "customerReviews":
            List<dynamic>.from(customerReviews.map((x) => x.toJson())),
      };
}

class Category {
  final String name;

  Category({required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(name: json['name']);
  }

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}

class Menu {
  final List<Category> foods;
  final List<Category> drinks;

  Menu({required this.foods, required this.drinks});

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      foods:
          List<Category>.from(json['foods'].map((x) => Category.fromJson(x))),
      drinks:
          List<Category>.from(json['drinks'].map((x) => Category.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "foods": List<dynamic>.from(foods.map((x) => x.toJson())),
        "drinks": List<dynamic>.from(drinks.map((x) => x.toJson())),
      };
}

class CustomerReview {
  final String name;
  final String review;
  final String date;

  CustomerReview({
    required this.name,
    required this.review,
    required this.date,
  });

  factory CustomerReview.fromJson(Map<String, dynamic> json) {
    return CustomerReview(
      name: json['name'],
      review: json['review'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "review": review,
        "date": date,
      };
}
