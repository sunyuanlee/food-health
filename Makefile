setup:
	@if [ ! -f env.development ]; then \
		cp env.development.example env.development; \
		echo "✅ 已从 env.development.example 创建 env.development，请按需修改 BASE_URL"; \
	else \
		echo "ℹ️  env.development 已存在，跳过创建"; \
	fi
	flutter pub get

dev:
	flutter run --dart-define-from-file=env.development

dev-release:
	flutter run --release --dart-define-from-file=env.development

build-ios:
	flutter build ios --dart-define-from-file=env.development
