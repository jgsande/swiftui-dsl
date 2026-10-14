import Foundation
import InternalUtils
import MapLibre

/// A MapLibre symbol.
///
/// An enum would probably be better for iconAnchor and textAnchor?
public struct SymbolStyleLayer: SourceBoundVectorStyleLayerDefinition {
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
        sourceLayerIdentifier = nil
        self.source = .source(source)
    }

    public init(identifier: String, source: MLNSource, sourceLayerIdentifier: String? = nil) {
        self.identifier = identifier
        self.sourceLayerIdentifier = sourceLayerIdentifier
        self.source = .mglSource(source)
    }

    public func makeStyleLayer(style: MLNStyle) -> StyleLayer {
        let styleSource = addSource(to: style)

        // Register the images with the map style
        for image in iconImages {
            style.setImage(image, forName: image.sha256())
        }
        return SymbolStyleLayerInternal(definition: self, mglSource: styleSource)
    }

    public var iconImageName: NSExpression?

    public var iconImages = [UIImage]()

    // MARK: - Modifiers

    public func iconImage(_ image: UIImage) -> Self {
        modified(self) { it in
            it.iconImageName = NSExpression(forConstantValue: image.sha256())
            it.iconImages = [image]
        }
    }

    public func iconImage(featurePropertyNamed keyPath: String) -> Self {
        var copy = self
        copy.iconImageName = NSExpression(forKeyPath: keyPath)
        return copy
    }

    /// Add an icon image that can be dynamic and use UIImages in your app, based on a feature property of the source.
    /// For example, your feature could have a property called "icon-name". This name is then resolved against the key
    /// in the mappings dictionary and used to find a UIImage to display on the map for that feature.
    /// - Parameters:
    ///   - keyPath: The keypath to the feature property containing the icon to use, for example "icon-name".
    ///   - mappings: A lookup dictionary containing the keys found in "keyPath" and a UIImage for each keyPath. The key
    /// of the mappings dictionary needs to match the value type stored at keyPath, for example `String`.
    ///   - defaultImage: A UIImage that MapLibre should fall back to if the key in your feature is not found in the
    /// mappings table
    public func iconImage(
        featurePropertyNamed keyPath: String,
        mappings: [AnyHashable: UIImage],
        default defaultImage: UIImage
    ) -> Self {
        modified(self) { it in
            let attributeExpression = NSExpression(forKeyPath: keyPath)
            let mappingExpressions = mappings.mapValues { image in
                NSExpression(forConstantValue: image.sha256())
            }
            let mappingDictionary = NSDictionary(dictionary: mappingExpressions)
            let defaultExpression = NSExpression(forConstantValue: defaultImage.sha256())

            it.iconImageName = NSExpression(
                forMLNMatchingKey: attributeExpression,
                in: mappingDictionary as! [NSExpression: NSExpression],
                default: defaultExpression
            )
            it.iconImages = mappings.values + [defaultImage]
        }
    }

    fileprivate var iconRotation: NSExpression? = nil

    public func iconRotation(_ value: Double) -> Self {
        var copy = self
        copy.iconRotation = NSExpression(forConstantValue: value)
        return copy
    }

    public func iconRotation(expression: NSExpression) -> Self {
        var copy = self
        copy.iconRotation = expression
        return copy
    }

    public func iconRotation(featurePropertyNamed keyPath: String) -> Self {
        var copy = self
        copy.iconRotation = NSExpression(forKeyPath: keyPath)
        return copy
    }

    public func iconRotation(
        interpolatedBy expression: MLNVariableExpression,
        curveType: MLNExpressionInterpolationMode,
        parameters: NSExpression?,
        stops: NSExpression
    ) -> Self {
        var copy = self
        copy.iconRotation = interpolatingExpression(
            expression: expression,
            curveType: curveType,
            parameters: parameters,
            stops: stops
        )
        return copy
    }

    fileprivate var iconColor: NSExpression? = nil

    public func iconColor(_ value: UIColor) -> Self {
        var copy = self
        copy.iconColor = NSExpression(forConstantValue: value)
        return copy
    }

    public func iconColor(expression: NSExpression) -> Self {
        var copy = self
        copy.iconColor = expression
        return copy
    }

    public func iconColor(featurePropertyNamed keyPath: String) -> Self {
        var copy = self
        copy.iconColor = NSExpression(forKeyPath: keyPath)
        return copy
    }

    public func iconColor(
        interpolatedBy expression: MLNVariableExpression,
        curveType: MLNExpressionInterpolationMode,
        parameters: NSExpression?,
        stops: NSExpression
    ) -> Self {
        var copy = self
        copy.iconColor = interpolatingExpression(
            expression: expression,
            curveType: curveType,
            parameters: parameters,
            stops: stops
        )
        return copy
    }

    fileprivate var iconAllowsOverlap: NSExpression? = nil

    public func iconAllowsOverlap(_ value: Bool) -> Self {
        var copy = self
        copy.iconAllowsOverlap = NSExpression(forConstantValue: value)
        return copy
    }

    public func iconAllowsOverlap(expression: NSExpression) -> Self {
        var copy = self
        copy.iconAllowsOverlap = expression
        return copy
    }

    public func iconAllowsOverlap(featurePropertyNamed keyPath: String) -> Self {
        var copy = self
        copy.iconAllowsOverlap = NSExpression(forKeyPath: keyPath)
        return copy
    }

    fileprivate var iconOffset: NSExpression? = nil

    public func iconOffset(_ value: CGVector) -> Self {
        var copy = self
        copy.iconOffset = NSExpression(forConstantValue: value)
        return copy
    }

    public func iconOffset(expression: NSExpression) -> Self {
        var copy = self
        copy.iconOffset = expression
        return copy
    }

    public func iconOffset(featurePropertyNamed keyPath: String) -> Self {
        var copy = self
        copy.iconOffset = NSExpression(forKeyPath: keyPath)
        return copy
    }

    public func iconOffset(
        interpolatedBy expression: MLNVariableExpression,
        curveType: MLNExpressionInterpolationMode,
        parameters: NSExpression?,
        stops: NSExpression
    ) -> Self {
        var copy = self
        copy.iconOffset = interpolatingExpression(
            expression: expression,
            curveType: curveType,
            parameters: parameters,
            stops: stops
        )
        return copy
    }

    fileprivate var iconAnchor: NSExpression? = nil

    public func iconAnchor(_ value: String) -> Self {
        var copy = self
        copy.iconAnchor = NSExpression(forConstantValue: value)
        return copy
    }

    public func iconAnchor(expression: NSExpression) -> Self {
        var copy = self
        copy.iconAnchor = expression
        return copy
    }

    public func iconAnchor(featurePropertyNamed keyPath: String) -> Self {
        var copy = self
        copy.iconAnchor = NSExpression(forKeyPath: keyPath)
        return copy
    }

    fileprivate var textColor: NSExpression? = nil

    public func textColor(_ value: UIColor) -> Self {
        var copy = self
        copy.textColor = NSExpression(forConstantValue: value)
        return copy
    }

    public func textColor(expression: NSExpression) -> Self {
        var copy = self
        copy.textColor = expression
        return copy
    }

    public func textColor(featurePropertyNamed keyPath: String) -> Self {
        var copy = self
        copy.textColor = NSExpression(forKeyPath: keyPath)
        return copy
    }

    public func textColor(
        interpolatedBy expression: MLNVariableExpression,
        curveType: MLNExpressionInterpolationMode,
        parameters: NSExpression?,
        stops: NSExpression
    ) -> Self {
        var copy = self
        copy.textColor = interpolatingExpression(
            expression: expression,
            curveType: curveType,
            parameters: parameters,
            stops: stops
        )
        return copy
    }

    fileprivate var textFontSize: NSExpression? = nil

    public func textFontSize(_ value: Double) -> Self {
        var copy = self
        copy.textFontSize = NSExpression(forConstantValue: value)
        return copy
    }

    public func textFontSize(expression: NSExpression) -> Self {
        var copy = self
        copy.textFontSize = expression
        return copy
    }

    public func textFontSize(featurePropertyNamed keyPath: String) -> Self {
        var copy = self
        copy.textFontSize = NSExpression(forKeyPath: keyPath)
        return copy
    }

    public func textFontSize(
        interpolatedBy expression: MLNVariableExpression,
        curveType: MLNExpressionInterpolationMode,
        parameters: NSExpression?,
        stops: NSExpression
    ) -> Self {
        var copy = self
        copy.textFontSize = interpolatingExpression(
            expression: expression,
            curveType: curveType,
            parameters: parameters,
            stops: stops
        )
        return copy
    }

    fileprivate var text: NSExpression? = nil

    public func text(_ value: String) -> Self {
        var copy = self
        copy.text = NSExpression(forConstantValue: value)
        return copy
    }

    public func text(expression: NSExpression) -> Self {
        var copy = self
        copy.text = expression
        return copy
    }

    public func text(featurePropertyNamed keyPath: String) -> Self {
        var copy = self
        copy.text = NSExpression(forKeyPath: keyPath)
        return copy
    }

    fileprivate var textFontNames: NSExpression? = nil

    public func textFontNames(_ value: [String]) -> Self {
        var copy = self
        copy.textFontNames = NSExpression(forConstantValue: value)
        return copy
    }

    public func textFontNames(expression: NSExpression) -> Self {
        var copy = self
        copy.textFontNames = expression
        return copy
    }

    public func textFontNames(featurePropertyNamed keyPath: String) -> Self {
        var copy = self
        copy.textFontNames = NSExpression(forKeyPath: keyPath)
        return copy
    }

    fileprivate var textAnchor: NSExpression? = nil

    public func textAnchor(_ value: String) -> Self {
        var copy = self
        copy.textAnchor = NSExpression(forConstantValue: value)
        return copy
    }

    public func textAnchor(expression: NSExpression) -> Self {
        var copy = self
        copy.textAnchor = expression
        return copy
    }

    public func textAnchor(featurePropertyNamed keyPath: String) -> Self {
        var copy = self
        copy.textAnchor = NSExpression(forKeyPath: keyPath)
        return copy
    }

    fileprivate var textOffset: NSExpression? = nil

    public func textOffset(_ value: CGVector) -> Self {
        var copy = self
        copy.textOffset = NSExpression(forConstantValue: value)
        return copy
    }

    public func textOffset(expression: NSExpression) -> Self {
        var copy = self
        copy.textOffset = expression
        return copy
    }

    public func textOffset(featurePropertyNamed keyPath: String) -> Self {
        var copy = self
        copy.textOffset = NSExpression(forKeyPath: keyPath)
        return copy
    }

    public func textOffset(
        interpolatedBy expression: MLNVariableExpression,
        curveType: MLNExpressionInterpolationMode,
        parameters: NSExpression?,
        stops: NSExpression
    ) -> Self {
        var copy = self
        copy.textOffset = interpolatingExpression(
            expression: expression,
            curveType: curveType,
            parameters: parameters,
            stops: stops
        )
        return copy
    }

    fileprivate var maximumTextWidth: NSExpression? = nil

    public func maximumTextWidth(_ value: Double) -> Self {
        var copy = self
        copy.maximumTextWidth = NSExpression(forConstantValue: value)
        return copy
    }

    public func maximumTextWidth(expression: NSExpression) -> Self {
        var copy = self
        copy.maximumTextWidth = expression
        return copy
    }

    public func maximumTextWidth(featurePropertyNamed keyPath: String) -> Self {
        var copy = self
        copy.maximumTextWidth = NSExpression(forKeyPath: keyPath)
        return copy
    }

    public func maximumTextWidth(
        interpolatedBy expression: MLNVariableExpression,
        curveType: MLNExpressionInterpolationMode,
        parameters: NSExpression?,
        stops: NSExpression
    ) -> Self {
        var copy = self
        copy.maximumTextWidth = interpolatingExpression(
            expression: expression,
            curveType: curveType,
            parameters: parameters,
            stops: stops
        )
        return copy
    }

    fileprivate var textAllowsOverlap: NSExpression? = nil

    public func textAllowsOverlap(_ value: Bool) -> Self {
        var copy = self
        copy.textAllowsOverlap = NSExpression(forConstantValue: value)
        return copy
    }

    public func textAllowsOverlap(expression: NSExpression) -> Self {
        var copy = self
        copy.textAllowsOverlap = expression
        return copy
    }

    public func textAllowsOverlap(featurePropertyNamed keyPath: String) -> Self {
        var copy = self
        copy.textAllowsOverlap = NSExpression(forKeyPath: keyPath)
        return copy
    }

    fileprivate var textHaloColor: NSExpression? = nil

    public func textHaloColor(_ value: UIColor) -> Self {
        var copy = self
        copy.textHaloColor = NSExpression(forConstantValue: value)
        return copy
    }

    public func textHaloColor(expression: NSExpression) -> Self {
        var copy = self
        copy.textHaloColor = expression
        return copy
    }

    public func textHaloColor(featurePropertyNamed keyPath: String) -> Self {
        var copy = self
        copy.textHaloColor = NSExpression(forKeyPath: keyPath)
        return copy
    }

    public func textHaloColor(
        interpolatedBy expression: MLNVariableExpression,
        curveType: MLNExpressionInterpolationMode,
        parameters: NSExpression?,
        stops: NSExpression
    ) -> Self {
        var copy = self
        copy.textHaloColor = interpolatingExpression(
            expression: expression,
            curveType: curveType,
            parameters: parameters,
            stops: stops
        )
        return copy
    }

    fileprivate var textHaloWidth: NSExpression? = nil

    public func textHaloWidth(_ value: Double) -> Self {
        var copy = self
        copy.textHaloWidth = NSExpression(forConstantValue: value)
        return copy
    }

    public func textHaloWidth(expression: NSExpression) -> Self {
        var copy = self
        copy.textHaloWidth = expression
        return copy
    }

    public func textHaloWidth(featurePropertyNamed keyPath: String) -> Self {
        var copy = self
        copy.textHaloWidth = NSExpression(forKeyPath: keyPath)
        return copy
    }

    public func textHaloWidth(
        interpolatedBy expression: MLNVariableExpression,
        curveType: MLNExpressionInterpolationMode,
        parameters: NSExpression?,
        stops: NSExpression
    ) -> Self {
        var copy = self
        copy.textHaloWidth = interpolatingExpression(
            expression: expression,
            curveType: curveType,
            parameters: parameters,
            stops: stops
        )
        return copy
    }

    fileprivate var textHaloBlur: NSExpression? = nil

    public func textHaloBlur(_ value: Double) -> Self {
        var copy = self
        copy.textHaloBlur = NSExpression(forConstantValue: value)
        return copy
    }

    public func textHaloBlur(expression: NSExpression) -> Self {
        var copy = self
        copy.textHaloBlur = expression
        return copy
    }

    public func textHaloBlur(featurePropertyNamed keyPath: String) -> Self {
        var copy = self
        copy.textHaloBlur = NSExpression(forKeyPath: keyPath)
        return copy
    }

    public func textHaloBlur(
        interpolatedBy expression: MLNVariableExpression,
        curveType: MLNExpressionInterpolationMode,
        parameters: NSExpression?,
        stops: NSExpression
    ) -> Self {
        var copy = self
        copy.textHaloBlur = interpolatingExpression(
            expression: expression,
            curveType: curveType,
            parameters: parameters,
            stops: stops
        )
        return copy
    }

    fileprivate var symbolPlacement: NSExpression? = nil

    public func symbolPlacement(_ value: String) -> Self {
        var copy = self
        copy.symbolPlacement = NSExpression(forConstantValue: value)
        return copy
    }

    public func symbolPlacement(expression: NSExpression) -> Self {
        var copy = self
        copy.symbolPlacement = expression
        return copy
    }

    public func symbolPlacement(featurePropertyNamed keyPath: String) -> Self {
        var copy = self
        copy.symbolPlacement = NSExpression(forKeyPath: keyPath)
        return copy
    }

    fileprivate var symbolSpacing: NSExpression? = nil

    public func symbolSpacing(_ value: Double) -> Self {
        var copy = self
        copy.symbolSpacing = NSExpression(forConstantValue: value)
        return copy
    }

    public func symbolSpacing(expression: NSExpression) -> Self {
        var copy = self
        copy.symbolSpacing = expression
        return copy
    }

    public func symbolSpacing(featurePropertyNamed keyPath: String) -> Self {
        var copy = self
        copy.symbolSpacing = NSExpression(forKeyPath: keyPath)
        return copy
    }

    public func symbolSpacing(
        interpolatedBy expression: MLNVariableExpression,
        curveType: MLNExpressionInterpolationMode,
        parameters: NSExpression?,
        stops: NSExpression
    ) -> Self {
        var copy = self
        copy.symbolSpacing = interpolatingExpression(
            expression: expression,
            curveType: curveType,
            parameters: parameters,
            stops: stops
        )
        return copy
    }
}

private struct SymbolStyleLayerInternal: StyleLayer {
    private var definition: SymbolStyleLayer
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

    init(definition: SymbolStyleLayer, mglSource: MLNSource) {
        self.definition = definition
        self.mglSource = mglSource
    }

    func makeMLNStyleLayer() -> MLNStyleLayer {
        let result = MLNSymbolStyleLayer(identifier: identifier, source: mglSource)
        result.sourceLayerIdentifier = definition.sourceLayerIdentifier

        result.iconImageName = definition.iconImageName
        result.iconRotation = definition.iconRotation
        result.iconAllowsOverlap = definition.iconAllowsOverlap
        result.iconColor = definition.iconColor
        result.iconOffset = definition.iconOffset
        result.iconAnchor = definition.iconAnchor

        result.text = definition.text
        result.textColor = definition.textColor
        result.textFontSize = definition.textFontSize
        result.maximumTextWidth = definition.maximumTextWidth
        result.textAnchor = definition.textAnchor
        result.textOffset = definition.textOffset
        result.textFontNames = definition.textFontNames
        result.textAllowsOverlap = definition.textAllowsOverlap

        result.textHaloColor = definition.textHaloColor
        result.textHaloWidth = definition.textHaloWidth
        result.textHaloBlur = definition.textHaloBlur

        result.symbolPlacement = definition.symbolPlacement
        result.symbolSpacing = definition.symbolSpacing

        result.predicate = definition.predicate

        if let minimumZoomLevel = definition.minimumZoomLevel {
            result.minimumZoomLevel = minimumZoomLevel
        }

        if let maximumZoomLevel = definition.maximumZoomLevel {
            result.maximumZoomLevel = maximumZoomLevel
        }

        return result
    }
}
