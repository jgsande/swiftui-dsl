import Foundation
import InternalUtils
import MapLibre

// TODO: Other properties and their modifiers
public struct FillStyleLayer: SourceBoundVectorStyleLayerDefinition {
    public let identifier: String
    public let sourceLayerIdentifier: String?
    public var insertionPosition: LayerInsertionPosition = .above(.all)
    public var isVisible: Bool = true
    public var maximumZoomLevel: Float?
    public var minimumZoomLevel: Float?

    public var source: StyleLayerSource
    public var predicate: NSPredicate?

    public init(identifier: String, source: Source) {
        self.identifier = identifier
        self.source = .source(source)
        sourceLayerIdentifier = nil
    }

    public init(identifier: String, source: MLNSource, sourceLayerIdentifier: String? = nil) {
        self.identifier = identifier
        self.source = .mglSource(source)
        self.sourceLayerIdentifier = sourceLayerIdentifier
    }

    public func makeStyleLayer(style: MLNStyle) -> StyleLayer {
        let styleSource = addSource(to: style)

        return FillStyleLayerInternal(definition: self, mglSource: styleSource)
    }

    fileprivate var fillColor: NSExpression? = nil

    public func fillColor(_ value: UIColor) -> Self {
        var copy = self
        copy.fillColor = NSExpression(forConstantValue: value)
        return copy
    }

    public func fillColor(expression: NSExpression) -> Self {
        var copy = self
        copy.fillColor = expression
        return copy
    }

    public func fillColor(featurePropertyNamed keyPath: String) -> Self {
        var copy = self
        copy.fillColor = NSExpression(forKeyPath: keyPath)
        return copy
    }

    public func fillColor(
        interpolatedBy expression: MLNVariableExpression,
        curveType: MLNExpressionInterpolationMode,
        parameters: NSExpression?,
        stops: NSExpression
    ) -> Self {
        var copy = self
        copy.fillColor = interpolatingExpression(
            expression: expression,
            curveType: curveType,
            parameters: parameters,
            stops: stops
        )
        return copy
    }

    fileprivate var fillOutlineColor: NSExpression? = nil

    public func fillOutlineColor(_ value: UIColor) -> Self {
        var copy = self
        copy.fillOutlineColor = NSExpression(forConstantValue: value)
        return copy
    }

    public func fillOutlineColor(expression: NSExpression) -> Self {
        var copy = self
        copy.fillOutlineColor = expression
        return copy
    }

    public func fillOutlineColor(featurePropertyNamed keyPath: String) -> Self {
        var copy = self
        copy.fillOutlineColor = NSExpression(forKeyPath: keyPath)
        return copy
    }

    public func fillOutlineColor(
        interpolatedBy expression: MLNVariableExpression,
        curveType: MLNExpressionInterpolationMode,
        parameters: NSExpression?,
        stops: NSExpression
    ) -> Self {
        var copy = self
        copy.fillOutlineColor = interpolatingExpression(
            expression: expression,
            curveType: curveType,
            parameters: parameters,
            stops: stops
        )
        return copy
    }

    fileprivate var fillOpacity: NSExpression? = nil

    public func fillOpacity(_ value: Float) -> Self {
        var copy = self
        copy.fillOpacity = NSExpression(forConstantValue: value)
        return copy
    }

    public func fillOpacity(expression: NSExpression) -> Self {
        var copy = self
        copy.fillOpacity = expression
        return copy
    }

    public func fillOpacity(featurePropertyNamed keyPath: String) -> Self {
        var copy = self
        copy.fillOpacity = NSExpression(forKeyPath: keyPath)
        return copy
    }

    public func fillOpacity(
        interpolatedBy expression: MLNVariableExpression,
        curveType: MLNExpressionInterpolationMode,
        parameters: NSExpression?,
        stops: NSExpression
    ) -> Self {
        var copy = self
        copy.fillOpacity = interpolatingExpression(
            expression: expression,
            curveType: curveType,
            parameters: parameters,
            stops: stops
        )
        return copy
    }
}

private struct FillStyleLayerInternal: StyleLayer {
    private var definition: FillStyleLayer
    private let mglSource: MLNSource

    var identifier: String {
        definition.identifier
    }

    var insertionPosition: LayerInsertionPosition {
        get { definition.insertionPosition }
        set { definition.insertionPosition = newValue }
    }

    var isVisible: Bool {
        get { definition.isVisible }
        set { definition.isVisible = newValue }
    }

    var maximumZoomLevel: Float? {
        get { definition.maximumZoomLevel }
        set { definition.maximumZoomLevel = newValue }
    }

    var minimumZoomLevel: Float? {
        get { definition.minimumZoomLevel }
        set { definition.minimumZoomLevel = newValue }
    }

    init(definition: FillStyleLayer, mglSource: MLNSource) {
        self.definition = definition
        self.mglSource = mglSource
    }

    func makeMLNStyleLayer() -> MLNStyleLayer {
        let result = MLNFillStyleLayer(identifier: identifier, source: mglSource)

        result.fillColor = definition.fillColor
        result.fillOutlineColor = definition.fillOutlineColor
        result.fillOpacity = definition.fillOpacity

        result.predicate = definition.predicate

        return result
    }
}
