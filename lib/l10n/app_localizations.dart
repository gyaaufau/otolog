import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'OtoLog'**
  String get appTitle;

  /// Home tab label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Garage tab label
  ///
  /// In en, this message translates to:
  /// **'Garage'**
  String get garage;

  /// Service Logs tab label
  ///
  /// In en, this message translates to:
  /// **'Service Logs'**
  String get serviceLogs;

  /// Settings tab label
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Add action button
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// Edit action button
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Delete action button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Save action button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Cancel action button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Confirm action button
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Vehicles section title
  ///
  /// In en, this message translates to:
  /// **'Vehicles'**
  String get vehicles;

  /// Add vehicle button title
  ///
  /// In en, this message translates to:
  /// **'Add Vehicle'**
  String get addVehicle;

  /// Edit vehicle button title
  ///
  /// In en, this message translates to:
  /// **'Edit Vehicle'**
  String get editVehicle;

  /// Step 2 title
  ///
  /// In en, this message translates to:
  /// **'Vehicle Details'**
  String get vehicleDetails;

  /// Vehicle name field label
  ///
  /// In en, this message translates to:
  /// **'Vehicle Name'**
  String get vehicleName;

  /// Vehicle type label
  ///
  /// In en, this message translates to:
  /// **'Vehicle Type'**
  String get vehicleType;

  /// Vehicle make field label
  ///
  /// In en, this message translates to:
  /// **'Make'**
  String get make;

  /// Model field label
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get model;

  /// Year field label
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// License plate field label
  ///
  /// In en, this message translates to:
  /// **'License Plate'**
  String get licensePlate;

  /// VIN field label
  ///
  /// In en, this message translates to:
  /// **'VIN (Vehicle Identification Number)'**
  String get vin;

  /// Odometer field label
  ///
  /// In en, this message translates to:
  /// **'Odometer'**
  String get odometer;

  /// Color field label
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// Purchase date label
  ///
  /// In en, this message translates to:
  /// **'Purchase Date'**
  String get purchaseDate;

  /// Purchase price field label
  ///
  /// In en, this message translates to:
  /// **'Purchase Price'**
  String get purchasePrice;

  /// Current value field label
  ///
  /// In en, this message translates to:
  /// **'Current Value'**
  String get currentValue;

  /// Notes field label
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// Select vehicle dropdown label
  ///
  /// In en, this message translates to:
  /// **'Select Vehicle'**
  String get selectVehicle;

  /// Message when no vehicles exist
  ///
  /// In en, this message translates to:
  /// **'No vehicles added yet'**
  String get noVehicles;

  /// Message encouraging to add first vehicle
  ///
  /// In en, this message translates to:
  /// **'Add your first vehicle to get started'**
  String get addFirstVehicle;

  /// Service section title
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get service;

  /// Add service button title
  ///
  /// In en, this message translates to:
  /// **'Add Service'**
  String get addService;

  /// Edit service button title
  ///
  /// In en, this message translates to:
  /// **'Edit Service'**
  String get editService;

  /// Service details section title
  ///
  /// In en, this message translates to:
  /// **'Service Details'**
  String get serviceDetails;

  /// Service date field label
  ///
  /// In en, this message translates to:
  /// **'Service Date'**
  String get serviceDate;

  /// Service type field label
  ///
  /// In en, this message translates to:
  /// **'Service Type'**
  String get serviceType;

  /// Service provider field label
  ///
  /// In en, this message translates to:
  /// **'Service Provider'**
  String get serviceProvider;

  /// Cost field label
  ///
  /// In en, this message translates to:
  /// **'Cost'**
  String get cost;

  /// Odometer reading field label
  ///
  /// In en, this message translates to:
  /// **'Odometer Reading'**
  String get odometerReading;

  /// Description field label
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// Next service date field label
  ///
  /// In en, this message translates to:
  /// **'Next Service Date'**
  String get nextServiceDate;

  /// Next service odometer field label
  ///
  /// In en, this message translates to:
  /// **'Next Service Odometer'**
  String get nextServiceOdometer;

  /// Message when no services exist
  ///
  /// In en, this message translates to:
  /// **'No service records yet'**
  String get noServices;

  /// Message encouraging to add first service
  ///
  /// In en, this message translates to:
  /// **'Add your first service record'**
  String get addFirstService;

  /// Oil change service type
  ///
  /// In en, this message translates to:
  /// **'Oil Change'**
  String get oilChange;

  /// Tire rotation service type
  ///
  /// In en, this message translates to:
  /// **'Tire Rotation'**
  String get tireRotation;

  /// Brake service type
  ///
  /// In en, this message translates to:
  /// **'Brake Service'**
  String get brakeService;

  /// Inspection service type
  ///
  /// In en, this message translates to:
  /// **'Inspection'**
  String get inspection;

  /// General maintenance service type
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get maintenance;

  /// Repair service type
  ///
  /// In en, this message translates to:
  /// **'Repair'**
  String get repair;

  /// Other service type
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// Car vehicle type
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get car;

  /// Motorcycle vehicle type
  ///
  /// In en, this message translates to:
  /// **'Motorcycle'**
  String get motorcycle;

  /// Truck vehicle type
  ///
  /// In en, this message translates to:
  /// **'Truck'**
  String get truck;

  /// SUV vehicle type
  ///
  /// In en, this message translates to:
  /// **'SUV'**
  String get suv;

  /// Van vehicle type
  ///
  /// In en, this message translates to:
  /// **'Van'**
  String get van;

  /// Required field indicator
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// Optional field indicator
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// Search field placeholder
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Search vehicles placeholder
  ///
  /// In en, this message translates to:
  /// **'Search vehicles...'**
  String get searchVehicles;

  /// Search services placeholder
  ///
  /// In en, this message translates to:
  /// **'Search services...'**
  String get searchServices;

  /// Delete confirmation dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Confirmation'**
  String get deleteConfirmation;

  /// Delete vehicle confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this vehicle? This action cannot be undone.'**
  String get deleteVehicleMessage;

  /// Delete service confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this service record? This action cannot be undone.'**
  String get deleteServiceMessage;

  /// Success message title
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// Vehicle added success message
  ///
  /// In en, this message translates to:
  /// **'Vehicle added successfully'**
  String get vehicleAdded;

  /// Vehicle updated success message
  ///
  /// In en, this message translates to:
  /// **'Vehicle updated successfully'**
  String get vehicleUpdated;

  /// Vehicle deleted success message
  ///
  /// In en, this message translates to:
  /// **'Vehicle deleted successfully'**
  String get vehicleDeleted;

  /// Service added success message
  ///
  /// In en, this message translates to:
  /// **'Service record added successfully'**
  String get serviceAdded;

  /// Service updated success message
  ///
  /// In en, this message translates to:
  /// **'Service record updated successfully'**
  String get serviceUpdated;

  /// Service deleted success message
  ///
  /// In en, this message translates to:
  /// **'Service record deleted successfully'**
  String get serviceDeleted;

  /// Error message title
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get somethingWentWrong;

  /// Required field validation error
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get requiredField;

  /// Invalid format validation error
  ///
  /// In en, this message translates to:
  /// **'Invalid format'**
  String get invalidFormat;

  /// Total vehicles count label
  ///
  /// In en, this message translates to:
  /// **'Total Vehicles'**
  String get totalVehicles;

  /// Total services count label
  ///
  /// In en, this message translates to:
  /// **'Total Services'**
  String get totalServices;

  /// Total spent label
  ///
  /// In en, this message translates to:
  /// **'Total Spent'**
  String get totalSpent;

  /// Recent services section title
  ///
  /// In en, this message translates to:
  /// **'Recent Services'**
  String get recentServices;

  /// Upcoming services section title
  ///
  /// In en, this message translates to:
  /// **'Upcoming Services'**
  String get upcomingServices;

  /// Language setting label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Theme setting label
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// About section label
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Dark mode setting label
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// Light mode setting label
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// System mode setting label
  ///
  /// In en, this message translates to:
  /// **'System Mode'**
  String get systemMode;

  /// Location field label
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// Select location button
  ///
  /// In en, this message translates to:
  /// **'Select Location'**
  String get selectLocation;

  /// Use current location button
  ///
  /// In en, this message translates to:
  /// **'Use Current Location'**
  String get useCurrentLocation;

  /// Photo field label
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get photo;

  /// Add photo button
  ///
  /// In en, this message translates to:
  /// **'Add Photo'**
  String get addPhoto;

  /// Change photo button
  ///
  /// In en, this message translates to:
  /// **'Change Photo'**
  String get changePhoto;

  /// Remove photo button
  ///
  /// In en, this message translates to:
  /// **'Remove Photo'**
  String get removePhoto;

  /// Take photo option
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// Choose from gallery option
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGallery;

  /// Kilometers unit
  ///
  /// In en, this message translates to:
  /// **'km'**
  String get km;

  /// Miles unit
  ///
  /// In en, this message translates to:
  /// **'miles'**
  String get miles;

  /// Yes option
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No option
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// Close button
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Done button
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// Back button
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Next button
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Or separator
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// And separator
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get and;

  /// Today label
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// Yesterday label
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// Tomorrow label
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// Retry button label
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Welcome back greeting
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// Your garage title
  ///
  /// In en, this message translates to:
  /// **'Your Garage'**
  String get yourGarage;

  /// Subtitle for home screen
  ///
  /// In en, this message translates to:
  /// **'Track your vehicle maintenance and service history'**
  String get trackVehicleMaintenance;

  /// Switch vehicle button
  ///
  /// In en, this message translates to:
  /// **'Switch'**
  String get switchVehicle;

  /// Last odometer reading label
  ///
  /// In en, this message translates to:
  /// **'Last Odometer'**
  String get lastOdometer;

  /// Quick actions section title
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// See all link label
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// Days ago relative time
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String daysAgo(int count);

  /// Subtitle for vehicles screen
  ///
  /// In en, this message translates to:
  /// **'Manage your vehicle fleet'**
  String get manageVehicleFleet;

  /// Empty state message when no vehicles found
  ///
  /// In en, this message translates to:
  /// **'No Vehicles Found'**
  String get noVehiclesFound;

  /// Empty state suggestion when search has results
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search or filters'**
  String get tryAdjustingSearchOrFilters;

  /// Empty state suggestion when no vehicles exist
  ///
  /// In en, this message translates to:
  /// **'Add your first vehicle to get started'**
  String get addFirstVehicleToGetStarted;

  /// License plate label
  ///
  /// In en, this message translates to:
  /// **'Plate'**
  String get plate;

  /// Type label
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// Odometer label
  ///
  /// In en, this message translates to:
  /// **'Odometer'**
  String get odometerLabel;

  /// Primary vehicle badge
  ///
  /// In en, this message translates to:
  /// **'Primary Vehicle'**
  String get primaryVehicle;

  /// Mark as primary vehicle option
  ///
  /// In en, this message translates to:
  /// **'Mark as Primary'**
  String get markAsPrimary;

  /// Vehicle options bottom sheet title
  ///
  /// In en, this message translates to:
  /// **'Vehicle Options'**
  String get vehicleOptions;

  /// Delete vehicle confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{vehicleName}\"? This action cannot be undone.'**
  String deleteVehicleConfirmation(String vehicleName);

  /// All filter option
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// Sedan vehicle type
  ///
  /// In en, this message translates to:
  /// **'Sedan'**
  String get sedan;

  /// Add vehicle screen title
  ///
  /// In en, this message translates to:
  /// **'Add Vehicle'**
  String get addVehicleTitle;

  /// Step 1 title
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInformation;

  /// Step 3 title
  ///
  /// In en, this message translates to:
  /// **'Vehicle Photos'**
  String get vehiclePhotos;

  /// Step 1 subtitle
  ///
  /// In en, this message translates to:
  /// **'Enter basic vehicle information'**
  String get enterBasicInfo;

  /// Step 2 subtitle
  ///
  /// In en, this message translates to:
  /// **'Provide detailed vehicle specifications'**
  String get provideDetailedSpecs;

  /// Step 3 subtitle
  ///
  /// In en, this message translates to:
  /// **'Add a photo of your vehicle'**
  String get addPhotoOfVehicle;

  /// Vehicle name validation error
  ///
  /// In en, this message translates to:
  /// **'Vehicle name is required'**
  String get vehicleNameRequired;

  /// Plate number label
  ///
  /// In en, this message translates to:
  /// **'Plate Number'**
  String get plateNumber;

  /// Plate number validation error
  ///
  /// In en, this message translates to:
  /// **'Plate number is required'**
  String get plateNumberRequired;

  /// Brand field label
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get brand;

  /// Current odometer label
  ///
  /// In en, this message translates to:
  /// **'Current Odometer (km)'**
  String get currentOdometer;

  /// Select purchase date button
  ///
  /// In en, this message translates to:
  /// **'Select purchase date'**
  String get selectPurchaseDate;

  /// Vehicle type dropdown hint
  ///
  /// In en, this message translates to:
  /// **'Select vehicle type'**
  String get selectVehicleType;

  /// Fuel type label
  ///
  /// In en, this message translates to:
  /// **'Fuel Type'**
  String get fuelType;

  /// Fuel type dropdown hint
  ///
  /// In en, this message translates to:
  /// **'Select fuel type'**
  String get selectFuelType;

  /// Transmission type label
  ///
  /// In en, this message translates to:
  /// **'Transmission Type'**
  String get transmissionType;

  /// Transmission type dropdown hint
  ///
  /// In en, this message translates to:
  /// **'Select transmission type'**
  String get selectTransmissionType;

  /// VIN field hint
  ///
  /// In en, this message translates to:
  /// **'e.g., 1HGCM82633A123456'**
  String get vinHint;

  /// VIN validation error
  ///
  /// In en, this message translates to:
  /// **'VIN is required'**
  String get vinRequired;

  /// Odometer field hint
  ///
  /// In en, this message translates to:
  /// **'e.g., 50000'**
  String get odometerHint;

  /// Odometer validation error
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid odometer reading'**
  String get odometerRequired;

  /// Color field hint
  ///
  /// In en, this message translates to:
  /// **'e.g., Black'**
  String get colorHint;

  /// Year field hint
  ///
  /// In en, this message translates to:
  /// **'e.g., 2020'**
  String get yearHint;

  /// Year validation error
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid year'**
  String get yearInvalid;

  /// Previous button
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// Tap to add photo hint
  ///
  /// In en, this message translates to:
  /// **'Tap to add photo'**
  String get tapToAddPhoto;

  /// Saving button text
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// Primary badge label
  ///
  /// In en, this message translates to:
  /// **'Primary'**
  String get primary;

  /// Delete vehicle button
  ///
  /// In en, this message translates to:
  /// **'Delete Vehicle'**
  String get deleteVehicle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
