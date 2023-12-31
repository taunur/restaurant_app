enum ImageResolution { small, medium, large }

class ImageHelper {
  static String getImageUrl(String pictureId, ImageResolution resolution) {
    String baseUrl = 'https://restaurant-api.dicoding.dev/images';

    switch (resolution) {
      case ImageResolution.small:
        return '$baseUrl/small/$pictureId';
      case ImageResolution.medium:
        return '$baseUrl/medium/$pictureId';
      case ImageResolution.large:
        return '$baseUrl/large/$pictureId';
      default:
        return ''; // Handle the default case or throw an exception
    }
  }
}
