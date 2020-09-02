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
         envNameToDeploy: "qa"
         title: "Dev"

         repositories: Store.sccs_project_settings.projectObj.projects[projectIndex].repositories;

         anchors.right: qa.left;
         width: (scroll.width * 0.8) / 5;
         anchors.margins: scroll.width * 0.05
    }

    DeployByEnvironment {
         id: qa;

         envName: "qa"
         envNameToDeploy: "acceptation"
         title: "Qa"

         repositories: Store.sccs_project_settings.projectObj.projects[projectIndex].repositories;

         anchors.right: accept.left;
         width: (scroll.width * 0.8) / 5;
         anchors.margins: scroll.width * 0.05
    }

    DeployByEnvironment {
         id: accept;

         envName: "acceptation"
         envNameToDeploy: "training"
         title: "Accept"

         repositories: Store.sccs_project_settings.projectObj.projects[projectIndex].repositories;

         anchors.horizontalCenter: root.horizontalCenter;
         width: (scroll.width * 0.8) / 5;
         anchors.margins: scroll.width * 0.05
    }

    DeployByEnvironment {
         id: formation;

         envName: "training"
         envNameToDeploy: "production"
         title: "Formation"

         repositories: Store.sccs_project_settings.projectObj.projects[projectIndex].repositories;

         anchors.left: accept.right;
         width: (scroll.width * 0.8) / 5;
         anchors.margins: scroll.width * 0.05
    }

    DeployByEnvironment {
         id: production;

         envName: "production"
         envNameToDeploy: "none"
         title: "Production"

         repositories: Store.sccs_project_settings.projectObj.projects[projectIndex].repositories;

         anchors.left: formation.right;
         width: (scroll.width * 0.8) / 5;
         anchors.margins: scroll.width * 0.05
    }
}

