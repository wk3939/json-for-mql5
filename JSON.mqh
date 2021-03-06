//+------------------------------------------------------------------+
//|                                                         JSON.mqh |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#define JSON_TYPE_STRING 10
#define JSON_TYPE_DOUBLE 20
#define JSON_TYPE_LONG 30
#define JSON_TYPE_BOOL 40
#define JSON_TYPE_OBJECT 50
#define JSON_TYPE_ARRAYS 60
#define JSON_TYPE_UNKNOW 70
#define JSON_NAME_ARRAY_NAME "default_array"

#define JSON_RETURN_SUCCESS 1
#define JSON_RETURN_UNFOUND_ERROR -1
#define JSON_RETURN_TYPE_ERROR -2
//#include "JSONStack.mqh"
class JSON
  {
private:


   JSON*             searchObj(string objName);
public:

   JSON              *next;
   JSON              *prev;
   JSON              *child;
   int               type;
   string            name;
   string            valuestring;
   double            valuedouble;
   long              valuelong;
   bool              valuebool;

                     JSON();
                    ~JSON();
   static JSON*      parse(string jsonString);
   static string     toString(JSON *item);
   JSON*             addJSONObject(string objName,JSON *item);
   JSON*             addIntItem(string objName, int item);
   JSON*             addLongItem(string objName, long item);
   JSON*             addDoubleItem(string objName, double item);
   JSON*             addFloatItem(string objName,float item);
   JSON*             addBoolItem(string objName, bool item);
   JSON*             addStringItem(string objName,string item);
   JSON*             addJSONObjectArray(string objName,JSON& array[]);
   JSON*             addIntArray(string objName, int& array[]);
   JSON*             addLongArray(string objName, long& array[]);
   JSON*             addDoubleArray(string objName, double& array[]);
   JSON*             addFloatArray(string objName,float& array[]);
   JSON*             addBoolArray(string objName, bool& array[]);
   JSON*             addStringArray(string objName,string& array[]);

   JSON*             getJSONObject(string objName);
   int               getIntItem(string objName);
   long              getLongItem(string objName);
   double            getDoubleItem(string objName);
   float             getFloatItem(string objName);
   bool              getBoolItem(string objName);
   string            getStringItem(string objName);
   int               getArraySize(string objName);
   int               getStringArray(string& strArray[], string objName);
   int               getDoubleArray(double& doubleArray[], string objName);
   int               getFloatArray(float& floatArray[], string objName);
   int               getIntArray(int& intArray[], string objName);
   int               getLongArray(long& longArray[], string objName);
   int               getBoolArray(bool& boolArray[], string objName);
   int               getObjectArray(JSON& objArray[], string objName);
  };


#include "JSONStack.mqh"
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
//|                                                                  |
//+------------------------------------------------------------------+
JSON* JSON::addJSONObject(string objName,JSON *item)
  {
   JSON *obj = new JSON();
   obj.child = item;
   obj.name = objName;
   obj.type = JSON_TYPE_OBJECT;
   obj.next = this.child;
   this.child.prev = obj;
   this.child = obj;
   return (GetPointer(this));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JSON* JSON::addIntItem(string objName, int item)
  {
   JSON *obj = new JSON();
   obj.valuelong = item;
   obj.type = JSON_TYPE_LONG;
   obj.name = objName;
   obj.next = this.child;
   this.child.prev = obj;
   this.child = obj;
   return (GetPointer(this));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JSON* JSON::addLongItem(string objName, long item)
  {
   JSON *obj = new JSON();
   obj.valuelong = item;
   obj.type = JSON_TYPE_LONG;
   obj.name = objName;
   obj.next = this.child;
   this.child.prev = obj;
   this.child = obj;
   return (GetPointer(this));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JSON* JSON::addDoubleItem(string objName, double item)
  {
   JSON *obj = new JSON();
   obj.valuedouble = item;
   obj.type = JSON_TYPE_DOUBLE;
   obj.name = objName;
   obj.next = this.child;
   this.child.prev = obj;
   this.child = obj;
   return (GetPointer(this));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JSON* JSON::addFloatItem(string objName,float item)
  {
   JSON *obj = new JSON();
   obj.valuedouble = item;
   obj.type = JSON_TYPE_DOUBLE;
   obj.name = objName;
   obj.next = this.child;
   this.child.prev = obj;
   this.child = obj;
   return (GetPointer(this));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JSON* JSON::addBoolItem(string objName, bool item)
  {
   JSON *obj = new JSON();
   obj.valuebool = item;
   obj.type = JSON_TYPE_BOOL;
   obj.name = objName;
   obj.next = this.child;
   this.child.prev = obj;
   this.child = obj;
   return (GetPointer(this));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JSON* JSON::addStringItem(string objName,string item)
  {
   JSON *obj = new JSON();
   obj.valuestring = item;
   obj.type = JSON_TYPE_STRING;
   obj.name = objName;
   obj.next = this.child;
   this.child.prev = obj;
   this.child = obj;
   return (GetPointer(this));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JSON* JSON::addJSONObjectArray(string objName,JSON& array[])
  {
   JSON *obj = new JSON();
   obj.type = JSON_TYPE_ARRAYS;
   obj.name = objName;
   obj.next = this.child;
   this.child.prev = obj;
   this.child = obj;
   JSON *arrayItem = new JSON();
   int size = ArraySize(array);
   while(--size >0)
     {
      arrayItem.type = JSON_TYPE_OBJECT;
      arrayItem.child = array[size];
      arrayItem.prev = new JSON;
      arrayItem.prev.next = arrayItem;
      arrayItem = arrayItem.prev;
     }
   obj.child = arrayItem;
   return (GetPointer(this));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JSON* JSON::addIntArray(string objName, int& array[])
  {
   JSON *obj = new JSON();
   obj.type = JSON_TYPE_ARRAYS;
   obj.name = objName;
   obj.next = this.child;
   this.child.prev = obj;
   this.child = obj;
   JSON *arrayItem = new JSON();
   int size = ArraySize(array);
   while(--size >0)
     {
      arrayItem.type = JSON_TYPE_LONG;
      arrayItem.valuelong = array[size];
      arrayItem.prev = new JSON;
      arrayItem.prev.next = arrayItem;
      arrayItem = arrayItem.prev;
     }
   obj.child = arrayItem;
   return (GetPointer(this));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JSON* JSON::addLongArray(string objName, long& array[])
  {
   JSON *obj = new JSON();
   obj.type = JSON_TYPE_ARRAYS;
   obj.name = objName;
   obj.next = this.child;
   this.child.prev = obj;
   this.child = obj;
   JSON *arrayItem = new JSON();
   int size = ArraySize(array);
   while(--size >0)
     {
      arrayItem.type = JSON_TYPE_LONG;
      arrayItem.valuelong = array[size];
      arrayItem.prev = new JSON;
      arrayItem.prev.next = arrayItem;
      arrayItem = arrayItem.prev;
     }
   obj.child = arrayItem;
   return (GetPointer(this));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JSON* JSON::addDoubleArray(string objName, double& array[])
  {
   JSON *obj = new JSON();
   obj.type = JSON_TYPE_ARRAYS;
   obj.name = objName;
   obj.next = this.child;
   this.child.prev = obj;
   this.child = obj;
   JSON *arrayItem = new JSON();
   int size = ArraySize(array);
   while(--size >0)
     {
      arrayItem.type = JSON_TYPE_DOUBLE;
      arrayItem.valuedouble = array[size];
      arrayItem.prev = new JSON;
      arrayItem.prev.next = arrayItem;
      arrayItem = arrayItem.prev;
     }
   obj.child = arrayItem;
   return (GetPointer(this));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JSON* JSON::addFloatArray(string objName,float& array[])
  {
   JSON *obj = new JSON();
   obj.type = JSON_TYPE_ARRAYS;
   obj.name = objName;
   obj.next = this.child;
   this.child.prev = obj;
   this.child = obj;
   JSON *arrayItem = new JSON();
   int size = ArraySize(array);
   while(--size >0)
     {
      arrayItem.type = JSON_TYPE_DOUBLE;
      arrayItem.valuedouble = array[size];
      arrayItem.prev = new JSON;
      arrayItem.prev.next = arrayItem;
      arrayItem = arrayItem.prev;
     }
   obj.child = arrayItem;
   return (GetPointer(this));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JSON* JSON::addBoolArray(string objName, bool& array[])
  {
   JSON *obj = new JSON();
   obj.type = JSON_TYPE_ARRAYS;
   obj.name = objName;
   obj.next = this.child;
   this.child.prev = obj;
   this.child = obj;
   JSON *arrayItem = new JSON();
   int size = ArraySize(array);
   while(--size >0)
     {
      arrayItem.type = JSON_TYPE_BOOL;
      arrayItem.valuebool = array[size];
      arrayItem.prev = new JSON;
      arrayItem.prev.next = arrayItem;
      arrayItem = arrayItem.prev;
     }
   obj.child = arrayItem;
   return (GetPointer(this));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JSON* JSON::addStringArray(string objName,string& array[])
  {
   JSON *obj = new JSON();
   obj.type = JSON_TYPE_ARRAYS;
   obj.name = objName;
   obj.next = this.child;
   this.child.prev = obj;
   this.child = obj;
   JSON *arrayItem = new JSON();
   int size = ArraySize(array);
   while(--size >0)
     {
      arrayItem.type = JSON_TYPE_STRING;
      arrayItem.valuestring = array[size];
      arrayItem.prev = new JSON;
      arrayItem.prev.next = arrayItem;
      arrayItem = arrayItem.prev;
     }
   obj.child = arrayItem;
   return (GetPointer(this));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string JSON::getStringItem(string objName)
  {
   JSON* obj = this.searchObj(objName);
   if(obj == NULL || obj.type != JSON_TYPE_STRING)
     {
      return NULL;
     }
   return obj.valuestring;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JSON::getBoolItem(string objName)
  {
   JSON* obj = this.searchObj(objName);
   if(obj == NULL || obj.type != JSON_TYPE_BOOL)
     {
      return NULL;
     }
   return obj.valuebool;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
float JSON::getFloatItem(string objName)
  {
   JSON* obj = this.searchObj(objName);
   if(obj == NULL || obj.type != JSON_TYPE_DOUBLE)
     {
      return NULL;
     }
   return obj.valuedouble;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JSON::getDoubleItem(string objName)
  {
   JSON* obj = this.searchObj(objName);
   if(obj == NULL || obj.type != JSON_TYPE_DOUBLE)
     {
      return NULL;
     }
   return obj.valuedouble;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
long JSON::getLongItem(string objName)
  {
   JSON* obj = this.searchObj(objName);
   if(obj == NULL || obj.type != JSON_TYPE_LONG)
     {
      return NULL;
     }
   return obj.valuelong;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int JSON::getIntItem(string objName)
  {
   JSON* obj = this.searchObj(objName);
   if(obj == NULL || obj.type != JSON_TYPE_LONG)
     {
      return NULL;
     }
   return obj.valuelong;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JSON* JSON::getJSONObject(string objName)
  {
   JSON* obj = this.searchObj(objName);
   if(obj == NULL || obj.type != JSON_TYPE_OBJECT)
     {
      return NULL;
     }
   return obj.child;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int JSON::getObjectArray(JSON& objArray[], string objName)
  {
   JSON* obj = this.searchObj(objName);
   if(obj == NULL)
     {
      return JSON_RETURN_UNFOUND_ERROR;
     }
   obj = obj.child;
   ArrayFree(objArray);
   ArrayResize(objArray,0);
   int size =0;
   if(obj.type == JSON_TYPE_UNKNOW)
     {
      return JSON_RETURN_SUCCESS;
     }
   while(obj != NULL)
     {
      if(obj.type != JSON_TYPE_OBJECT)
        {
         ArrayFree(objArray);
         ArrayResize(objArray,0);
         return JSON_RETURN_TYPE_ERROR;
        }
      ArrayResize(objArray,++size);
      objArray[size-1] = obj.child;
      obj = obj.next;
     }
   return size;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int JSON::getBoolArray(bool& boolArray[], string objName)
  {
   JSON* obj = this.searchObj(objName);
   if(obj == NULL)
     {
      return JSON_RETURN_UNFOUND_ERROR;
     }
   obj = obj.child;
   ArrayFree(boolArray);
   ArrayResize(boolArray,0);
   int size =0;
   if(obj.type == JSON_TYPE_UNKNOW)
     {
      return JSON_RETURN_SUCCESS;
     }
   while(obj != NULL)
     {
      if(obj.type != JSON_TYPE_BOOL)
        {
         ArrayFree(boolArray);
         ArrayResize(boolArray,0);
         return JSON_RETURN_TYPE_ERROR;
        }
      ArrayResize(boolArray,++size);
      boolArray[size-1] = obj.valuebool;
      obj = obj.next;
     }
   return size;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int JSON::getIntArray(int& intArray[], string objName)
  {
   JSON* obj = this.searchObj(objName);
   if(obj == NULL)
     {
      return JSON_RETURN_UNFOUND_ERROR;
     }
   obj = obj.child;
   ArrayFree(intArray);
   ArrayResize(intArray,0);
   int size =0;
   if(obj.type == JSON_TYPE_UNKNOW)
     {
      return JSON_RETURN_SUCCESS;
     }
   while(obj != NULL)
     {
      if(obj.type != JSON_TYPE_LONG)
        {
         ArrayFree(intArray);
         ArrayResize(intArray,0);
         return JSON_RETURN_TYPE_ERROR;
        }
      ArrayResize(intArray,++size);
      intArray[size-1] = obj.valuelong;
      obj = obj.next;
     }
   return size;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int JSON::getLongArray(long& longArray[], string objName)
  {
   JSON* obj = this.searchObj(objName);
   if(obj == NULL)
     {
      return JSON_RETURN_UNFOUND_ERROR;
     }
   obj = obj.child;
   ArrayFree(longArray);
   ArrayResize(longArray,0);
   int size =0;
   if(obj.type == JSON_TYPE_UNKNOW)
     {
      return JSON_RETURN_SUCCESS;
     }
   while(obj != NULL)
     {
      if(obj.type != JSON_TYPE_LONG)
        {
         ArrayFree(longArray);
         ArrayResize(longArray,0);
         return JSON_RETURN_TYPE_ERROR;
        }
      ArrayResize(longArray,++size);
      longArray[size-1] = obj.valuelong;
      obj = obj.next;
     }
   return size;

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int  JSON::getFloatArray(float& floatArray[], string objName)
  {
   JSON* obj = this.searchObj(objName);
   if(obj == NULL)
     {
      return JSON_RETURN_UNFOUND_ERROR;
     }
   obj = obj.child;
   ArrayFree(floatArray);
   ArrayResize(floatArray,0);
   int size =0;
   if(obj.type == JSON_TYPE_UNKNOW)
     {
      return JSON_RETURN_SUCCESS;
     }
   while(obj != NULL)
     {
      if(obj.type != JSON_TYPE_DOUBLE)
        {
         ArrayFree(floatArray);
         ArrayResize(floatArray,0);
         return JSON_RETURN_TYPE_ERROR;
        }
      ArrayResize(floatArray,++size);
      floatArray[size-1] = obj.valuedouble;
      obj = obj.next;
     }
   return size;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int JSON::getDoubleArray(double& doubleArray[], string objName)
  {
   JSON* obj = this.searchObj(objName);
   if(obj == NULL)
     {
      return JSON_RETURN_UNFOUND_ERROR;
     }
   obj = obj.child;
   ArrayFree(doubleArray);
   ArrayResize(doubleArray,0);
   int size =0;
   if(obj.type == JSON_TYPE_UNKNOW)
     {
      return JSON_RETURN_SUCCESS;
     }
   while(obj != NULL)
     {
      if(obj.type != JSON_TYPE_DOUBLE)
        {
         ArrayFree(doubleArray);
         ArrayResize(doubleArray,0);
         return JSON_RETURN_TYPE_ERROR;
        }
      ArrayResize(doubleArray,++size);
      doubleArray[size-1] = obj.valuedouble;
      obj = obj.next;
     }
   return size;
  }
//+------------------------------------------------------------------+
//|strArray数组，返回数组大小，-2类型错误，-1查询不到对象                                                                  |
//+------------------------------------------------------------------+
int JSON::getStringArray(string& strArray[],string objName)
  {
   JSON* obj = this.searchObj(objName);
   if(obj == NULL)
     {
      return JSON_RETURN_UNFOUND_ERROR;
     }
   obj = obj.child;
   ArrayFree(strArray);
   ArrayResize(strArray,0);
   int size =0;
   if(obj.type == JSON_TYPE_UNKNOW)
     {
      return JSON_RETURN_SUCCESS;
     }
   while(obj != NULL)
     {
      if(obj.type != JSON_TYPE_STRING)
        {
         ArrayFree(strArray);
         ArrayResize(strArray,0);
         return JSON_RETURN_TYPE_ERROR;
        }
      ArrayResize(strArray,++size);
      strArray[size-1] = obj.valuestring;
      obj = obj.next;
     }
   return size;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int JSON::getArraySize(string objName)
  {
   JSON* obj = this.searchObj(objName);
   if(obj == NULL)
     {
      return JSON_RETURN_UNFOUND_ERROR;
     }
   int size =0;
   obj = obj.child;
   if(obj.type == JSON_TYPE_UNKNOW)
     {
      return size;
     }

   while(obj != NULL)
     {
      size++;
      obj = obj.next;
     }
   return size;

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JSON* JSON::searchObj(string objName)
  {
   if(this.child == NULL || this.child.type == JSON_TYPE_UNKNOW)
     {
      return NULL;
     }
   JSON *obj = this.child;
   while(StringCompare(obj.name,objName) != 0 && obj.next != NULL)
     {
      obj = obj.next;
     }
   if(StringCompare(obj.name,objName) != 0 && obj.next == NULL)
     {
      return NULL;
     }
   return obj;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JSON* JSON::parse(string jsonString)
  {
   int len = StringLen(jsonString);
   int point = 0;
   JSONStack *stack = new JSONStack();
   JSON *obj;
   obj = new JSON();
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
         obj.child = new JSON();
         if(StringGetCharacter(jsonString, point)=='{')
           {
            obj.type = JSON_TYPE_OBJECT;
           }
         else
           {
            obj.type = JSON_TYPE_ARRAYS;
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
         obj.next = new JSON();
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
            obj.type = JSON_TYPE_UNKNOW;
           }

         else
            if(StringCompare(tmpVal,"true")==0)
              {
               obj.valuebool = true;
               obj.type = JSON_TYPE_BOOL;
              }
            else
               if(StringCompare(tmpVal,"false")==0)
                 {
                  obj.valuebool = false;
                  obj.type = JSON_TYPE_BOOL;

                 }
               else
                  if(StringFind(tmpVal,".") == -1)
                    {
                     obj.valuelong = StringToInteger(tmpVal);
                     obj.type = JSON_TYPE_LONG;

                    }
                  else
                     if(StringFind(tmpVal,".")>-1)
                       {
                        obj.valuedouble = StringToDouble(tmpVal);
                        obj.type = JSON_TYPE_DOUBLE;

                       }
         tmpVal = "";
         obj.next = new JSON();
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
         obj.type = JSON_TYPE_STRING;
         tmpVal = "";
         obj.next = new JSON();
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
               obj.type = JSON_TYPE_BOOL;
              }
            else
               if(StringCompare(tmpVal,"false")==0)
                 {
                  obj.valuebool = false;
                  obj.type = JSON_TYPE_BOOL;

                 }
               else
                  if(StringFind(tmpVal,".") == -1)
                    {
                     obj.valuelong = StringToInteger(tmpVal);
                     obj.type = JSON_TYPE_LONG;

                    }
                  else
                     if(StringFind(tmpVal,".")>-1)
                       {
                        obj.valuedouble = StringToDouble(tmpVal);
                        obj.type = JSON_TYPE_DOUBLE;

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
         obj.type = JSON_TYPE_STRING;
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
string JSON::toString(JSON *item)
  {
   JSONStack *stack = new JSONStack();
   JSON *obj = item;
   string buf = "";
   do
     {
      if(StringLen(obj.name)>0 && obj.name != JSON_NAME_ARRAY_NAME)
        {
         StringAdd(buf,"\"" +obj.name+"\":");
        }

      if(obj.type == JSON_TYPE_OBJECT)
        {
         StringAdd(buf,"{");
         stack.push(obj);
         obj = obj.child;
         continue;
        }

      if(obj.type == JSON_TYPE_ARRAYS)
        {
         StringAdd(buf,"[");
         stack.push(obj);
         obj = obj.child;
         continue;
        }

      if(obj.type == JSON_TYPE_BOOL)
        {
         StringAdd(buf, obj.valuebool?"true":"false");
        }
      else
         if(obj.type == JSON_TYPE_DOUBLE)
           {
            StringAdd(buf, DoubleToString(obj.valuedouble));
           }
         else
            if(obj.type == JSON_TYPE_LONG)
              {
               StringAdd(buf, IntegerToString(obj.valuelong));
              }
            else
               if(obj.type == JSON_TYPE_STRING)
                 {
                  StringReplace(obj.valuestring,"\"","\\\"");
                  StringAdd(buf, "\""+obj.valuestring+"\"");
                 }


      while(obj.next == NULL)
        {
         if(StringCompare(obj.name,JSON_NAME_ARRAY_NAME)==0)
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
   delete stack;
   return buf;
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
