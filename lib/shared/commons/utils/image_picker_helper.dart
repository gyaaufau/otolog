import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../resources/theme.dart';

/// Helper class for handling image picking functionality
class ImagePickerHelper {
  final ImagePicker _picker = ImagePicker();

  /// Check if the current platform is macOS
  static bool isMacOS(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.macOS;
  }

  /// Check if the current platform is web
  static bool isWeb() {
    return kIsWeb;
  }

  /// Check if the current platform is mobile (not macOS or web)
  static bool isMobile(BuildContext context) {
    return !isMacOS(context) && !isWeb();
  }

  /// Pick an image from the gallery
  ///
  /// Returns [File] if successful, null if cancelled or on unsupported platform
  /// Shows a snackbar with error message if picking fails
  Future<File?> pickImageFromGallery(BuildContext context) async {
    // Check if image picker is supported on current platform
    if (isMacOS(context)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Image picker is not available on macOS. Please add vehicle photos on mobile devices.',
            ),
            backgroundColor: AppColors.warning,
            duration: Duration(seconds: 3),
          ),
        );
      }
      return null;
    }

    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1024,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return null;
    }
  }

  /// Pick an image from the camera
  ///
  /// Returns [File] if successful, null if cancelled or on unsupported platform
  /// Shows a snackbar with error message if picking fails
  Future<File?> pickImageFromCamera(BuildContext context) async {
    // Check if image picker is supported on current platform
    if (isMacOS(context)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Camera is not available on macOS. Please use mobile devices to take photos.',
            ),
            backgroundColor: AppColors.warning,
            duration: Duration(seconds: 3),
          ),
        );
      }
      return null;
    }

    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1024,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return null;
    }
  }

  /// Pick multiple images from the gallery
  ///
  /// Returns [List<File>] if successful, empty list if cancelled or on unsupported platform
  /// Shows a snackbar with error message if picking fails
  Future<List<File>> pickMultipleImages(BuildContext context) async {
    // Check if image picker is supported on current platform
    if (isMacOS(context)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Image picker is not available on macOS. Please add vehicle photos on mobile devices.',
            ),
            backgroundColor: AppColors.warning,
            duration: Duration(seconds: 3),
          ),
        );
      }
      return [];
    }

    try {
      final pickedFiles = await _picker.pickMultiImage(
        imageQuality: 80,
        maxWidth: 1024,
      );

      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        return pickedFiles.map((xFile) => File(xFile.path)).toList();
      }
      return [];
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick images: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return [];
    }
  }
}
