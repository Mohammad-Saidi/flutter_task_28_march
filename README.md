# Rick and Morty Character Explorer

A Flutter application that allows users to explore characters from the Rick and Morty universe. 

## Setup Instructions

1. **Prerequisites**: Ensure you have Flutter SDK installed (version `^3.5.0` or compatible).
2. **Clone the repository**:
   ```bash
   git clone <https://github.com/Mohammad-Saidi/flutter_task_28_march.git>
   cd flutter_task_28_march
   ```
3. **Install dependencies**:
   ```bash
   flutter pub get
   ```
4. **Generate Hive Adapters** (if making changes to models requiring code generation):
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
5. **Run the app**:
   ```bash
   flutter run
   ```

## State Management Choice

**GetX** was chosen for state management, dependency injection, and simple routing. 
*Reasoning*: GetX provides a lightweight and powerful ecosystem for Flutter applications. It minimizes boilerplate code and separates business logic from UI smoothly. Its built-in reactive state management (using `Rx` variables and `Obx` widgets) is highly effective for handling dynamic behaviors—like pagination, offline fallback states, favorite toggles, and editing characters—without the heavy setup other solutions might require.

## Storage Approach Explanation

The application uses **Hive** (a lightweight, NoSQL, Dart-native key-value database) for fast local storage and offline capabilities.
* **Architecture**: The storage is organized into multiple boxes:
  - `charactersCache` box: Caches the paginated lists of characters from the API, enabling offline feed viewing.
  - `favorites` box: Persists characters that the user has marked as favorites.
  - `overrides` box: Stores user-edited fields (like changing a character's name or status). 
* **Data Merging Logic**: When rendering character details, the `CharacterRepository` fetches the entity from the API (or cache) and dynamically overlays it with any local modifications present in the `overrides` box. This perfectly preserves the user's edits while maintaining the original API values for untouched fields.

## Known Limitations

- **Search/Filters Offline**: Filtering characters by status or name bypasses standard pagination caching because the results are highly dynamic. Searching is limited or disabled when fully offline.
- **Image Caching Offline**: While text data is cached via Hive, character images rely on `cached_network_image`. If a character's image hasn't been loaded previously while online, it will show a placeholder offline.
