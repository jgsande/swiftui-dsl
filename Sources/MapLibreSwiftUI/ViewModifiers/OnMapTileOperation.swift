import MapLibre
import SwiftUI

/// One step in the life of a map tile, as MapLibre reports it to its map view's delegate.
public struct MapTileOperation: Equatable, Sendable {
    /// What happened to the tile: requested, loaded, parsed, failed or cancelled.
    public let operation: MLNTileOperation
    public let x: Int
    public let y: Int
    public let z: Int
    /// Which copy of the world the tile belongs to, when the map wraps around the antimeridian.
    public let wrap: Int
    /// The zoom level the tile is drawn at, which can be greater than `z` when a source's tiles are overzoomed.
    public let overscaledZ: Int
    /// The identifier of the source the tile belongs to.
    public let sourceID: String

    public init(operation: MLNTileOperation, x: Int, y: Int, z: Int, wrap: Int, overscaledZ: Int, sourceID: String) {
        self.operation = operation
        self.x = x
        self.y = y
        self.z = z
        self.wrap = wrap
        self.overscaledZ = overscaledZ
        self.sourceID = sourceID
    }
}

#if swift(>=6.2)
    private struct OnMapTileOperationKey: @MainActor EnvironmentKey {
        @MainActor static let defaultValue: ((MapTileOperation) -> Void)? = nil
    }
#else
    private struct OnMapTileOperationKey: EnvironmentKey {
        nonisolated(unsafe) static let defaultValue: ((MapTileOperation) -> Void)? = nil
    }
#endif

@MainActor
extension EnvironmentValues {
    var onMapTileOperation: ((MapTileOperation) -> Void)? {
        get { self[OnMapTileOperationKey.self] }
        set { self[OnMapTileOperationKey.self] = newValue }
    }
}

private struct OnMapTileOperationViewModifier: ViewModifier {
    let onMapTileOperation: (MapTileOperation) -> Void

    func body(content: Content) -> some View {
        content.environment(\.onMapTileOperation, onMapTileOperation)
    }
}

public extension View {
    /// Perform an action at every step in the life of every map tile: each request, load, parse, error and
    /// cancellation, with the tile's coordinates and its source.
    ///
    /// Unlike ``onMapTileError(_:)``, nothing is debounced or dropped, so a host can follow each tile from its
    /// request to its parse and tell when every tile of the current view has loaded. The action runs on the main
    /// actor, once per operation, so keep it light.
    ///
    /// ```swift
    /// MapView(...)
    ///     .onMapTileOperation { tile in
    ///         if tile.operation == .endParse {
    ///             print("Tile \(tile.z)/\(tile.x)/\(tile.y) of \(tile.sourceID) is ready")
    ///         }
    ///     }
    /// ```
    @MainActor
    func onMapTileOperation(_ perform: @escaping (MapTileOperation) -> Void) -> some View {
        modifier(OnMapTileOperationViewModifier(onMapTileOperation: perform))
    }
}
