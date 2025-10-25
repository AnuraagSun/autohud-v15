/*
═══════════════════════════════════════════════════════════════
FILE: src/main.cpp
PHASE: Phase 5 - Complete UI Implementation with Correct Imports
LOCATION: infotainment-os-v15/src/main.cpp
═══════════════════════════════════════════════════════════════
*/

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include <QIcon>
#include <QDebug>

int main(int argc, char *argv[])
{
    // Enable high DPI scaling
    QGuiApplication::setHighDpiScaleFactorRoundingPolicy(Qt::HighDpiScaleFactorRoundingPolicy::PassThrough);
    
    QGuiApplication app(argc, argv);

    // Set application properties
    app.setApplicationName("infotainment-os-v15");
    app.setApplicationVersion("1.0.0");
    app.setOrganizationName("EmbeddedSystems");
    
    // Set the default style to material for modern look
    QQuickStyle::setStyle("Material");

    QQmlApplicationEngine engine;

    // Add import path for custom components - this matches the RESOURCE_PREFIX from CMake
    engine.addImportPath("qrc:/qt/qml");

    // Load the main.qml file - this path matches the RESOURCE_PREFIX and module structure
    const QUrl url(u"qrc:/qt/qml/infotainment/qml/main.qml"_s);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);

    if (engine.rootObjects().isEmpty()) {
        return -1;
    }

    return app.exec();
}

/*
═══════════════════════════════════════════════════════════════
END OF FILE: src/main.cpp
# ════════════════════════════════════════════════════════════════
*/
