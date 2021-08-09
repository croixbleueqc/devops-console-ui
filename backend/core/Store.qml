pragma Singleton

import QtQuick 2.12
import "../sccs" as Sccs
import "../projects" as Projects

Item {
    id: root

    // default user
    property string user: qsTr("Guest")

    // default routes
    property var defaultRoutes: [
        {
            name: qsTr("Repositories Centric"),
            page: "../pages/SccsPage.qml",
            icon: {
                name: "code-class",
                source: "qrc:/icons/actions/code-class.svg"
            }
        },
        {
            name: qsTr("Continuous Deployment by Project"),
            page: "../pages/ContinuousDeploymentByProjectPage.qml",
            icon: {
                name: "cloud-upload",
                source: "qrc:/icons/actions/cloud-upload.svg"
            }
        },
        {
            name: qsTr("Compliance Report"),
            page: "../pages/CompliancePage.qml",
            icon: {
                name: "security-medium-symbolic",
                source: "qrc:/icons/status/symbolic/security-medium-symbolic.svg"
            }
        }
//        ,{
//            name: "Experimental",
//            page: "../pages/ExperimentalPage.qml",
//            icon: {
//                name: "question",
//                source: "qrc:/icons/actions/question.svg"
//            }
//        }
    ]

    // default router
    property QtObject defaultRouter: null

    // languages supported
    property var languagesSupported: [
        qsTr("English"),
        qsTr("Français")
    ]

    // DevOps Sccs Plugin Settings
    property Sccs.PluginSettings sccs_plugin_settings: Sccs.PluginSettings {}

    // DevOps Project Settings
    property Projects.ProjectSettings projects_project_settings: Projects.ProjectSettings {}

    /* POC

      Attempt to load on demand some subset of data shareable between multiple components (like redux/js)

      */

    // POC: Dynamic Loader for Repositories list
    StoreLoader {
        id: repos

        sourceAlt: "../sccs/Repositories.qml"
        parametersAlt: {"autoSend": false}
    }
 // POC: Dynamic Loader for OAuth2
    StoreLoader {
        id: auth2

        sourceAlt: "../OAuth2/OAuth2Config.qml"
        parametersAlt: {"autoSend": false}
    }
    // POC: register/unregister functions to use Dynamic Loader feature
    function register(module) {
        console.log("register " + module)

        if (module === "repos") {
            return repos.use()
        } else if(module ==="OAuth2") {
            return auth2.use()
        }else{
            console.log(module + " not available !")
        }
    }

    function unregister(module) {
        console.log("unregister " + module)

        if (module === "repos") {
            repos.unuse()
        } else if(module ==="OAuth2"){
            return auth2.use()
        }else{
            console.log(module + " not available")
        }
    }
}
