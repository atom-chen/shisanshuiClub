﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class BestHTTP_WebSocket_WebSocketWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(BestHTTP.WebSocket.WebSocket), typeof(System.Object));
		L.RegFunction("Open", Open);
		L.RegFunction("Send", Send);
		L.RegFunction("Close", Close);
		L.RegFunction("EncodeCloseData", EncodeCloseData);
		L.RegFunction("New", _CreateBestHTTP_WebSocket_WebSocket);
		L.RegFunction("__tostring", Lua_ToString);
		L.RegVar("OnOpen", get_OnOpen, set_OnOpen);
		L.RegVar("OnMessage", get_OnMessage, set_OnMessage);
		L.RegVar("OnBinary", get_OnBinary, set_OnBinary);
		L.RegVar("OnClosed", get_OnClosed, set_OnClosed);
		L.RegVar("OnError", get_OnError, set_OnError);
		L.RegVar("OnErrorDesc", get_OnErrorDesc, set_OnErrorDesc);
		L.RegVar("OnIncompleteFrame", get_OnIncompleteFrame, set_OnIncompleteFrame);
		L.RegVar("IsOpen", get_IsOpen, null);
		L.RegVar("BufferedAmount", get_BufferedAmount, null);
		L.RegVar("StartPingThread", get_StartPingThread, set_StartPingThread);
		L.RegVar("IsUsed", get_IsUsed, set_IsUsed);
		L.RegVar("PingFrequency", get_PingFrequency, set_PingFrequency);
		L.RegVar("InternalRequest", get_InternalRequest, null);
		L.RegVar("Extensions", get_Extensions, null);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateBestHTTP_WebSocket_WebSocket(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 1)
			{
				System.Uri arg0 = (System.Uri)ToLua.CheckObject(L, 1, typeof(System.Uri));
				BestHTTP.WebSocket.WebSocket obj = new BestHTTP.WebSocket.WebSocket(arg0);
				ToLua.PushObject(L, obj);
				return 1;
			}
			else if (TypeChecker.CheckTypes(L, 1, typeof(System.Uri), typeof(string), typeof(string)) && TypeChecker.CheckParamsType(L, typeof(BestHTTP.WebSocket.Extensions.IExtension), 4, count - 3))
			{
				System.Uri arg0 = (System.Uri)ToLua.CheckObject(L, 1, typeof(System.Uri));
				string arg1 = ToLua.CheckString(L, 2);
				string arg2 = ToLua.CheckString(L, 3);
				BestHTTP.WebSocket.Extensions.IExtension[] arg3 = ToLua.CheckParamsObject<BestHTTP.WebSocket.Extensions.IExtension>(L, 4, count - 3);
				BestHTTP.WebSocket.WebSocket obj = new BestHTTP.WebSocket.WebSocket(arg0, arg1, arg2, arg3);
				ToLua.PushObject(L, obj);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to ctor method: BestHTTP.WebSocket.WebSocket.New");
			}
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Open(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			BestHTTP.WebSocket.WebSocket obj = (BestHTTP.WebSocket.WebSocket)ToLua.CheckObject(L, 1, typeof(BestHTTP.WebSocket.WebSocket));
			obj.Open();
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Send(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 2 && TypeChecker.CheckTypes(L, 1, typeof(BestHTTP.WebSocket.WebSocket), typeof(BestHTTP.WebSocket.Frames.WebSocketFrame)))
			{
				BestHTTP.WebSocket.WebSocket obj = (BestHTTP.WebSocket.WebSocket)ToLua.ToObject(L, 1);
				BestHTTP.WebSocket.Frames.WebSocketFrame arg0 = (BestHTTP.WebSocket.Frames.WebSocketFrame)ToLua.ToObject(L, 2);
				obj.Send(arg0);
				return 0;
			}
			else if (count == 2 && TypeChecker.CheckTypes(L, 1, typeof(BestHTTP.WebSocket.WebSocket), typeof(byte[])))
			{
				BestHTTP.WebSocket.WebSocket obj = (BestHTTP.WebSocket.WebSocket)ToLua.ToObject(L, 1);
				byte[] arg0 = ToLua.CheckByteBuffer(L, 2);
				obj.Send(arg0);
				return 0;
			}
			else if (count == 2 && TypeChecker.CheckTypes(L, 1, typeof(BestHTTP.WebSocket.WebSocket), typeof(string)))
			{
				BestHTTP.WebSocket.WebSocket obj = (BestHTTP.WebSocket.WebSocket)ToLua.ToObject(L, 1);
				string arg0 = ToLua.ToString(L, 2);
				obj.Send(arg0);
				return 0;
			}
			else if (count == 4 && TypeChecker.CheckTypes(L, 1, typeof(BestHTTP.WebSocket.WebSocket), typeof(byte[]), typeof(ulong), typeof(ulong)))
			{
				BestHTTP.WebSocket.WebSocket obj = (BestHTTP.WebSocket.WebSocket)ToLua.ToObject(L, 1);
				byte[] arg0 = ToLua.CheckByteBuffer(L, 2);
				ulong arg1 = (ulong)LuaDLL.lua_tonumber(L, 3);
				ulong arg2 = (ulong)LuaDLL.lua_tonumber(L, 4);
				obj.Send(arg0, arg1, arg2);
				return 0;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to method: BestHTTP.WebSocket.WebSocket.Send");
			}
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Close(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 1 && TypeChecker.CheckTypes(L, 1, typeof(BestHTTP.WebSocket.WebSocket)))
			{
				BestHTTP.WebSocket.WebSocket obj = (BestHTTP.WebSocket.WebSocket)ToLua.ToObject(L, 1);
				obj.Close();
				return 0;
			}
			else if (count == 3 && TypeChecker.CheckTypes(L, 1, typeof(BestHTTP.WebSocket.WebSocket), typeof(ushort), typeof(string)))
			{
				BestHTTP.WebSocket.WebSocket obj = (BestHTTP.WebSocket.WebSocket)ToLua.ToObject(L, 1);
				ushort arg0 = (ushort)LuaDLL.lua_tonumber(L, 2);
				string arg1 = ToLua.ToString(L, 3);
				obj.Close(arg0, arg1);
				return 0;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to method: BestHTTP.WebSocket.WebSocket.Close");
			}
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int EncodeCloseData(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			ushort arg0 = (ushort)LuaDLL.luaL_checknumber(L, 1);
			string arg1 = ToLua.CheckString(L, 2);
			byte[] o = BestHTTP.WebSocket.WebSocket.EncodeCloseData(arg0, arg1);
			ToLua.Push(L, o);
			return 1;
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
	static int get_OnOpen(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			BestHTTP.WebSocket.WebSocket obj = (BestHTTP.WebSocket.WebSocket)o;
			BestHTTP.WebSocket.OnWebSocketOpenDelegate ret = obj.OnOpen;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index OnOpen on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_OnMessage(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			BestHTTP.WebSocket.WebSocket obj = (BestHTTP.WebSocket.WebSocket)o;
			BestHTTP.WebSocket.OnWebSocketMessageDelegate ret = obj.OnMessage;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index OnMessage on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_OnBinary(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			BestHTTP.WebSocket.WebSocket obj = (BestHTTP.WebSocket.WebSocket)o;
			BestHTTP.WebSocket.OnWebSocketBinaryDelegate ret = obj.OnBinary;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index OnBinary on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_OnClosed(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			BestHTTP.WebSocket.WebSocket obj = (BestHTTP.WebSocket.WebSocket)o;
			BestHTTP.WebSocket.OnWebSocketClosedDelegate ret = obj.OnClosed;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index OnClosed on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_OnError(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			BestHTTP.WebSocket.WebSocket obj = (BestHTTP.WebSocket.WebSocket)o;
			BestHTTP.WebSocket.OnWebSocketErrorDelegate ret = obj.OnError;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index OnError on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_OnErrorDesc(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			BestHTTP.WebSocket.WebSocket obj = (BestHTTP.WebSocket.WebSocket)o;
			BestHTTP.WebSocket.OnWebSocketErrorDescriptionDelegate ret = obj.OnErrorDesc;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index OnErrorDesc on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_OnIncompleteFrame(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			BestHTTP.WebSocket.WebSocket obj = (BestHTTP.WebSocket.WebSocket)o;
			BestHTTP.WebSocket.OnWebSocketIncompleteFrameDelegate ret = obj.OnIncompleteFrame;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index OnIncompleteFrame on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_IsOpen(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			BestHTTP.WebSocket.WebSocket obj = (BestHTTP.WebSocket.WebSocket)o;
			bool ret = obj.IsOpen;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index IsOpen on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_BufferedAmount(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			BestHTTP.WebSocket.WebSocket obj = (BestHTTP.WebSocket.WebSocket)o;
			int ret = obj.BufferedAmount;
			LuaDLL.lua_pushinteger(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index BufferedAmount on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_StartPingThread(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			BestHTTP.WebSocket.WebSocket obj = (BestHTTP.WebSocket.WebSocket)o;
			bool ret = obj.StartPingThread;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index StartPingThread on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_IsUsed(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			BestHTTP.WebSocket.WebSocket obj = (BestHTTP.WebSocket.WebSocket)o;
			bool ret = obj.IsUsed;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index IsUsed on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_PingFrequency(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			BestHTTP.WebSocket.WebSocket obj = (BestHTTP.WebSocket.WebSocket)o;
			int ret = obj.PingFrequency;
			LuaDLL.lua_pushinteger(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index PingFrequency on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_InternalRequest(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			BestHTTP.WebSocket.WebSocket obj = (BestHTTP.WebSocket.WebSocket)o;
			BestHTTP.HTTPRequest ret = obj.InternalRequest;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index InternalRequest on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Extensions(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			BestHTTP.WebSocket.WebSocket obj = (BestHTTP.WebSocket.WebSocket)o;
			BestHTTP.WebSocket.Extensions.IExtension[] ret = obj.Extensions;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index Extensions on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_OnOpen(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			BestHTTP.WebSocket.WebSocket obj = (BestHTTP.WebSocket.WebSocket)o;
			BestHTTP.WebSocket.OnWebSocketOpenDelegate arg0 = null;
			LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

			if (funcType2 != LuaTypes.LUA_TFUNCTION)
			{
				 arg0 = (BestHTTP.WebSocket.OnWebSocketOpenDelegate)ToLua.CheckObject(L, 2, typeof(BestHTTP.WebSocket.OnWebSocketOpenDelegate));
			}
			else
			{
				LuaFunction func = ToLua.ToLuaFunction(L, 2);
				arg0 = DelegateFactory.CreateDelegate(typeof(BestHTTP.WebSocket.OnWebSocketOpenDelegate), func) as BestHTTP.WebSocket.OnWebSocketOpenDelegate;
			}

			obj.OnOpen = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index OnOpen on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_OnMessage(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			BestHTTP.WebSocket.WebSocket obj = (BestHTTP.WebSocket.WebSocket)o;
			BestHTTP.WebSocket.OnWebSocketMessageDelegate arg0 = null;
			LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

			if (funcType2 != LuaTypes.LUA_TFUNCTION)
			{
				 arg0 = (BestHTTP.WebSocket.OnWebSocketMessageDelegate)ToLua.CheckObject(L, 2, typeof(BestHTTP.WebSocket.OnWebSocketMessageDelegate));
			}
			else
			{
				LuaFunction func = ToLua.ToLuaFunction(L, 2);
				arg0 = DelegateFactory.CreateDelegate(typeof(BestHTTP.WebSocket.OnWebSocketMessageDelegate), func) as BestHTTP.WebSocket.OnWebSocketMessageDelegate;
			}

			obj.OnMessage = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index OnMessage on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_OnBinary(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			BestHTTP.WebSocket.WebSocket obj = (BestHTTP.WebSocket.WebSocket)o;
			BestHTTP.WebSocket.OnWebSocketBinaryDelegate arg0 = null;
			LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

			if (funcType2 != LuaTypes.LUA_TFUNCTION)
			{
				 arg0 = (BestHTTP.WebSocket.OnWebSocketBinaryDelegate)ToLua.CheckObject(L, 2, typeof(BestHTTP.WebSocket.OnWebSocketBinaryDelegate));
			}
			else
			{
				LuaFunction func = ToLua.ToLuaFunction(L, 2);
				arg0 = DelegateFactory.CreateDelegate(typeof(BestHTTP.WebSocket.OnWebSocketBinaryDelegate), func) as BestHTTP.WebSocket.OnWebSocketBinaryDelegate;
			}

			obj.OnBinary = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index OnBinary on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_OnClosed(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			BestHTTP.WebSocket.WebSocket obj = (BestHTTP.WebSocket.WebSocket)o;
			BestHTTP.WebSocket.OnWebSocketClosedDelegate arg0 = null;
			LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

			if (funcType2 != LuaTypes.LUA_TFUNCTION)
			{
				 arg0 = (BestHTTP.WebSocket.OnWebSocketClosedDelegate)ToLua.CheckObject(L, 2, typeof(BestHTTP.WebSocket.OnWebSocketClosedDelegate));
			}
			else
			{
				LuaFunction func = ToLua.ToLuaFunction(L, 2);
				arg0 = DelegateFactory.CreateDelegate(typeof(BestHTTP.WebSocket.OnWebSocketClosedDelegate), func) as BestHTTP.WebSocket.OnWebSocketClosedDelegate;
			}

			obj.OnClosed = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index OnClosed on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_OnError(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			BestHTTP.WebSocket.WebSocket obj = (BestHTTP.WebSocket.WebSocket)o;
			BestHTTP.WebSocket.OnWebSocketErrorDelegate arg0 = null;
			LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

			if (funcType2 != LuaTypes.LUA_TFUNCTION)
			{
				 arg0 = (BestHTTP.WebSocket.OnWebSocketErrorDelegate)ToLua.CheckObject(L, 2, typeof(BestHTTP.WebSocket.OnWebSocketErrorDelegate));
			}
			else
			{
				LuaFunction func = ToLua.ToLuaFunction(L, 2);
				arg0 = DelegateFactory.CreateDelegate(typeof(BestHTTP.WebSocket.OnWebSocketErrorDelegate), func) as BestHTTP.WebSocket.OnWebSocketErrorDelegate;
			}

			obj.OnError = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index OnError on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_OnErrorDesc(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			BestHTTP.WebSocket.WebSocket obj = (BestHTTP.WebSocket.WebSocket)o;
			BestHTTP.WebSocket.OnWebSocketErrorDescriptionDelegate arg0 = null;
			LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

			if (funcType2 != LuaTypes.LUA_TFUNCTION)
			{
				 arg0 = (BestHTTP.WebSocket.OnWebSocketErrorDescriptionDelegate)ToLua.CheckObject(L, 2, typeof(BestHTTP.WebSocket.OnWebSocketErrorDescriptionDelegate));
			}
			else
			{
				LuaFunction func = ToLua.ToLuaFunction(L, 2);
				arg0 = DelegateFactory.CreateDelegate(typeof(BestHTTP.WebSocket.OnWebSocketErrorDescriptionDelegate), func) as BestHTTP.WebSocket.OnWebSocketErrorDescriptionDelegate;
			}

			obj.OnErrorDesc = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index OnErrorDesc on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_OnIncompleteFrame(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			BestHTTP.WebSocket.WebSocket obj = (BestHTTP.WebSocket.WebSocket)o;
			BestHTTP.WebSocket.OnWebSocketIncompleteFrameDelegate arg0 = null;
			LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

			if (funcType2 != LuaTypes.LUA_TFUNCTION)
			{
				 arg0 = (BestHTTP.WebSocket.OnWebSocketIncompleteFrameDelegate)ToLua.CheckObject(L, 2, typeof(BestHTTP.WebSocket.OnWebSocketIncompleteFrameDelegate));
			}
			else
			{
				LuaFunction func = ToLua.ToLuaFunction(L, 2);
				arg0 = DelegateFactory.CreateDelegate(typeof(BestHTTP.WebSocket.OnWebSocketIncompleteFrameDelegate), func) as BestHTTP.WebSocket.OnWebSocketIncompleteFrameDelegate;
			}

			obj.OnIncompleteFrame = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index OnIncompleteFrame on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_StartPingThread(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			BestHTTP.WebSocket.WebSocket obj = (BestHTTP.WebSocket.WebSocket)o;
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.StartPingThread = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index StartPingThread on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_IsUsed(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			BestHTTP.WebSocket.WebSocket obj = (BestHTTP.WebSocket.WebSocket)o;
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.IsUsed = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index IsUsed on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_PingFrequency(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			BestHTTP.WebSocket.WebSocket obj = (BestHTTP.WebSocket.WebSocket)o;
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
			obj.PingFrequency = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index PingFrequency on a nil value" : e.Message);
		}
	}
}
