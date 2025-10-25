// AIWindow.qml
// Main AI Chatbot interface with voice input and chat display
// Standalone version with mock functionality
// Dimensions: 320x380px to match ClimateControl component
// FIXED: Removed duplicate property assignments

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root
    
    width: 320
    height: 380
    
    // Signals
    signal closeRequested()
    signal messageSubmitted(string message)
    
    // Properties
    property bool isListening: false
    property bool showHistory: false
    property string currentChatId: "current"
    
    // Mock chat messages for current conversation
    ListModel {
        id: chatMessagesModel
        
        Component.onCompleted: {
            // Add welcome message
            append({
                isUser: false,
                message: "Hi! I'm your AI assistant. How can I help you today?",
                timestamp: getCurrentTime()
            })
        }
    }
    
    // Main container
    Rectangle {
        id: mainBackground
        anchors.fill: parent
        color: "#0A0A0F"
        radius: 12
        border.color: "#1A1A1A"
        border.width: 2
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 10
            
            // Top bar with list and close buttons
            RowLayout {
                Layout.fillWidth: true
                spacing: 8
                
                // List icon (chat history)
                Rectangle {
                    id: listButton
                    width: 32
                    height: 32
                    radius: 16
                    color: "transparent"
                    border.color: "#404040"
                    border.width: 1.5
                    
                    // FIXED: Removed duplicate scale property
                    property real buttonScale: 1.0
                    scale: buttonScale
                    
                    Text {
                        anchors.centerIn: parent
                        text: "☰"
                        font.pixelSize: 16
                        color: "#FFFFFF"
                    }
                    
                    MouseArea {
                        id: listButtonMouseArea
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        
                        onPressed: listButton.buttonScale = 0.9
                        onReleased: listButton.buttonScale = 1.0
                        onClicked: {
                            root.showHistory = !root.showHistory
                        }
                    }
                    
                    Behavior on buttonScale {
                        NumberAnimation { duration: 100 }
                    }
                }
                
                // Title
                Text {
                    Layout.fillWidth: true
                    text: "AI Assistant"
                    font.family: "Segoe UI"
                    font.pixelSize: 14
                    font.bold: true
                    color: "#FFFFFF"
                    horizontalAlignment: Text.AlignHCenter
                }
                
                // Close button
                Rectangle {
                    id: closeButton
                    width: 32
                    height: 32
                    radius: 16
                    color: "transparent"
                    border.color: "#404040"
                    border.width: 1.5
                    
                    // FIXED: Removed duplicate scale property
                    property real buttonScale: 1.0
                    scale: buttonScale
                    
                    Text {
                        anchors.centerIn: parent
                        text: "×"
                        font.pixelSize: 20
                        color: "#FFFFFF"
                    }
                    
                    MouseArea {
                        id: closeButtonMouseArea
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        
                        onPressed: closeButton.buttonScale = 0.9
                        onReleased: closeButton.buttonScale = 1.0
                        onClicked: {
                            root.closeRequested()
                        }
                    }
                    
                    Behavior on buttonScale {
                        NumberAnimation { duration: 100 }
                    }
                }
            }
            
            // Chat messages area OR voice visualizer
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "#1A1A1A"
                radius: 10
                
                // Chat messages view (when not listening)
                ListView {
                    id: chatView
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 8
                    clip: true
                    visible: !root.isListening
                    
                    model: chatMessagesModel
                    
                    delegate: Item {
                        width: chatView.width
                        height: messageBubble.height + 12
                        
                        Rectangle {
                            id: messageBubble
                            width: Math.min(parent.width * 0.75, messageText.implicitWidth + 20)
                            height: messageText.implicitHeight + 16
                            
                            x: model.isUser ? parent.width - width : 0
                            
                            color: model.isUser ? "#00D9FF" : "#2A2A2A"
                            radius: 12
                            
                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 10
                                spacing: 4
                                
                                Text {
                                    id: messageText
                                    Layout.fillWidth: true
                                    text: model.message
                                    font.family: "Segoe UI"
                                    font.pixelSize: 12
                                    color: model.isUser ? "#0A0A0F" : "#FFFFFF"
                                    wrapMode: Text.Wrap
                                }
                                
                                Text {
                                    text: model.timestamp
                                    font.family: "Segoe UI"
                                    font.pixelSize: 9
                                    color: model.isUser ? "#0A0A0F" : "#808080"
                                    opacity: 0.7
                                }
                            }
                        }
                    }
                    
                    // Auto-scroll to bottom
                    onCountChanged: {
                        Qt.callLater(positionViewAtEnd)
                    }
                }
                
                // Voice visualizer (when listening)
                VoiceVisualizer {
                    id: visualizer
                    anchors.fill: parent
                    anchors.margins: 8
                    visible: root.isListening
                    isActive: root.isListening
                    barColor: "#00D9FF"
                }
                
                // Thinking indicator (when AI is responding)
                Row {
                    id: thinkingIndicator
                    anchors.centerIn: parent
                    spacing: 8
                    visible: false
                    
                    Repeater {
                        model: 3
                        
                        Rectangle {
                            width: 8
                            height: 8
                            radius: 4
                            color: "#00D9FF"
                            
                            SequentialAnimation on opacity {
                                running: thinkingIndicator.visible
                                loops: Animation.Infinite
                                
                                PauseAnimation { duration: index * 200 }
                                NumberAnimation { from: 0.3; to: 1.0; duration: 600 }
                                NumberAnimation { from: 1.0; to: 0.3; duration: 600 }
                            }
                        }
                    }
                }
            }
            
            // Input area
            Rectangle {
                Layout.fillWidth: true
                height: 45
                color: "#1A1A1A"
                radius: 20
                border.color: textInput.activeFocus ? "#00D9FF" : "#404040"
                border.width: 1
                
                Behavior on border.color {
                    ColorAnimation { duration: 200 }
                }
                
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 15
                    anchors.rightMargin: 8
                    spacing: 8
                    
                    // Text input
                    TextInput {
                        id: textInput
                        Layout.fillWidth: true
                        
                        font.family: "Segoe UI"
                        font.pixelSize: 13
                        color: "#FFFFFF"
                        selectionColor: "#00D9FF"
                        selectedTextColor: "#0A0A0F"
                        
                        clip: true
                        
                        Text {
                            anchors.fill: parent
                            text: "Type a message..."
                            font: textInput.font
                            color: "#808080"
                            visible: !textInput.text && !textInput.activeFocus
                            verticalAlignment: Text.AlignVCenter
                        }
                        
                        Keys.onReturnPressed: {
                            sendMessage()
                        }
                    }
                    
                    // Microphone button
                    Rectangle {
                        id: micButton
                        width: 32
                        height: 32
                        radius: 16
                        color: root.isListening ? "#00D9FF" : "#2A2A2A"
                        
                        // FIXED: Removed duplicate scale property
                        property real buttonScale: 1.0
                        scale: buttonScale
                        
                        Behavior on color {
                            ColorAnimation { duration: 200 }
                        }
                        
                        Text {
                            anchors.centerIn: parent
                            text: "🎤"
                            font.pixelSize: 16
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            
                            onPressed: micButton.buttonScale = 0.9
                            onReleased: micButton.buttonScale = 1.0
                            onClicked: {
                                root.isListening = !root.isListening
                                
                                if (root.isListening) {
                                    // Simulate voice input after 3 seconds
                                    voiceInputTimer.start()
                                }
                            }
                        }
                        
                        Behavior on buttonScale {
                            NumberAnimation { duration: 100 }
                        }
                        
                        // Pulsing animation when listening - FIXED: Use separate property
                        property real pulseScale: 1.0
                        
                        SequentialAnimation on pulseScale {
                            running: root.isListening
                            loops: Animation.Infinite
                            NumberAnimation { from: 1.0; to: 1.1; duration: 800; easing.type: Easing.InOutQuad }
                            NumberAnimation { from: 1.1; to: 1.0; duration: 800; easing.type: Easing.InOutQuad }
                        }
                        
                        // Apply pulse scale only when listening
                        transform: Scale {
                            origin.x: micButton.width / 2
                            origin.y: micButton.height / 2
                            xScale: root.isListening ? micButton.pulseScale : 1.0
                            yScale: root.isListening ? micButton.pulseScale : 1.0
                        }
                    }
                    
                    // Send button
                    Rectangle {
                        id: sendButton
                        width: 32
                        height: 32
                        radius: 16
                        color: textInput.text.length > 0 ? "#00D9FF" : "#2A2A2A"
                        
                        // FIXED: Removed duplicate scale property
                        property real buttonScale: 1.0
                        scale: buttonScale
                        
                        Behavior on color {
                            ColorAnimation { duration: 200 }
                        }
                        
                        Text {
                            anchors.centerIn: parent
                            text: "⏎"
                            font.pixelSize: 16
                            color: textInput.text.length > 0 ? "#0A0A0F" : "#808080"
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            enabled: textInput.text.length > 0
                            
                            onPressed: sendButton.buttonScale = 0.9
                            onReleased: sendButton.buttonScale = 1.0
                            onClicked: {
                                sendMessage()
                            }
                        }
                        
                        Behavior on buttonScale {
                            NumberAnimation { duration: 100 }
                        }
                    }
                }
            }
        }
    }
    
    // Chat history sidebar (overlay)
    Loader {
        id: historySidebarLoader
        anchors.fill: parent
        active: root.showHistory
        sourceComponent: historySidebarComponent
        
        // Slide animation
        Behavior on opacity {
            NumberAnimation { duration: 300 }
        }
        
        opacity: root.showHistory ? 1.0 : 0.0
    }
    
    Component {
        id: historySidebarComponent
        
        ChatHistoryList {
            onChatSelected: function(chatId) {
                console.log("Selected chat:", chatId)
                root.showHistory = false
            }
            
            onChatDeleted: function(chatId) {
                console.log("Deleted chat:", chatId)
            }
            
            onCloseRequested: {
                root.showHistory = false
            }
        }
    }
    
    // Timer to simulate voice input completion
    Timer {
        id: voiceInputTimer
        interval: 3000
        repeat: false
        
        onTriggered: {
            root.isListening = false
            
            // Simulate recognized speech
            var mockPhrases = [
                "What's the weather today?",
                "Navigate to the nearest coffee shop",
                "Play some relaxing music",
                "Set cabin temperature to 68 degrees",
                "How far can I drive with current battery?"
            ]
            
            var randomPhrase = mockPhrases[Math.floor(Math.random() * mockPhrases.length)]
            textInput.text = randomPhrase
            sendMessage()
        }
    }
    
    // Timer to simulate AI response
    Timer {
        id: aiResponseTimer
        interval: 1500
        repeat: false
        
        property string userMessage: ""
        
        onTriggered: {
            thinkingIndicator.visible = false
            
            // Generate mock AI response
            var response = generateMockResponse(userMessage)
            
            chatMessagesModel.append({
                isUser: false,
                message: response,
                timestamp: getCurrentTime()
            })
        }
    }
    
    // Helper functions
    function sendMessage() {
        if (textInput.text.trim().length === 0) return
        
        var message = textInput.text.trim()
        
        // Add user message to chat
        chatMessagesModel.append({
            isUser: true,
            message: message,
            timestamp: getCurrentTime()
        })
        
        root.messageSubmitted(message)
        
        // Clear input
        textInput.text = ""
        
        // Show thinking indicator
        thinkingIndicator.visible = true
        
        // Simulate AI response
        aiResponseTimer.userMessage = message
        aiResponseTimer.start()
    }
    
    function getCurrentTime() {
        var now = new Date()
        var hours = now.getHours()
        var minutes = now.getMinutes()
        var ampm = hours >= 12 ? 'PM' : 'AM'
        hours = hours % 12
        hours = hours ? hours : 12
        minutes = minutes < 10 ? '0' + minutes : minutes
        return hours + ':' + minutes + ' ' + ampm
    }
    
    function generateMockResponse(userMessage) {
        var lowerMessage = userMessage.toLowerCase()
        
        if (lowerMessage.includes("weather")) {
            return "The current temperature is 72°F with clear skies. Perfect driving conditions!"
        } else if (lowerMessage.includes("navigate") || lowerMessage.includes("directions")) {
            return "I've found the nearest location. Starting navigation now. ETA is 15 minutes."
        } else if (lowerMessage.includes("music") || lowerMessage.includes("play")) {
            return "Playing your favorite playlist. Enjoy the music!"
        } else if (lowerMessage.includes("temperature") || lowerMessage.includes("climate")) {
            return "I've adjusted the cabin temperature to your requested setting. It should reach that temperature in about 2 minutes."
        } else if (lowerMessage.includes("battery") || lowerMessage.includes("range") || lowerMessage.includes("drive")) {
            return "With your current battery level at 85%, you can drive approximately 61 kilometers at highway speeds."
        } else if (lowerMessage.includes("hello") || lowerMessage.includes("hi")) {
            return "Hello! How can I assist you with your drive today?"
        } else {
            return "I understand. Let me help you with that. Is there anything specific you'd like me to do?"
        }
    }
}
