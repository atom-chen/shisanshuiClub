﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class UniWebViewMessageWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(UniWebViewMessage), null);
		L.RegFunction("New", _CreateUniWebViewMessage);
		L.RegFunction("__tostring", Lua_ToString);
		L.RegVar("rawMessage", get_rawMessage, null);
		L.RegVar("scheme", get_scheme, null);
		L.RegVar("path", get_path, null);
		L.RegVar("args", get_args, null);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateUniWebViewMessage(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 1)
			{
				string arg0 = ToLua.CheckString(L, 1);
				UniWebViewMessage obj = new UniWebViewMessage(arg0);
				ToLua.PushValue(L, obj);
				return 1;
			}
			else if (count == 0)
			{
				UniWebViewMessage obj = new UniWebViewMessage();
				ToLua.PushValue(L, obj);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to ctor method: UniWebViewMessage.New");
			}
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Lua_ToString(IntPtr L)
	{
		object obj = ToLua.ToObject(L, 1);

		if (obj != null)
		{
			LuaDLL.lua_pushstring(L, obj.ToString());
		}
		else
		{
			LuaDLL.lua_pushnil(L);
		}

		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_rawMessage(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			UniWebViewMessage obj = (UniWebViewMessage)o;
			string ret = obj.rawMessage;
			LuaDLL.lua_pushstring(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index rawMessage on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_scheme(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			UniWebViewMessage obj = (UniWebViewMessage)o;
			string ret = obj.scheme;
			LuaDLL.lua_pushstring(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index scheme on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_path(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			UniWebViewMessage obj = (UniWebViewMessage)o;
			string ret = obj.path;
			LuaDLL.lua_pushstring(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index path on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_args(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			UniWebViewMessage obj = (UniWebViewMessage)o;
			System.Collections.Generic.Dictionary<string,string> ret = obj.args;
			ToLua.PushObject(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index args on a nil value" : e.Message);
		}
	}
}
