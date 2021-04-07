//+------------------------------------------------------------------+
//|                                                         JSON.mqh |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include "JSONObject.mqh"
#include "JSONStack.mqh"
class JSON
  {
private:
public:

                     JSON();
                    ~JSON();
   JSONObject*        parse(string jsonString);
   string            toString(JSONObject *item);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JSON::JSON()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JSON::~JSON()
  {
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JSONObject* JSON::parse(string jsonString)
  {
   int len = StringLen(jsonString);
   int point = 0;
   JSONStack *stack = new JSONStack();
   JSONObject *obj;
   obj = new JSONObject();
   string tmpVal="";
   while(point < len)
     {

      if((StringGetCharacter(jsonString, point)=='\r' || StringGetCharacter(jsonString, point)=='\n'
          || StringGetCharacter(jsonString, point)==' '|| StringGetCharacter(jsonString, point)=='\t')
         &&(StringLen(tmpVal)==0 || (StringLen(tmpVal)>0 && StringGetCharacter(tmpVal,0)!='"')
            || (StringLen(tmpVal)>1 &&  StringGetCharacter(tmpVal,StringLen(tmpVal)-1) == '"' && StringGetCharacter(tmpVal,StringLen(tmpVal)-2) != '\\'))
        )
        {
         point ++;
         continue;
        }



      //{[前tmpval为空表示对象开始
      if((StringGetCharacter(jsonString, point)=='{' || StringGetCharacter(jsonString, point)=='[')
         && StringLen(tmpVal)==0)
        {
         obj.child = new JSONObject();
         if(StringGetCharacter(jsonString, point)=='{')
           {
            obj.type = JSON_OBJECT;
           }
         else
           {
            obj.type = JSON_ARRAYS;
           }

         stack.push(obj);
         obj = obj.child;
         point ++;
         continue;

        }


      //冒号判断
      if(StringGetCharacter(jsonString, point)==':' && StringGetCharacter(tmpVal,StringLen(tmpVal)-1) == '"' && StringGetCharacter(tmpVal,StringLen(tmpVal)-2) != '\\')
        {
         string tmp = StringSubstr(tmpVal,1,StringLen(tmpVal)-2);
         StringReplace(tmp,"\\\"","\"");
         obj.name = tmp;
         tmpVal = "";
         point ++;
         continue;
        }

      if(StringGetCharacter(jsonString, point)==',' && obj.child != NULL)
        {
         tmpVal = "";
         obj.next = new JSONObject();
         obj.next.prev = obj;
         obj = obj.next;
         point ++;
         continue;
        }
      //逗号前非字符串判断
      if(StringGetCharacter(jsonString, point)==',' && (StringLen(tmpVal) == 0 || (StringLen(tmpVal) == 1 && StringGetCharacter(tmpVal,0)=='"')  || StringGetCharacter(tmpVal,0)!='"'))
        {
         if(StringLen(tmpVal) == 0 || (StringLen(tmpVal) == 1 && StringGetCharacter(tmpVal,0)=='"'))
           {
            obj.type = JSON_UNKNOW;
           }

         else
            if(StringCompare(tmpVal,"true")==0)
              {
               obj.valuebool = true;
               obj.type = JSON_BOOL;
              }
            else
               if(StringCompare(tmpVal,"false")==0)
                 {
                  obj.valuebool = false;
                  obj.type = JSON_BOOL;

                 }
               else
                  if(StringFind(tmpVal,".") == -1)
                    {
                     obj.valuelong = StringToInteger(tmpVal);
                     obj.type = JSON_LONG;

                    }
                  else
                     if(StringFind(tmpVal,".")>-1)
                       {
                        obj.valuedouble = StringToDouble(tmpVal);
                        obj.type = JSON_DOUBLE;

                       }
         tmpVal = "";
         obj.next = new JSONObject();
         obj.next.prev = obj;
         obj = obj.next;
         point ++;
         continue;

        }
      //逗号前为字符串解析
      if(StringGetCharacter(jsonString, point)==',' && StringGetCharacter(tmpVal,StringLen(tmpVal)-1) == '"' && StringGetCharacter(tmpVal,StringLen(tmpVal)-2) != '\\')
        {
         string tmp = StringSubstr(tmpVal,1,StringLen(tmpVal)-2);
         StringReplace(tmp,"\\\"","\"");
         obj.valuestring = tmp;
         obj.type = JSON_STRING;
         tmpVal = "";
         obj.next = new JSONObject();
         obj.next.prev = obj;
         obj = obj.next;
         point ++;
         continue;
        }

      //}]前非字符串判断
      if((StringGetCharacter(jsonString, point)=='}' || StringGetCharacter(jsonString, point)==']') &&
         (StringLen(tmpVal) == 0 || (StringLen(tmpVal) == 1 && StringGetCharacter(tmpVal,0)=='"')  || StringGetCharacter(tmpVal,0)!='"'))
        {
         if(StringLen(tmpVal) == 0 || (StringLen(tmpVal) == 1 && StringGetCharacter(tmpVal,0)=='"'))
           {

           }
         else
            if(StringCompare(tmpVal,"true")==0)
              {
               obj.valuebool = true;
               obj.type = JSON_BOOL;
              }
            else
               if(StringCompare(tmpVal,"false")==0)
                 {
                  obj.valuebool = false;
                  obj.type = JSON_BOOL;

                 }
               else
                  if(StringFind(tmpVal,".") == -1)
                    {
                     obj.valuelong = StringToInteger(tmpVal);
                     obj.type = JSON_LONG;

                    }
                  else
                     if(StringFind(tmpVal,".")>-1)
                       {
                        obj.valuedouble = StringToDouble(tmpVal);
                        obj.type = JSON_DOUBLE;

                       }
         tmpVal = "";
         obj = stack.pop();
         point ++;
         continue;

        }
      //}]前为字符串解析
      if((StringGetCharacter(jsonString, point)=='}' || StringGetCharacter(jsonString, point)==']')
         && StringGetCharacter(tmpVal,StringLen(tmpVal)-1) == '"' && StringGetCharacter(tmpVal,StringLen(tmpVal)-2) != '\\')
        {
         string tmp = StringSubstr(tmpVal,1,StringLen(tmpVal)-2);
         StringReplace(tmp,"\\\"","\"");
         obj.valuestring = tmp;
         obj.type = JSON_STRING;
         tmpVal = "";
         obj = stack.pop();
         point ++;
         continue;
        }

      StringAdd(tmpVal,ShortToString(StringGetCharacter(jsonString, point)));
      point ++;
     }
   delete stack;
   return obj;
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string JSON::toString(JSONObject *item)
  {
   JSONStack *stack = new JSONStack();
   JSONObject *obj = item;
   string buf = "";
   do
     {
      if(StringLen(obj.name)>0 && obj.name != JSON_ARRAY_NAME)
        {
         StringAdd(buf,"\"" +obj.name+"\":");
        }

      if(obj.type == JSON_OBJECT)
        {
         StringAdd(buf,"{");
         stack.push(obj);
         obj = obj.child;
         continue;
        }

      if(obj.type == JSON_ARRAYS)
        {
         StringAdd(buf,"[");
         stack.push(obj);
         obj = obj.child;
         continue;
        }

      if(obj.type == JSON_BOOL)
        {
         StringAdd(buf, obj.valuebool?"true":"false");
        }
      else
         if(obj.type == JSON_DOUBLE)
           {
            StringAdd(buf, DoubleToString(obj.valuedouble));
           }
         else
            if(obj.type == JSON_LONG)
              {
               StringAdd(buf, IntegerToString(obj.valuelong));
              }
            else
               if(obj.type == JSON_STRING)
                 {
                  StringReplace(obj.valuestring,"\"","\\\"");
                  StringAdd(buf, "\""+obj.valuestring+"\"");
                 }


      while(obj.next == NULL)
        {
         if(StringCompare(obj.name,JSON_ARRAY_NAME)==0)
           {
            StringAdd(buf, "]");
           }
         else
           {
            StringAdd(buf, "}");
           }
         obj = stack.pop();
         if(stack.stackpoint==-1)
           {
            break;
           }
        }
      if(obj.next != NULL)
        {
         StringAdd(buf, ",");
         obj = obj.next;
        }

     }
   while(stack.stackpoint!=-1);
   return buf;
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
