DevOps Console Frontend (Experimental)
======================================

The DevOps Console Frontend is an experimental project based on Qt 5.

The main target for now is WebAssembly and Desktop (Mobile applications will follow)


Build
-----

WebAssembly
^^^^^^^^^^^

.. code:: bash

   # TODO: rework to have a runtime configuration support
   # You need to configure the backend url with BACKEND build argument
   docker build --build-arg BACKEND="wss://..." -t devops-console-ui -f docker/Dockerfile.wasm .

Run it
------

WebAssembly
^^^^^^^^^^^

.. code:: bash

   # Prerequisite: You need to run the DevOps Console Backend or you will be offline

   docker run -it --rm -p 8080:80 devops-console-ui:latest
   # open your browser to http://localhost:8080

Experimental
------------

OAuth2
^^^^^^

OAuth2 is supported on the Desktop version. It is disabled for now as few todos need to be done before. Take a look on main.cpp and auth.cpp for more details.

Store
^^^^^

Store will be able to have caching, real time data update, network capabilities (provided with component embedded in StoreLoader) to manage data... it will be the main piece to fetch and share data accross UI components. It uses native Qt binding (see Search.qml as an example)
