import QtQuick 2.12
import "../core"

WSNetworkAbstract {
    id: root

    property string repositoryName: ""
    property string branchName: ""
    property string commit: ""

    com: WSComOne

    request: "sccs:update:/repository/deploy"

    dataRequest: { "repository": repositoryName, "branch": branchName, "commit": commit }
}
