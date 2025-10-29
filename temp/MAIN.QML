/*
═══════════════════════════════════════════════════════════════
FILE: qml/main.qml
PHASE: Phase 9 - Integrate CarCameraWorkspace Component
LOCATION: infotainment-os-v15/qml/main.qml
═══════════════════════════════════════════════════════════════
*/

import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import infotainment

ApplicationWindow {
    id: mainWindow
    width: 1024
    height: 600
    visible: true
    title: "Infotainment OS v15"

    Material.theme: Material.Dark
    Material.accent: Material.Teal

    color: "#0A0A0F"

    // State management for General Display Box and Main Workspace
    // Modes for General Display Box: "climate", "ai", "audio", "clock", "bluetooth"
    // Modes for Main Workspace: "map", "car", "climate_workspace", "settings", "sos"
    property string currentDisplayMode: "climate"  // For left panel
    property string currentWorkspaceMode: "map"   // For main central area

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // Left Panel
        Rectangle {
            id: leftPanel
            Layout.preferredWidth: 350
            Layout.fillHeight: true
            color: "#0A0A0F"
            border.color: "#1A1A1A"
            border.width: 1

            Column {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 15

                // Music Player Component
                MusicPlayer {
                    id: musicPlayerComponent
                    Layout.preferredWidth: parent.width - 20
                    Layout.preferredHeight: 140
                }

                // General Display Box - Switches between Climate/AI/Audio/Clock/Bluetooth
                Item {
                    id: generalDisplayBox
                    width: parent.width - 20
                    height: 380

                    // Climate Control (default)
                    ClimateControl {
                        id: climateControlComponent
                        anchors.fill: parent
                        visible: mainWindow.currentDisplayMode === "climate"

                        // Fade in/out animation
                        opacity: visible ? 1.0 : 0.0
                        Behavior on opacity {
                            NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
                        }
                    }

                    // AI Window
                    AIWindow {
                        id: aiWindowComponent
                        anchors.fill: parent
                        visible: mainWindow.currentDisplayMode === "ai"

                        // Fade in/out animation
                        opacity: visible ? 1.0 : 0.0
                        Behavior on opacity {
                            NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
                        }

                        // Handle close button - return to climate control
                        onCloseRequested: {
                            mainWindow.currentDisplayMode = "climate"
                        }

                        onMessageSubmitted: function(message) {
                            console.log("AI Message:", message)
                        }
                    }

                    // Audio Window
                    AudioWindow {
                        id: audioWindowComponent
                        anchors.fill: parent
                        visible: mainWindow.currentDisplayMode === "audio"

                        // Fade in/out animation
                        opacity: visible ? 1.0 : 0.0
                        Behavior on opacity {
                            NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
                        }

                        // Handle close button - return to climate control
                        onCloseClicked: {
                            mainWindow.currentDisplayMode = "climate"
                        }

                        onVolumeChanged: function(value) {
                            console.log("Volume changed:", value)
                        }

                        onReverbChanged: function(value) {
                            console.log("Reverb changed:", value)
                        }

                        onPitchChanged: function(value) {
                            console.log("Pitch changed:", value)
                        }

                        onSpeedChanged: function(value) {
                            console.log("Speed changed:", value)
                        }

                        onEqChanged: function(value) {
                            console.log("EQ changed:", value)
                        }
                    }

                    // Clock Window
                    ClockWindow {
                        id: clockWindowComponent
                        anchors.fill: parent
                        visible: mainWindow.currentDisplayMode === "clock"

                        // Fade in/out animation
                        opacity: visible ? 1.0 : 0.0
                        Behavior on opacity {
                            NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
                        }

                        // Handle close button - return to climate control
                        onCloseClicked: {
                            mainWindow.currentDisplayMode = "climate"
                        }
                    }

                    // Bluetooth Window
                    BluetoothWindow {
                        id: bluetoothWindowComponent
                        anchors.fill: parent
                        visible: mainWindow.currentDisplayMode === "bluetooth"

                        // Fade in/out animation
                        opacity: visible ? 1.0 : 0.0
                        Behavior on opacity {
                            NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
                        }

                        // Handle close button - return to climate control
                        onCloseClicked: {
                            mainWindow.currentDisplayMode = "climate"
                        }
                    }
                }

                // Misc Controls - Now connected to switching logic
                MiscControls {
                    id: miscControlsComponent
                    width: parent.width - 20
                    height: 80

                    // Connect button clicks to mode switching for General Display Box
                    onAiButtonClicked: {
                        // Toggle AI mode
                        if (mainWindow.currentDisplayMode === "ai") {
                            mainWindow.currentDisplayMode = "climate"
                        } else {
                            mainWindow.currentDisplayMode = "ai"
                        }
                    }

                    onSpeakerButtonClicked: {
                        if (mainWindow.currentDisplayMode === "audio") {
                            mainWindow.currentDisplayMode = "climate"
                        } else {
                            mainWindow.currentDisplayMode = "audio"
                        }
                    }

                    onClockButtonClicked: {
                        if (mainWindow.currentDisplayMode === "clock") {
                            mainWindow.currentDisplayMode = "climate"
                        } else {
                            mainWindow.currentDisplayMode = "clock"
                        }
                    }

                    onBluetoothButtonClicked: {
                        if (mainWindow.currentDisplayMode === "bluetooth") {
                            mainWindow.currentDisplayMode = "climate"
                        } else {
                            mainWindow.currentDisplayMode = "bluetooth"
                        }
                    }
                }
            }
        }

        // Column for main content area
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            // Status Bar
            Rectangle {
                id: statusBar
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                color: "#0A0A0F"
                border.color: "#1A1A1A"
                border.width: 1

                Row {
                    anchors.fill: parent
                    spacing: 10

                    // Left side: Status icons
                    Row {
                        anchors.verticalCenter: parent.verticalCenter
                        x: 10
                        spacing: 15

                        // Battery icon
                        Rectangle {
                            width: 20
                            height: 12
                            border.color: "white"
                            border.width: 1
                            color: "transparent"
                            anchors.verticalCenter: parent.verticalCenter

                            Rectangle {
                                x: width - 2
                                width: 2
                                height: 6
                                anchors.verticalCenter: parent.verticalCenter
                                color: "white"
                            }

                            // Battery level inside the battery
                            Rectangle {
                                x: 2
                                y: 2
                                width: 14 * 0.8  // 80% battery
                                height: 8
                                color: "white"
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        // Signal strength
                        Item {
                            width: 20
                            height: 12
                            anchors.verticalCenter: parent.verticalCenter

                            Repeater {
                                model: 4
                                Rectangle {
                                    x: index * 4
                                    width: 2
                                    height: index * 2 + 2
                                    color: "white"
                                    y: 12 - height
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                        }

                        Text {
                            text: "BT"
                            color: "white"
                            font.pixelSize: 10
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            text: "WiFi"
                            color: "white"
                            font.pixelSize: 10
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    // Center: Time and date
                    Text {
                        id: timeDateText
                        text: "10:00 AM - 20/5/2025"
                        color: "white"
                        anchors.centerIn: parent
                        font.pixelSize: 14
                        horizontalAlignment: Text.AlignHCenter
                    }

                    // Right side: Range indicator
                    Text {
                        text: "72 km"
                        color: "#00D9FF"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: 20
                        font.pixelSize: 14
                        font.bold: true
                    }
                }
            }

            // Row for main content area (main content + right sidebar)
            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 0

                // Main Content Area - This is where workspaces are shown
                Item {
                    id: mainContentArea
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    // Default Map View (shown when currentWorkspaceMode is "map")
                    Rectangle {
                        id: mapViewPlaceholder
                        anchors.fill: parent
                        color: "#121212"
                        border.color: "#1A1A1A"
                        border.width: 1
                        visible: mainWindow.currentWorkspaceMode === "map"

                        // Simple map grid pattern as a placeholder
                        Item {
                            anchors.fill: parent

                            Repeater {
                                model: 20
                                Rectangle {
                                    x: 0
                                    y: index * 30
                                    width: parent.width
                                    height: 1
                                    color: "#1A1A1A"  // Darker grid lines
                                }
                            }

                            Repeater {
                                model: 34
                                Rectangle {
                                    x: index * 30
                                    y: 0
                                    width: 1
                                    height: parent.height
                                    color: "#1A1A1A"  // Darker grid lines
                                }
                            }

                            // Center arrow indicator (like in the reference image)
                            Canvas {
                                id: arrowCanvas
                                anchors.centerIn: parent
                                width: 100
                                height: 100

                                onPaint: {
                                    var ctx = getContext("2d");
                                    ctx.reset();

                                    // Draw a simple arrow pointing up (like in the reference image)
                                    ctx.fillStyle = "cyan";
                                    ctx.beginPath();

                                    // Arrow shape
                                    ctx.moveTo(width/2, 10);  // Top point
                                    ctx.lineTo(width/2 - 15, 35);  // Left bottom of arrowhead
                                    ctx.lineTo(width/2 - 10, 35);  // Left top of shaft
                                    ctx.lineTo(width/2 - 10, 80);  // Bottom left of shaft
                                    ctx.lineTo(width/2 + 10, 80);  // Bottom right of shaft
                                    ctx.lineTo(width/2 + 10, 35);  // Right top of shaft
                                    ctx.lineTo(width/2 + 15, 35);  // Right bottom of arrowhead
                                    ctx.closePath();
                                    ctx.fill();
                                }

                                // Redraw when needed
                                Component.onCompleted: requestPaint();
                            }
                        }
                    }

                    // Car Camera Workspace View (REPLACES Car Health/Status View)
                    CarCameraWorkspace {
                        id: carCameraWorkspace
                        anchors.fill: parent
                        visible: mainWindow.currentWorkspaceMode === "car"  // Show when currentWorkspaceMode is "car"

                        // Handle close button - return to map view
                        onCloseClicked: {
                            console.log("Car Camera Workspace Close Clicked");
                            mainWindow.currentWorkspaceMode = "map";
                        }
                    }

                    // Climate Control View (duplicate of left panel for demo)
                    WeatherWorkspace {
                        id: weatherWorkspaceView
                        anchors.fill: parent
                        visible: mainWindow.currentWorkspaceMode === "climate_workspace"

                        onCloseClicked: {
                            mainWindow.currentWorkspaceMode = "map";
                        }
                    }

                    // Safety & Driving Assistance Workspace (REPLACES Settings)
                    SafetyWorkspace {
                        id: safetyWorkspaceComponent
                        anchors.fill: parent
                        visible: mainWindow.currentWorkspaceMode === "settings" // Ensure this line exists and is correct

                        // Handle close button - return to map view
                        onCloseClicked: {
                            console.log("Safety Workspace Close Clicked");
                            mainWindow.currentWorkspaceMode = "map";
                        }
                    }

                    // SOS Emergency View
                    Rectangle {
                        id: sosViewPlaceholder
                        anchors.fill: parent
                        color: "red" // High contrast for emergency
                        visible: mainWindow.currentWorkspaceMode === "sos"

                        // Full-screen emergency takeover interface simulation
                        Column {
                            anchors.centerIn: parent
                            spacing: 20
                            Text {
                                text: "SOS EMERGENCY"
                                font.pixelSize: 48
                                font.bold: true
                                color: "white"
                                horizontalAlignment: Text.AlignHCenter
                            }
                            Text {
                                text: "Help is on the way..."
                                font.pixelSize: 24
                                color: "white"
                                horizontalAlignment: Text.AlignHCenter
                            }
                            Text {
                                text: "Countdown: 10s"
                                font.pixelSize: 20
                                color: "yellow"
                                horizontalAlignment: Text.AlignHCenter
                            }
                        }
                    }
                }

                // Right Sidebar (Navigation Icons)
                Rectangle {
                    id: rightSidebar
                    Layout.preferredWidth: 60
                    Layout.fillHeight: true
                    color: "#0A0A0F"  // Dark background matching reference
                    border.color: "#1A1A1A"
                    border.width: 1

                    Column {
                        anchors.centerIn: parent
                        spacing: 20

                        // Map Icon (default on boot) - reserved space for SVG
                        Item {
                            width: 40
                            height: 40

                            Text {
                                text: "MAP"
                                anchors.centerIn: parent
                                font.pixelSize: 10
                                color: "white"
                            }

                            // MouseArea for interaction
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor

                                onPressed: parent.scale = 0.9
                                onReleased: parent.scale = 1.0
                                onClicked: {
                                    console.log("Map Icon Clicked");
                                    mainWindow.currentWorkspaceMode = "map";
                                }
                            }

                            Behavior on scale {
                                NumberAnimation { duration: 100; easing.type: Easing.InOutCubic }
                            }
                        }

                        // Car Icon (car health/status) - reserved space for SVG
                        Item {
                            width: 40
                            height: 40

                            Text {
                                text: "CAR"
                                anchors.centerIn: parent
                                font.pixelSize: 10
                                color: "white"
                            }

                            // MouseArea for interaction - This now shows the CarCameraWorkspace
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor

                                onPressed: parent.scale = 0.9
                                onReleased: parent.scale = 1.0
                                onClicked: {
                                    console.log("Car Icon Clicked - Showing Car Camera Workspace");
                                    // Key Change: Show CarCameraWorkspace when Car icon is clicked
                                    mainWindow.currentWorkspaceMode = "car";
                                }
                            }

                            Behavior on scale {
                                NumberAnimation { duration: 100; easing.type: Easing.InOutCubic }
                            }
                        }

                        // Mountain Icon (climate workspace) - reserved space for SVG
                        Item {
                            width: 40
                            height: 40

                            Text {
                                text: "CLM"
                                anchors.centerIn: parent
                                font.pixelSize: 10
                                color: "white"
                            }

                            // MouseArea for interaction
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor

                                onPressed: parent.scale = 0.9
                                onReleased: parent.scale = 1.0
                                onClicked: {
                                    console.log("Climate Icon Clicked");
                                    mainWindow.currentWorkspaceMode = "climate_workspace";
                                }
                            }

                            Behavior on scale {
                                NumberAnimation { duration: 100; easing.type: Easing.InOutCubic }
                            }
                        }

                        // Settings Gear Icon (NOW SHOWS SAFETY WORKSPACE) - reserved space for SVG
                        Item {
                            width: 40
                            height: 40

                            Text {
                                text: "SET"
                                anchors.centerIn: parent
                                font.pixelSize: 10
                                color: "white"
                            }

                            // MouseArea for interaction - This triggers the Safety Workspace
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor

                                onPressed: parent.scale = 0.9
                                onReleased: parent.scale = 1.0
                                onClicked: {
                                    console.log("Settings Icon Clicked - Showing Safety Workspace");
                                    // Key Change: Show Safety Workspace when Settings icon is clicked
                                    mainWindow.currentWorkspaceMode = "settings"; // This line should already be correct
                                }
                            }

                            Behavior on scale {
                                NumberAnimation { duration: 100; easing.type: Easing.InOutCubic }
                            }
                        }

                        // SOS Emergency Button - reserved space for SVG
                        Item {
                            width: 40
                            height: 40

                            Text {
                                text: "SOS"
                                anchors.centerIn: parent
                                font.pixelSize: 10
                               color: "red"
                                font.bold: true
                            }

                            // MouseArea for interaction
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor

                                onPressed: parent.scale = 0.9
                                onReleased: parent.scale = 1.0
                                onClicked: {
                                    console.log("SOS Icon Clicked");
                                    mainWindow.currentWorkspaceMode = "sos";
                                }
                            }

                            Behavior on scale {
                                NumberAnimation { duration: 100; easing.type: Easing.InOutCubic }
                            }
                        }
                    }
                }
            }
        }
    }
}

/*
═══════════════════════════════════════════════════════════════
END OF FILE: qml/main.qml
═══════════════════════════════════════════════════════════════
*/
