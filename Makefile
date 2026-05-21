dev:
	flutter run --dart-define-from-file=env.development

dev-release:
	flutter run --release --dart-define-from-file=env.development

build-ios:
	flutter build ios --dart-define-from-file=env.development
