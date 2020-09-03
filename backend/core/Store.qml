pragma Singleton

import QtQuick 2.12
import "../sccs" as Sccs

Item {
    id: root

    // default user
    property string user: qsTr("Guest")

    // default routes
    property var defaultRoutes: [
        {
            name: qsTr("Welcome"),
            page: "../pages/WelcomePage.qml"
        },
        {
            name: "Sccs / Deploy",
            page: "../pages/SccsDeployPage.qml"
        },
        {
            name: "Sccs Parameters",
            page: "../pages/SccsParametersPage.qml"
        },
        {
            name: "Project / Deploy",
            page: "../pages/ProjectDeployPage.qml"
        },
        {
            name: "Project Parameters",
            page: "../pages/ProjectParametersPage.qml"
        }
//        ,{
//            name: "Experimental",
//            page: "../pages/ExperimentalPage.qml"
//        }

    ]

    // default router
    property QtObject defaultRouter: null

    // DevOps Sccs Plugin Settings
    property Sccs.PluginSettings sccs_plugin_settings: Sccs.PluginSettings {}

    // DevOps Project Settings
    property Sccs.ProjectSettings sccs_project_settings: Sccs.ProjectSettings {}
    property var currentProject: [];

    /* POC

      Attempt to load on demand some subset of data shareable between multiple components (like redux/js)

      */

    // POC: Dynamic Loader for Repositories list
    StoreLoader {
        id: repos

        sourceAlt: "../sccs/Repositories.qml"
        parametersAlt: {"autoSend": false}
    }

    // POC: register/unregister functions to use Dynamic Loader feature
    function register(module) {
        console.log("register " + module)

        if (module === "repos") {
            return repos.use()
        } else {
            console.log(module + " not available !")
        }
    }

    function unregister(module) {
        console.log("unregister " + module)

        if (module === "repos") {
            repos.unuse()
        } else {
            console.log(module + " not available")
        }
    }
}
