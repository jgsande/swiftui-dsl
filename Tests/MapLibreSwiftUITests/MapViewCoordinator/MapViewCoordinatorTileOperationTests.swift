import MapLibre
import XCTest
@testable import MapLibreSwiftUI

final class MapViewCoordinatorTileOperationTests: XCTestCase {
    @MainActor func testEveryTileOperationReachesTheHandlerInOrder() {
        let coordinator = MapView<MLNMapViewController>.Coordinator(
            parent: MapView(styleURL: URL(string: "https://maplibre.org")!),
            onGesture: { _, _ in
                // No action
            },
            onViewProxyChanged: { _ in
                // No action
            }, proxyUpdateMode: .onFinish
        )
        var received: [MapTileOperation] = []
        coordinator.onMapTileOperation = { received.append($0) }
        let mapView = MLNMapView(frame: .zero)

        coordinator.mapView(mapView, tileDidTriggerAction: .requestedFromNetwork, x: 1, y: 2, z: 3, wrap: 0,
                            overscaledZ: 3, sourceID: "first")
        coordinator.mapView(mapView, tileDidTriggerAction: .endParse, x: 1, y: 2, z: 3, wrap: 0,
                            overscaledZ: 3, sourceID: "first")
        coordinator.mapView(mapView, tileDidTriggerAction: .error, x: 4, y: 5, z: 6, wrap: 1,
                            overscaledZ: 7, sourceID: "second")

        XCTAssertEqual(received, [
            MapTileOperation(operation: .requestedFromNetwork, x: 1, y: 2, z: 3, wrap: 0, overscaledZ: 3,
                             sourceID: "first"),
            MapTileOperation(operation: .endParse, x: 1, y: 2, z: 3, wrap: 0, overscaledZ: 3, sourceID: "first"),
            MapTileOperation(operation: .error, x: 4, y: 5, z: 6, wrap: 1, overscaledZ: 7, sourceID: "second"),
        ])
    }
}
