#include "WASMAuth.h"

#include <QReadLocker>
#include <QWriteLocker>
#include <QReadWriteLock>

#include <emscripten.h>
#include <emscripten/bind.h>

#include <string>
#include <cstdlib>
#include <QDebug>
#include <stdio.h>

using namespace emscripten;

char * json_config_ptr = nullptr;
QString token= "";

void make_json(std::string currUrl)
{
        QReadLocker gard(&OAuth2Config::get().getLock());
        std::string json =
                std::string("{\"authority\": \"")+OAuth2Config::get().getIssuer().toString().toStdString()+"\","+
                        "\"client_id\": \""+OAuth2Config::get().getClientID().toStdString() +"\","+
                        "\"silent_redirect_uri\":\""+currUrl+"/silent-redirect.html\","+
                        "\"popup_redirect_uri\": \""+currUrl+"/popup-signin.html\","+
                        "\"response_type\": \"code\","+
                        "\"scope\": \""+OAuth2Config::get().getKScope().toStdString()+"\"}";
        if(json_config_ptr!= nullptr){
            free(json_config_ptr);
        }
        json_config_ptr = reinterpret_cast<char*>(std::malloc( json.size()+1));
        memmove(json_config_ptr,json.c_str(),json.size()+1);
}

extern "C"{
EMSCRIPTEN_KEEPALIVE
   char * get_config()
    {
        return json_config_ptr;
    };

EMSCRIPTEN_KEEPALIVE
    void set_token(char * str )
    {
        token = QString(str);
    };
}

EM_JS(int, getUser, (), {
          //There is probably a better way to do it ...
          return Asyncify.handleSleep(function (wakeUp) {
              function set_token(usr){
                  let jsToken = usr.access_token;
                  let lengthBytes = lengthBytesUTF8(jsToken)+1;
                  let stringOnWasmHeap = Module._malloc(lengthBytes);
                  stringToUTF8(jsToken, stringOnWasmHeap, lengthBytes);
                  Module._set_token(stringOnWasmHeap);
                  Module._free(stringOnWasmHeap);
              }
              var jsonConfig =UTF8ToString(Module._get_config());
              var mgr = new Oidc.UserManager(JSON.parse(jsonConfig));
              mgr.getUser().then(function (user_) {
                  if(user_ == null)
                  {
                      let session = {state: 'some data'};
                       mgr.signinPopup(session).then((user_a) =>
                      {
                          set_token(user_a);
                          wakeUp(user_a.expires_at);
                      }).catch(err =>
                      {
                          wakeUp(0);
                      });
                  }else{
                      set_token(user_);
                      wakeUp(user_.expires_at);
                  }

              }).catch(err =>
              {
                  wakeUp(0);
              });
          });
      });

WASMAuth::WASMAuth(QObject *parent) : AuthAbstract(parent),jsonLock(){}

bool WASMAuth::isPermanent() const
{
    return permanent;
}

void WASMAuth::setPermanent(bool value)
{
    permanent = value;
}

bool WASMAuth::isAuthenticated() const
{
    return true;
}

bool WASMAuth::isConfigured() const
{
    return configured;
} 

WASMAuth::~WASMAuth()
{
    free(json_config_ptr);
}

void WASMAuth::updateConfig()
{
    std::lock_guard<std::mutex> lock(jsonLock);
    std::string currUrl  =val::global("location")["origin"].as<std::string>();
    make_json(currUrl);
    // qInfo() << "c++ Updated config";
    this->configured = true;
    emit this->updatedConfig();
}

void WASMAuth::grant() {
    // qInfo() << "c++ granting";
    std::lock_guard<std::mutex> lock(jsonLock);
    QReadLocker locker (&OAuth2Config::get().getLock());
    // qInfo() << "c++ calling getUser";
    expiration = getUser();
    // qInfo() << "c++ called getUser";
    if(expiration != 0)
    {
       emit this->authenticatedChanged();
       emit this->emailChanged();
    }
    // qInfo() << "c++ granted";
}

QString WASMAuth::getEmail()
{
  return getEmailFromToken(token);
}
