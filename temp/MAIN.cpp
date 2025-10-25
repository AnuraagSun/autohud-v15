/*
═══════════════════════════════════════════════════════════════
FILE: src/main.cpp
FIXED: C++17 compatible string literals
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
    QGuiApplication::setHighDpiScaleFactorRoundingPolicy(
        Qt::HighDpiScaleFactorRoundingPolicy::PassThrough
    );
    
    QGuiApplication app(argc, argv);

    // Set application properties
    app.setApplicationName("infotainment-os-v15");
    app.setApplicationVersion("1.0.0");
    app.setOrganizationName("EmbeddedSystems");
    
    // Set the default style to material for modern look
    QQuickStyle::setStyle("Material");

    QQmlApplicationEngine engine;

    // Add import path for custom components
    engine.addImportPath("qrc:/qt/qml");

    // Load the main.qml file - FIXED: Use QStringLiteral for C++17 compatibility
    const QUrl url(QStringLiteral("qrc:/qt/qml/infotainment/qml/main.qml"));
    
    QObject::connect(
        &engine, 
        &QQmlApplicationEngine::objectCreationFailed,
        &app, 
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection
    );
    
    engine.load(url);

    if (engine.rootObjects().isEmpty()) {
        qWarning() << "Failed to load QML file";
        return -1;
    }

    return app.exec();
}

/*
═══════════════════════════════════════════════════════════════
END OF FILE: src/main.cpp
═══════════════════════════════════════════════════════════════
*/
