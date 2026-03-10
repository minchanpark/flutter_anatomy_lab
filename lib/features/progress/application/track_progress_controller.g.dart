// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_progress_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(trackProgressRepository)
final trackProgressRepositoryProvider = TrackProgressRepositoryProvider._();

final class TrackProgressRepositoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<TrackProgressRepository>,
          TrackProgressRepository,
          FutureOr<TrackProgressRepository>
        >
    with
        $FutureModifier<TrackProgressRepository>,
        $FutureProvider<TrackProgressRepository> {
  TrackProgressRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'trackProgressRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$trackProgressRepositoryHash();

  @$internal
  @override
  $FutureProviderElement<TrackProgressRepository> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<TrackProgressRepository> create(Ref ref) {
    return trackProgressRepository(ref);
  }
}

String _$trackProgressRepositoryHash() =>
    r'88439d61692f8c1db95f70ba3103c711ecc5b109';

@ProviderFor(TrackProgressController)
final trackProgressControllerProvider = TrackProgressControllerFamily._();

final class TrackProgressControllerProvider
    extends
        $AsyncNotifierProvider<TrackProgressController, TrackProgressDocument> {
  TrackProgressControllerProvider._({
    required TrackProgressControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'trackProgressControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$trackProgressControllerHash();

  @override
  String toString() {
    return r'trackProgressControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  TrackProgressController create() => TrackProgressController();

  @override
  bool operator ==(Object other) {
    return other is TrackProgressControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$trackProgressControllerHash() =>
    r'c0003ca7b0ab2bb171b36df82b1d563ce6c82cad';

final class TrackProgressControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          TrackProgressController,
          AsyncValue<TrackProgressDocument>,
          TrackProgressDocument,
          FutureOr<TrackProgressDocument>,
          String
        > {
  TrackProgressControllerFamily._()
    : super(
        retry: null,
        name: r'trackProgressControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TrackProgressControllerProvider call(String trackId) =>
      TrackProgressControllerProvider._(argument: trackId, from: this);

  @override
  String toString() => r'trackProgressControllerProvider';
}

abstract class _$TrackProgressController
    extends $AsyncNotifier<TrackProgressDocument> {
  late final _$args = ref.$arg as String;
  String get trackId => _$args;

  FutureOr<TrackProgressDocument> build(String trackId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<TrackProgressDocument>, TrackProgressDocument>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<TrackProgressDocument>,
                TrackProgressDocument
              >,
              AsyncValue<TrackProgressDocument>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
