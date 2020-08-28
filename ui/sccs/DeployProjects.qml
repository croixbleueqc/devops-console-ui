import QtQuick 2.12
import QtQuick.Controls 2.12

import "../../backend/core"

Item {
    id: root

    property var projectIndex

    width: scroll.width

    DeployByEnvironment {
         id: dev;

         envName: "master"
         title: "Dev"

         repositories: Store.sccs_project_settings.projectObj.projects[projectIndex].repositories;

         anchors.right: qa.left;
         width: (scroll.width * 0.8) / 5;
         anchors.margins: scroll.width * 0.05
    }

    DeployTo {
        anchors.top: root.top;
        anchors.left: dev.right;
        anchors.right: qa.left;
        anchors.topMargin: 100;
    }

    DeployByEnvironment {
         id: qa;

         envName: "qa"
         title: "Qa"

         repositories: Store.sccs_project_settings.projectObj.projects[projectIndex].repositories;

         anchors.right: accept.left;
         width: (scroll.width * 0.8) / 5;
         anchors.margins: scroll.width * 0.05
    }

    DeployTo {
        anchors.top: root.top;
        anchors.left: qa.right;
        anchors.right: accept.left;
        anchors.topMargin: 100;
    }

    DeployByEnvironment {
         id: accept;

         envName: "acceptation"
         title: "Accept"

         repositories: Store.sccs_project_settings.projectObj.projects[projectIndex].repositories;

         anchors.horizontalCenter: root.horizontalCenter;
         width: (scroll.width * 0.8) / 5;
         anchors.margins: scroll.width * 0.05
    }

    DeployTo {
        anchors.top: root.top;
        anchors.left: accept.right;
        anchors.right: formation.left;
        anchors.topMargin: 100;
    }

    DeployByEnvironment {
         id: formation;

         envName: "training"
         title: "Formation"

         repositories: Store.sccs_project_settings.projectObj.projects[projectIndex].repositories;

         anchors.left: accept.right;
         width: (scroll.width * 0.8) / 5;
         anchors.margins: scroll.width * 0.05
    }

    DeployTo {
        anchors.top: root.top;
        anchors.left: formation.right;
        anchors.right: production.left;
        anchors.topMargin: 100;
    }

    DeployByEnvironment {
         id: production;

         envName: "production"
         title: "Production"

         repositories: Store.sccs_project_settings.projectObj.projects[projectIndex].repositories;

         anchors.left: formation.right;
         width: (scroll.width * 0.8) / 5;
         anchors.margins: scroll.width * 0.05
    }
}

