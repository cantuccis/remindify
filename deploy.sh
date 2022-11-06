firebase use remindify-bd881
echo "Building release"
flutter build web --release --web-renderer canvaskit --dart-define=BROWSER_IMAGE_DECODING_ENABLED=false
echo "Setup firebase.json"
#cp firebase-dev.json firebase.json
firebase deploy --only hosting:remindify-axny-dev

