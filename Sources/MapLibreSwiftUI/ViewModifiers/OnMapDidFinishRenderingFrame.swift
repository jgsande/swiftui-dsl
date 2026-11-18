import SwiftUI

#if swift(>=6.2)
    private struct OnMapDidFinishRenderingFrameKey: @MainActor EnvironmentKey {
        @MainActor static let defaultValue: ((Bool) -> Void)? = nil
    }
#else
    private struct OnMapDidFinishRenderingFrameKey: EnvironmentKey {
        nonisolated(unsafe) static let defaultValue: ((Bool) -> Void)? = nil
    }
#endif

@MainActor
extension EnvironmentValues {
    var onMapDidFinishRenderingFrame: ((Bool) -> Void)? {
        get { self[OnMapDidFinishRenderingFrameKey.self] }
        set { self[OnMapDidFinishRenderingFrameKey.self] = newValue }
    }
}

private struct OnMapDidFinishRenderingFrameViewModifier: ViewModifier {
    let onMapDidFinishRenderingFrame: (Bool) -> Void

    func body(content: Content) -> some View {
        content.environment(\.onMapDidFinishRenderingFrame, onMapDidFinishRenderingFrame)
    }
}

public extension View {
    /// Perform an action each time the map draws a frame. The action receives whether the frame is fully rendered:
    /// `false` while the map still awaits data for it, such as tiles.
    ///
    /// A map whose camera keeps moving, following a location for instance, never becomes idle, so
    /// ``onMapIdle(_:)`` does not fire. This tells such a map's host when every frame it draws lacks nothing.
    ///
    /// The action runs on the main actor once per frame, so keep it light, and act only when the value changes.
    ///
    /// ```swift
    /// MapView(...)
    ///     .onMapDidFinishRenderingFrame { fullyRendered in
    ///         if fullyRendered != lastFullyRendered {
    ///             lastFullyRendered = fullyRendered
    ///         }
    ///     }
    /// ```
    @MainActor
    func onMapDidFinishRenderingFrame(_ perform: @escaping (Bool) -> Void) -> some View {
        modifier(OnMapDidFinishRenderingFrameViewModifier(onMapDidFinishRenderingFrame: perform))
    }
}
