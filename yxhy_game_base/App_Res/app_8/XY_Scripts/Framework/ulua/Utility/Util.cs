﻿using UnityEngine;
using System;
using System.IO;
using System.Text;
using System.Collections;
using System.Collections.Generic;
using System.Security.Cryptography;
using System.Text.RegularExpressions;
using ICSharpCode.SharpZipLib.GZip;
using System.Reflection;
using LuaInterface;
using cs;
using ICSharpCode.SharpZipLib.Zip.Compression.Streams;

public class Util : MonoBehaviour {
    private static MemoryStream ms1 = new MemoryStream(1024);
    private static InflaterInputStream inflaterInputStream = new InflaterInputStream(ms1);  // DeCompress

    private static MemoryStream ms2 = new MemoryStream(1024);
    private static DeflaterOutputStream deflaterInputStream = new DeflaterOutputStream(ms2); // Compress

    private static int originCullingMask = 0;

    public static int Int(object o) {
        return Convert.ToInt32(o);
    }

    public static float Float(object o) {
        return (float)Math.Round(Convert.ToSingle(o), 2);
    }

    public static long Long(object o) {
        return Convert.ToInt64(o);
    }

    public static ulong ULong(MyUint64 uint64Value)
    {
        ulong ulongHigh = (ulong)uint64Value.High;
        ulongHigh = ulongHigh << 32;
        ulong ulongValue = ulongHigh + uint64Value.Low;
        return ulongValue;
    }

    public static ulong ULong(LuaInteger64 uint64Helper)
    {
        return uint64Helper.ToUInt64();
    }

    public static string ULongTostring(LuaInteger64 uint64Helper)
    {
        return uint64Helper.ToUInt64().ToString();
    }

    public static MyUint64 Uint64(ulong longValue)
    {
        MyUint64 myUnit64 = new MyUint64();
        uint high = (uint)(longValue>>32);
        uint low = (uint)(longValue - ((ulong)high << 32));
        myUnit64.High = high;
        myUnit64.Low = low;
        return myUnit64;
    }

    public static LuaInteger64 Uint64(string value)
    {
        ulong longValue = ulong.Parse(value);
        LuaInteger64 myUnit64 = new LuaInteger64((long)longValue);
        return myUnit64;
    }

    public static LuaInteger64 ToUint64Helper(ulong longValue)
    {
        LuaInteger64 uint64Helper = new LuaInteger64((long)longValue);
        return uint64Helper;
    }

    public static MyUint64 Uint64(LuaInteger64 uint64Helper)
    {
        MyUint64 myUnit64 = new MyUint64();
        ulong longValue = uint64Helper.ToUInt64();
        uint high = (uint)(longValue >> 32);
        uint low = (uint)(longValue - ((ulong)(high) << 32));

        myUnit64.High = high;
        myUnit64.Low = low;
        return myUnit64;
    }

    public static int Random(int min, int max) {
        return UnityEngine.Random.Range(min, max);
    }

    public static float Random(float min, float max) {
        return UnityEngine.Random.Range(min, max);
    }

    public static List<int> RandomRange(int min, int max, int count)
    {
        List<int> retValue = new List<int>();
        if (min < max && count<max-min)
        {
            int total = max - min;
            int[] sequence = new int[total];
            for (int i = 0; i < total; i++)
            {
                sequence[i] = i;
            }
            int end = total - 1;
            for (int i = 0; i < count; i++)
            {
                int num = Random(0, end + 1);
                retValue.Add(sequence[num] + min);
                sequence[num] = sequence[end];
                end--;
            }
        }
        return retValue;
    }

    public static string Uid(string uid) {
        int position = uid.LastIndexOf('_');
        return uid.Remove(0, position + 1);
    }

    public static long GetTime() { 
        TimeSpan ts = new TimeSpan(DateTime.UtcNow.Ticks - new DateTime(1970, 1, 1, 0, 0, 0).Ticks);
        return (long)ts.TotalMilliseconds;
    }

    /// <summary>
    /// 搜索子物体组件-GameObject版
    /// </summary>
    public static T Get<T>(GameObject go, string subnode) where T : Component {
        if (go != null) {
            Transform sub = go.transform.FindChild(subnode);
            if (sub != null) return sub.GetComponent<T>();
        }
        return null;
    }

    /// <summary>
    /// 搜索子物体组件-Transform版
    /// </summary>
    public static T Get<T>(Transform go, string subnode) where T : Component {
        if (go != null) {
            Transform sub = go.FindChild(subnode);
            if (sub != null) return sub.GetComponent<T>();
        }
        return null;
    }

    /// <summary>
    /// 搜索子物体组件-Component版
    /// </summary>
    public static T Get<T>(Component go, string subnode) where T : Component {
        return go.transform.FindChild(subnode).GetComponent<T>();
    }

    /// <summary>
    /// 添加组件
    /// </summary>
    public static T Add<T>(GameObject go) where T : Component {
        if (go != null) {
            T[] ts = go.GetComponents<T>();
            for (int i = 0; i < ts.Length; i++ ) {
                if (ts[i] != null) Destroy(ts[i]);
            }
            return go.gameObject.AddComponent<T>();
        }
        return null;
    }

    /// <summary>
    /// 添加组件
    /// </summary>
    public static T Add<T>(Transform go) where T : Component {
        return Add<T>(go.gameObject);
    }

    /// <summary>
    /// 查找子对象
    /// </summary>
    public static GameObject Child(GameObject go, string subnode) {
        return Child(go.transform, subnode);
    }

    /// <summary>
    /// 查找子对象
    /// </summary>
    public static GameObject Child(Transform go, string subnode) {
        Transform tran = go.FindChild(subnode);
        if (tran == null) return null;
        return tran.gameObject;
    }

    /// <summary>
    /// 取平级对象
    /// </summary>
    public static GameObject Peer(GameObject go, string subnode) {
        return Peer(go.transform, subnode);
    }

    /// <summary>
    /// 取平级对象
    /// </summary>
    public static GameObject Peer(Transform go, string subnode) {
        Transform tran = go.parent.FindChild(subnode);
        if (tran == null) return null;
        return tran.gameObject;
    }

    /// <summary>
    /// 手机震动
    /// </summary>
    public static void Vibrate() {
        //int canVibrate = PlayerPrefs.GetInt(Const.AppPrefix + "Vibrate", 1);
        //if (canVibrate == 1) iPhoneUtils.Vibrate();
    }

    /// <summary>
    /// Base64编码
    /// </summary>
    public static string Encode(string message) {
        byte[] bytes = Encoding.GetEncoding("utf-8").GetBytes(message);
        return Convert.ToBase64String(bytes);
    }

    /// <summary>
    /// Base64解码
    /// </summary>
    public static string Decode(string message) {
        byte[] bytes = Convert.FromBase64String(message);
        return Encoding.GetEncoding("utf-8").GetString(bytes);
    }

    /// <summary>
    /// 判断数字
    /// </summary>
    public static bool IsNumeric(string str) {
        if (str == null || str.Length == 0) return false;
        for (int i = 0; i < str.Length; i++ ) {
            if (!Char.IsNumber(str[i])) { return false; }
        }
        return true;
    }

    /// <summary>
    /// HashToMD5Hex
    /// </summary>
    public static string HashToMD5Hex(string sourceStr) {
        byte[] Bytes = Encoding.UTF8.GetBytes(sourceStr);
        using (MD5CryptoServiceProvider md5 = new MD5CryptoServiceProvider()) {
            byte[] result = md5.ComputeHash(Bytes);
            StringBuilder builder = new StringBuilder();
            for (int i = 0; i < result.Length; i++)
                builder.Append(result[i].ToString("x2"));
            return builder.ToString();
        }
    }

    /// <summary>
    /// 计算字符串的MD5值
    /// </summary>
    public static string md5(string source) {
        MD5CryptoServiceProvider md5 = new MD5CryptoServiceProvider();
        byte[] data = System.Text.Encoding.UTF8.GetBytes(source);
        byte[] md5Data = md5.ComputeHash(data, 0, data.Length);
        md5.Clear();

        string destString = "";
        for (int i = 0; i < md5Data.Length; i++) {
            destString += System.Convert.ToString(md5Data[i], 16).PadLeft(2, '0');
        }
        destString = destString.PadLeft(32, '0');
        return destString;
    }

        /// <summary>
    /// 计算文件的MD5值
    /// </summary>
    public static string md5file(string file) {
        try {
            FileStream fs = new FileStream(file, FileMode.Open);
            System.Security.Cryptography.MD5 md5 = new System.Security.Cryptography.MD5CryptoServiceProvider();
            byte[] retVal = md5.ComputeHash(fs);
            fs.Close();

            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < retVal.Length; i++) {
                sb.Append(retVal[i].ToString("x2"));
            }
            return sb.ToString();
        } catch (Exception ex) {
            throw new Exception("md5file() fail, error:" + ex.Message);
        }
    }

    /// <summary>
    /// 功能：压缩字符串
    /// </summary>
    /// <param name="infile">被压缩的文件路径</param>
    /// <param name="outfile">生成压缩文件的路径</param>
    public static void CompressFile(string infile, string outfile) {
        Stream gs = new GZipOutputStream(File.Create(outfile));
        FileStream fs = File.OpenRead(infile);
        byte[] writeData = new byte[fs.Length];
        fs.Read(writeData, 0, (int)fs.Length);
        gs.Write(writeData, 0, writeData.Length);
        gs.Close(); fs.Close();
    }

    /// <summary>
    /// 功能：输入文件路径，返回解压后的字符串
    /// </summary>
    public static string DecompressFile(string infile) {
        string result = string.Empty;
        Stream gs = new GZipInputStream(File.OpenRead(infile));
        MemoryStream ms = new MemoryStream();
        int size = 2048;
        byte[] writeData = new byte[size]; 
        while (true) {
            size = gs.Read(writeData, 0, size); 
            if (size > 0) {
                ms.Write(writeData, 0, size); 
            } else {
                break; 
            }
        }
        result = new UTF8Encoding().GetString(ms.ToArray());
        gs.Close(); ms.Close();
        return result;
    }

    /// <summary>
    /// 压缩字符串
    /// </summary>
    public static string Compress(string source) 
    {
        byte[] data = Encoding.UTF8.GetBytes(source);
        MemoryStream ms = null;
        using (ms = new MemoryStream()) {
            using (Stream stream = new GZipOutputStream(ms)) {
                try {
                    stream.Write(data, 0, data.Length);
                } finally {
                    stream.Close();
                    ms.Close();
                }
            }
        }
        return Convert.ToBase64String(ms.ToArray());
    }

    /// <summary>
    /// 解压字符串
    /// </summary>
    public static string Decompress(string source) {
        string result = string.Empty;
        byte[] buffer = null;
        try {
            buffer = Convert.FromBase64String(source);
        } catch {
            Debugger.LogError("Decompress---->>>>" + source);
        }
        using (MemoryStream ms = new MemoryStream(buffer)) {
            using (Stream sm = new GZipInputStream(ms)) {
                StreamReader reader = new StreamReader(sm, Encoding.UTF8);
                try {
                    result = reader.ReadToEnd();
                } finally {
                    sm.Close();
                    ms.Close();
                }
            }
        }
        return result;
    }


    public static byte[] CompressBytes(byte[] source)
    {
        MemoryStream ms = null;
        using (ms = new MemoryStream())
        {
            using (Stream stream = new DeflaterOutputStream(ms))
            {
                try
                {
                    stream.Write(source, 0, source.Length);
                }
                finally
                {
                    stream.Close();
                    ms.Close();
                }
            }
        }
        return ms.ToArray();
    }

    static byte[] s_DecompressBuffer = new byte[65536];
    public static byte[] DecompressBytes(byte[] source)
    {
        byte[] resBuffer = null;
        using (MemoryStream ms = new MemoryStream(source))
        {
            using (InflaterInputStream sm = new InflaterInputStream(ms))
            {
                Stream output = new MemoryStream();
                try
                {
                    while(sm.Available == 1)
                    {
                        int nByteLen = sm.Read(s_DecompressBuffer, 0, s_DecompressBuffer.Length);
                        output.Write(s_DecompressBuffer, 0, nByteLen);
                    }
                    output.Seek(0, SeekOrigin.Begin);
                    resBuffer = new byte[output.Length];
                    output.Read(resBuffer, 0, resBuffer.Length);
                }
                finally
                {
                    sm.Close();
                    ms.Close();
                }
            }
        }
        return resBuffer;
    }

    /// <summary>
    /// 清除所有子节点
    /// </summary>
    public static void ClearChild(Transform go) {
        if (go == null) return;
        for (int i = go.childCount - 1; i >= 0; i--) {
            Destroy(go.GetChild(i).gameObject);
        }
    }

    /// <summary>
    /// 生成一个Key名
    /// </summary>
    public static string GetKey(string key) {
        return Const.AppPrefix + Const.UserId + "_" + key; 
    }

    /// <summary>
    /// 取得整型
    /// </summary>
    public static int GetInt(string key) {
        string name = GetKey(key);
        return PlayerPrefs.GetInt(name);
    }

    /// <summary>
    /// 有没有值
    /// </summary>
    public static bool HasKey(string key) {
        string name = GetKey(key);
        return PlayerPrefs.HasKey(name);
    }

    /// <summary>
    /// 保存整型
    /// </summary>
    public static void SetInt(string key, int value) {
        string name = GetKey(key);
        PlayerPrefs.DeleteKey(name);
        PlayerPrefs.SetInt(name, value);
    }

    /// <summary>
    /// 取得数据
    /// </summary>
    public static string GetString(string key) {
        string name = GetKey(key);
        return PlayerPrefs.GetString(name);
    }

    /// <summary>
    /// 保存数据
    /// </summary>
    public static void SetString(string key, string value) {
        string name = GetKey(key);
        PlayerPrefs.DeleteKey(name);
        PlayerPrefs.SetString(name, value);
    }

    /// <summary>
    /// 删除数据
    /// </summary>
    public static void RemoveData(string key) {
        string name = GetKey(key);
        PlayerPrefs.DeleteKey(name);
    }

    /// <summary>
    /// 清理内存
    /// </summary>
    public static void ClearMemory() {
        GC.Collect(); Resources.UnloadUnusedAssets();
    }

    /// <summary>
    /// 是否为数字
    /// </summary>
    public static bool IsNumber(string strNumber) {
        Regex regex = new Regex("[^0-9]");
        return !regex.IsMatch(strNumber);
    }



    /// <summary>
    /// 取得行文本
    /// </summary>
    public static string GetFileText(string path) {
        return File.ReadAllText(path);
    }

    /// <summary>
    /// 网络可用
    /// </summary>
    public static bool NetAvailable {
        get {
            return Application.internetReachability != NetworkReachability.NotReachable;
        }
    }

    /// <summary>
    /// 是否是无线
    /// </summary>
    public static bool IsWifi {
        get {
            return Application.internetReachability == NetworkReachability.ReachableViaLocalAreaNetwork;
        }
    }

    /// <summary>
    /// 取得数据存放目录
    /// </summary>
    public static string DataPath
    {
        get
        {
            string game = Const.AppName.ToLower();

            if (Application.platform == RuntimePlatform.IPhonePlayer ||
                Application.platform == RuntimePlatform.Android ||
                Application.platform == RuntimePlatform.WP8Player)
            {
                return Application.persistentDataPath + "/" + game + "/";
                //return "/sdcard/" + game + "/";
            }

            if (Const.DebugMode)
            {
//                string target = string.Empty;
//                if (Application.platform == RuntimePlatform.OSXEditor ||
//                    Application.platform == RuntimePlatform.IPhonePlayer ||
//                    Application.platform == RuntimePlatform.OSXEditor)
//                {
//#if UNITY_5
//                    target = "ios";
//#else
//                    target = "iphone";
//#endif
//                }
//                else
//                {
//                    target = "android";
//                }
                return Application.dataPath + "/PersistentData/" + game + "/";
            }

            return "c:/" + game + "/";
        }
    }

    /// <summary>
    /// 应用程序内容路径
    /// </summary>
    public static string AppContentPath {
       get
       {
           string path = string.Empty;
           switch (Application.platform)
           {
               case RuntimePlatform.Android:
                   path = "jar:file://" + Application.dataPath + "!/assets/";
                   break;
               case RuntimePlatform.IPhonePlayer:
                   path = Application.dataPath + "/Raw/ios";
                   break;
               default:
                   path = Application.dataPath + "/StreamingAssets/";
                   break;
           }
           return path;
       }
    }

    /// <summary>
    /// 添加lua单机事件
    /// </summary>
    public static void AddClick(GameObject go, System.Object luafuc) {
        UIEventListener.Get(go).onClick += delegate(GameObject o) {
            LuaInterface.LuaFunction func = (LuaInterface.LuaFunction)luafuc;
            func.Call();
        };
    }

    /// <summary>
    /// 是否是登录场景
    /// </summary>
    public static bool isLogin {
        get { return Application.loadedLevelName.CompareTo("login") == 0; }
    }

    /// <summary>
    /// 是否是城镇场景
    /// </summary>
    public static bool isMain {
        get { return Application.loadedLevelName.CompareTo("main") == 0; }
    }

    /// <summary>
    /// 判断是否是战斗场景
    /// </summary>
    public static bool isFight {
        get { return Application.loadedLevelName.CompareTo("fight") == 0; }
    }

    public static string LuaPath() {
        if (Const.DebugMode) {
            return Application.dataPath + "/lua/";
        }
        return DataPath + "lua/"; 
    }

    /// <summary>
    /// 取得Lua路径
    /// </summary>
    public static string LuaPath(string name)
    {
        UnityEngine.Debug.LogWarning("-----LuaPath:-->" + name);
        string path = Const.DebugMode ? Application.dataPath + "/" : DataPath;
#if (UNITY_STANDALONE_WIN && !UNITY_EDITOR)
		path = Application.streamingAssetsPath + "/";
#endif
        string lowerName = name.ToLower();
        if (lowerName.EndsWith(".lua")) {
            return path + "XY_Lua/" + name;
        }

        Debugger.Log("LuaPath: " + path + "XY_Lua/" + name + ".lua");
        return path + "XY_Lua/" + name + ".lua";
    }

    //public static void SetLoggerLevel(LogLevel level)
    //{
    //    Logger.SetLevel(level);
    //}

    //public static void SetWriteLoggerToggle(bool toggle)
    //{
    //    Logger.SetWriteTxtToggle(toggle);
    //}

    public static void Trace(string str)
    {
        Debugger.Log(str);
    }

    public static void Debug(string str)
    {
        Debugger.Log(str);
    }

    public static void Info(string str)
    {
        Debugger.Log(str);
    }

    public static void Warning(string str)
    {
        Debugger.LogWarning(str);
    }

    public static void Fatal(string str)
    {
        Debugger.LogError(str);
    }

    public static GameObject LoadAsset(AssetBundle bundle, string name) {
#if UNITY_5
        return bundle.LoadAsset(name, typeof(GameObject)) as GameObject;
#else
        return bundle.Load(name, typeof(GameObject)) as GameObject;
#endif
    }

    public static Component AddComponent(GameObject go, string assembly, string classname) {
        Assembly asmb = Assembly.Load(assembly);
        Type t = asmb.GetType(assembly + "." + classname);
        return go.AddComponent(t); 
    }

    /// <summary>
    /// 得到文件名（去除前面的文件夹路径部分）
    /// </summary>
    /// <param name="path"></param>
    /// <returns></returns>
    public static string GetSingleFileName(string path)
    {
        string fileName = path.Substring(path.LastIndexOf("/") + 1);
        return fileName.Split('.')[0];
    }

    /// <summary>
    /// 文件名中是否包含大写字母
    /// </summary>
    /// <param name="fileName"></param>
    /// <returns></returns>
    public static bool ContainsUppperChars(string fileName)
    {
        return Regex.IsMatch(fileName, "[A-Z]");
    }

    /// <summary>
    /// 确定最终的路径（考虑版本更新）
    /// </summary>
    /// <param name="fileName"></param>
    /// <param name="suffix"></param>
    /// <returns></returns>
    public static string GetFileValidPath(string fileName, string suffix = "")
    {
        string retPath = "";
        string fileNameWithSuffix = fileName + suffix;
        if (File.Exists(Util.DataPath + fileNameWithSuffix))
        {
            retPath = Util.DataPath + fileNameWithSuffix;
        }
        else if (File.Exists(Util.AppContentPath + fileNameWithSuffix))
        {
            retPath = Util.AppContentPath + fileNameWithSuffix;
        }

        return retPath;
    }

    public static String RepaceFirstStr(String strText, String strSrc, String strDst)
    {
        int idx = strText.IndexOf(strSrc);
        if (idx >= 0)
        {
            strText = strText.Remove(idx, strSrc.Length);
            strText = strText.Insert(idx, strDst);
        }
        return strText;
    }

    public static void MakeLayerVisible(int layer)
    {
        if (Camera.main != null)
        {
            Camera.main.cullingMask |= (1 << layer);
        }      
    }

    public static void MakeLayerUnVisible(int layer)
    {
        if (Camera.main != null)
        {
            if (originCullingMask == 0)
            {
                originCullingMask = Camera.main.cullingMask;
            }

            Camera.main.cullingMask &= ~(1 << layer);
        }
    }

    public static void MakeOriginCullingMask()
    {
        if (originCullingMask != 0)
        {
            if (Camera.main != null)
            {
                Camera.main.cullingMask = originCullingMask;
            }       
        }      
    }

    public static Vector3[] GetVector3ArrayByTable(LuaTable table)
    {
        object[] arr = table.ToArray();
        Vector3[] vector3_arr = new Vector3[arr.Length];
        for (int i = 0; i < arr.Length; ++i)
        {
            vector3_arr[i] = (Vector3)arr[i];
        }
        return vector3_arr;
    }
}