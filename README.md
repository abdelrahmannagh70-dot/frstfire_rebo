📚 Bookia App

A modern mobile application built with Flutter and Dart that lets users browse books, search, view details, manage a shopping cart, and manage their profile.

The project follows a modular, feature-based structure using Cubit (flutter_bloc) for state management and Dio for networking, so the code stays organized, reusable, and easy to maintain.

📱 Screenshots
Splash & Welcome
<p align="center"> <img src="assets/images/splash1.png" width="250" alt="Splash Screen"> 
<img src="assets/images/welcome 2.png" width="250" alt="Welcome Screen"> </p>
Authentication
<p align="center"> <img src="assets/images/login.png" width="250" alt="Login Screen"> 
<img src="assets/images/register 1.png" width="250" alt="Register Screen">
<img src="assets/images/error.png" width="250" alt="Login Error State"> </p>
Home
<p align="center"> <img src="assets/images/home_screenn.png" width="250" alt="Home Screen"> 
<img src="assets/images/silder.png" width="250" alt="Home Slider"> </p>
Search
<p align="center"> <img src="assets/images/search2.png" width="250" alt="Search"> 
<img src="assets/images/search3.png" width="250" alt="Search Results"> </p>
Book Details
<p align="center"> <img src="assets/images/details.png" width="250" alt="Book Details"> 
<img src="assets/images/details3.png" width="250" alt="Book Details Description"> </p>
Bottom Navigation
<p align="center"> <img src="assets/images/nav1.jpg" width="250" alt="Navigation 1">
<img src="assets/images/nav3.jpg" width="250" alt="Navigation 2"> </p>
Profile
<p align="center"> 
<img src="assets/images/profile1.jpg" width="250" alt="Profile 1"> 
<img src="assets/images/profile2.jpg" width="250" alt="Profile 2"> 
<img src="assets/images/edit.jpg" width="300">
<img src="assets/images/orders.jpg" width="300">
<img src="assets/images/orders2.jpg" width="300">
<img src="assets/images/orders3.jpg" width="300">
</p>
Cart
<p align="center"> <img src="assets/images/cart1.jpg" width="250" alt="Cart 1">
<img src="assets/images/cart2.jpg" width="250" alt="Cart 2"> </p>
Error Handeler
<img src="assets/images/errorHandeler.jpg" width="250" alt="Error">
Note: GitHub paths are case-sensitive, and filenames containing spaces (like welcome 2.png) must match exactly. Renaming files to use underscores (e.g. welcome_2.png) avoids problems.

✨ Features
Authentication
Login screen with email and password fields.
Registration screen UI.
Form validation for user input.
Loading, success, and error states managed by AuthCubit.
Navigation after successful authentication.
Home
Best Seller books list.
Banner slider with page indicators.
Add to cart directly from the home screen.
Search & Book Details
Search for books by name.
Book details screen (name, price, discount, description, category).
Navigation
Bottom navigation bar to move between the main screens.
Profile
Displays the logged-in user's data (name, email, image, address, city, phone).
Cart
Fetch the cart from the API with a skeleton loading effect.
Cart items list with image, name, price, discount, and quantity.
Increase / decrease quantity of an item.
Remove an item from the cart.
Order summary with the total price.
Item counter badge in the app bar.
Pull-to-refresh and a refresh button.
Empty cart view and error view.
Thin progress bar while an item is being updated or removed.
SnackBar error messages for failed operations.
Centralized API error handling with ApiErrorHandler.
Readable error messages for Dio exceptions and HTTP status codes.
Application Architecture
State management using Cubit and flutter_bloc.
Centralized API endpoints (ApiEndPoint).
Centralized named routes.
Repository pattern for data access.
Centralized API error handling using ApiErrorHandler.
Reusable UI components.
Responsive layouts using Flutter ScreenUtil.
Localization support using Easy Localization.
🛠️ Technologies & Packages
Package / Tool  Purpose
Flutter / Dart  Building the app and programming language
flutter_bloc    State management (Cubit and BlocBuilder / BlocConsumer / BlocProvider)
bloc    Core Bloc library used by flutter_bloc
meta    Annotations such as @immutable on state classes
dio Sending HTTP requests (GET / POST) to the API
flutter_screenutil  Responsive sizing (.w, .h, .sp, .r)
easy_localization   Multi-language support (English / German)
pretty_dio_logger   Readable request/response logs in the console (verify in your pubspec.yaml)
firebase_core    Firebase initialization (required when Firebase is configured)
firebase_auth    Optional Firebase Authentication
cloud_firestore  Optional Cloud Firestore database
firebase_storage Optional Firebase file storage
firebase_messaging Optional Firebase push notifications

Tip: Open pubspec.yaml and make sure this table matches the packages you actually use. Add any others you installed (for example image caching, shimmer, or HTML rendering packages).

🔐 Authentication
Login
Email and password input fields.
Form validation before submitting credentials.
API request using Dio.
Loading state while waiting for the response.
Success and error states managed by AuthCubit.
Navigation to the home screen after successful login.
The returned token is sent as a Bearer token in the Authorization header on later requests.
Register

Fields: Username, Email, Password, Confirm Password.

Note: The registration UI is separate from login and may not be connected to a working API endpoint yet.

Auth states: AuthInitial, LoginLoadingState, LoginSuccessState, LoginErrorState.

🏠 Home: Best Sellers & Slider
Best Seller
Endpoint: GET products-bestseller
HomeCubit.getBestSellerBox() emits loading, then success or error.
HomeRepo fetches the data and BookModel represents each book.
State   Purpose
HomeInitial Before any request
GetBestSellerLoading    Books are loading
GetBestSellerSuccess    Request succeeded
GetBestSellerError  Request failed
Slider
Endpoint: GET sliders (response: data.sliders[].image).
File    Responsibility
slider_model.dart   Converts JSON to SliderModel, SliderData, SliderItem
slider_repo.dart    Sends the request using Dio
slider_cubit.dart   Calls the repo and emits states
slider_state.dart   SliderInitial, SliderLoading, SliderSuccess, SliderError
home_slider.dart    PageView.builder with indicators and Image.network

Both HomeCubit and SliderCubit are provided to the Home screen with MultiBlocProvider, so each request stays independent.

🔎 Search & Book Details
Search: products-search endpoint returns books matching the query.
Details: products/ endpoint combined with the book id returns the full book information (name, description, price, discount, price after discount, stock, category, image).
👤 Profile
Endpoint: GET profile/
Returns the user's id, name, email, address, city, phone, email verification status, and image.
🛒 Cart Feature
Endpoints
Action  Method Endpoint   Body
Get cart    GET    cart/  none
Add to cart POST   add-to-cart    product_id
Update quantity POST   update-cart    cart_item_id, quantity
Remove item POST   remove-from-cart   cart_item_id

cart_item_id is the id of the cart item (item_id in the cart response), not the product id. product_id is only used when adding to the cart.

Files
File    Responsibility
cart_model.dart CartResponseModel, CartDataModel, cart items, user
cart_repo.dart  getCartData, removeFromCart, updateCart using Dio
cart_cubit.dart Cart logic and currentCartData cache
cart_state.dart Cart states
cart_screen.dart    Main cart screen (BlocConsumer)
cart_item_card.dart Single item card with quantity and remove buttons
cart_summary.dart   Order summary and checkout
cart_skeleton_loading.dart  Loading placeholder
cart_empty_view.dart    Empty cart view
cart_error_view.dart    Error view
Cart States
State   Purpose
CartInitial Before the cart is requested
GetCartLoading  Cart is loading
GetCartSuccess  Cart loaded (holds cartData)
GetCartError    Failed to load the cart
CartItemActionLoading   An item is being updated or removed
CartItemActionError An item action failed (SnackBar shown in CartScreen)
Cart Flow
CartScreen calls getCartData() once when opened (if the state is CartInitial).
The cubit emits GetCartLoading, then GetCartSuccess with the data.
When the user changes quantity or removes an item, the cubit emits CartItemActionLoading and the screen shows a thin progress bar.
CartRepo sends the POST request. On success, the cart is fetched again so the UI shows the updated data.
On failure, an error state is emitted and a SnackBar message is shown.
Error Logging in CartRepo

CartRepo prints the status code, error type, and URL of any failed request using debugPrint, so failed requests are no longer silent:

text
[updateCart] DioException | status: 422 | type: DioExceptionType.badResponse | url: .../api/update-cart
🌐 API Integration

All endpoints are stored in one place:

dart
class ApiEndPoint {
static const String baseUrl = "https://codingarabic.eraapro.com/api/";

static const String login = "login";
static const String bestSeller = "products-bestseller";
static const String search = "products-search";
static const String BookDetails = "products/";
static const String sliders = "sliders";
static const String Profile = "profile/";

static const String AddToCart = "add-to-cart";
static const String cart = "cart/";
static const String removeFromCart = "remove-from-cart";
static const String updateCart = "update-cart";
}
Layer   Responsibility
ApiEndPoint Base URL and endpoint paths
Repository  Sends requests and returns models
Model   Converts JSON into Dart objects
Cubit   Emits loading / success / error states
UI  Displays content based on the current state


## 🔥 Firebase Integration
<img src="assets/images/firebase1.png" width="300">
<img src="assets/images/firebase2.png" width="300">


This project currently uses a REST API with **Dio** for its existing backend features, including login, books, profile, and cart operations. Firebase can be added alongside that backend. Adding Firebase Core does **not** automatically move the existing login, products, profile, or cart data to Firebase.

Use only the Firebase services your app needs:

| Firebase service | What it can be used for in Bookia |
|---|---|
| Firebase Core | Initializes Firebase in the Flutter app. Required by the other Firebase Flutter plugins. |
| Firebase Authentication | Optional alternative or additional authentication using email/password, Google, etc. |
| Cloud Firestore | Optional database for app data such as favorites, reviews, or user-generated content. |
| Firebase Storage | Optional storage for user-uploaded profile pictures or other files. |
| Firebase Cloud Messaging | Push notifications, for example order updates or promotions. |

### 1. Prerequisites

Install and configure:

- Flutter SDK and Dart SDK.
- Node.js and npm.
- The official Firebase CLI.
- FlutterFire CLI.
- A Google account with access to the Firebase project.

Install the Firebase CLI:

```bash
npm install -g firebase-tools