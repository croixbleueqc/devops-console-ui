import QtQuick 2.12
import QtQuick.Controls 2.12

import "../../backend/sccs" as Backend

import "../common"

//import "../../backend/core"

Item {
    id: root

    height: suggestions.height

    property string currentText: suggestions.selected !== null ? suggestions.selected.name : ""

    Backend.Repositories {
        id: repos
    }

    Suggestion {
        id: suggestions

        width: root.width

        filterRoleName: "name"
        maxVisibleSuggestions: 4
        showAdd: false
        suggestionToText: (suggestion) => suggestion.name

        json: repos.dataResponse

        loading: repos.processing
    }
}
