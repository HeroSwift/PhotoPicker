
public class PickedAsset {
    
    public var path: String
    
    public var width: Int
    
    public var height: Int
    
    public var size: Int
    
    public var isVideo: Bool
    
    public var isRaw: Bool
    
    public init(path: String, width: Int, height: Int, size: Int, isVideo: Bool, isRaw: Bool) {
        self.path = path
        self.width = width
        self.height = height
        self.size = size
        self.isVideo = isVideo
        self.isRaw = isRaw
    }
    
}
