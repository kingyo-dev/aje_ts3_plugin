//
//  TeamSpeakManager.m
//  client_ios
//
//  Copyright (c) 2017 TeamSpeak-Systems
//

#import "TeamSpeakManager.h"

#import "teamspeak/clientlib.h"
#import "teamspeak/public_errors.h"
#import "teamspeak/public_definitions.h"

@interface TeamSpeakManager ()

- (void)initializeLibrary;
- (void)destroyLibrary;

- (void)spawnServerConnectionHandler;
- (void)destroyServerConnectionHandler;

- (void)registerAudioDevice;
- (void)unregisterAudioDevice;

- (void)openAudio;
- (void)closeAudio;

- (NSString *)getErrorMessage:(int)error;
- (BOOL)setPreProcessorValue:(NSString *)value forIdentifier:(NSString *)ident;


- (void)onConnectStatusChangedEvent:(NSDictionary *)parameters;
- (void)onNewChannelEvent:(NSDictionary *)parameters;
- (void)onNewChannelCreatedEvent:(NSDictionary *)parameters;
- (void)onDelChannelEvent:(NSDictionary *)parameters;
- (void)onClientMoveEvent:(NSDictionary *)parameters;
- (void)onClientMoveSubscriptionEvent:(NSDictionary *)parameters;
- (void)onClientMoveTimeoutEvent:(NSDictionary *)parameters;
- (void)onTalkStatusChangeEvent:(NSDictionary *)parameters;
- (void)onServerErrorEvent:(NSDictionary *)parameters;

@end


#pragma mark - SDK C function callbacks

void onConnectStatusChangeEvent(uint64 serverConnectionHandlerID, int newStatus, unsigned int errorNumber) {
    @autoreleasepool {
        NSDictionary *params = @{@"handlerID": @(serverConnectionHandlerID),
                                 @"newStatus": @(newStatus),
                                 @"errorNumber": @(errorNumber)};
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[TeamSpeakManager sharedManager] onConnectStatusChangedEvent:params];
        });
    }
}

void onNewChannelEvent(uint64 serverConnectionHandlerID, uint64 channelID, uint64 channelParentID) {
    @autoreleasepool {
        NSDictionary *params = @{@"handlerID": @(serverConnectionHandlerID),
                                 @"channelID": @(channelID),
                                 @"channelParentID": @(channelParentID)};
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[TeamSpeakManager sharedManager] onNewChannelEvent:params];
        });
    }
}

void onNewChannelCreatedEvent(uint64 serverConnectionHandlerID, uint64 channelID, uint64 channelParentID, anyID invokerID, const char* invokerName, const char* invokerUniqueIdentifier) {
    @autoreleasepool {
        NSDictionary *params = @{@"handlerID": @(serverConnectionHandlerID),
                                 @"channelID": @(channelID),
                                 @"channelParentID": @(channelParentID),
                                 @"invokerID": @(invokerID),
                                 @"invokerName": invokerName ? [NSString stringWithUTF8String:invokerName] : @"",
                                 @"invokerUniqueIdentifier": invokerUniqueIdentifier ? [NSString stringWithUTF8String:invokerUniqueIdentifier] : @""};
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[TeamSpeakManager sharedManager] onNewChannelCreatedEvent:params];
        });
    }
}

void onDelChannelEvent(uint64 serverConnectionHandlerID, uint64 channelID, anyID invokerID, const char* invokerName, const char* invokerUniqueIdentifier) {
    @autoreleasepool {
        NSDictionary *params = @{@"handlerID": @(serverConnectionHandlerID),
                                 @"channelID": @(channelID),
                                 @"invokerID": @(invokerID),
                                 @"invokerName": invokerName ? [NSString stringWithUTF8String:invokerName] : @"",
                                 @"invokerUniqueIdentifier": invokerUniqueIdentifier ? [NSString stringWithUTF8String:invokerUniqueIdentifier] : @""};
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[TeamSpeakManager sharedManager] onDelChannelEvent:params];
        });
    }
}

void onClientMoveEvent(uint64 serverConnectionHandlerID, anyID clientID, uint64 oldChannelID, uint64 newChannelID, int visibility, const char* moveMessage) {
    @autoreleasepool {
        NSDictionary *params = @{@"handlerID": @(serverConnectionHandlerID),
                                 @"clientID": @(clientID),
                                 @"oldChannelID": @(oldChannelID),
                                 @"newChannelID": @(newChannelID),
                                 @"visibility": @(visibility),
                                 @"moveMessage": moveMessage ? [NSString stringWithUTF8String:moveMessage] : @""};
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[TeamSpeakManager sharedManager] onClientMoveEvent:params];
        });
    }
}

void onClientMoveSubscriptionEvent(uint64 serverConnectionHandlerID, anyID clientID, uint64 oldChannelID, uint64 newChannelID, int visibility) {
    @autoreleasepool {
        NSDictionary *params = @{@"handlerID": @(serverConnectionHandlerID),
                                 @"clientID": @(clientID),
                                 @"oldChannelID": @(oldChannelID),
                                 @"newChannelID": @(newChannelID),
                                 @"visibility": @(visibility)};
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[TeamSpeakManager sharedManager] onClientMoveSubscriptionEvent:params];
        });
    }
}

void onClientMoveTimeoutEvent(uint64 serverConnectionHandlerID, anyID clientID, uint64 oldChannelID, uint64 newChannelID, int visibility, const char* timeoutMessage) {
    @autoreleasepool {
        NSDictionary *params = @{@"handlerID": @(serverConnectionHandlerID),
                                 @"clientID": @(clientID),
                                 @"oldChannelID": @(oldChannelID),
                                 @"newChannelID": @(newChannelID),
                                 @"visibility": @(visibility),
                                 @"timeoutMessage": timeoutMessage ? [NSString stringWithUTF8String:timeoutMessage] : @""};
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[TeamSpeakManager sharedManager] onClientMoveTimeoutEvent:params];
        });
    }
}

void onTalkStatusChangeEvent(uint64 serverConnectionHandlerID, int status, int isReceivedWhisper, anyID clientID) {
    @autoreleasepool {
        NSDictionary *params = @{@"handlerID": @(serverConnectionHandlerID),
                                 @"status": @(status),
                                 @"isReceivedWhisper": @(isReceivedWhisper),
                                 @"clientID": @(clientID)};
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[TeamSpeakManager sharedManager] onTalkStatusChangeEvent:params];
        });
    }
}

void onServerErrorEvent(uint64 serverConnectionHandlerID, const char* errorMessage, unsigned int error, const char* returnCode, const char* extraMessage) {
    @autoreleasepool {
        NSDictionary *params = @{@"handlerID": @(serverConnectionHandlerID),
                                 @"errorMessage": @(errorMessage),
                                 @"error": @(error),
                                 @"returnCode": returnCode ? [NSString stringWithUTF8String:returnCode] : @"",
                                 @"extraMessage": extraMessage ? [NSString stringWithUTF8String:extraMessage] : @""};
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[TeamSpeakManager sharedManager] onServerErrorEvent:params];
        });
    }
}

@implementation TeamSpeakManager {
    UInt64 _serverConnectionHandlerID;
    BOOL   _captureActive;
    BOOL   _playbackActive;
}

+ (instancetype)sharedManager {
    static TeamSpeakManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _audioIO = [[AudioIO alloc] init];
        _audioIO.delegate = self;
        
        [self initializeLibrary];
        [self spawnServerConnectionHandler];
        [self registerAudioDevice];
        
        self.nickname = @"client";
    }
    return self;
}

- (void)dealloc
{
    [self unregisterAudioDevice];
    [self destroyServerConnectionHandler];
    [self destroyLibrary];
}

#pragma mark -

- (NSString *)createIdentity
{
    NSString *identity = nil;
    char* cstring;
    int error = ts3client_createIdentity(&cstring);
    if(error == ERROR_ok)
    {
        identity = [NSString stringWithUTF8String:cstring];
        ts3client_freeMemory(cstring);
    }
    else
    {
        NSLog(@"Error creating identity: %@", [self getErrorMessage:error]);
    }
    
    return identity;
}

- (void)connectToIPAddress:(NSString *)IPAddress port:(int)port password:(NSString *)password
{
    if (!self.identity) {
        NSLog(@"Creating default identity");
        self.identity = [self createIdentity];
    }
    
    if (!password) {
        /* be careful with nil as parameters for SDK calls. */
        password = @"";
    }
    
    /* Connect to server. No default channel and no default channel password specified */
    int error = ts3client_startConnection(_serverConnectionHandlerID, self.identity.UTF8String, IPAddress.UTF8String, port, self.nickname.UTF8String, NULL, "", password.UTF8String);
    if(error != ERROR_ok) {
        NSLog(@"Error connecting to server: %@", [self getErrorMessage:error]);
        return;
    }
    
    [self openAudio];
    
    /* Set mode to voice activated */
    [self setPreProcessorValue:@"true" forIdentifier:@"vad"];
    
    /* Set the voice activation level in dB. You might want to experiment with these values */
    [self setPreProcessorValue:@"-5" forIdentifier:@"voiceactivation_level"];
    
}

- (void)disconnect
{
    unsigned int error;
    
    NSLog(@"DISCONNECT button pressed, calling lib function");
    
    /* Disconnect from server */
    if((error = ts3client_stopConnection(_serverConnectionHandlerID, "leaving")) != ERROR_ok) {
        printf("Error stopping connection: %d\n", error);
        return;
    }
    
}

#pragma mark - Properties

- (int)connectStatus
{
    int status;
    int error = ts3client_getConnectionStatus(_serverConnectionHandlerID, &status);
    if (error == ERROR_ok) {
        return status;
    }
    return STATUS_DISCONNECTED;
}

- (NSString *)connectStatusString
{
    switch (self.connectStatus) {
        case STATUS_DISCONNECTED: return @"STATUS_DISCONNECTED";
        case STATUS_CONNECTING: return @"STATUS_CONNECTING";
        case STATUS_CONNECTED: return @"STATUS_CONNECTED";
        case STATUS_CONNECTION_ESTABLISHING: return @"STATUS_CONNECTION_ESTABLISHING";
        case STATUS_CONNECTION_ESTABLISHED: return @"STATUS_CONNECTION_ESTABLISHED";
    }
    return nil;
}

- (NSString *)clientLibVersion
{
    NSString *version = nil;
    char* cstring;
    if(ts3client_getClientLibVersion(&cstring) == ERROR_ok)
    {
        version = [NSString stringWithUTF8String:cstring];
        ts3client_freeMemory(cstring);
    }
    return version;
}

- (BOOL)isConnected
{
    return self.connectStatus == STATUS_CONNECTION_ESTABLISHED;
}

- (BOOL)isDisconnected
{
    return self.connectStatus == STATUS_DISCONNECTED;
}

- (BOOL)isConnecting
{
    return !self.isConnected && !self.isDisconnected;
}

#pragma mark - Private methods

- (void)initializeLibrary
{
    /* Create struct for callback function pointers */
    struct ClientUIFunctions funcs;
    
    /* Initialize all callbacks with NULL */
    memset(&funcs, 0, sizeof(struct ClientUIFunctions));
    
    /* Now assign the used callback function pointers */
    funcs.onConnectStatusChangeEvent    = onConnectStatusChangeEvent;
    funcs.onNewChannelEvent             = onNewChannelEvent;
    funcs.onNewChannelCreatedEvent      = onNewChannelCreatedEvent;
    funcs.onDelChannelEvent             = onDelChannelEvent;
    funcs.onClientMoveEvent             = onClientMoveEvent;
    funcs.onClientMoveSubscriptionEvent = onClientMoveSubscriptionEvent;
    funcs.onClientMoveTimeoutEvent      = onClientMoveTimeoutEvent;
    funcs.onTalkStatusChangeEvent       = onTalkStatusChangeEvent;
    funcs.onServerErrorEvent            = onServerErrorEvent;
    
    /* Initialize client lib with callbacks */
    unsigned int error = ts3client_initClientLib(&funcs, 0, LogType_CONSOLE, NULL, NULL);
    if(error != ERROR_ok)
    {
        NSLog(@"initializeLibrary ERROR: %@", [self getErrorMessage:error]);
    }
    else
    {
        NSLog(@"initializeLibrary OK");
    }

}

- (void)destroyLibrary
{
    ts3client_destroyClientLib();
}

- (NSString *)getErrorMessage:(int)error
{
    NSString *message = nil;
    char* cstring;
    if(ts3client_getErrorMessage(error, &cstring) == ERROR_ok)
    {
        message = [NSString stringWithUTF8String:cstring];
        ts3client_freeMemory(cstring);
    }
    return message;
}

- (BOOL)setPreProcessorValue:(NSString *)value forIdentifier:(NSString *)ident
{
    int error = ts3client_setPreProcessorConfigValue(_serverConnectionHandlerID, ident.UTF8String, value.UTF8String);
    if (error != ERROR_ok)
    {
        NSLog(@"Error setting preprocessor %@ = %@: %@", ident, value, [self getErrorMessage:error]);
        return NO;
    }
    return YES;
}

- (int)selfClientID
{
    anyID ourID;
    int error = ts3client_getClientID(_serverConnectionHandlerID, &ourID);
    if (error == ERROR_ok)
    {
        return ourID;
    }
    return 0;
}

- (void)spawnServerConnectionHandler
{
    // Create a server connection handler
    unsigned int error = ts3client_spawnNewServerConnectionHandler(0, &_serverConnectionHandlerID);
    if(error != ERROR_ok)
    {
        NSLog(@"ts3client_spawnNewServerConnectionHandler ERROR");
        return;
    }
}

- (void)destroyServerConnectionHandler
{
    if (_serverConnectionHandlerID > 0)
    {
        ts3client_destroyServerConnectionHandler(_serverConnectionHandlerID);
        _serverConnectionHandlerID = 0;
    }
}

#pragma mark - Audio Handling

- (void)registerAudioDevice
{
    NSLog(@"Registering custom sound device, sample rate = %f ***", AUDIO_SAMPLE_RATE);
    
    int error = ts3client_registerCustomDevice(self.audioIO.deviceID.UTF8String,
                                               self.audioIO.deviceDisplayName.UTF8String,
                                               self.audioIO.sampleRate,
                                               self.audioIO.numChannels,
                                               self.audioIO.sampleRate,
                                               self.audioIO.numChannels);
    if (error != ERROR_ok)
    {
        NSLog(@"Error registering custom sound device: %@", [self getErrorMessage:error]);
    }

}

- (void)unregisterAudioDevice
{
    NSLog(@"Unregistering custom sound device");
    
    int error = ts3client_unregisterCustomDevice(self.audioIO.deviceID.UTF8String);
    if (error != ERROR_ok)
    {
        NSLog(@"Error unregistering custom sound device: %@", [self getErrorMessage:error]);
    }
}

- (void)openAudio
{
    NSLog(@"Opening capture device for server connection handler %qu", _serverConnectionHandlerID);
    
    int error = ts3client_openCaptureDevice(_serverConnectionHandlerID, "custom", self.audioIO.deviceID.UTF8String);
    if (error != ERROR_ok)
    {
        NSLog(@"Error opening capture device: %@", [self getErrorMessage:error]);
    }
    else
    {
        _captureActive = YES;
    }
    
    NSLog(@"Opening playback device for server connection handler %qu", _serverConnectionHandlerID);
    
    error = ts3client_openPlaybackDevice(_serverConnectionHandlerID, "custom", self.audioIO.deviceID.UTF8String);
    if (error != ERROR_ok)
    {
        NSLog(@"Error opening playback device: %@", [self getErrorMessage:error]);
    }
    else
    {
        _playbackActive = YES;
    }
    
    [_audioIO start];
}

- (void)closeAudio
{
    if (_captureActive) {
        NSLog(@"Closing capture device");
        
        int error = ts3client_closeCaptureDevice(_serverConnectionHandlerID);
        if (error != ERROR_ok)
        {
            NSLog(@"Error closing capture device: %@\n", [self getErrorMessage:error]);
        }
        else
        {
            _captureActive = NO;
        }
    }
    
    if (_playbackActive) {
        NSLog(@"Closing playback device");
        
        int error = ts3client_closePlaybackDevice(_serverConnectionHandlerID);
        if (error != ERROR_ok)
        {
            printf("Error closing playback device: %d\n", error);
        }
        else
        {
            _playbackActive = NO;
        }
    }
    
    [_audioIO stop];
}

-(void)audioIO:(AudioIO *)audioIO processAudioToSpeaker:(AudioBufferList *)ioData {
    if (!_playbackActive) {
        return;
    }
    
    int numSamples = ioData->mBuffers[0].mDataByteSize / (AUDIO_BIT_DEPTH_IN_BYTES * AUDIO_NUM_CHANNELS);
    short *outData = (short*)(ioData->mBuffers[0].mData); // A single buffer contains interleaved data for AUDIO_NUM_CHANNELS channels
    
    
    /* Get playback data from the client lib */
    int error = ts3client_acquireCustomPlaybackData(self.audioIO.deviceID.UTF8String,
                                                    outData,
                                                    numSamples);
    if (error != ERROR_ok && error != ERROR_sound_no_data)
    {
        NSLog(@"Error acquiring playback data: %@", [self getErrorMessage:error]);
    }
}

-(void)audioIO:(AudioIO *)audioIO processAudioFromMicrophone:(AudioBufferList *)ioData {
    if (!_captureActive) {
        return;
    }
    
    int numSamples = ioData->mBuffers[0].mDataByteSize / (AUDIO_BIT_DEPTH_IN_BYTES * AUDIO_NUM_CHANNELS);
    short *inData = (short*)(ioData->mBuffers[0].mData); // A single buffer contains interleaved data for AUDIO_NUM_CHANNELS channels
    
    /* Send capture data to the client lib */
    int error = ts3client_processCustomCaptureData(self.audioIO.deviceID.UTF8String,
                                                   inData,
                                                   numSamples);
    if (error != ERROR_ok)
    {
        NSLog(@"Error processing capture data: %@", [self getErrorMessage:error]);
    }
}

-(void)audioWillStart:(AudioIO *)audioIO {
    if (!self.isDisconnected) {
        [self openAudio];
    }
}

-(void)audioWillStop:(AudioIO *)audioIO {
    if (!self.isDisconnected) {
        [self closeAudio];
    }
}


#pragma mark - SDK callbacks on main thread

/*
 * Callback for connection status change.
 * Connection status switches through the states STATUS_DISCONNECTED, STATUS_CONNECTING, STATUS_CONNECTED and STATUS_CONNECTION_ESTABLISHED.
 *
 * Parameters:
 *   serverConnectionHandlerID - Server connection handler ID
 *   newStatus                 - New connection status, see the enum ConnectStatus in clientlib_publicdefinitions.h
 *   errorNumber               - Error code. Should be zero when connecting or actively disconnection.
 *                               Contains error state when losing connection.
 */
- (void)onConnectStatusChangedEvent:(NSDictionary *)parameters {
    int newStatus = [parameters[@"newStatus"] intValue];
    int errorNumber = [parameters[@"errorNumber"] intValue];
    
    NSLog(@"onConnectStatusChangedEvent newStatus: %i error: %i\n", newStatus, errorNumber);
    /* Failed to connect ? */
    if(newStatus == STATUS_DISCONNECTED && errorNumber == ERROR_failed_connection_initialisation) {
        printf("Looks like there is no server running!\n");
    }
    
    if (newStatus == STATUS_DISCONNECTED)
    {
        [self closeAudio];
    }
    
    [self.delegate teamSpeakManager:self connectStatusChanged:newStatus];
    
    if (errorNumber > 0) {
        [self.delegate teamSpeakManager:self onConnectionError:errorNumber];
    }
}

/*
 * Callback for current channels being announced to the client after connecting to a server.
 *
 * Parameters:
 *   serverConnectionHandlerID - Server connection handler ID
 *   channelID                 - ID of the announced channel
 *   channelParentID           - ID of the parent channel
 */
- (void)onNewChannelEvent:(NSDictionary *)parameters {
    int channelID = [parameters[@"channelID"] intValue];
    int channelParentID = [parameters[@"channelParentID"] intValue];
    
    NSLog(@"onNewChannelEvent channelID: %i channelParentID: %i", channelID, channelParentID);
}

/*
 * Callback for just created channels.
 *
 * Parameters:
 *   serverConnectionHandlerID - Server connection handler ID
 *   channelID                 - ID of the announced channel
 *   channelParentID           - ID of the parent channel
 *   invokerID                 - ID of the client who created the channel
 *   invokerName               - Name of the client who created the channel
 */
- (void)onNewChannelCreatedEvent:(NSDictionary *)parameters {
    int channelID = [parameters[@"channelID"] intValue];
    NSString* invokerName = parameters[@"invokerName"];
    
    NSLog(@"onNewChannelCreatedEvent channelID: %i invokerName: %@", channelID, invokerName);
}

/*
 * Callback when a channel was deleted.
 *
 * Parameters:
 *   serverConnectionHandlerID - Server connection handler ID
 *   channelID                 - ID of the deleted channel
 *   invokerID                 - ID of the client who deleted the channel
 *   invokerName               - Name of the client who deleted the channel
 */
- (void)onDelChannelEvent:(NSDictionary *)parameters {
    int channelID = [parameters[@"channelID"] intValue];
    NSString* invokerName = parameters[@"invokerName"];
    
    NSLog(@"onDelChannelEvent channelID: %i invokerName: %@", channelID, invokerName);
}

/*
 * Called when a client joins, leaves or moves to another channel.
 *
 * Parameters:
 *   serverConnectionHandlerID - Server connection handler ID
 *   clientID                  - ID of the moved client
 *   oldChannelID              - ID of the old channel left by the client
 *   newChannelID              - ID of the new channel joined by the client
 *   visibility                - Visibility of the moved client. See the enum Visibility in clientlib_publicdefinitions.h
 *                               Values: ENTER_VISIBILITY, RETAIN_VISIBILITY, LEAVE_VISIBILITY
 */
- (void)onClientMoveEvent:(NSDictionary *)parameters {
    int clientID = [parameters[@"clientID"] intValue];
    int oldChannelID = [parameters[@"oldChannelID"] intValue];
    int newChannelID = [parameters[@"newChannelID"] intValue];
    int visibility = [parameters[@"visibility"] intValue];
    
    NSLog(@"onClientMoveEvent clientID: %i oldChannelID: %i newChannelID: %i visibility: %i", clientID, oldChannelID, newChannelID, visibility);
}

/*
 * Callback for other clients in current and subscribed channels being announced to the client.
 *
 * Parameters:
 *   serverConnectionHandlerID - Server connection handler ID
 *   clientID                  - ID of the announced client
 *   oldChannelID              - ID of the subscribed channel where the client left visibility
 *   newChannelID              - ID of the subscribed channel where the client entered visibility
 *   visibility                - Visibility of the announced client. See the enum Visibility in clientlib_publicdefinitions.h
 *                               Values: ENTER_VISIBILITY, RETAIN_VISIBILITY, LEAVE_VISIBILITY
 */
- (void)onClientMoveSubscriptionEvent:(NSDictionary *)parameters {
    int clientID = [parameters[@"clientID"] intValue];
    int oldChannelID = [parameters[@"oldChannelID"] intValue];
    int newChannelID = [parameters[@"newChannelID"] intValue];
    int visibility = [parameters[@"visibility"] intValue];
    
    NSLog(@"onClientMoveSubscriptionEvent clientID: %i oldChannelID: %i newChannelID: %i visibility: %i", clientID, oldChannelID, newChannelID, visibility);
}

/*
 * Called when a client drops his connection.
 *
 * Parameters:
 *   serverConnectionHandlerID - Server connection handler ID
 *   clientID                  - ID of the moved client
 *   oldChannelID              - ID of the channel the leaving client was previously member of
 *   newChannelID              - 0, as client is leaving
 *   visibility                - Always LEAVE_VISIBILITY
 *   timeoutMessage            - Optional message giving the reason for the timeout
 */
- (void)onClientMoveTimeoutEvent:(NSDictionary *)parameters {
    int clientID = [parameters[@"clientID"] intValue];
    int oldChannelID = [parameters[@"oldChannelID"] intValue];
    int newChannelID = [parameters[@"newChannelID"] intValue];
    int visibility = [parameters[@"visibility"] intValue];
    
    NSLog(@"onClientMoveTimeoutEvent clientID: %i oldChannelID: %i newChannelID: %i visibility: %i", clientID, oldChannelID, newChannelID, visibility);
}

/*
 * This event is called when a client starts or stops talking.
 *
 * Parameters:
 *   serverConnectionHandlerID - Server connection handler ID
 *   status                    - 1 if client starts talking, 0 if client stops talking
 *   isReceivedWhisper         - 1 if this event was caused by whispering, 0 if caused by normal talking
 *   clientID                  - ID of the client who announced the talk status change
 */
- (void)onTalkStatusChangeEvent:(NSDictionary *)parameters {
    int status = [parameters[@"status"] intValue];
    int isReceivedWhisper = [parameters[@"isReceivedWhisper"] intValue];
    int clientID = [parameters[@"clientID"] intValue];
    
    NSLog(@"onTalkStatusChangeEvent status: %i isReceivedWhisper: %i clientID: %i", status, isReceivedWhisper, clientID);
    
    [self.delegate teamSpeakManager:self clientID:clientID talkStatusChanged:status != STATUS_NOT_TALKING];
}

/*
 * This event is called when the server sends an error to the client as the result of an asynchronous request.
 *
 *
 * Parameters:
 *   serverConnectionHandlerID - Server connection handler ID
 *   errorMessage              - String containing a verbose error message
 *   error                     - Error code as defined in public_errors.h
 *   returnCode                - Set by the client lib function call which caused this event
 *   extraMessage              - Can contain additional information about the error
 */
- (void)onServerErrorEvent:(NSDictionary *)parameters {
    NSString *errorMessage = parameters[@"errorMessage"];
    int error = [parameters[@"error"] intValue];
    NSString* returnCode = parameters[@"returnCode"];
    NSString* extraMessage = parameters[@"extraMessage"];
    
    NSLog(@"onServerErrorEvent errorMessage: %@ error: %i returnCode: %@ extraMessage: %@", errorMessage, error, returnCode, extraMessage);
}

@end

