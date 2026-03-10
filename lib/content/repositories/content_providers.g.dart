// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(contentRepository)
final contentRepositoryProvider = ContentRepositoryProvider._();

final class ContentRepositoryProvider
    extends
        $FunctionalProvider<
          ContentRepository,
          ContentRepository,
          ContentRepository
        >
    with $Provider<ContentRepository> {
  ContentRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contentRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contentRepositoryHash();

  @$internal
  @override
  $ProviderElement<ContentRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ContentRepository create(Ref ref) {
    return contentRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ContentRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ContentRepository>(value),
    );
  }
}

String _$contentRepositoryHash() => r'c4939a9a5043e63893de6ea251b44beaf249d0b9';

@ProviderFor(trackManifest)
final trackManifestProvider = TrackManifestFamily._();

final class TrackManifestProvider
    extends
        $FunctionalProvider<
          AsyncValue<TrackManifest>,
          TrackManifest,
          FutureOr<TrackManifest>
        >
    with $FutureModifier<TrackManifest>, $FutureProvider<TrackManifest> {
  TrackManifestProvider._({
    required TrackManifestFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'trackManifestProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$trackManifestHash();

  @override
  String toString() {
    return r'trackManifestProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<TrackManifest> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<TrackManifest> create(Ref ref) {
    final argument = this.argument as String;
    return trackManifest(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TrackManifestProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$trackManifestHash() => r'36d4c24adcc7e03af59e8b4728fef5d722a4bb00';

final class TrackManifestFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<TrackManifest>, String> {
  TrackManifestFamily._()
    : super(
        retry: null,
        name: r'trackManifestProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TrackManifestProvider call(String trackId) =>
      TrackManifestProvider._(argument: trackId, from: this);

  @override
  String toString() => r'trackManifestProvider';
}

@ProviderFor(lessonBundle)
final lessonBundleProvider = LessonBundleFamily._();

final class LessonBundleProvider
    extends
        $FunctionalProvider<
          AsyncValue<LessonBundle>,
          LessonBundle,
          FutureOr<LessonBundle>
        >
    with $FutureModifier<LessonBundle>, $FutureProvider<LessonBundle> {
  LessonBundleProvider._({
    required LessonBundleFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'lessonBundleProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$lessonBundleHash();

  @override
  String toString() {
    return r'lessonBundleProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<LessonBundle> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<LessonBundle> create(Ref ref) {
    final argument = this.argument as String;
    return lessonBundle(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LessonBundleProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$lessonBundleHash() => r'2ed197b5d9afd624c8ff913e9bd5cd335ba25a1d';

final class LessonBundleFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<LessonBundle>, String> {
  LessonBundleFamily._()
    : super(
        retry: null,
        name: r'lessonBundleProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LessonBundleProvider call(String widgetId) =>
      LessonBundleProvider._(argument: widgetId, from: this);

  @override
  String toString() => r'lessonBundleProvider';
}
