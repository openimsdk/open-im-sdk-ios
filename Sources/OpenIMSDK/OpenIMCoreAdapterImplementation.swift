#if canImport(OpenIMCore)

    import Foundation
    import OpenIMCore

    /// Adapter for the gomobile-generated OpenIMCore module.
    public final class NativeOpenIMCoreAdapter: OpenIMCoreAdapter {
        private let lock = NSLock()
        private var connectionListener: ConnectionListener?
        private var userListenerBridge: UserListenerBridge?
        private var friendshipListenerBridge: FriendshipListenerBridge?
        private var groupListenerBridge: GroupListenerBridge?
        private var conversationListenerBridge: ConversationListenerBridge?
        private var advancedMsgListenerBridge: AdvancedMsgListenerBridge?
        private var pendingCallbacks: [UUID: Any] = [:]

        public init() {}

        // MARK: - Lifecycle
        public func initialize(
            configuration: OpenIMConfiguration,
            eventHandler: @escaping (OpenIMCoreEvent) -> Void
        ) throws {
            let listener = ConnectionListener(eventHandler: eventHandler)
            let operationID = UUID().uuidString
            let configJSON = try makeConfigurationJSON(configuration)

            lock.lock()
            connectionListener = listener
            lock.unlock()

            guard Open_im_sdkInitSDK(listener, operationID, configJSON) else {
                lock.lock()
                connectionListener = nil
                lock.unlock()
                throw OpenIMError.core(code: -1, message: "OpenIMCore initialization failed")
            }
        }

        public func login(
            userID: String,
            token: String,
            completion: @escaping (Result<Void, OpenIMError>) -> Void
        ) {
            let callback = retainVoidCallback(completion)
            Open_im_sdkLogin(callback, UUID().uuidString, userID, token)
        }

        public func logout(completion: @escaping (Result<Void, OpenIMError>) -> Void) {
            let callback = retainVoidCallback(completion)
            Open_im_sdkLogout(callback, UUID().uuidString)
        }

        public func uninitialize() {
            Open_im_sdkUnInitSDK(UUID().uuidString)
            lock.lock()
            connectionListener = nil
            userListenerBridge = nil
            friendshipListenerBridge = nil
            groupListenerBridge = nil
            conversationListenerBridge = nil
            advancedMsgListenerBridge = nil
            let cancellables = pendingCallbacks.values.compactMap { $0 as? CancellableCallback }
            pendingCallbacks.removeAll()
            lock.unlock()

            cancellables.forEach { $0.cancel() }
        }

        // MARK: - User Module
        public func getUsersInfo(userIDs: [String], completion: @escaping (Result<[OpenIMPublicUserInfo], OpenIMError>) -> Void) {
            do {
                let json = try encodeJSON(userIDs)
                let callback = retainDecodableCallback([OpenIMPublicUserInfo].self, completion: completion)
                Open_im_sdkGetUsersInfo(callback, UUID().uuidString, json)
            } catch {
                completion(.failure(error as? OpenIMError ?? .encodingFailed(message: error.localizedDescription)))
            }
        }

        public func getSelfUserInfo(completion: @escaping (Result<OpenIMUserInfo, OpenIMError>) -> Void) {
            let callback = retainDecodableCallback(OpenIMUserInfo.self, completion: completion)
            Open_im_sdkGetSelfUserInfo(callback, UUID().uuidString)
        }

        public func setSelfUserInfo(userInfo: OpenIMUserInfo, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
            do {
                let json = try encodeJSON(userInfo)
                let callback = retainVoidCallback(completion)
                Open_im_sdkSetSelfInfo(callback, UUID().uuidString, json)
            } catch {
                completion(.failure(error as? OpenIMError ?? .encodingFailed(message: error.localizedDescription)))
            }
        }

        public func updateFcmToken(fcmToken: String, expireTime: Int, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
            let callback = retainVoidCallback(completion)
            Open_im_sdkUpdateFcmToken(callback, UUID().uuidString, fcmToken, Int64(expireTime))
        }

        public func subscribeUsersStatus(userIDs: [String], completion: @escaping (Result<[OpenIMUserStatusInfo], OpenIMError>) -> Void) {
            do {
                let json = try encodeJSON(userIDs)
                let callback = retainDecodableCallback([OpenIMUserStatusInfo].self, completion: completion)
                Open_im_sdkSubscribeUsersStatus(callback, UUID().uuidString, json)
            } catch {
                completion(.failure(error as? OpenIMError ?? .encodingFailed(message: error.localizedDescription)))
            }
        }

        public func unsubscribeUsersStatus(userIDs: [String], completion: @escaping (Result<Void, OpenIMError>) -> Void) {
            do {
                let json = try encodeJSON(userIDs)
                let callback = retainVoidCallback(completion)
                Open_im_sdkUnsubscribeUsersStatus(callback, UUID().uuidString, json)
            } catch {
                completion(.failure(error as? OpenIMError ?? .encodingFailed(message: error.localizedDescription)))
            }
        }

        public func getSubscribeUsersStatus(completion: @escaping (Result<[OpenIMUserStatusInfo], OpenIMError>) -> Void) {
            let callback = retainDecodableCallback([OpenIMUserStatusInfo].self, completion: completion)
            Open_im_sdkGetSubscribeUsersStatus(callback, UUID().uuidString)
        }

        public func getUserStatus(userIDs: [String], completion: @escaping (Result<[OpenIMUserStatusInfo], OpenIMError>) -> Void) {
            do {
                let json = try encodeJSON(userIDs)
                let callback = retainDecodableCallback([OpenIMUserStatusInfo].self, completion: completion)
                Open_im_sdkGetUserStatus(callback, UUID().uuidString, json)
            } catch {
                completion(.failure(error as? OpenIMError ?? .encodingFailed(message: error.localizedDescription)))
            }
        }

        public func setUserListener(_ listener: OpenIMUserListener?) {
            guard let listener else {
                Open_im_sdkSetUserListener(nil)
                lock.lock()
                userListenerBridge = nil
                lock.unlock()
                return
            }
            let bridge = UserListenerBridge(listener: listener)
            lock.lock()
            userListenerBridge = bridge
            lock.unlock()
            Open_im_sdkSetUserListener(bridge)
        }

        // MARK: - Friend Module
        public func getSpecifiedFriendsInfo(userIDs: [String], filterBlack: Bool, completion: @escaping (Result<[OpenIMFriendInfo], OpenIMError>) -> Void) {
            do {
                let json = try encodeJSON(userIDs)
                let callback = retainDecodableCallback([OpenIMFriendInfo].self, completion: completion)
                Open_im_sdkGetSpecifiedFriendsInfo(callback, UUID().uuidString, json, filterBlack)
            } catch {
                completion(.failure(error as? OpenIMError ?? .encodingFailed(message: error.localizedDescription)))
            }
        }

        public func getFriendList(filterBlack: Bool, completion: @escaping (Result<[OpenIMFriendInfo], OpenIMError>) -> Void) {
            let callback = retainDecodableCallback([OpenIMFriendInfo].self, completion: completion)
            Open_im_sdkGetFriendList(callback, UUID().uuidString, filterBlack)
        }

        public func getFriendListPage(offset: Int, count: Int, filterBlack: Bool, completion: @escaping (Result<[OpenIMFriendInfo], OpenIMError>) -> Void) {
            let callback = retainDecodableCallback([OpenIMFriendInfo].self, completion: completion)
            Open_im_sdkGetFriendListPage(callback, UUID().uuidString, Int32(offset), Int32(count), filterBlack)
        }

        public func searchFriends(param: OpenIMSearchFriendsParam, completion: @escaping (Result<[OpenIMSearchFriendsInfo], OpenIMError>) -> Void) {
            do {
                let json = try encodeJSON(param)
                let callback = retainDecodableCallback([OpenIMSearchFriendsInfo].self, completion: completion)
                Open_im_sdkSearchFriends(callback, UUID().uuidString, json)
            } catch {
                completion(.failure(error as? OpenIMError ?? .encodingFailed(message: error.localizedDescription)))
            }
        }

        public func checkFriend(userIDs: [String], completion: @escaping (Result<[OpenIMFriendCheckResult], OpenIMError>) -> Void) {
            do {
                let json = try encodeJSON(userIDs)
                let callback = retainDecodableCallback([OpenIMFriendCheckResult].self, completion: completion)
                Open_im_sdkCheckFriend(callback, UUID().uuidString, json)
            } catch {
                completion(.failure(error as? OpenIMError ?? .encodingFailed(message: error.localizedDescription)))
            }
        }

        public func addFriend(userID: String, reqMsg: String?, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
            do {
                let req: [String: Any] = ["toUserID": userID, "reqMsg": reqMsg ?? ""]
                let data = try JSONSerialization.data(withJSONObject: req, options: [])
                guard let json = String(data: data, encoding: .utf8) else {
                    throw OpenIMError.invalidParameter(message: "Failed to format friend request")
                }
                let callback = retainVoidCallback(completion)
                Open_im_sdkAddFriend(callback, UUID().uuidString, json)
            } catch {
                completion(.failure(error as? OpenIMError ?? .encodingFailed(message: error.localizedDescription)))
            }
        }

        public func setFriendRemark(userID: String, remark: String, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
            do {
                let req: [String: Any] = ["friendUserIDs": [userID], "remark": remark]
                let data = try JSONSerialization.data(withJSONObject: req, options: [])
                guard let json = String(data: data, encoding: .utf8) else {
                    throw OpenIMError.invalidParameter(message: "Failed to format remark request")
                }
                let callback = retainVoidCallback(completion)
                Open_im_sdkUpdateFriends(callback, UUID().uuidString, json)
            } catch {
                completion(.failure(error as? OpenIMError ?? .encodingFailed(message: error.localizedDescription)))
            }
        }

        public func deleteFriend(friendUserID: String, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
            let callback = retainVoidCallback(completion)
            Open_im_sdkDeleteFriend(callback, UUID().uuidString, friendUserID)
        }

        public func getFriendApplicationListAsRecipient(completion: @escaping (Result<[OpenIMFriendApplication], OpenIMError>) -> Void) {
            let callback = retainDecodableCallback([OpenIMFriendApplication].self, completion: completion)
            Open_im_sdkGetFriendApplicationListAsRecipient(callback, UUID().uuidString, "{}")
        }

        public func getFriendApplicationListAsApplicant(completion: @escaping (Result<[OpenIMFriendApplication], OpenIMError>) -> Void) {
            let callback = retainDecodableCallback([OpenIMFriendApplication].self, completion: completion)
            Open_im_sdkGetFriendApplicationListAsApplicant(callback, UUID().uuidString, "{}")
        }

        public func acceptFriendApplication(userID: String, handleMsg: String?, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
            do {
                let req: [String: Any] = ["toUserID": userID, "handleMsg": handleMsg ?? ""]
                let data = try JSONSerialization.data(withJSONObject: req, options: [])
                guard let json = String(data: data, encoding: .utf8) else {
                    throw OpenIMError.invalidParameter(message: "Failed to format accept friend request")
                }
                let callback = retainVoidCallback(completion)
                Open_im_sdkAcceptFriendApplication(callback, UUID().uuidString, json)
            } catch {
                completion(.failure(error as? OpenIMError ?? .encodingFailed(message: error.localizedDescription)))
            }
        }

        public func refuseFriendApplication(userID: String, handleMsg: String?, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
            do {
                let req: [String: Any] = ["toUserID": userID, "handleMsg": handleMsg ?? ""]
                let data = try JSONSerialization.data(withJSONObject: req, options: [])
                guard let json = String(data: data, encoding: .utf8) else {
                    throw OpenIMError.invalidParameter(message: "Failed to format refuse friend request")
                }
                let callback = retainVoidCallback(completion)
                Open_im_sdkRefuseFriendApplication(callback, UUID().uuidString, json)
            } catch {
                completion(.failure(error as? OpenIMError ?? .encodingFailed(message: error.localizedDescription)))
            }
        }

        public func addBlack(blackUserID: String, ex: String?, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
            let callback = retainVoidCallback(completion)
            Open_im_sdkAddBlack(callback, UUID().uuidString, blackUserID, ex ?? "")
        }

        public func removeBlack(blackUserID: String, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
            let callback = retainVoidCallback(completion)
            Open_im_sdkRemoveBlack(callback, UUID().uuidString, blackUserID)
        }

        public func getBlackList(completion: @escaping (Result<[OpenIMBlackInfo], OpenIMError>) -> Void) {
            let callback = retainDecodableCallback([OpenIMBlackInfo].self, completion: completion)
            Open_im_sdkGetBlackList(callback, UUID().uuidString)
        }

        public func setFriendshipListener(_ listener: OpenIMFriendshipListener?) {
            guard let listener else {
                Open_im_sdkSetFriendListener(nil)
                lock.lock()
                friendshipListenerBridge = nil
                lock.unlock()
                return
            }
            let bridge = FriendshipListenerBridge(listener: listener)
            lock.lock()
            friendshipListenerBridge = bridge
            lock.unlock()
            Open_im_sdkSetFriendListener(bridge)
        }

        // MARK: - Group Module
        public func createGroup(createInfo: OpenIMGroupCreateInfo, completion: @escaping (Result<OpenIMGroupInfo, OpenIMError>) -> Void) {
            do {
                let json = try encodeJSON(createInfo)
                let callback = retainDecodableCallback(OpenIMGroupInfo.self, completion: completion)
                Open_im_sdkCreateGroup(callback, UUID().uuidString, json)
            } catch {
                completion(.failure(error as? OpenIMError ?? .encodingFailed(message: error.localizedDescription)))
            }
        }

        public func joinGroup(groupID: String, reqMsg: String?, joinSource: OpenIMJoinType, ex: String?, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
            let callback = retainVoidCallback(completion)
            Open_im_sdkJoinGroup(callback, UUID().uuidString, groupID, reqMsg ?? "", Int32(joinSource.rawValue), ex ?? "")
        }

        public func quitGroup(groupID: String, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
            let callback = retainVoidCallback(completion)
            Open_im_sdkQuitGroup(callback, UUID().uuidString, groupID)
        }

        public func dismissGroup(groupID: String, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
            let callback = retainVoidCallback(completion)
            Open_im_sdkDismissGroup(callback, UUID().uuidString, groupID)
        }

        public func getJoinedGroupList(completion: @escaping (Result<[OpenIMGroupInfo], OpenIMError>) -> Void) {
            let callback = retainDecodableCallback([OpenIMGroupInfo].self, completion: completion)
            Open_im_sdkGetJoinedGroupList(callback, UUID().uuidString)
        }

        public func getJoinedGroupListPage(offset: Int, count: Int, completion: @escaping (Result<[OpenIMGroupInfo], OpenIMError>) -> Void) {
            let callback = retainDecodableCallback([OpenIMGroupInfo].self, completion: completion)
            Open_im_sdkGetJoinedGroupListPage(callback, UUID().uuidString, Int32(offset), Int32(count))
        }

        public func getSpecifiedGroupsInfo(groupIDs: [String], completion: @escaping (Result<[OpenIMGroupInfo], OpenIMError>) -> Void) {
            do {
                let json = try encodeJSON(groupIDs)
                let callback = retainDecodableCallback([OpenIMGroupInfo].self, completion: completion)
                Open_im_sdkGetSpecifiedGroupsInfo(callback, UUID().uuidString, json)
            } catch {
                completion(.failure(error as? OpenIMError ?? .encodingFailed(message: error.localizedDescription)))
            }
        }

        public func searchGroups(param: OpenIMSearchGroupParam, completion: @escaping (Result<[OpenIMGroupInfo], OpenIMError>) -> Void) {
            do {
                let json = try encodeJSON(param)
                let callback = retainDecodableCallback([OpenIMGroupInfo].self, completion: completion)
                Open_im_sdkSearchGroups(callback, UUID().uuidString, json)
            } catch {
                completion(.failure(error as? OpenIMError ?? .encodingFailed(message: error.localizedDescription)))
            }
        }

        public func setGroupInfo(groupInfo: OpenIMGroupInfo, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
            do {
                let json = try encodeJSON(groupInfo)
                let callback = retainVoidCallback(completion)
                Open_im_sdkSetGroupInfo(callback, UUID().uuidString, json)
            } catch {
                completion(.failure(error as? OpenIMError ?? .encodingFailed(message: error.localizedDescription)))
            }
        }

        public func getGroupMemberList(groupID: String, filter: OpenIMGroupMemberFilter, offset: Int, count: Int, completion: @escaping (Result<[OpenIMGroupMemberInfo], OpenIMError>) -> Void) {
            let callback = retainDecodableCallback([OpenIMGroupMemberInfo].self, completion: completion)
            Open_im_sdkGetGroupMemberList(callback, UUID().uuidString, groupID, Int32(filter.rawValue), Int32(offset), Int32(count))
        }

        public func getSpecifiedGroupMembersInfo(groupID: String, userIDs: [String], completion: @escaping (Result<[OpenIMGroupMemberInfo], OpenIMError>) -> Void) {
            do {
                let json = try encodeJSON(userIDs)
                let callback = retainDecodableCallback([OpenIMGroupMemberInfo].self, completion: completion)
                Open_im_sdkGetSpecifiedGroupMembersInfo(callback, UUID().uuidString, groupID, json)
            } catch {
                completion(.failure(error as? OpenIMError ?? .encodingFailed(message: error.localizedDescription)))
            }
        }

        public func searchGroupMembers(param: OpenIMSearchGroupMembersParam, completion: @escaping (Result<[OpenIMGroupMemberInfo], OpenIMError>) -> Void) {
            do {
                let json = try encodeJSON(param)
                let callback = retainDecodableCallback([OpenIMGroupMemberInfo].self, completion: completion)
                Open_im_sdkSearchGroupMembers(callback, UUID().uuidString, json)
            } catch {
                completion(.failure(error as? OpenIMError ?? .encodingFailed(message: error.localizedDescription)))
            }
        }

        public func setGroupMemberRoleLevel(groupID: String, userID: String, roleLevel: OpenIMGroupMemberRole, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
            do {
                let req: [String: Any] = ["groupID": groupID, "userID": userID, "roleLevel": roleLevel.rawValue]
                let data = try JSONSerialization.data(withJSONObject: req, options: [])
                guard let json = String(data: data, encoding: .utf8) else {
                    throw OpenIMError.invalidParameter(message: "Failed to format member role request")
                }
                let callback = retainVoidCallback(completion)
                Open_im_sdkSetGroupMemberInfo(callback, UUID().uuidString, json)
            } catch {
                completion(.failure(error as? OpenIMError ?? .encodingFailed(message: error.localizedDescription)))
            }
        }

        public func changeGroupMute(groupID: String, isMute: Bool, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
            let callback = retainVoidCallback(completion)
            Open_im_sdkChangeGroupMute(callback, UUID().uuidString, groupID, isMute)
        }

        public func changeGroupMemberMute(groupID: String, userID: String, mutedSeconds: Int, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
            let callback = retainVoidCallback(completion)
            Open_im_sdkChangeGroupMemberMute(callback, UUID().uuidString, groupID, userID, mutedSeconds)
        }

        public func setGroupMemberNickname(groupID: String, userID: String, nickname: String, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
            do {
                let req: [String: Any] = ["groupID": groupID, "userID": userID, "nickname": nickname]
                let data = try JSONSerialization.data(withJSONObject: req, options: [])
                guard let json = String(data: data, encoding: .utf8) else {
                    throw OpenIMError.invalidParameter(message: "Failed to format member nickname request")
                }
                let callback = retainVoidCallback(completion)
                Open_im_sdkSetGroupMemberInfo(callback, UUID().uuidString, json)
            } catch {
                completion(.failure(error as? OpenIMError ?? .encodingFailed(message: error.localizedDescription)))
            }
        }

        public func kickGroupMember(groupID: String, reason: String?, userIDs: [String], completion: @escaping (Result<Void, OpenIMError>) -> Void) {
            do {
                let json = try encodeJSON(userIDs)
                let callback = retainVoidCallback(completion)
                Open_im_sdkKickGroupMember(callback, UUID().uuidString, groupID, reason ?? "", json)
            } catch {
                completion(.failure(error as? OpenIMError ?? .encodingFailed(message: error.localizedDescription)))
            }
        }

        public func inviteUserToGroup(groupID: String, reason: String?, userIDs: [String], completion: @escaping (Result<Void, OpenIMError>) -> Void) {
            do {
                let json = try encodeJSON(userIDs)
                let callback = retainVoidCallback(completion)
                Open_im_sdkInviteUserToGroup(callback, UUID().uuidString, groupID, reason ?? "", json)
            } catch {
                completion(.failure(error as? OpenIMError ?? .encodingFailed(message: error.localizedDescription)))
            }
        }

        public func getGroupApplicationListAsRecipient(completion: @escaping (Result<[OpenIMGroupApplicationInfo], OpenIMError>) -> Void) {
            let callback = retainDecodableCallback([OpenIMGroupApplicationInfo].self, completion: completion)
            Open_im_sdkGetGroupApplicationListAsRecipient(callback, UUID().uuidString, "{}")
        }

        public func getGroupApplicationListAsApplicant(completion: @escaping (Result<[OpenIMGroupApplicationInfo], OpenIMError>) -> Void) {
            let callback = retainDecodableCallback([OpenIMGroupApplicationInfo].self, completion: completion)
            Open_im_sdkGetGroupApplicationListAsApplicant(callback, UUID().uuidString, "{}")
        }

        public func acceptGroupApplication(groupID: String, fromUserID: String, handleMsg: String?, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
            let callback = retainVoidCallback(completion)
            Open_im_sdkAcceptGroupApplication(callback, UUID().uuidString, groupID, fromUserID, handleMsg ?? "")
        }

        public func refuseGroupApplication(groupID: String, fromUserID: String, handleMsg: String?, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
            let callback = retainVoidCallback(completion)
            Open_im_sdkRefuseGroupApplication(callback, UUID().uuidString, groupID, fromUserID, handleMsg ?? "")
        }

        public func setGroupListener(_ listener: OpenIMGroupListener?) {
            guard let listener else {
                Open_im_sdkSetGroupListener(nil)
                lock.lock()
                groupListenerBridge = nil
                lock.unlock()
                return
            }
            let bridge = GroupListenerBridge(listener: listener)
            lock.lock()
            groupListenerBridge = bridge
            lock.unlock()
            Open_im_sdkSetGroupListener(bridge)
        }

        // MARK: - Conversation Module
        public func getAllConversationList(completion: @escaping (Result<[OpenIMConversationInfo], OpenIMError>) -> Void) {
            let callback = retainDecodableCallback([OpenIMConversationInfo].self, completion: completion)
            Open_im_sdkGetAllConversationList(callback, UUID().uuidString)
        }

        public func getConversationListSplit(offset: Int, count: Int, completion: @escaping (Result<[OpenIMConversationInfo], OpenIMError>) -> Void) {
            let callback = retainDecodableCallback([OpenIMConversationInfo].self, completion: completion)
            Open_im_sdkGetConversationListSplit(callback, UUID().uuidString, offset, count)
        }

        public func getOneConversation(sessionType: OpenIMConversationType, sourceID: String, completion: @escaping (Result<OpenIMConversationInfo, OpenIMError>) -> Void) {
            let callback = retainDecodableCallback(OpenIMConversationInfo.self, completion: completion)
            Open_im_sdkGetOneConversation(callback, UUID().uuidString, Int32(sessionType.rawValue), sourceID)
        }

        public func getMultipleConversation(conversationIDs: [String], completion: @escaping (Result<[OpenIMConversationInfo], OpenIMError>) -> Void) {
            do {
                let json = try encodeJSON(conversationIDs)
                let callback = retainDecodableCallback([OpenIMConversationInfo].self, completion: completion)
                Open_im_sdkGetMultipleConversation(callback, UUID().uuidString, json)
            } catch {
                completion(.failure(error as? OpenIMError ?? .encodingFailed(message: error.localizedDescription)))
            }
        }

        public func setConversation(conversationID: String, req: OpenIMConversationReq, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
            do {
                let json = try encodeJSON(req)
                let callback = retainVoidCallback(completion)
                Open_im_sdkSetConversation(callback, UUID().uuidString, conversationID, json)
            } catch {
                completion(.failure(error as? OpenIMError ?? .encodingFailed(message: error.localizedDescription)))
            }
        }

        public func hideConversation(conversationID: String, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
            let callback = retainVoidCallback(completion)
            Open_im_sdkHideConversation(callback, UUID().uuidString, conversationID)
        }

        public func setConversationDraft(conversationID: String, draftText: String, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
            let callback = retainVoidCallback(completion)
            Open_im_sdkSetConversationDraft(callback, UUID().uuidString, conversationID, draftText)
        }

        public func setConversationPinned(conversationID: String, isPinned: Bool, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
            do {
                let req: [String: Any] = ["isPinned": isPinned]
                let data = try JSONSerialization.data(withJSONObject: req, options: [])
                guard let json = String(data: data, encoding: .utf8) else {
                    throw OpenIMError.invalidParameter(message: "Failed to format pin request")
                }
                let callback = retainVoidCallback(completion)
                Open_im_sdkSetConversation(callback, UUID().uuidString, conversationID, json)
            } catch {
                completion(.failure(error as? OpenIMError ?? .encodingFailed(message: error.localizedDescription)))
            }
        }

        public func setConversationRecvMessageOpt(conversationIDs: [String], status: OpenIMReceiveMessageOpt, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
            do {
                let req: [String: Any] = ["recvMsgOpt": status.rawValue]
                let data = try JSONSerialization.data(withJSONObject: req, options: [])
                guard let json = String(data: data, encoding: .utf8) else {
                    throw OpenIMError.invalidParameter(message: "Failed to format recvMsgOpt request")
                }
                let callback = retainVoidCallback(completion)
                if let firstID = conversationIDs.first {
                    Open_im_sdkSetConversation(callback, UUID().uuidString, firstID, json)
                } else {
                    completion(.success(()))
                }
            } catch {
                completion(.failure(error as? OpenIMError ?? .encodingFailed(message: error.localizedDescription)))
            }
        }

        public func markConversationMessageAsRead(conversationID: String, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
            let callback = retainVoidCallback(completion)
            Open_im_sdkMarkConversationMessageAsRead(callback, UUID().uuidString, conversationID)
        }

        public func getTotalUnreadMsgCount(completion: @escaping (Result<Int, OpenIMError>) -> Void) {
            let callback = retainDataCallback(
                transform: { data in
                    guard let str = data?.trimmingCharacters(in: .whitespacesAndNewlines), let count = Int(str) else {
                        return 0
                    }
                    return count
                },
                completion: completion
            )
            Open_im_sdkGetTotalUnreadMsgCount(callback, UUID().uuidString)
        }

        public func deleteConversationAndDeleteAllMsg(conversationID: String, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
            let callback = retainVoidCallback(completion)
            Open_im_sdkDeleteConversationAndDeleteAllMsg(callback, UUID().uuidString, conversationID)
        }

        public func clearConversationAndDeleteAllMsg(conversationID: String, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
            let callback = retainVoidCallback(completion)
            Open_im_sdkClearConversationAndDeleteAllMsg(callback, UUID().uuidString, conversationID)
        }

        public func setConversationListener(_ listener: OpenIMConversationListener?) {
            guard let listener else {
                Open_im_sdkSetConversationListener(nil)
                lock.lock()
                conversationListenerBridge = nil
                lock.unlock()
                return
            }
            let bridge = ConversationListenerBridge(listener: listener)
            lock.lock()
            conversationListenerBridge = bridge
            lock.unlock()
            Open_im_sdkSetConversationListener(bridge)
        }

        // MARK: - Message Module
        public func createTextMessage(text: String) throws -> OpenIMMessageInfo {
            let json = Open_im_sdkCreateTextMessage(UUID().uuidString, text)
            return try decodeJSON(json)
        }

        public func createTextAtMessage(text: String, atUserIDs: [String], atUsersInfo: [OpenIMAtInfo], quoteMessage: OpenIMMessageInfo?) throws -> OpenIMMessageInfo {
            let atUsersJSON = try encodeJSON(atUserIDs)
            let atUsersInfoJSON = try encodeJSON(atUsersInfo)
            let quoteJSON = try quoteMessage.map { try encodeJSON($0) } ?? ""
            let json = Open_im_sdkCreateTextAtMessage(UUID().uuidString, text, atUsersJSON, atUsersInfoJSON, quoteJSON)
            return try decodeJSON(json)
        }

        public func createImageMessage(imagePath: String) throws -> OpenIMMessageInfo {
            let json = Open_im_sdkCreateImageMessage(UUID().uuidString, imagePath)
            return try decodeJSON(json)
        }

        public func createSoundMessage(soundPath: String, duration: Int64) throws -> OpenIMMessageInfo {
            let json = Open_im_sdkCreateSoundMessage(UUID().uuidString, soundPath, duration)
            return try decodeJSON(json)
        }

        public func createVideoMessage(videoPath: String, videoType: String, duration: Int64, snapshotPath: String) throws -> OpenIMMessageInfo {
            let json = Open_im_sdkCreateVideoMessage(UUID().uuidString, videoPath, videoType, duration, snapshotPath)
            return try decodeJSON(json)
        }

        public func createFileMessage(filePath: String, fileName: String) throws -> OpenIMMessageInfo {
            let json = Open_im_sdkCreateFileMessage(UUID().uuidString, filePath, fileName)
            return try decodeJSON(json)
        }

        public func createLocationMessage(description: String, longitude: Double, latitude: Double) throws -> OpenIMMessageInfo {
            let json = Open_im_sdkCreateLocationMessage(UUID().uuidString, description, longitude, latitude)
            return try decodeJSON(json)
        }

        public func createCustomMessage(data: String, `extension`: String?, description: String?) throws -> OpenIMMessageInfo {
            let json = Open_im_sdkCreateCustomMessage(UUID().uuidString, data, `extension` ?? "", description ?? "")
            return try decodeJSON(json)
        }

        public func createQuoteMessage(text: String, message: OpenIMMessageInfo) throws -> OpenIMMessageInfo {
            let messageJSON = try encodeJSON(message)
            let json = Open_im_sdkCreateQuoteMessage(UUID().uuidString, text, messageJSON)
            return try decodeJSON(json)
        }

        public func createCardMessage(cardInfo: OpenIMCardElem) throws -> OpenIMMessageInfo {
            let cardJSON = try encodeJSON(cardInfo)
            let json = Open_im_sdkCreateCardMessage(UUID().uuidString, cardJSON)
            return try decodeJSON(json)
        }

        public func createFaceMessage(index: Int, data: String) throws -> OpenIMMessageInfo {
            let json = Open_im_sdkCreateFaceMessage(UUID().uuidString, index, data)
            return try decodeJSON(json)
        }

        public func createMergerMessage(messageList: [OpenIMMessageInfo], title: String, summaryList: [String]) throws -> OpenIMMessageInfo {
            let msgListJSON = try encodeJSON(messageList)
            let summaryJSON = try encodeJSON(summaryList)
            let json = Open_im_sdkCreateMergerMessage(UUID().uuidString, msgListJSON, title, summaryJSON)
            return try decodeJSON(json)
        }

        public func createForwardMessage(message: OpenIMMessageInfo) throws -> OpenIMMessageInfo {
            let msgJSON = try encodeJSON(message)
            let json = Open_im_sdkCreateForwardMessage(UUID().uuidString, msgJSON)
            return try decodeJSON(json)
        }

        public func sendMessage(
            message: OpenIMMessageInfo,
            recvID: String?,
            groupID: String?,
            offlinePushInfo: OpenIMOfflinePushInfo?,
            isOnlineOnly: Bool,
            onProgress: ((Int) -> Void)?,
            completion: @escaping (Result<OpenIMMessageInfo, OpenIMError>) -> Void
        ) {
            do {
                let msgJSON = try encodeJSON(message)
                let pushJSON = try offlinePushInfo.map { try encodeJSON($0) } ?? "{}"
                let callback = retainSendMsgCallBack(
                    onProgress: onProgress,
                    completion: completion
                )
                Open_im_sdkSendMessage(
                    callback,
                    UUID().uuidString,
                    msgJSON,
                    recvID ?? "",
                    groupID ?? "",
                    pushJSON,
                    isOnlineOnly
                )
            } catch {
                completion(.failure(error as? OpenIMError ?? .encodingFailed(message: error.localizedDescription)))
            }
        }

        public func getAdvancedHistoryMessageList(options: OpenIMGetMessageOptions, completion: @escaping (Result<OpenIMGetAdvancedHistoryMessageListInfo, OpenIMError>) -> Void) {
            do {
                let json = try encodeJSON(options)
                let callback = retainDecodableCallback(OpenIMGetAdvancedHistoryMessageListInfo.self, completion: completion)
                Open_im_sdkGetAdvancedHistoryMessageList(callback, UUID().uuidString, json)
            } catch {
                completion(.failure(error as? OpenIMError ?? .encodingFailed(message: error.localizedDescription)))
            }
        }

        public func revokeMessage(conversationID: String, clientMsgID: String, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
            let callback = retainVoidCallback(completion)
            Open_im_sdkRevokeMessage(callback, UUID().uuidString, conversationID, clientMsgID)
        }

        public func typingStatusUpdate(recvID: String, msgTip: String, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
            let callback = retainVoidCallback(completion)
            Open_im_sdkTypingStatusUpdate(callback, UUID().uuidString, recvID, msgTip)
        }

        public func markMessagesAsReadByMsgID(conversationID: String, clientMsgIDs: [String], completion: @escaping (Result<Void, OpenIMError>) -> Void) {
            do {
                let json = try encodeJSON(clientMsgIDs)
                let callback = retainVoidCallback(completion)
                Open_im_sdkMarkMessagesAsReadByMsgID(callback, UUID().uuidString, conversationID, json)
            } catch {
                completion(.failure(error as? OpenIMError ?? .encodingFailed(message: error.localizedDescription)))
            }
        }

        public func deleteMessage(conversationID: String, clientMsgID: String, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
            let callback = retainVoidCallback(completion)
            Open_im_sdkDeleteMessage(callback, UUID().uuidString, conversationID, clientMsgID)
        }

        public func deleteMessageFromLocalStorage(conversationID: String, clientMsgID: String, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
            let callback = retainVoidCallback(completion)
            Open_im_sdkDeleteMessageFromLocalStorage(callback, UUID().uuidString, conversationID, clientMsgID)
        }

        public func deleteAllMsgFromLocal(completion: @escaping (Result<Void, OpenIMError>) -> Void) {
            let callback = retainVoidCallback(completion)
            Open_im_sdkDeleteAllMsgFromLocal(callback, UUID().uuidString)
        }

        public func deleteAllMsgFromLocalAndSvr(completion: @escaping (Result<Void, OpenIMError>) -> Void) {
            let callback = retainVoidCallback(completion)
            Open_im_sdkDeleteAllMsgFromLocalAndSvr(callback, UUID().uuidString)
        }

        public func searchLocalMessages(param: OpenIMSearchParam, completion: @escaping (Result<OpenIMSearchResultInfo, OpenIMError>) -> Void) {
            do {
                let json = try encodeJSON(param)
                let callback = retainDecodableCallback(OpenIMSearchResultInfo.self, completion: completion)
                Open_im_sdkSearchLocalMessages(callback, UUID().uuidString, json)
            } catch {
                completion(.failure(error as? OpenIMError ?? .encodingFailed(message: error.localizedDescription)))
            }
        }

        public func setAdvancedMsgListener(_ listener: OpenIMAdvancedMsgListener?) {
            guard let listener else {
                Open_im_sdkSetAdvancedMsgListener(nil)
                lock.lock()
                advancedMsgListenerBridge = nil
                lock.unlock()
                return
            }
            let bridge = AdvancedMsgListenerBridge(listener: listener)
            lock.lock()
            advancedMsgListenerBridge = bridge
            lock.unlock()
            Open_im_sdkSetAdvancedMsgListener(bridge)
        }

        // MARK: - Private Helpers
        private func makeConfigurationJSON(_ configuration: OpenIMConfiguration) throws -> String {
            let payload: [String: Any] = [
                "platformID": configuration.platform.rawValue,
                "apiAddr": configuration.apiAddress,
                "wsAddr": configuration.websocketAddress,
                "dataDir": configuration.dataDirectory?.path ?? "",
                "logLevel": configuration.logLevel,
                "isCompression": configuration.compression,
                "logFilePath": configuration.logFileURL?.path ?? "",
                "isLogStandardOutput": configuration.logToStandardOutput,
                "systemType": configuration.systemType,
            ]

            let data = try JSONSerialization.data(withJSONObject: payload, options: [])
            guard let json = String(data: data, encoding: .utf8) else {
                throw OpenIMError.core(code: -2, message: "Unable to encode OpenIMCore configuration")
            }
            return json
        }

        private func encodeJSON<T: Encodable>(_ value: T) throws -> String {
            let data = try JSONEncoder().encode(value)
            guard let string = String(data: data, encoding: .utf8) else {
                throw OpenIMError.invalidParameter(message: "Failed to encode parameter to JSON")
            }
            return string
        }

        private func decodeJSON<T: Decodable>(_ json: String) throws -> T {
            guard let data = json.data(using: .utf8) else {
                throw OpenIMError.decodingFailed(message: "Invalid UTF-8 string")
            }
            return try JSONDecoder().decode(T.self, from: data)
        }

        private func retainDataCallback<T>(
            transform: @escaping (String?) throws -> T,
            completion: @escaping (Result<T, OpenIMError>) -> Void
        ) -> DataCallback<T> {
            let id = UUID()
            let callback = DataCallback<T>(
                transform: transform,
                completion: completion,
                onFinished: { [weak self] in
                    self?.releaseCallback(id)
                }
            )
            lock.lock()
            pendingCallbacks[id] = callback
            lock.unlock()
            return callback
        }

        private func retainDecodableCallback<T: Decodable>(
            _ type: T.Type,
            completion: @escaping (Result<T, OpenIMError>) -> Void
        ) -> DataCallback<T> {
            retainDataCallback(
                transform: { data in
                    guard let dataStr = data, let raw = dataStr.data(using: .utf8) else {
                        throw OpenIMError.decodingFailed(message: "Empty or missing response payload")
                    }
                    return try JSONDecoder().decode(T.self, from: raw)
                },
                completion: completion
            )
        }

        private func retainVoidCallback(
            _ completion: @escaping (Result<Void, OpenIMError>) -> Void
        ) -> DataCallback<Void> {
            retainDataCallback(
                transform: { _ in () },
                completion: completion
            )
        }

        private func retainSendMsgCallBack(
            onProgress: ((Int) -> Void)?,
            completion: @escaping (Result<OpenIMMessageInfo, OpenIMError>) -> Void
        ) -> SendMsgCallBack {
            let id = UUID()
            let callback = SendMsgCallBack(
                onProgress: onProgress,
                completion: completion,
                onFinished: { [weak self] in
                    self?.releaseCallback(id)
                }
            )
            lock.lock()
            pendingCallbacks[id] = callback
            lock.unlock()
            return callback
        }

        private func releaseCallback(_ id: UUID) {
            lock.lock()
            pendingCallbacks.removeValue(forKey: id)
            lock.unlock()
        }
    }

    private protocol CancellableCallback: AnyObject {
        func cancel()
    }

    private final class DataCallback<T>: NSObject, Open_im_sdk_callbackBaseProtocol, CancellableCallback {
        private let lock = NSLock()
        private let transform: (String?) throws -> T
        private let completion: (Result<T, OpenIMError>) -> Void
        private let onFinished: () -> Void
        private var isFinished = false

        init(
            transform: @escaping (String?) throws -> T,
            completion: @escaping (Result<T, OpenIMError>) -> Void,
            onFinished: @escaping () -> Void
        ) {
            self.transform = transform
            self.completion = completion
            self.onFinished = onFinished
        }

        func onError(_ errCode: Int32, errMsg: String?) {
            finish(.failure(.core(code: Int(errCode), message: errMsg)))
        }

        func onSuccess(_ data: String?) {
            do {
                let result = try transform(data)
                finish(.success(result))
            } catch let error as OpenIMError {
                finish(.failure(error))
            } catch {
                finish(.failure(.decodingFailed(message: error.localizedDescription)))
            }
        }

        func cancel() {
            finish(.failure(.cancelled))
        }

        private func finish(_ result: Result<T, OpenIMError>) {
            lock.lock()
            guard !isFinished else {
                lock.unlock()
                return
            }
            isFinished = true
            lock.unlock()

            completion(result)
            onFinished()
        }
    }

    private final class SendMsgCallBack: NSObject, Open_im_sdk_callbackSendMsgCallBackProtocol, CancellableCallback {
        private let lock = NSLock()
        private let onProgress: ((Int) -> Void)?
        private let completion: (Result<OpenIMMessageInfo, OpenIMError>) -> Void
        private let onFinished: () -> Void
        private var isFinished = false

        init(
            onProgress: ((Int) -> Void)?,
            completion: @escaping (Result<OpenIMMessageInfo, OpenIMError>) -> Void,
            onFinished: @escaping () -> Void
        ) {
            self.onProgress = onProgress
            self.completion = completion
            self.onFinished = onFinished
        }

        func onError(_ errCode: Int32, errMsg: String?) {
            finish(.failure(.core(code: Int(errCode), message: errMsg)))
        }

        func onProgress(_ progress: Int) {
            onProgress?(progress)
        }

        func onSuccess(_ data: String?) {
            guard let dataStr = data, let raw = dataStr.data(using: .utf8) else {
                finish(.failure(.decodingFailed(message: "Empty message payload")))
                return
            }
            do {
                let msg = try JSONDecoder().decode(OpenIMMessageInfo.self, from: raw)
                finish(.success(msg))
            } catch {
                finish(.failure(.decodingFailed(message: error.localizedDescription)))
            }
        }

        func cancel() {
            finish(.failure(.cancelled))
        }

        private func finish(_ result: Result<OpenIMMessageInfo, OpenIMError>) {
            lock.lock()
            guard !isFinished else {
                lock.unlock()
                return
            }
            isFinished = true
            lock.unlock()

            completion(result)
            onFinished()
        }
    }

    private final class ConnectionListener: NSObject, Open_im_sdk_callbackOnConnListenerProtocol {
        private let eventHandler: (OpenIMCoreEvent) -> Void

        init(eventHandler: @escaping (OpenIMCoreEvent) -> Void) {
            self.eventHandler = eventHandler
        }

        func onConnectFailed(_ errCode: Int32, errMsg: String?) {
            eventHandler(.connectionFailed(code: Int(errCode), message: errMsg))
        }

        func onConnectSuccess() {
            eventHandler(.connected)
        }

        func onConnecting() {
            eventHandler(.connecting)
        }

        func onKickedOffline() {
            eventHandler(.kickedOffline)
        }

        func onUserTokenExpired() {
            eventHandler(.tokenExpired)
        }

        func onUserTokenInvalid(_ errMsg: String?) {
            eventHandler(.tokenInvalid(message: errMsg))
        }
    }

    private final class UserListenerBridge: NSObject, Open_im_sdk_callbackOnUserListenerProtocol {
        private weak var listener: OpenIMUserListener?

        init(listener: OpenIMUserListener) {
            self.listener = listener
        }

        func onSelfInfoUpdated(_ userInfo: String?) {
            guard let data = userInfo?.data(using: .utf8),
                  let info = try? JSONDecoder().decode(OpenIMUserInfo.self, from: data) else { return }
            listener?.onSelfInfoUpdated(info)
        }

        func onUserStatusChanged(_ userOnlineStatus: String?) {
            guard let data = userOnlineStatus?.data(using: .utf8),
                  let status = try? JSONDecoder().decode(OpenIMUserStatusInfo.self, from: data) else { return }
            listener?.onUserStatusChanged(status)
        }

        func onUserCommandAdd(_ userCommand: String?) {}
        func onUserCommandDelete(_ userCommand: String?) {}
        func onUserCommandUpdate(_ userCommand: String?) {}
    }

    private final class FriendshipListenerBridge: NSObject, Open_im_sdk_callbackOnFriendshipListenerProtocol {
        private weak var listener: OpenIMFriendshipListener?

        init(listener: OpenIMFriendshipListener) {
            self.listener = listener
        }

        func onBlackAdded(_ blackInfo: String?) {
            guard let data = blackInfo?.data(using: .utf8),
                  let info = try? JSONDecoder().decode(OpenIMBlackInfo.self, from: data) else { return }
            listener?.onBlackAdded(info)
        }

        func onBlackDeleted(_ blackInfo: String?) {
            guard let data = blackInfo?.data(using: .utf8),
                  let info = try? JSONDecoder().decode(OpenIMBlackInfo.self, from: data) else { return }
            listener?.onBlackDeleted(info)
        }

        func onFriendAdded(_ friendInfo: String?) {
            guard let data = friendInfo?.data(using: .utf8),
                  let info = try? JSONDecoder().decode(OpenIMFriendInfo.self, from: data) else { return }
            listener?.onFriendAdded(info)
        }

        func onFriendDeleted(_ friendInfo: String?) {
            guard let data = friendInfo?.data(using: .utf8),
                  let info = try? JSONDecoder().decode(OpenIMFriendInfo.self, from: data) else { return }
            listener?.onFriendDeleted(info)
        }

        func onFriendInfoChanged(_ friendInfo: String?) {
            guard let data = friendInfo?.data(using: .utf8),
                  let info = try? JSONDecoder().decode(OpenIMFriendInfo.self, from: data) else { return }
            listener?.onFriendInfoChanged(info)
        }

        func onFriendApplicationAdded(_ friendApplication: String?) {
            guard let data = friendApplication?.data(using: .utf8),
                  let app = try? JSONDecoder().decode(OpenIMFriendApplication.self, from: data) else { return }
            listener?.onFriendApplicationAdded(app)
        }

        func onFriendApplicationDeleted(_ friendApplication: String?) {
            guard let data = friendApplication?.data(using: .utf8),
                  let app = try? JSONDecoder().decode(OpenIMFriendApplication.self, from: data) else { return }
            listener?.onFriendApplicationDeleted(app)
        }

        func onFriendApplicationAccepted(_ friendApplication: String?) {
            guard let data = friendApplication?.data(using: .utf8),
                  let app = try? JSONDecoder().decode(OpenIMFriendApplication.self, from: data) else { return }
            listener?.onFriendApplicationAccepted(app)
        }

        func onFriendApplicationRejected(_ friendApplication: String?) {
            guard let data = friendApplication?.data(using: .utf8),
                  let app = try? JSONDecoder().decode(OpenIMFriendApplication.self, from: data) else { return }
            listener?.onFriendApplicationRejected(app)
        }
    }

    private final class GroupListenerBridge: NSObject, Open_im_sdk_callbackOnGroupListenerProtocol {
        private weak var listener: OpenIMGroupListener?

        init(listener: OpenIMGroupListener) {
            self.listener = listener
        }

        func onJoinedGroupAdded(_ groupInfo: String?) {
            guard let data = groupInfo?.data(using: .utf8),
                  let info = try? JSONDecoder().decode(OpenIMGroupInfo.self, from: data) else { return }
            listener?.onJoinedGroupAdded(info)
        }

        func onJoinedGroupDeleted(_ groupInfo: String?) {
            guard let data = groupInfo?.data(using: .utf8),
                  let info = try? JSONDecoder().decode(OpenIMGroupInfo.self, from: data) else { return }
            listener?.onJoinedGroupDismissed(info)
        }

        func onGroupDismissed(_ groupInfo: String?) {
            guard let data = groupInfo?.data(using: .utf8),
                  let info = try? JSONDecoder().decode(OpenIMGroupInfo.self, from: data) else { return }
            listener?.onGroupDismissed(info)
        }

        func onGroupInfoChanged(_ groupInfo: String?) {
            guard let data = groupInfo?.data(using: .utf8),
                  let info = try? JSONDecoder().decode(OpenIMGroupInfo.self, from: data) else { return }
            listener?.onGroupInfoChanged(info)
        }

        func onGroupMemberAdded(_ groupMemberInfo: String?) {
            guard let data = groupMemberInfo?.data(using: .utf8),
                  let member = try? JSONDecoder().decode(OpenIMGroupMemberInfo.self, from: data) else { return }
            listener?.onGroupMemberAdded(member)
        }

        func onGroupMemberDeleted(_ groupMemberInfo: String?) {
            guard let data = groupMemberInfo?.data(using: .utf8),
                  let member = try? JSONDecoder().decode(OpenIMGroupMemberInfo.self, from: data) else { return }
            listener?.onGroupMemberDeleted(member)
        }

        func onGroupMemberInfoChanged(_ groupMemberInfo: String?) {
            guard let data = groupMemberInfo?.data(using: .utf8),
                  let member = try? JSONDecoder().decode(OpenIMGroupMemberInfo.self, from: data) else { return }
            listener?.onGroupMemberInfoChanged(member)
        }

        func onGroupApplicationAdded(_ groupApplication: String?) {
            guard let data = groupApplication?.data(using: .utf8),
                  let app = try? JSONDecoder().decode(OpenIMGroupApplicationInfo.self, from: data) else { return }
            listener?.onGroupApplicationAdded(app)
        }

        func onGroupApplicationDeleted(_ groupApplication: String?) {
            guard let data = groupApplication?.data(using: .utf8),
                  let app = try? JSONDecoder().decode(OpenIMGroupApplicationInfo.self, from: data) else { return }
            listener?.onGroupApplicationDeleted(app)
        }

        func onGroupApplicationAccepted(_ groupApplication: String?) {
            guard let data = groupApplication?.data(using: .utf8),
                  let app = try? JSONDecoder().decode(OpenIMGroupApplicationInfo.self, from: data) else { return }
            listener?.onGroupApplicationAccepted(app)
        }

        func onGroupApplicationRejected(_ groupApplication: String?) {
            guard let data = groupApplication?.data(using: .utf8),
                  let app = try? JSONDecoder().decode(OpenIMGroupApplicationInfo.self, from: data) else { return }
            listener?.onGroupApplicationRejected(app)
        }
    }

    private final class ConversationListenerBridge: NSObject, Open_im_sdk_callbackOnConversationListenerProtocol {
        private weak var listener: OpenIMConversationListener?

        init(listener: OpenIMConversationListener) {
            self.listener = listener
        }

        func onSyncServerStart(_ reinstalled: Bool) {
            listener?.onSyncServerStart()
        }

        func onSyncServerFinish(_ reinstalled: Bool) {
            listener?.onSyncServerFinish()
        }

        func onSyncServerProgress(_ progress: Int) {
            listener?.onSyncServerProgress(progress)
        }

        func onSyncServerFailed(_ reinstalled: Bool) {
            listener?.onSyncServerFailed()
        }

        func onNewConversation(_ conversationList: String?) {
            guard let data = conversationList?.data(using: .utf8),
                  let convs = try? JSONDecoder().decode([OpenIMConversationInfo].self, from: data) else { return }
            listener?.onNewConversation(convs)
        }

        func onConversationChanged(_ conversationList: String?) {
            guard let data = conversationList?.data(using: .utf8),
                  let convs = try? JSONDecoder().decode([OpenIMConversationInfo].self, from: data) else { return }
            listener?.onConversationChanged(convs)
        }

        func onTotalUnreadMessageCountChanged(_ totalUnreadCount: Int32) {
            listener?.onTotalUnreadMessageCountChanged(Int(totalUnreadCount))
        }

        func onConversationUserInputStatusChanged(_ change: String?) {}
    }

    private final class AdvancedMsgListenerBridge: NSObject, Open_im_sdk_callbackOnAdvancedMsgListenerProtocol {
        private weak var listener: OpenIMAdvancedMsgListener?

        init(listener: OpenIMAdvancedMsgListener) {
            self.listener = listener
        }

        func onRecvNewMessage(_ message: String?) {
            guard let data = message?.data(using: .utf8),
                  let msg = try? JSONDecoder().decode(OpenIMMessageInfo.self, from: data) else { return }
            listener?.onRecvNewMessage(msg)
        }

        func onRecvC2CReadReceipt(_ msgReceiptList: String?) {
            guard let data = msgReceiptList?.data(using: .utf8),
                  let receipts = try? JSONDecoder().decode([OpenIMReceiptInfo].self, from: data) else { return }
            listener?.onRecvC2CReadReceipt(receipts)
        }

        func onNewRecvMessageRevoked(_ messageRevoked: String?) {
            guard let data = messageRevoked?.data(using: .utf8),
                  let revoked = try? JSONDecoder().decode(OpenIMMessageRevokedInfo.self, from: data) else { return }
            listener?.onRecvMessageRevoked(revoked)
        }

        func onMsgDeleted(_ message: String?) {}
        func onRecvOfflineNewMessage(_ message: String?) {}
        func onRecvOnlineOnlyMessage(_ message: String?) {}
    }

#endif
