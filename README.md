# Spirit - Mobile Learning Application

A modern Flutter-based mobile learning application focused on delivering quality, spiritually inspired educational content via YouTube video playlists.

## 🌟 Features

### ✅ Phase 1 (Static MVP - Current Implementation)
- **Modern UI Design**: Clean, responsive interface with spiritual-inspired color scheme
- **Course Categories**: Spiritual wisdom, meditation, ancient knowledge, consciousness
- **Video Playlists**: YouTube-integrated video courses with progress tracking
- **Progress Tracking**: Static UI showing completed videos, course progress, and watch time
- **User Profile**: Profile screen with achievements and motivational quotes
- **State Management**: Provider pattern for scalable architecture

### 🎯 Future Enhancements (Phase 2+)
- Full Firebase integration (Auth, Firestore, Storage)
- User progress saved dynamically
- Real-time sync of watch history
- Notifications, comments, and quizzes
- Role-based content access (admin, learner, guest)

## 🏗️ Architecture

### Project Structure
```
lib/
├── data/           # Static data and mock content
├── models/         # Data models (Category, Course, Video, UserProgress)
├── providers/      # State management (Provider pattern)
├── screens/        # UI screens (Home, Video, Progress, Profile)
├── theme/          # App theming and styling
├── utils/          # Helper functions and constants
└── widgets/        # Reusable UI components
```

### Key Components
- **Models**: Category, Course, Video, UserProgress with JSON serialization
- **Providers**: CourseProvider, ProgressProvider, VideoProvider for state management
- **Screens**: Home, CourseDetail, Video, Progress, Profile
- **Widgets**: CategoryCard, CourseCard, VideoListItem, ProgressIndicator

## 🎨 Design System

### Color Palette
- **Primary Purple**: #6B46C1 (Spiritual wisdom)
- **Secondary Green**: #059669 (Growth and nature)
- **Accent Gold**: #F59E0B (Enlightenment)
- **Deep Red**: #DC2626 (Passion and energy)
- **Soft Violet**: #7C3AED (Consciousness)

### Typography
- **Display**: Playfair Display (Elegant headings)
- **Body**: Inter (Clean, readable text)

## 🔧 Dependencies

### Core Dependencies
- `flutter`: SDK
- `provider`: State management
- `webview_flutter`: WebView integration for video display
- `url_launcher`: External app/browser launching
- `http`: Network requests
- `cached_network_image`: Efficient image loading
- `google_fonts`: Typography

### Development Dependencies
- `flutter_test`: Testing framework
- `flutter_lints`: Code quality

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.8.0+)
- Dart SDK
- Android Studio / VS Code
- Android/iOS device or emulator

### Installation
1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

## 📱 Screens Overview

### Home Screen
- Welcome header with gradient background
- Search functionality
- Featured courses carousel
- Category grid with spiritual themes
- Recent courses section

### Course Detail Screen
- Course thumbnail and information
- Progress tracking section
- Video list with completion status
- Course tags and difficulty level

### Video Screen
- YouTube player integration
- Video controls and progress
- Mark as completed functionality
- Auto-play next video
- Video description and tags

### Progress Screen
- Learning overview with statistics
- Learning streak tracking
- Recent activity feed
- In-progress and completed courses

### Profile Screen
- User profile header
- Daily motivational quotes
- Achievement system
- Learning preferences
- App information

## 🎯 Static Data

The app currently uses static data for demonstration:
- 4 spiritual categories
- 6 sample courses
- 8+ sample videos with YouTube integration
- Mock user progress data
- Motivational quotes collection

## 🔮 Future Development

### Phase 2: Firebase Integration
- User authentication
- Cloud Firestore for data storage
- Real-time progress synchronization
- Push notifications

### Phase 3: Advanced Features
- Offline video downloads
- Community features (comments, discussions)
- Quiz and assessment system
- Personalized recommendations
- Admin dashboard

## 🤝 Contributing

This is a learning project focused on modern Flutter development practices. Contributions and suggestions are welcome!

## 📄 License

This project is for educational purposes and personal use.
