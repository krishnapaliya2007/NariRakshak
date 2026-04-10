class AppStrings {
  static bool isHindi = false;

  static String get appName =>
      isHindi ? 'नारी रक्षक' : 'NariRakshak';

  static String get tagline =>
      isHindi ? 'सामुदायिक महिला सुरक्षा' : 'Community Driven Women Safety';

  static String get sosButton =>
      isHindi ? 'आपातकाल SOS' : 'SOS EMERGENCY';

  static String get sosTap =>
      isHindi ? 'मदद के लिए टैप करें' : 'Tap to send emergency alert';

  static String get features =>
      isHindi ? 'सुरक्षा सुविधाएं' : 'Safety Features';

  static String get checkIn =>
      isHindi ? 'चेक-इन टाइमर' : 'Check-In Timer';

  static String get redZone =>
      isHindi ? 'खतरा क्षेत्र मैप' : 'Red Zone Map';

  static String get companion =>
      isHindi ? 'यात्रा साथी' : 'Travel Companion';

  static String get community =>
      isHindi ? 'सपोर्ट कम्युनिटी' : 'Support Community';

  static String get contacts =>
      isHindi ? 'विश्वसनीय संपर्क' : 'Trusted Contacts';

  static String get safetyTip =>
      isHindi ? 'सुरक्षा सुझाव' : 'Safety Tip';

  static String get safetyTipText =>
      isHindi
          ? 'रात में यात्रा से पहले विश्वसनीय संपर्क जोड़ें।'
          : 'Always add trusted contacts before travelling alone at night.';

  static String get loginTitle =>
      isHindi ? 'नारी रक्षक में आपका स्वागत है' : 'Welcome to NariRakshak';

  static String get sendOtp =>
      isHindi ? 'OTP भेजें' : 'Send OTP';

  static String get verifyOtp =>
      isHindi ? 'OTP सत्यापित करें' : 'Verify OTP';

  static String get iAmSafe =>
      isHindi ? 'मैं सुरक्षित हूँ!' : 'I am Safe!';

  static String get startTimer =>
      isHindi ? 'टाइमर शुरू करें' : 'Start Timer';
}