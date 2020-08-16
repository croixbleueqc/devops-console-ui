.pragma library

//NOT WORKING WITH WebAssembly

var BASE="http://localhost:8080"

function request(verb, endpoint, obj, cb, cb_err) {
    print('request: ' + verb + ' ' + BASE + (endpoint ? endpoint : ''))
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() {
        print('xhr: on ready state change: ' + xhr.readyState)
        if(xhr.readyState === XMLHttpRequest.DONE) {
            print(xhr.status);

            if(xhr.status >= 200 && xhr.status < 300) {
                if(cb) {
                    var res = JSON.parse(xhr.responseText.toString());
                    cb(res);
                }
            } else {
                if(cb_err) {
                    cb_err(xhr.statusText);
                }
            }
        }
    }

    xhr.ontimeout = () => {
        if (cb_err) {
            cb_err("timeout");
        }
    };

    xhr.open(verb, BASE + (endpoint?'/' + endpoint:''));
    xhr.setRequestHeader("Content-Type", "application/json");
    xhr.setRequestHeader("Accept", "application/json");
    var data = obj ? JSON.stringify(obj) : ''
    xhr.send(data)
}

function get(endpoint, cb, cb_err) {
    request('GET', endpoint, null, cb, cb_err)
}

function add(endpoint, entry, cb, cb_err) {
    request('POST', endpoint, entry, cb, cb_err)
}

function update(endpoint, entry, cb, cb_err) {
    request('PUT', endpoint, entry, cb, cb_err)
}

function remove(endpoint, cb, cb_err) {
    request('DELETE', endpoint, null, cb, cb_err)
}
