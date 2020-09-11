DevOps Console Frontend (Experimental)
======================================

The DevOps Console Frontend is an experimental project based on Qt 5.

The main target for now is WebAssembly, Desktop and Android (proof of concept). Other targets will follow.


Build
-----

Prerequisite
^^^^^^^^^^^^

.. code:: bash

   # update/init submodules if necessary
   git submodule update --init --recursive

WebAssembly
^^^^^^^^^^^

.. code:: bash

   # TODO: rework to have a runtime configuration support
   # You need to configure the backend url with BACKEND build argument
   docker build --build-arg BACKEND="wss://..." -t devops-console-ui -f docker/Dockerfile.wasm .

Android
^^^^^^^

.. code:: bash

   # This is a proof of concept. The build process is not optimal and need to be improved (aab, distributioon, signing, ...)
   # Prerequiste: You need to build qt5-android-builder first. Please look at https://github.com/croixbleueqc/qt5-android-builder

   docker build --build-arg BACKEND="wss://..." -t devops-console-android -f docker/Dockerfile.android .

   # Alternative (local build)
   
   mkdir ../devops_ANDROID_BUILD
   docker run -it --rm -v $(pwd):/usr/src/app/devops -v $(pwd)/../devops_ANDROID_BUILD:/usr/src/app/devops_BUILD qt5-android-builder:latest /bin/bash
   cd devops_BUILD
   qmake ../devops/
   make -j$(nproc) apk

Run it
------

WebAssembly
^^^^^^^^^^^

.. code:: bash

   # Prerequisite: You need to run the DevOps Console Backend or you will be offline

   docker run -it --rm -p 8080:80 devops-console-ui:latest
   # open your browser to http://localhost:8080

Android
^^^^^^^

.. code:: bash

   # This is a proof of concept.

   docker run -it --rm -p 8080:80 devops-console-android:latest
   # open your browser to http://localhost:8080
   # download and install the apk

   # Alternative (local build)
   cd ../devops_ANDROID_BUILD/android-build/
   # install the apk

Experimental
------------

OAuth2
^^^^^^

OAuth2 is supported on the Desktop version. It is disabled for now as few todos need to be done before. Take a look on main.cpp and auth.cpp for more details.

Store
^^^^^

Store will be able to have caching, real time data update, network capabilities (provided with component embedded in StoreLoader) to manage data... it will be the main piece to fetch and share data accross UI components. It uses native Qt binding (see Search.qml as an example)
