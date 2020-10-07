import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import "../kubernetes/kind/pod"
import "../../backend/kubernetes"

Item {
    property alias repositoryName: dataPods.repositoryName
    property alias environment: dataPods.environment

    ScrollView {
        id: scroll
        anchors.fill: parent
        clip: true
        padding: 10

        Column {
            width: scroll.availableWidth

            RowLayout {
                width: parent.width

                ColumnLayout {
                    Label {
                        Layout.alignment: Qt.AlignRight

                        text: qsTr("Namespace:")
                        font.bold: true
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight

                        text: qsTr("Cluster:")
                        font.bold: true
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight

                        text: qsTr("Permission:")
                        font.bold: true
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true

                    Label {
                        text: dataPods.dataResponseInfo.bridge ? dataPods.dataResponseInfo.bridge.namespace : ""
                    }

                    Label {
                        text: dataPods.dataResponseInfo.bridge ? dataPods.dataResponseInfo.bridge.cluster : ""
                    }

                    Label {
                        text: {
                            if(dataPods.dataResponseInfo.bridge === undefined){
                                return ""
                            }

                            return dataPods.dataResponseInfo.bridge.repository.write_access ? qsTr("write") : qsTr("read only")
                        }
                    }
                }

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    BusyIndicator {
                        anchors.centerIn: parent

                        width: 48
                        height: 48

                        visible: dataPods.processing
                        running: visible
                    }
                }
            }

            Label {
                text: qsTr("There is no pods available !")

                visible: !dataPods.processing && modelPods.count === 0

                width: parent.width
                topPadding: 10
                horizontalAlignment: Text.AlignHCenter
            }

            Repeater {
                width: parent.width
                model: ListModel {
                    id: modelPods
                }

                PodCompact {
                    width: parent.width

                    json: raw
                    showDelete: dataPods.dataResponseInfo.bridge.repository.write_access

                    repositoryName: root.repositoryName
                    environment: root.environment
                }
            }
        }
    }

    Pods {
        id: dataPods

        onAdded: modelPods.append({raw: value})
        onModified: modelPods.set(index, {raw: value})
        onDeleted: modelPods.remove(index)

        onErrorChanged: console.log(error)
    }
}
