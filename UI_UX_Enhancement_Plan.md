# UI/UX Enhancement Plan for Islamic Duas App

## Objective
Enhance the UI/UX of the Islamic Duas App, focusing on a traditional Islamic aesthetic with rich colors and intricate patterns. This includes improving the visual design, user interaction, and overall user experience.

## Overall Strategy:
1.  **Define a Custom Theme**: Create a `theme/app_theme.dart` file to centralize color schemes, text styles, and potentially custom widgets that reflect the traditional Islamic aesthetic. This will ensure consistency across the app.
2.  **Update `pubspec.yaml`**: If specific traditional Arabic or decorative English fonts are identified, I will instruct you to add them to the `assets/fonts` directory and declare them in `pubspec.yaml`.
3.  **Apply Theme in `main.dart`**: Integrate the custom theme into the `MaterialApp`.
4.  **Enhance Screen UI**: Modify `DuaListScreen`, `DuaDetailScreen`, and `FavoritesScreen` to utilize the new theme and incorporate visual elements that align with the desired aesthetic.

## Detailed Plan:

### Goal 1: Define a Custom Theme for Traditional Islamic Aesthetic
*   **Action**: Create a new file `islamic_duas_app/lib/theme/app_theme.dart`.
*   **Content**: This file will define:
    *   **Color Palette**: Rich colors like deep greens, golds, maroons, and creams.
    *   **Text Styles**: Custom `TextTheme` for different text elements (e.g., app bar titles, dua titles, Arabic text, narration, source).
    *   **Card Theme**: Define `CardTheme` with subtle shadows, rounded corners, and appropriate background colors.
    *   **AppBar Theme**: Style the `AppBar` with a suitable background color and text style.
    *   **Button Theme**: Define styles for interactive elements.

### Goal 2: Update `pubspec.yaml` for Custom Fonts (if necessary)
*   **Action**: If specific traditional Arabic or decorative English fonts are identified, I will instruct you to add them to the `assets/fonts` directory and declare them in `pubspec.yaml`.

### Goal 3: Apply the Custom Theme in `main.dart`
*   **Action**: Modify the `ThemeData` in `islamic_duas_app/lib/main.dart` to use the newly defined `AppTheme`.

### Goal 4: Enhance `DuaListScreen`
*   **Action**: Modify `islamic_duas_app/lib/screens/dua_list_screen.dart`.
*   **Improvements**:
    *   Apply `AppBar` theme.
    *   Enhance `Card` appearance (e.g., background color, border radius, elevation).
    *   Improve `ListTile` styling (e.g., text styles for title and subtitle, leading/trailing icons if applicable).
    *   Consider adding a subtle background pattern or image to the `Scaffold` body for a richer feel.

### Goal 5: Enhance `DuaDetailScreen`
*   **Action**: Modify `islamic_duas_app/lib/screens/dua_detail_screen.dart`.
*   **Improvements**:
    *   Apply `AppBar` theme.
    *   Style the narration text with an appropriate font and color.
    *   Enhance the `Card` for each supplication (e.g., background, padding, shadows).
    *   Crucially, ensure the Arabic text (`supplication.arabicText`) uses a suitable Arabic font (if added) and a larger, bold style.
    *   Style the virtue, source, and notes text.
    *   Consider adding decorative dividers or separators between sections.

### Goal 6: Enhance `FavoritesScreen`
*   **Action**: Modify `islamic_duas_app/lib/screens/favorites_screen.dart`.
*   **Improvements**:
    *   Apply `AppBar` theme.
    *   Similar `Card` and `ListTile` enhancements as `DuaListScreen`.
    *   Ensure the favorite icon (`Icons.favorite`) color aligns with the new theme.

```mermaid
graph TD
    A[Start UI/UX Enhancement] --> B{Define Custom Theme};
    B --> B1[Create app_theme.dart];
    B1 --> B2[Define Color Palette];
    B1 --> B3[Define Text Styles];
    B1 --> B4[Define Card, AppBar, Button Themes];
    B --> C{Update pubspec.yaml};
    C --> C1[Add Custom Fonts (if needed)];
    C1 --> D[Apply Theme in main.dart];
    D --> E[Enhance DuaListScreen];
    E --> E1[Apply AppBar Theme];
    E --> E2[Enhance Card/ListTile];
    E --> E3[Add Background Pattern];
    D --> F[Enhance DuaDetailScreen];
    F --> F1[Apply AppBar Theme];
    F --> F2[Style Narration Text];
    F --> F3[Enhance Supplication Cards];
    F --> F4[Ensure Arabic Font/Style];
    F --> F5[Style Virtue/Source/Notes];
    F --> F6[Add Decorative Dividers];
    D --> G[Enhance FavoritesScreen];
    G --> G1[Apply AppBar Theme];
    G --> G2[Enhance Card/ListTile];
    G --> G3[Adjust Favorite Icon Color];
    E & F & G --> H[Review and Refine];
    H --> I[End UI/UX Enhancement];