import QtQuick 2.12
import QtQuick.Controls 2.12

import "../../backend/sccs"

Item {
    ReposComplianceReport {
        id: data
    }

    function create_report() {
        var report = ""

        if(data.dataResponse === null) {
            return qsTr("Report is not available!")
        }

        for(const repository of Object.keys(data.dataResponse)) {
            report += "<br><b>" + repository + "</b><br>"

            for(const divergence of data.dataResponse[repository].divergences) {
                report += divergence.rule + " (current: <i>" + divergence.current + "</i>, expected: <i>" + divergence.expected + "</i>)<br>"
            }
        }

        if(report === "") {
            return qsTr("All repositories are compliants!")
        }

        return report
    }

    ScrollView {
        anchors.fill: parent
        padding: 10

        Text {
            id: report

            text: data.processing ? qsTr("Loading...") : create_report()
        }
    }
}
