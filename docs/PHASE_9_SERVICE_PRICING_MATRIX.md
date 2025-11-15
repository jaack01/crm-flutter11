# Phase 9: Service Pricing Matrix

**Status**: ✅ Completed
**Date**: 2025-11-15

## Overview

Phase 9 implements a comprehensive Service Pricing Matrix feature that allows laundry businesses to define different prices for each combination of service and item type (e.g., "Wash & Fold" for "Shirt" vs "Wash & Fold" for "Bedsheet"). This enables flexible, granular pricing control with support for rush order premium pricing.

## Business Value

- **Flexible Pricing**: Different prices for different item types within the same service
- **Rush Order Pricing**: Optional premium pricing for urgent orders
- **Automatic Price Lookup**: Order creation automatically uses configured prices
- **Manual Override**: Ability to override prices when needed
- **Price Management UI**: Easy-to-use interface for managing pricing matrix

## Features Implemented

### 1. Data Layer

#### Service Pricing Model
- **File**: `lib/data/models/service_pricing_model.dart`
- **Features**:
  - JSON serialization/deserialization
  - Entity conversion (toEntity/fromEntity)
  - Boolean to integer conversion for SQLite
  - Includes populated fields: serviceName, itemTypeName
  - copyWith method for immutability

#### Service Pricing Local Data Source
- **File**: `lib/data/datasources/local/service_pricing_local_datasource.dart`
- **Methods**:
  - `getAllServicePricing()` - Returns all active pricing with SQL JOINs
  - `getServicePricing(serviceId, itemTypeId)` - Get specific combination
  - `getPricingByService(serviceId)` - All pricing for a service
  - `getPricingByItemType(itemTypeId)` - All pricing for an item type
  - `addServicePricing(pricing)` - Insert with duplicate check
  - `updateServicePricing(pricing)` - Update existing pricing
  - `deleteServicePricing(id)` - Soft delete (sets is_active = 0)
- **Features**:
  - SQL JOIN queries to populate service and item type names
  - Duplicate prevention on insert
  - Soft delete pattern

#### Repository Updates
- **File**: `lib/data/repositories/service_repository_impl.dart`
- **Changes**:
  - Added `servicePricingLocalDataSource` parameter
  - Implemented all 7 pricing repository methods
  - Proper error handling with Either<Failure, T>

### 2. Domain Layer

#### Use Cases (7 total)
- **Directory**: `lib/domain/usecases/pricing/`
- **Files**:
  - `get_all_service_pricing.dart`
  - `get_service_pricing.dart`
  - `get_pricing_by_service.dart`
  - `get_pricing_by_item_type.dart`
  - `add_service_pricing.dart`
  - `update_service_pricing.dart`
  - `delete_service_pricing.dart`

### 3. Presentation Layer

#### Pricing BLoC
- **Files**:
  - `lib/presentation/blocs/pricing/pricing_event.dart`
  - `lib/presentation/blocs/pricing/pricing_state.dart`
  - `lib/presentation/blocs/pricing/pricing_bloc.dart`
- **Events**:
  - `LoadAllServicePricing`
  - `LoadServicePricing(serviceId, itemTypeId)`
  - `LoadPricingByService(serviceId)`
  - `LoadPricingByItemType(itemTypeId)`
  - `AddServicePricingEvent(pricing)`
  - `UpdateServicePricingEvent(pricing)`
  - `DeleteServicePricingEvent(id)`
- **States**:
  - `PricingInitial`
  - `PricingLoading`
  - `AllServicePricingLoaded(pricingList)`
  - `ServicePricingLoaded(pricing)`
  - `PricingListLoaded(pricingList)`
  - `PricingOperationSuccess(message)`
  - `PricingError(message)`

#### Service Pricing Matrix UI
- **File**: `lib/presentation/pages/pricing/service_pricing_page.dart`
- **Features**:
  - View all pricing combinations in card format
  - Filter by service or item type
  - Add new pricing with form dialog
  - Edit existing pricing
  - Delete pricing with confirmation
  - Shows both regular and rush order prices
  - Displays service and item type names
  - Active/inactive status indicator
- **Components**:
  - `ServicePricingPage` - Main page with list and filters
  - `_PricingFormDialog` - Add/edit pricing dialog
  - Price display cards with color coding
  - Dropdown filters for service and item type

### 4. Order Creation Integration

#### Enhanced Order Item Dialog
- **File**: `lib/presentation/pages/orders/create_order_page.dart`
- **Changes**:
  - Added item type selection dropdown
  - Integrated PricingBloc for automatic price lookup
  - Shows pricing from matrix with helper text
  - Supports rush order pricing
  - Falls back to service base price if no pricing configured
  - Shows item type name in order item cards
  - Manual price override still available

#### Updated Order Item Entry
- **Changes**:
  - Added `itemTypeId` and `itemTypeName` fields
  - Order items now store complete pricing information

### 5. Routing and Navigation

#### New Route
- **Path**: `/pricing`
- **Name**: `pricing`
- **BLoCs**: PricingBloc, ServiceBloc
- **Page**: ServicePricingPage

### 6. Dependency Injection

#### Additions to `injection_container.dart`
- ServicePricingLocalDataSource registration
- 7 pricing use case registrations
- PricingBloc factory registration
- Updated ServiceRepository with pricing datasource

## Technical Details

### Database Schema
The service_pricing table was already created in Phase 3:
```sql
CREATE TABLE service_pricing (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  service_id INTEGER NOT NULL,
  item_type_id INTEGER NOT NULL,
  price REAL NOT NULL,
  rush_order_price REAL,
  is_active INTEGER DEFAULT 1,
  created_at TEXT NOT NULL,
  FOREIGN KEY (service_id) REFERENCES services(id),
  FOREIGN KEY (item_type_id) REFERENCES item_types(id),
  UNIQUE(service_id, item_type_id)
);
```

### Key Design Decisions

1. **Soft Delete**: Using `is_active` flag instead of physical deletion to preserve pricing history

2. **Duplicate Prevention**: Check before insert to prevent multiple prices for same service+item type combination

3. **JOIN Queries**: Populate service and item type names in queries for display purposes, eliminating the need for additional lookups

4. **Rush Order Support**: Optional `rushOrderPrice` field for premium pricing on urgent orders

5. **Null-safe Datasource**: Optional parameter with null checks for backward compatibility

6. **Price Fallback**: Order creation falls back to service base price if no pricing matrix entry exists

7. **Manual Override**: Users can still manually override prices in order creation

## Usage Workflows

### 1. Configure Pricing Matrix

1. Navigate to Service Pricing page (`/pricing`)
2. Click "Add Pricing" FAB
3. Select service and item type
4. Enter regular price
5. Optionally enter rush order price
6. Set active status
7. Save

### 2. Create Order with Pricing Matrix

1. Navigate to Create Order page
2. Select customer and order details
3. Click "Add Item"
4. Select service
5. Select item type
6. **Price is automatically populated** from pricing matrix
7. Shows helper text indicating source (matrix or manual)
8. If rush order, automatically uses rush price
9. Can override price if needed
10. Set quantity and add item

### 3. Manage Existing Pricing

1. Navigate to Service Pricing page
2. Use filters to find specific pricing
3. Click "Edit" on pricing card
4. Modify price or status
5. Save changes

### 4. Delete Pricing

1. Navigate to Service Pricing page
2. Click "Delete" on pricing card
3. Confirm deletion
4. Pricing is soft deleted (marked inactive)

## Files Created

### Data Layer
- `lib/data/models/service_pricing_model.dart`
- `lib/data/datasources/local/service_pricing_local_datasource.dart`

### Domain Layer
- `lib/domain/usecases/pricing/get_all_service_pricing.dart`
- `lib/domain/usecases/pricing/get_service_pricing.dart`
- `lib/domain/usecases/pricing/get_pricing_by_service.dart`
- `lib/domain/usecases/pricing/get_pricing_by_item_type.dart`
- `lib/domain/usecases/pricing/add_service_pricing.dart`
- `lib/domain/usecases/pricing/update_service_pricing.dart`
- `lib/domain/usecases/pricing/delete_service_pricing.dart`

### Presentation Layer
- `lib/presentation/blocs/pricing/pricing_event.dart`
- `lib/presentation/blocs/pricing/pricing_state.dart`
- `lib/presentation/blocs/pricing/pricing_bloc.dart`
- `lib/presentation/pages/pricing/service_pricing_page.dart`

### Documentation
- `docs/PHASE_9_SERVICE_PRICING_MATRIX.md`

## Files Modified

- `lib/core/di/injection_container.dart` - Added pricing dependencies
- `lib/data/repositories/service_repository_impl.dart` - Implemented pricing methods
- `lib/presentation/routes/app_router.dart` - Added pricing route and updated order route
- `lib/presentation/pages/orders/create_order_page.dart` - Integrated pricing matrix

## Testing Recommendations

### Unit Tests
1. ServicePricingModel serialization/deserialization
2. ServicePricingLocalDataSource CRUD operations
3. Pricing use cases
4. PricingBloc event handling
5. Duplicate prevention logic

### Integration Tests
1. Full pricing matrix workflow
2. Order creation with pricing lookup
3. Rush order pricing application
4. Price fallback when no matrix entry exists

### Manual Testing
1. Create pricing for various service+item type combinations
2. Verify pricing appears correctly in order creation
3. Test rush order pricing
4. Verify manual price override still works
5. Test filtering and search
6. Verify soft delete behavior

## Future Enhancements

1. **Bulk Pricing Import**: CSV import for bulk pricing setup
2. **Pricing History**: Track price changes over time
3. **Seasonal Pricing**: Support for date-based pricing rules
4. **Tiered Pricing**: Volume-based pricing discounts
5. **Price Templates**: Reusable pricing templates
6. **Analytics**: Pricing effectiveness analytics
7. **Customer-specific Pricing**: Custom prices for VIP customers
8. **Dynamic Pricing**: AI-based pricing recommendations

## Dependencies

- dartz: ^0.10.1 (Functional programming)
- equatable: ^2.0.5 (Value comparison)
- flutter_bloc: ^8.1.3 (State management)
- sqflite: ^2.3.0 (Local database)
- get_it: ^7.6.0 (Dependency injection)

## Notes

- Pricing matrix is optional; orders can still be created without it
- Service base price serves as fallback
- Manual price override always available
- Item types need to be configured before creating pricing
- Consider adding default pricing when creating new services

## Performance Considerations

- JOIN queries are efficient for small-medium datasets
- Consider indexing on (service_id, item_type_id) for large datasets
- Pricing lookup happens on-demand, not preloaded
- Caching could be added for frequently accessed pricing

## Completion Checklist

- [x] Create ServicePricingModel
- [x] Create ServicePricingLocalDataSource
- [x] Update ServiceRepositoryImpl
- [x] Create pricing use cases (7 total)
- [x] Create PricingBloc (events, states, bloc)
- [x] Create ServicePricingPage UI
- [x] Add pricing route
- [x] Update dependency injection
- [x] Integrate pricing with order creation
- [x] Update order item entry to include item type
- [x] Add pricing lookup in order dialog
- [x] Support rush order pricing
- [x] Create documentation
- [x] Commit changes

## Next Phase Recommendations

Based on remaining features, the recommended next phases are:

1. **Phase 10: Customer Details Page** - Complete customer management
2. **Phase 11: Reports & Analytics** - Business insights and reporting
3. **Phase 12: PDF Generation** - Invoice and receipt generation
4. **Phase 13: Inventory Management** - Stock tracking
5. **Phase 14: Employee Management** - Staff and role management
