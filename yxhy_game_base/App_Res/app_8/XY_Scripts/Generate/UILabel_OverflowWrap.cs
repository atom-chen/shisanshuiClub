﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class UILabel_OverflowWrap
{
	public static void Register(LuaState L)
	{
		L.BeginEnum(typeof(UILabel.Overflow));
		L.RegVar("ShrinkContent", get_ShrinkContent, null);
		L.RegVar("ClampContent", get_ClampContent, null);
		L.RegVar("ResizeFreely", get_ResizeFreely, null);
		L.RegVar("ResizeHeight", get_ResizeHeight, null);
		L.RegFunction("IntToEnum", IntToEnum);
		L.EndEnum();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_ShrinkContent(IntPtr L)
	{
		ToLua.Push(L, UILabel.Overflow.ShrinkContent);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_ClampContent(IntPtr L)
	{
		ToLua.Push(L, UILabel.Overflow.ClampContent);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_ResizeFreely(IntPtr L)
	{
		ToLua.Push(L, UILabel.Overflow.ResizeFreely);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_ResizeHeight(IntPtr L)
	{
		ToLua.Push(L, UILabel.Overflow.ResizeHeight);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int IntToEnum(IntPtr L)
	{
		int arg0 = (int)LuaDLL.lua_tonumber(L, 1);
		UILabel.Overflow o = (UILabel.Overflow)arg0;
		ToLua.Push(L, o);
		return 1;
	}
}
