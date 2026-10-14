import Foundation
import InternalUtils
import MapLibre

public struct CircleStyleLayer: SourceBoundVectorStyleLayerDefinition {
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

        return CircleStyleLayerInternal(definition: self, mglSource: styleSource)
    }

    // MARK: - Modifiers

    fileprivate var radius: NSExpression? = nil

    public func radius(_ value: Double) -> Self {
        var copy = self
        copy.radius = NSExpression(forConstantValue: value)
        return copy
    }

    public func radius(expression: NSExpression) -> Self {
        var copy = self
        copy.radius = expression
        return copy
    }

    public func radius(featurePropertyNamed keyPath: String) -> Self {
        var copy = self
        copy.radius = NSExpression(forKeyPath: keyPath)
        return copy
    }

    public func radius(
        interpolatedBy expression: MLNVariableExpression,
        curveType: MLNExpressionInterpolationMode,
        parameters: NSExpression?,
        stops: NSExpression
    ) -> Self {
        var copy = self
        copy.radius = interpolatingExpression(
            expression: expression,
            curveType: curveType,
            parameters: parameters,
            stops: stops
        )
        return copy
    }

    fileprivate var color: NSExpression? = nil

    public func color(_ value: UIColor) -> Self {
        var copy = self
        copy.color = NSExpression(forConstantValue: value)
        return copy
    }

    public func color(expression: NSExpression) -> Self {
        var copy = self
        copy.color = expression
        return copy
    }

    public func color(featurePropertyNamed keyPath: String) -> Self {
        var copy = self
        copy.color = NSExpression(forKeyPath: keyPath)
        return copy
    }

    fileprivate var strokeWidth: NSExpression? = nil

    public func strokeWidth(_ value: Double) -> Self {
        var copy = self
        copy.strokeWidth = NSExpression(forConstantValue: value)
        return copy
    }

    public func strokeWidth(expression: NSExpression) -> Self {
        var copy = self
        copy.strokeWidth = expression
        return copy
    }

    public func strokeWidth(featurePropertyNamed keyPath: String) -> Self {
        var copy = self
        copy.strokeWidth = NSExpression(forKeyPath: keyPath)
        return copy
    }

    public func strokeWidth(
        interpolatedBy expression: MLNVariableExpression,
        curveType: MLNExpressionInterpolationMode,
        parameters: NSExpression?,
        stops: NSExpression
    ) -> Self {
        var copy = self
        copy.strokeWidth = interpolatingExpression(
            expression: expression,
            curveType: curveType,
            parameters: parameters,
            stops: stops
        )
        return copy
    }

    fileprivate var strokeColor: NSExpression? = nil

    public func strokeColor(_ value: UIColor) -> Self {
        var copy = self
        copy.strokeColor = NSExpression(forConstantValue: value)
        return copy
    }

    public func strokeColor(expression: NSExpression) -> Self {
        var copy = self
        copy.strokeColor = expression
        return copy
    }

    public func strokeColor(featurePropertyNamed keyPath: String) -> Self {
        var copy = self
        copy.strokeColor = NSExpression(forKeyPath: keyPath)
        return copy
    }

    fileprivate var circleBlur: NSExpression? = nil

    public func circleBlur(_ value: Double) -> Self {
        var copy = self
        copy.circleBlur = NSExpression(forConstantValue: value)
        return copy
    }

    public func circleBlur(expression: NSExpression) -> Self {
        var copy = self
        copy.circleBlur = expression
        return copy
    }

    public func circleBlur(featurePropertyNamed keyPath: String) -> Self {
        var copy = self
        copy.circleBlur = NSExpression(forKeyPath: keyPath)
        return copy
    }

    public func circleBlur(
        interpolatedBy expression: MLNVariableExpression,
        curveType: MLNExpressionInterpolationMode,
        parameters: NSExpression?,
        stops: NSExpression
    ) -> Self {
        var copy = self
        copy.circleBlur = interpolatingExpression(
            expression: expression,
            curveType: curveType,
            parameters: parameters,
            stops: stops
        )
        return copy
    }

    fileprivate var circleOpacity: NSExpression? = nil

    public func circleOpacity(_ value: Double) -> Self {
        var copy = self
        copy.circleOpacity = NSExpression(forConstantValue: value)
        return copy
    }

    public func circleOpacity(expression: NSExpression) -> Self {
        var copy = self
        copy.circleOpacity = expression
        return copy
    }

    public func circleOpacity(featurePropertyNamed keyPath: String) -> Self {
        var copy = self
        copy.circleOpacity = NSExpression(forKeyPath: keyPath)
        return copy
    }

    public func circleOpacity(
        interpolatedBy expression: MLNVariableExpression,
        curveType: MLNExpressionInterpolationMode,
        parameters: NSExpression?,
        stops: NSExpression
    ) -> Self {
        var copy = self
        copy.circleOpacity = interpolatingExpression(
            expression: expression,
            curveType: curveType,
            parameters: parameters,
            stops: stops
        )
        return copy
    }

    fileprivate var circleStrokeOpacity: NSExpression? = nil

    public func circleStrokeOpacity(_ value: Double) -> Self {
        var copy = self
        copy.circleStrokeOpacity = NSExpression(forConstantValue: value)
        return copy
    }

    public func circleStrokeOpacity(expression: NSExpression) -> Self {
        var copy = self
        copy.circleStrokeOpacity = expression
        return copy
    }

    public func circleStrokeOpacity(featurePropertyNamed keyPath: String) -> Self {
        var copy = self
        copy.circleStrokeOpacity = NSExpression(forKeyPath: keyPath)
        return copy
    }

    public func circleStrokeOpacity(
        interpolatedBy expression: MLNVariableExpression,
        curveType: MLNExpressionInterpolationMode,
        parameters: NSExpression?,
        stops: NSExpression
    ) -> Self {
        var copy = self
        copy.circleStrokeOpacity = interpolatingExpression(
            expression: expression,
            curveType: curveType,
            parameters: parameters,
            stops: stops
        )
        return copy
    }
}

private struct CircleStyleLayerInternal: StyleLayer {
    private var definition: CircleStyleLayer
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

    init(definition: CircleStyleLayer, mglSource: MLNSource) {
        self.definition = definition
        self.mglSource = mglSource
    }

    func makeMLNStyleLayer() -> MLNStyleLayer {
        let result = MLNCircleStyleLayer(identifier: identifier, source: mglSource)

        result.sourceLayerIdentifier = definition.sourceLayerIdentifier
        result.circleRadius = definition.radius
        result.circleColor = definition.color

        result.circleStrokeWidth = definition.strokeWidth
        result.circleStrokeColor = definition.strokeColor
        result.circleBlur = definition.circleBlur

        result.circleOpacity = definition.circleOpacity
        result.circleStrokeOpacity = definition.circleStrokeOpacity

        result.predicate = definition.predicate

        return result
    }
}
