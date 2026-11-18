import MapLibre
import XCTest
@testable import MapLibreSwiftUI

final class MapViewCoordinatorTileOperationTests: XCTestCase {
    @MainActor private func makeCoordinator() -> MapView<MLNMapViewController>.Coordinator {
        MapView<MLNMapViewController>.Coordinator(
            parent: MapView(styleURL: URL(string: "https://maplibre.org")!),
            onGesture: { _, _ in
                // No action
            },
            onViewProxyChanged: { _ in
                // No action
            }, proxyUpdateMode: .onFinish
        )
    }

    /// Runs the main queue until everything queued on it before this call has run.
    @MainActor private func drainMainQueue() {
        let drained = expectation(description: "the main queue ran what was queued before it")
        DispatchQueue.main.async { drained.fulfill() }
        wait(for: [drained], timeout: 2)
    }

    @MainActor func testEveryTileOperationReachesTheHandlerInOrder() {
        let coordinator = makeCoordinator()
        var received: [MapTileOperation] = []
        coordinator.onMapTileOperation = { received.append($0) }
        let mapView = MLNMapView(frame: .zero)

        coordinator.mapView(mapView, tileDidTriggerAction: .requestedFromNetwork, x: 1, y: 2, z: 3, wrap: 0,
                            overscaledZ: 3, sourceID: "first")
        coordinator.mapView(mapView, tileDidTriggerAction: .endParse, x: 1, y: 2, z: 3, wrap: 0,
                            overscaledZ: 3, sourceID: "first")
        coordinator.mapView(mapView, tileDidTriggerAction: .error, x: 4, y: 5, z: 6, wrap: 1,
                            overscaledZ: 7, sourceID: "second")
        drainMainQueue()

        XCTAssertEqual(received, [
            MapTileOperation(operation: .requestedFromNetwork, x: 1, y: 2, z: 3, wrap: 0, overscaledZ: 3,
                             sourceID: "first"),
            MapTileOperation(operation: .endParse, x: 1, y: 2, z: 3, wrap: 0, overscaledZ: 3, sourceID: "first"),
            MapTileOperation(operation: .error, x: 4, y: 5, z: 6, wrap: 1, overscaledZ: 7, sourceID: "second"),
        ])
    }

    /// MapLibre reports tile operations from its worker threads: the handler still runs on the main thread.
    @MainActor func testATileOperationFromAWorkerThreadReachesTheHandlerOnTheMainThread() {
        let coordinator = makeCoordinator()
        var onTheMainThread: [Bool] = []
        coordinator.onMapTileOperation = { _ in onTheMainThread.append(Thread.isMainThread) }
        let mapView = MLNMapView(frame: .zero)

        let reported = expectation(description: "a worker thread reported a tile operation")
        DispatchQueue.global().async {
            coordinator.mapView(mapView, tileDidTriggerAction: .requestedFromNetwork, x: 1, y: 2, z: 3, wrap: 0,
                                overscaledZ: 3, sourceID: "first")
            reported.fulfill()
        }
        wait(for: [reported], timeout: 2)
        drainMainQueue()

        XCTAssertEqual(onTheMainThread, [true])
    }
}
