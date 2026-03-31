# Garage Screen Bug - Debug Documentation

## Bug Description

**Issue:** In the garage screen, when pressing on a vehicle to view its details and then pressing back to return to the vehicles list, only the vehicle that was just viewed is displayed instead of all vehicles.

## Root Cause Analysis

The bug was caused by improper state management in the [`VehicleCubit`](lib/cubit/vehicle_cubit.dart):

1. **Initial State:** When the vehicles screen loads, [`loadVehicles()`](lib/cubit/vehicle_cubit.dart:47) fetches all vehicles and emits a `VehicleLoaded` state with the complete list.

2. **Navigation to Detail Screen:** When a user taps on a vehicle, [`loadVehicleWithServices(vehicleId)`](lib/cubit/vehicle_cubit.dart:67) is called, which:
   - Loads only the selected vehicle
   - Emits a new `VehicleLoaded` state with `vehicles: [vehicle]` (a single vehicle)
   - **This overwrites the state that contained all vehicles**

3. **Returning to Vehicles Screen:** When the user navigates back:
   - The vehicles screen is still in the widget tree
   - It rebuilds with the current state from `VehicleCubit`
   - Since the state now contains only one vehicle, only that vehicle is displayed

### Visual Flow

```
Vehicles Screen (All Vehicles)
    ↓ [Tap Vehicle]
Vehicle Detail Screen (Single Vehicle State)
    ↓ [Press Back]
Vehicles Screen (Only Shows Single Vehicle) ❌ BUG
```

## Solution Implemented

### 1. State Caching

Added caching to preserve the complete vehicle list:

```dart
// Cache for all vehicles to preserve state across navigation
List<Vehicle>? _cachedAllVehicles;
List<ServiceRecord>? _cachedAllServiceRecords;
```

### 2. New Method: `restoreAllVehicles()`

Created a new method to restore all vehicles when returning to the vehicles screen:

```dart
// Restore all vehicles (call when returning to vehicles list screen)
Future<void> restoreAllVehicles() async {
  print('🔄 RESTORING ALL VEHICLES - Called from vehicles screen');
  
  // If we have cached vehicles, restore them immediately
  if (_cachedAllVehicles != null && _cachedAllServiceRecords != null) {
    final newState = VehicleLoaded(
      vehicles: _cachedAllVehicles!,
      serviceRecords: _cachedAllServiceRecords!,
    );
    emit(newState);
    _logState('restoreAllVehicles - Restored from cache', newState);
    return;
  }

  // Otherwise, reload from database
  // ... (fallback to database load)
}
```

### 3. Vehicles Screen Update with BlocListener

Modified [`vehicles_screen.dart`](lib/screens/garage/vehicles_screen.dart) to automatically detect and restore all vehicles when the state shows only one vehicle while on the vehicles route:

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    // ...
    body: SafeArea(
      child: Column(
        children: [
          // ...
          Expanded(
            child: BlocListener<VehicleCubit, VehicleState>(
              listener: (context, state) {
                print('🚗 VehiclesScreen: State changed - ${state.runtimeType}');
                if (state is VehicleLoaded) {
                  print('🚗 VehiclesScreen: Vehicle count = ${state.vehicles.length}');
                  // If we're on vehicles screen and only have 1 vehicle, restore all
                  final currentRoute = GoRouterState.of(context).uri.path;
                  print('🚗 VehiclesScreen: Current route = $currentRoute');
                  if (currentRoute == AppRoutes.vehicles && 
                      state.vehicles.length == 1) {
                    print('🚗 VehiclesScreen: Detected single vehicle on vehicles screen - Restoring all vehicles');
                    context.read<VehicleCubit>().restoreAllVehicles();
                  }
                }
              },
              child: BlocBuilder<VehicleCubit, VehicleState>(
                // ... builder code
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
```

### 4. Comprehensive Debug Logging

Added detailed logging to all state changes in [`VehicleCubit`](lib/cubit/vehicle_cubit.dart):

```dart
void _logState(String action, VehicleState state) {
  final timestamp = DateTime.now().toIso8601String();
  print('═══════════════════════════════════════════════════════════════');
  print('🚗 VEHICLE CUBIT DEBUG [$timestamp]');
  print('📍 Action: $action');
  print('📊 State Type: ${state.runtimeType}');
  
  if (state is VehicleLoaded) {
    print('📋 Vehicles Count: ${state.vehicles.length}');
    print('🔍 Filter Type: ${state.filterType ?? "None"}');
    print('⭐ Selected Vehicle ID: ${state.selectedVehicleId ?? "None"}');
    print('📝 Service Records: ${state.serviceRecords?.length ?? 0}');
    print('💰 Total Cost: ${state.totalCost ?? 0}');
    print('🔧 Service Count: ${state.serviceCount ?? 0}');
    
    // Log each vehicle
    for (int i = 0; i < state.vehicles.length; i++) {
      final v = state.vehicles[i];
      print('   └─ Vehicle $i: ID=${v.id}, Name="${v.name}", Primary=${v.isPrimary}');
    }
  } else if (state is VehicleError) {
    print('❌ Error: ${state.message}');
  }
  
  print('═══════════════════════════════════════════════════════════════');
}
```

## How to Use the Debug Features

### Viewing Debug Output

The debug logs are printed to the console. To view them:

1. **VS Code:**
   - Open the Debug Console (View → Debug)
   - Run the app in debug mode
   - Watch for the formatted debug output

2. **Terminal:**

   ```bash
   flutter run
   ```

   All debug output will appear in the terminal

### Debug Output Format

Each state change produces a formatted block:

```
═══════════════════════════════════════════════════════════════
🚗 VEHICLE CUBIT DEBUG [2026-03-31T12:58:31.061Z]
📍 Action: loadVehicles - Success
📊 State Type: VehicleLoaded
📋 Vehicles Count: 3
🔍 Filter Type: None
⭐ Selected Vehicle ID: None
📝 Service Records: 15
💰 Total Cost: 500000
🔧 Service Count: 15
   └─ Vehicle 0: ID=1, Name="Toyota Camry", Primary=true
   └─ Vehicle 1: ID=2, Name="Honda Civic", Primary=false
   └─ Vehicle 2: ID=3, Name="Ford Mustang", Primary=false
═══════════════════════════════════════════════════════════════
```

### Key Debug Messages

Watch for these important messages:

1. **`🔄 RESTORING ALL VEHICLES`** - Indicates when the vehicles screen is restoring the complete list
2. **`loadVehicleWithServices`** - Shows when a single vehicle is being loaded for detail view
3. **`restoreAllVehicles`** - Shows when the complete list is being restored
4. **`🚗 VehiclesScreen: Detected single vehicle on vehicles screen`** - Indicates automatic detection and restoration
5. **Vehicle count changes** - Monitor `📋 Vehicles Count` to track when the list changes

### Testing the Fix

1. **Open the garage screen** - Should show all vehicles
2. **Tap on any vehicle** - Should navigate to detail screen
3. **Press back** - Should return to garage screen with all vehicles displayed
4. **Check console** - Should see:

   ```
   🚗 VehiclesScreen: State changed - VehicleLoaded
   🚗 VehiclesScreen: Vehicle count = 1
   🚗 VehiclesScreen: Current route = /vehicles
   🚗 VehiclesScreen: Detected single vehicle on vehicles screen - Restoring all vehicles
   🔄 RESTORING ALL VEHICLES - Called from vehicles screen
   🚗 VEHICLE CUBIT DEBUG [...] - restoreAllVehicles - Restored from cache
   ```

## Files Modified

1. **[`lib/cubit/vehicle_cubit.dart`](lib/cubit/vehicle_cubit.dart)**
   - Added state caching (`_cachedAllVehicles`, `_cachedAllServiceRecords`)
   - Added `_logState()` method for comprehensive logging
   - Added `restoreAllVehicles()` method
   - Updated all methods to call `_logState()` before emitting states
   - Updated cache management in all vehicle-modifying operations

2. **[`lib/screens/garage/vehicles_screen.dart`](lib/screens/garage/vehicles_screen.dart)**
    - Added `BlocListener` to detect when state changes to single vehicle
    - Automatically calls `restoreAllVehicles()` when on vehicles route with single vehicle
    - Added console logging for state changes and route detection

## Benefits of This Solution

1. **Automatic Detection:** BlocListener automatically detects when state has only one vehicle on vehicles screen
2. **Immediate Restoration:** Uses cached data for instant restoration without database queries
3. **Comprehensive Debugging:** Every state change is logged with full context
4. **Performance:** Caching reduces unnecessary database queries
5. **Reliability:** Fallback to database load if cache is unavailable
6. **Maintainability:** Clear logging makes it easy to track state changes and diagnose issues

## Future Improvements

Consider these enhancements:

1. **Selective Cache Invalidation:** Invalidate cache only when data actually changes
2. **Automatic Cache Refresh:** Periodically refresh cache in background
3. **More Granular Logging:** Add performance timing for each operation
4. **Error Recovery:** Add retry logic for failed operations
5. **State Persistence:** Consider persisting cache to disk for faster app startup

## Troubleshooting

### Issue: Vehicles still not showing after returning

**Check:**

1. Console shows "RESTORING ALL VEHICLES" message
2. Cache is not null (check for "Restored from cache" vs "Loading from database")
3. No errors in the debug output

**Solution:**

- If cache is null, check if `loadVehicles()` was called initially
- Verify database connection is working
- Check for any exceptions in the debug output

### Issue: Too much debug output

**Solution:**

- Comment out `_logState()` calls in methods you don't need to debug
- Or add a debug flag to conditionally enable logging:

```dart
static const bool _enableDebugLogging = true;

void _logState(String action, VehicleState state) {
  if (!_enableDebugLogging) return;
  // ... rest of logging code
}
```

## Conclusion

The bug has been fixed by implementing state caching and automatic restoration when returning to the vehicles screen. Comprehensive debug logging has been added to help track state changes and diagnose any future issues.
