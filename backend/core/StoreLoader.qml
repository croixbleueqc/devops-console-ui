import QtQuick 2.12

//TODO: Make "used" variable thread safe. Target is WebAssembly without Threading so this is not a concern for now

Loader {
    active: false

    property string sourceAlt: ""
    property var parametersAlt: null

    property int used: 0

    function use() {
        var firstUse = (++used === 1)

        if(firstUse) {
            setSource(sourceAlt, parametersAlt)
            active = true
        }

        return this
    }

    function unuse() {
        if(used === 0) {
            return
        }

        if(--used === 0) {
            active = false
            setSource("")
        }
    }
}
