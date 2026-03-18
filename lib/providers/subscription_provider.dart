import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// Subscription Provider for RevenueCat integration
/// Manages Pro subscription status and purchase flow
class SubscriptionProvider with ChangeNotifier {
  bool _isPro = false;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  bool get isPro => _isPro;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Initialize RevenueCat SDK
  Future<void> initialize() async {
    try {
      _isLoading = true;
      notifyListeners();

      // TODO: Replace with actual RevenueCat API keys
      const androidApiKey = 'YOUR_REVENUECAT_ANDROID_API_KEY';
      const iosApiKey = 'YOUR_REVENUECAT_IOS_API_KEY';

      // Configure RevenueCat based on platform
      final apiKey = defaultTargetPlatform == TargetPlatform.android
          ? androidApiKey
          : iosApiKey;

      await Purchases.configure(
        PurchasesConfiguration(apiKey),
      );

      // Add listener for customer info updates
      Purchases.addCustomerInfoUpdateListener(_onCustomerInfoUpdate);

      // Fetch initial customer info
      await _fetchCustomerInfo();
    } catch (e) {
      _errorMessage = 'Failed to initialize subscriptions: $e';
      debugPrint('RevenueCat initialization error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Callback for customer info updates
  void _onCustomerInfoUpdate(CustomerInfo customerInfo) {
    _updateProStatus(customerInfo);
  }

  /// Fetch current customer info
  Future<void> _fetchCustomerInfo() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      _updateProStatus(customerInfo);
    } catch (e) {
      debugPrint('Error fetching customer info: $e');
    }
  }

  /// Update Pro status based on customer info
  void _updateProStatus(CustomerInfo customerInfo) {
    // Check if user has active Pro entitlement
    final hasProEntitlement = customerInfo.entitlements.active.containsKey('pro');
    
    if (_isPro != hasProEntitlement) {
      _isPro = hasProEntitlement;
      notifyListeners();
    }
  }

  /// Purchase Pro subscription
  Future<void> purchasePro() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Fetch available offerings
      final offerings = await Purchases.getOfferings();
      
      if (offerings.current == null) {
        _errorMessage = 'No subscription plans available';
        return;
      }

      final offering = offerings.current!;
      
      // Get the Pro package (assuming it's the first package)
      if (offering.availablePackages.isEmpty) {
        _errorMessage = 'No packages available';
        return;
      }

      final package = offering.availablePackages.first;

      // Make the purchase using the correct API
      final purchaseResult = await Purchases.purchaseStoreProduct(
        package.storeProduct,
      );
      
      // Update status
      _updateProStatus(purchaseResult.customerInfo);

      debugPrint('Purchase successful!');
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      
      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        _errorMessage = 'Purchase cancelled';
      } else if (errorCode == PurchasesErrorCode.paymentPendingError) {
        _errorMessage = 'Payment is pending';
      } else {
        _errorMessage = 'Purchase failed: ${e.message}';
      }
      
      debugPrint('Purchase error: $e');
    } catch (e) {
      _errorMessage = 'Unexpected error: $e';
      debugPrint('Unexpected purchase error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Restore purchases
  Future<void> restorePurchases() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final customerInfo = await Purchases.restorePurchases();
      _updateProStatus(customerInfo);

      if (!_isPro) {
        _errorMessage = 'No active subscriptions found';
      }
    } catch (e) {
      _errorMessage = 'Failed to restore purchases: $e';
      debugPrint('Restore error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    Purchases.removeCustomerInfoUpdateListener(_onCustomerInfoUpdate);
    super.dispose();
  }
}
