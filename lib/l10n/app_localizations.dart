import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

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

  /// Subtitle for service logs screen
  ///
  /// In en, this message translates to:
  /// **'Track all your vehicle maintenance'**
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

  /// Select button label
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// Save changes button
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// Delete vehicle confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this vehicle? This action cannot be undone and will also delete all associated service records.'**
  String get deleteVehicleConfirmation;

  /// Specifications section title
  ///
  /// In en, this message translates to:
  /// **'Specifications'**
  String get specifications;

  /// Service statistics section title
  ///
  /// In en, this message translates to:
  /// **'Service Statistics'**
  String get serviceStatistics;

  /// Total services label in statistics
  ///
  /// In en, this message translates to:
  /// **'Total Services'**
  String get totalServicesLabel;

  /// Total cost label in statistics
  ///
  /// In en, this message translates to:
  /// **'Total Cost'**
  String get totalCostLabel;

  /// Add service record button
  ///
  /// In en, this message translates to:
  /// **'Add Service Record'**
  String get addServiceRecord;

  /// Set as primary vehicle button
  ///
  /// In en, this message translates to:
  /// **'Set Primary'**
  String get setPrimary;

  /// Total cost label
  ///
  /// In en, this message translates to:
  /// **'Total Cost'**
  String get totalCost;

  /// Filters section title
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// Clear all filters button
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// Vehicle label
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get vehicle;

  /// Date range filter label
  ///
  /// In en, this message translates to:
  /// **'Date Range'**
  String get dateRange;

  /// All vehicles filter option
  ///
  /// In en, this message translates to:
  /// **'All Vehicles'**
  String get allVehicles;

  /// Start date label
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// End date label
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDate;

  /// Empty state message when no services found
  ///
  /// In en, this message translates to:
  /// **'No Service Records'**
  String get noServiceRecords;

  /// Empty state suggestion when no vehicles exist
  ///
  /// In en, this message translates to:
  /// **'Add a vehicle first to start tracking services'**
  String get addVehicleFirstToStartTracking;

  /// Empty state suggestion when no services exist
  ///
  /// In en, this message translates to:
  /// **'Add your first service record to get started'**
  String get addFirstServiceRecordToGetStarted;

  /// Service options bottom sheet title
  ///
  /// In en, this message translates to:
  /// **'Service Options'**
  String get serviceOptions;

  /// View details option
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// Delete service button
  ///
  /// In en, this message translates to:
  /// **'Delete Service'**
  String get deleteService;

  /// Delete service confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{serviceType}\" for {vehicleName}? This action cannot be undone.'**
  String deleteServiceConfirmation(String serviceType, String vehicleName);

  /// Mechanic field label
  ///
  /// In en, this message translates to:
  /// **'Mechanic'**
  String get mechanic;

  /// Select a vehicle hint
  ///
  /// In en, this message translates to:
  /// **'Select a vehicle'**
  String get selectAVehicle;

  /// No vehicles available message
  ///
  /// In en, this message translates to:
  /// **'No vehicles available. Please add a vehicle first.'**
  String get noVehiclesAvailablePleaseAddVehicleFirst;

  /// Service type dropdown hint
  ///
  /// In en, this message translates to:
  /// **'Select service type'**
  String get selectServiceType;

  /// Service date dropdown hint
  ///
  /// In en, this message translates to:
  /// **'Select service date'**
  String get selectServiceDate;

  /// Description field hint
  ///
  /// In en, this message translates to:
  /// **'Describe service performed...'**
  String get describeServicePerformed;

  /// Cost field label
  ///
  /// In en, this message translates to:
  /// **'Cost (IDR)'**
  String get costIDR;

  /// Cost field hint
  ///
  /// In en, this message translates to:
  /// **'e.g., 500000'**
  String get exampleCost;

  /// Mechanic field label
  ///
  /// In en, this message translates to:
  /// **'Mechanic / Shop'**
  String get mechanicShop;

  /// Mechanic field hint
  ///
  /// In en, this message translates to:
  /// **'e.g., Bengkel Jaya'**
  String get exampleMechanic;

  /// Notes field hint
  ///
  /// In en, this message translates to:
  /// **'Additional notes or observations...'**
  String get additionalNotesOrObservations;

  /// Save service record button
  ///
  /// In en, this message translates to:
  /// **'Save Service Record'**
  String get saveServiceRecord;

  /// Validation error message
  ///
  /// In en, this message translates to:
  /// **'Please fill in all required fields'**
  String get pleaseFillInAllRequiredFields;

  /// Update service record button
  ///
  /// In en, this message translates to:
  /// **'Update Service Record'**
  String get updateServiceRecord;

  /// Database viewer menu item
  ///
  /// In en, this message translates to:
  /// **'Database Viewer'**
  String get databaseViewer;

  /// Database viewer subtitle
  ///
  /// In en, this message translates to:
  /// **'View all database records'**
  String get viewAllDatabaseRecords;

  /// App information text
  ///
  /// In en, this message translates to:
  /// **'OtoLog - Vehicle Service Log App'**
  String get appInformation;

  /// January month name
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get january;

  /// February month name
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get february;

  /// March month name
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get march;

  /// April month name
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get april;

  /// May month name
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get may;

  /// June month name
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get june;

  /// July month name
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get july;

  /// August month name
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get august;

  /// September month name
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get september;

  /// October month name
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get october;

  /// November month name
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get november;

  /// December month name
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get december;

  /// Apply filters button
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get applyFilters;

  /// No service records for specific vehicle message
  ///
  /// In en, this message translates to:
  /// **'No service records for'**
  String get noServiceRecordsFor;

  /// Failed to load vehicles error message
  ///
  /// In en, this message translates to:
  /// **'Failed to load vehicles'**
  String get failedToLoadVehicles;

  /// Preferences section title
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// Support section title
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// Notifications setting label
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Notifications setting subtitle
  ///
  /// In en, this message translates to:
  /// **'Receive service reminders'**
  String get receiveServiceReminders;

  /// Export data setting label
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get exportData;

  /// Export data setting subtitle
  ///
  /// In en, this message translates to:
  /// **'Download all your data'**
  String get downloadAllYourData;

  /// Backup setting label
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get backup;

  /// Backup setting subtitle
  ///
  /// In en, this message translates to:
  /// **'Create a backup of your data'**
  String get createBackupOfYourData;

  /// Clear data setting label
  ///
  /// In en, this message translates to:
  /// **'Clear Data'**
  String get clearData;

  /// Clear data setting subtitle
  ///
  /// In en, this message translates to:
  /// **'Remove all data from the app'**
  String get removeAllDataFromApp;

  /// Help and FAQ setting label
  ///
  /// In en, this message translates to:
  /// **'Help & FAQ'**
  String get helpAndFaq;

  /// Help and FAQ setting subtitle
  ///
  /// In en, this message translates to:
  /// **'Find answers to common questions'**
  String get findAnswersToCommonQuestions;

  /// Rate app setting label
  ///
  /// In en, this message translates to:
  /// **'Rate App'**
  String get rateApp;

  /// Rate app setting subtitle
  ///
  /// In en, this message translates to:
  /// **'Rate us on the app store'**
  String get rateUsOnAppStore;

  /// Terms of Service setting label
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// Terms of Service setting subtitle
  ///
  /// In en, this message translates to:
  /// **'Read our terms and conditions'**
  String get readOurTermsAndConditions;

  /// Privacy Policy setting label
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Privacy Policy setting subtitle
  ///
  /// In en, this message translates to:
  /// **'Learn how we protect your data'**
  String get learnHowWeProtectYourData;

  /// App version
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get version;

  /// Copyright notice
  ///
  /// In en, this message translates to:
  /// **'© 2024 OtoLog. All rights reserved.'**
  String get copyright;

  /// Theme selector dialog title
  ///
  /// In en, this message translates to:
  /// **'Select Theme'**
  String get selectTheme;

  /// Light mode description
  ///
  /// In en, this message translates to:
  /// **'Use light theme'**
  String get lightModeDescription;

  /// Dark mode description
  ///
  /// In en, this message translates to:
  /// **'Use dark theme'**
  String get darkModeDescription;

  /// System mode description
  ///
  /// In en, this message translates to:
  /// **'Follow system settings'**
  String get systemModeDescription;

  /// Export data dialog title
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get exportDataTitle;

  /// Export data dialog description
  ///
  /// In en, this message translates to:
  /// **'This will export all your vehicle and service records to a JSON file. The file will be saved to your device\'s downloads folder.'**
  String get exportDataDescription;

  /// Export button
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// Export functionality not available message
  ///
  /// In en, this message translates to:
  /// **'Export functionality coming soon!'**
  String get exportFunctionalityComingSoon;

  /// Create backup dialog title
  ///
  /// In en, this message translates to:
  /// **'Create Backup'**
  String get createBackup;

  /// Create backup dialog description
  ///
  /// In en, this message translates to:
  /// **'This will create a backup of all your data. You can restore this backup later if needed.'**
  String get createBackupDescription;

  /// Backup functionality not available message
  ///
  /// In en, this message translates to:
  /// **'Backup functionality coming soon!'**
  String get backupFunctionalityComingSoon;

  /// Clear data dialog title
  ///
  /// In en, this message translates to:
  /// **'Clear All Data'**
  String get clearAllData;

  /// Clear data warning message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear all data? This action cannot be undone and will permanently delete all your vehicles and service records.'**
  String get clearDataWarning;

  /// Clear button
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// Clear data functionality not available message
  ///
  /// In en, this message translates to:
  /// **'Clear data functionality coming soon!'**
  String get clearDataFunctionalityComingSoon;

  /// Help FAQ question 1
  ///
  /// In en, this message translates to:
  /// **'How do I add a vehicle?'**
  String get howDoIAddAVehicle;

  /// Help FAQ answer 1
  ///
  /// In en, this message translates to:
  /// **'Go to the Garage tab and tap the \"Add Vehicle\" button. Fill in the required information and save.'**
  String get howDoIAddAVehicleAnswer;

  /// Help FAQ question 2
  ///
  /// In en, this message translates to:
  /// **'How do I add a service record?'**
  String get howDoIAddAServiceRecord;

  /// Help FAQ answer 2
  ///
  /// In en, this message translates to:
  /// **'Go to the Service Logs tab and tap the \"Add Service\" button. Select a vehicle, fill in the service details, and save.'**
  String get howDoIAddAServiceRecordAnswer;

  /// Help FAQ question 3
  ///
  /// In en, this message translates to:
  /// **'How do I switch between vehicles?'**
  String get howDoISwitchBetweenVehicles;

  /// Help FAQ answer 3
  ///
  /// In en, this message translates to:
  /// **'On the Home screen, tap the vehicle card to switch between your vehicles.'**
  String get howDoISwitchBetweenVehiclesAnswer;

  /// Rate app dialog title
  ///
  /// In en, this message translates to:
  /// **'Rate OtoLog'**
  String get rateOtoLog;

  /// Rate app dialog description
  ///
  /// In en, this message translates to:
  /// **'Enjoying OtoLog? Please consider rating us on the app store. Your feedback helps us improve!'**
  String get rateOtoLogDescription;

  /// Maybe later button
  ///
  /// In en, this message translates to:
  /// **'Maybe Later'**
  String get maybeLater;

  /// Rate now button
  ///
  /// In en, this message translates to:
  /// **'Rate Now'**
  String get rateNow;

  /// Opening app store message
  ///
  /// In en, this message translates to:
  /// **'Opening app store...'**
  String get openingAppStore;

  /// Terms of Service content
  ///
  /// In en, this message translates to:
  /// **'By using OtoLog, you agree to these terms:\n\n1. You are responsible for maintaining the confidentiality of your account.\n2. You agree not to use the app for any illegal purposes.\n3. We reserve the right to modify these terms at any time.\n4. Your data is stored locally on your device.\n5. We are not liable for any loss of data.\n\nFor more information, please contact us.'**
  String get termsOfServiceContent;

  /// Privacy Policy content
  ///
  /// In en, this message translates to:
  /// **'At OtoLog, we take your privacy seriously:\n\n1. All your data is stored locally on your device.\n2. We do not collect or transmit any personal data.\n3. We do not share your data with third parties.\n4. You can export or delete your data at any time.\n5. We use minimal permissions necessary for the app to function.\n\nIf you have any questions about our privacy practices, please contact us.'**
  String get privacyPolicyContent;
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
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
