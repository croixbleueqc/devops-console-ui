#include "WASMAuth.h"
#include<QDebug>
#include <QJsonDocument>
#include <QJsonObject>
#include <emscripten.h>
#include <emscripten/bind.h>
#include <string>
#include <ctime>






using namespace emscripten;

char * json_config_ptr = nullptr;
QString token= "";



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







EM_JS(int , getUser, (), {
          //There is probably a better way to do it ...
          return Asyncify.handleSleep(wakeUp=>
          {
              function set_token(usr){
                  let jsToken = usr.access_token;
                  let lengthBytes = lengthBytesUTF8(jsToken)+1;
                  let stringOnWasmHeap = Module._malloc(lengthBytes);
                  stringToUTF8(jsToken, stringOnWasmHeap, lengthBytes);
                  Module._set_token(stringOnWasmHeap);
                  Module._free(stringOnWasmHeap);
              }
              var mgr = new Oidc.UserManager(JSON.parse(UTF8ToString(Module._get_config())));
              mgr.getUser().then((user_) => {
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





WASMAuth::WASMAuth(QObject *parent) : QObject(parent)
{


}



WASMAuth::WASMAuth(const QString &clientId, QObject *parent): QObject(parent)
{

}

WASMAuth::WASMAuth(QScopedPointer<OAuth2Config> &_config_ptr,QObject *parent):
    WASMAuth(parent)
{
   config_ptr = &_config_ptr;

}


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
    qInfo("isAuthenticated");
    return true;
}

WASMAuth::~WASMAuth()
{
    free(json_config_ptr);
}

void WASMAuth::updateConfig()
{
    auto config = config_ptr->data();
    if(json_config_ptr != nullptr)
    {
        free(json_config_ptr);
    }
    std::string currUrl  =val::global("location")["origin"].as<std::string>();
    config->get_Json(json_config_ptr,currUrl);
}





void WASMAuth::grant()
{


   expiration =getUser();
   if(expiration != 0)
   {
   emit this->authenticatedChanged();
   emit this->emailChanged();
   }
}

QString WASMAuth::getEmail()
{
    qInfo("getEmail");
    if(token.isEmpty()) {
        return "";
    }

    auto parts = token.split(".");
    auto userdata = QByteArray::fromBase64(parts[1].toUtf8());

    qInfo()<< QByteArray::fromBase64(parts[0].toUtf8());
    const auto doc = QJsonDocument::fromJson(userdata);
    qInfo()<<doc;
    const auto email = doc.object().value("email").toString();
    qInfo()<< parts[2];
    return email;
}
