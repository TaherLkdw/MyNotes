cmake_minimum_required(VERSION 3.16)

project(MyNotes VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Felgo REQUIRED)

# Project identifier and version
# More information: https://felgo.com/doc/felgo-publishing/#project-configuration
set(PRODUCT_IDENTIFIER "com.lkdw.application.MyNotes")
set(PRODUCT_VERSION_NAME "1.0.0")
set(PRODUCT_VERSION_CODE 1)

# Set either "test" or "publish" stage:
set(PRODUCT_STAGE "publish")

# Optionally set a license key that is used instead of the license key from
# main.qml file (App::licenseKey for your app or GameWindow::licenseKey for your game)
# Only used for local builds and Felgo Cloud Builds (https://felgo.com/cloud-builds)
# Not used if using Felgo Live
set(PRODUCT_LICENSE_KEY "2AE5C76740FEA334306FCC403665578909970023E8F80A83CE94BC56492FAD169FE92A966F4C61B75580B14F1412D611860CA682C37595E02285EC308637B4E3D6422641173720933F27E2E286166B77FF8ED11AA3D7506892FE7CDB5D2D10AA6B91425F7F2F65F7930F631235E094A435167BFF7E740330712DBAA90D7E934B3CC966170EAB3D5D5769746CD8C2D278496B66D2DBE6086FFC81E01DFFCF6FA5FC09DF41475521F83E2956BF31ED0EC6B29EA2BA59A871866BF8D4EAB5995CFD8AB33964AF46935E523B53A7873B4741E592952D798B11996AF38AA0E32EBCC8289AAEC87AB5A257D4499FB0AAF3C1D0768109B3AA838DDBC599C4495AE6E2E6378B146D23C35720B535C26F60650C190F0444F2E23CBC9446D93A5D5F7829719CDFBAB640CC97AAE66AB4A1B7C3201D")

set(FELGO_PLUGINS
)

# Find all QML/JS files for the QML compiler:
file(GLOB_RECURSE QmlFiles RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} qml/*.qml qml/*.js)

# Find all non-QML/JS files in the qml and assets folder to add as resources:
file(GLOB_RECURSE AssetsFiles RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} assets/* qml/*)
list(REMOVE_ITEM AssetsFiles ${QmlFiles})

qt_add_executable(appMyNotes
    main.cpp
    ${QmlFiles}
    ${AssetsFiles}
)

felgo_configure_executable(appMyNotes)

# Deploy resources to build folder/package directly
# comment for publishing
#deploy_resources("${QmlFiles};${AssetsFiles}")

# Add QML files and resources to QML module to included them via QRC automatically:
qt_add_qml_module(appMyNotes
    URI MyNotes
    VERSION 1.0
# uncomment for publishing:
    QML_FILES ${QmlFiles}
    RESOURCES ${AssetsFiles}
    NO_RESOURCE_TARGET_PATH
)

# NOTE: for PUBLISHING, perform the following steps:
# 1. comment the deploy_resources line above, to avoid shipping your qml files with the application (instead they get compiled to the app binary)
# 2. uncomment the QML_FILES and RESOURCES above; this compiles your qml files and js files to the app binary and protects your source code
# 3. change the setMainQmlFile() call in main.cpp to the one starting with "qrc:/" - this loads the qml files from the resources
# for more details see the "Deployment Guides" in the Felgo Documentation

# during development, use the deploy_resources because you then get shorter compilation times (the qml files do not need to be compiled to the binary but are just copied)
# also, for quickest deployment on Desktop disable the "Shadow Build" option in Projects/Builds - you can then select "Run Without Deployment" from the Build menu in Qt Creator if you only changed QML files; this speeds up application start, because your app is not copied & re-compiled but just re-interpreted

target_compile_definitions(appMyNotes
    PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)

target_link_libraries(appMyNotes PRIVATE Felgo)

# uncomment this line to add the Live Client Module and use live reloading with your custom C++ code
# for the remaining steps to build a custom Live Code Reload app see here: https://felgo.com/custom-code-reload-app/
#find_package(FelgoLive REQUIRED)
#target_link_libraries(appMyNotes PRIVATE FelgoLive)
