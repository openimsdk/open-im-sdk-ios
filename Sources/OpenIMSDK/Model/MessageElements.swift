import Foundation

/// Picture resource info.
public struct OpenIMPictureInfo: Codable, Equatable, Sendable {
    public var uuID: String?
    public var type: String?
    public var size: Int?
    public var width: Double?
    public var height: Double?
    public var url: String?

    public init(
        uuID: String? = nil,
        type: String? = nil,
        size: Int? = nil,
        width: Double? = nil,
        height: Double? = nil,
        url: String? = nil
    ) {
        self.uuID = uuID
        self.type = type
        self.size = size
        self.width = width
        self.height = height
        self.url = url
    }
}

/// Image message element.
public struct OpenIMPictureElem: Codable, Equatable, Sendable {
    public var sourcePath: String?
    public var sourcePicture: OpenIMPictureInfo?
    public var bigPicture: OpenIMPictureInfo?
    public var snapshotPicture: OpenIMPictureInfo?

    public init(
        sourcePath: String? = nil,
        sourcePicture: OpenIMPictureInfo? = nil,
        bigPicture: OpenIMPictureInfo? = nil,
        snapshotPicture: OpenIMPictureInfo? = nil
    ) {
        self.sourcePath = sourcePath
        self.sourcePicture = sourcePicture
        self.bigPicture = bigPicture
        self.snapshotPicture = snapshotPicture
    }
}

/// Sound / Voice message element.
public struct OpenIMSoundElem: Codable, Equatable, Sendable {
    public var uuID: String?
    public var soundPath: String?
    public var sourceUrl: String?
    public var dataSize: Int?
    public var duration: Int?

    public init(
        uuID: String? = nil,
        soundPath: String? = nil,
        sourceUrl: String? = nil,
        dataSize: Int? = nil,
        duration: Int? = nil
    ) {
        self.uuID = uuID
        self.soundPath = soundPath
        self.sourceUrl = sourceUrl
        self.dataSize = dataSize
        self.duration = duration
    }
}

/// Video message element.
public struct OpenIMVideoElem: Codable, Equatable, Sendable {
    public var videoPath: String?
    public var videoUUID: String?
    public var videoUrl: String?
    public var videoType: String?
    public var videoSize: Int?
    public var duration: Int?
    public var snapshotPath: String?
    public var snapshotUUID: String?
    public var snapshotSize: Int?
    public var snapshotUrl: String?
    public var snapshotWidth: Double?
    public var snapshotHeight: Double?

    public init(
        videoPath: String? = nil,
        videoUUID: String? = nil,
        videoUrl: String? = nil,
        videoType: String? = nil,
        videoSize: Int? = nil,
        duration: Int? = nil,
        snapshotPath: String? = nil,
        snapshotUUID: String? = nil,
        snapshotSize: Int? = nil,
        snapshotUrl: String? = nil,
        snapshotWidth: Double? = nil,
        snapshotHeight: Double? = nil
    ) {
        self.videoPath = videoPath
        self.videoUUID = videoUUID
        self.videoUrl = videoUrl
        self.videoType = videoType
        self.videoSize = videoSize
        self.duration = duration
        self.snapshotPath = snapshotPath
        self.snapshotUUID = snapshotUUID
        self.snapshotSize = snapshotSize
        self.snapshotUrl = snapshotUrl
        self.snapshotWidth = snapshotWidth
        self.snapshotHeight = snapshotHeight
    }
}

/// File message element.
public struct OpenIMFileElem: Codable, Equatable, Sendable {
    public var filePath: String?
    public var uuID: String?
    public var sourceUrl: String?
    public var fileName: String?
    public var fileSize: Int?

    public init(
        filePath: String? = nil,
        uuID: String? = nil,
        sourceUrl: String? = nil,
        fileName: String? = nil,
        fileSize: Int? = nil
    ) {
        self.filePath = filePath
        self.uuID = uuID
        self.sourceUrl = sourceUrl
        self.fileName = fileName
        self.fileSize = fileSize
    }
}

/// Text message element.
public struct OpenIMTextElem: Codable, Equatable, Sendable {
    public var content: String?

    public init(content: String? = nil) {
        self.content = content
    }
}

/// Rich text entity (mention, link, tag).
public struct OpenIMMessageEntity: Codable, Equatable, Sendable {
    public var type: String?
    public var offset: Int?
    public var length: Int?
    public var url: String?
    public var info: String?

    public init(
        type: String? = nil,
        offset: Int? = nil,
        length: Int? = nil,
        url: String? = nil,
        info: String? = nil
    ) {
        self.type = type
        self.offset = offset
        self.length = length
        self.url = url
        self.info = info
    }
}

/// Advanced text element supporting entities.
public struct OpenIMAdvancedTextElem: Codable, Equatable, Sendable {
    public var text: String?
    public var messageEntityList: [OpenIMMessageEntity]?

    public init(text: String? = nil, messageEntityList: [OpenIMMessageEntity]? = nil) {
        self.text = text
        self.messageEntityList = messageEntityList
    }
}

/// User info in @ mentions.
public struct OpenIMAtInfo: Codable, Equatable, Sendable {
    public var atUserID: String?
    public var groupNickname: String?

    public init(atUserID: String? = nil, groupNickname: String? = nil) {
        self.atUserID = atUserID
        self.groupNickname = groupNickname
    }
}

/// Location message element.
public struct OpenIMLocationElem: Codable, Equatable, Sendable {
    public var desc: String?
    public var longitude: Double?
    public var latitude: Double?

    enum CodingKeys: String, CodingKey {
        case desc = "description"
        case longitude
        case latitude
    }

    public init(desc: String? = nil, longitude: Double? = nil, latitude: Double? = nil) {
        self.desc = desc
        self.longitude = longitude
        self.latitude = latitude
    }
}

/// Custom message element.
public struct OpenIMCustomElem: Codable, Equatable, Sendable {
    public var data: String?
    public var desc: String?
    public var `extension`: String?

    enum CodingKeys: String, CodingKey {
        case data
        case desc = "description"
        case `extension`
    }

    public init(data: String? = nil, desc: String? = nil, extension: String? = nil) {
        self.data = data
        self.desc = desc
        self.extension = `extension`
    }
}

/// Business card message element.
public struct OpenIMCardElem: Codable, Equatable, Sendable {
    public var userID: String?
    public var nickname: String?
    public var faceURL: String?
    public var ex: String?

    public init(userID: String? = nil, nickname: String? = nil, faceURL: String? = nil, ex: String? = nil) {
        self.userID = userID
        self.nickname = nickname
        self.faceURL = faceURL
        self.ex = ex
    }
}

/// Face / Sticker message element.
public struct OpenIMFaceElem: Codable, Equatable, Sendable {
    public var index: Int?
    public var data: String?

    public init(index: Int? = nil, data: String? = nil) {
        self.index = index
        self.data = data
    }
}

/// Typing indicator element.
public struct OpenIMTypingElem: Codable, Equatable, Sendable {
    public var msgTips: String?

    public init(msgTips: String? = nil) {
        self.msgTips = msgTips
    }
}
