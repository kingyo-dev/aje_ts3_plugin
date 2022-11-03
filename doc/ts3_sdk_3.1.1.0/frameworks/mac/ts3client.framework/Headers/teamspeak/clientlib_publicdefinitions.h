#ifndef CLIENTLIB_PUBLICDEFINITIONS_H
#define CLIENTLIB_PUBLICDEFINITIONS_H

enum Visibility {
	ENTER_VISIBILITY = 0, ///< Client joined from an unsubscribed channel, or joined the server.
	RETAIN_VISIBILITY, ///< Client switched from one subscribed channel to a different subscribed channel.
	LEAVE_VISIBILITY ///< Client switches to an unsubscribed channel, or disconnected from server.
};

enum ConnectStatus {
	STATUS_DISCONNECTED = 0,       ///< There is no activity to the server, this is the default value
	STATUS_CONNECTING,             ///< We are trying to connect, we haven't got a client id yet, we haven't been accepted by the server
	STATUS_CONNECTED,              ///< The server has accepted us, we can talk and hear and we have a client id, but we don't have the channels and clients yet, we can get server infos (welcome msg etc.)
	STATUS_CONNECTION_ESTABLISHING,///< we are connected and we are visible
	STATUS_CONNECTION_ESTABLISHED, ///< we are connected and we have the client and channels available
};

enum LocalTestMode {
    TEST_MODE_OFF = 0,
    TEST_MODE_VOICE_LOCAL_ONLY,
    TEST_MODE_VOICE_LOCAL_AND_REMOTE,
    TEST_MODE_TALK_STATUS_CHANGES_ONLY
};

#endif //CLIENTLIB_PUBLICDEFINITIONS_H
