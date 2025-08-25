#!/bin/bash

# 手机号加密项目独立运行脚本

echo "=== 手机号加密项目独立运行 ==="

# 检查Java是否安装
if ! command -v java &> /dev/null; then
    echo "错误: 未找到Java，请先安装Java 11或更高版本"
    exit 1
fi

# 检查参数
if [ $# -ne 3 ]; then
    echo "用法: $0 <输入CSV文件> <手机号输出文件> <MD5输出文件>"
    echo "示例: $0 test_phones_with_md5.csv encrypted_mobile.csv encrypted_md5.csv"
    exit 1
fi

INPUT_FILE=$1
MOBILE_OUTPUT=$2
MD5_OUTPUT=$3

# 检查输入文件是否存在
if [ ! -f "$INPUT_FILE" ]; then
    echo "错误: 输入文件 $INPUT_FILE 不存在"
    exit 1
fi

echo "输入文件: $INPUT_FILE"
echo "手机号输出: $MOBILE_OUTPUT"
echo "MD5输出: $MD5_OUTPUT"

# 设置classpath
CLASSPATH="target/classes"

# 添加commons-csv依赖
COMMONS_CSV_JAR=$(find ~/.m2/repository -name "commons-csv-1.10.0.jar" 2>/dev/null | head -1)
if [ -f "$COMMONS_CSV_JAR" ]; then
    CLASSPATH="$CLASSPATH:$COMMONS_CSV_JAR"
else
    echo "警告: 未找到commons-csv-1.10.0.jar，尝试使用lib目录中的版本"
    # 检查lib目录中是否有commons-csv
    if [ -f "lib/commons-csv-1.10.0.jar" ]; then
        CLASSPATH="$CLASSPATH:lib/commons-csv-1.10.0.jar"
    elif [ -f "lib/commons-csv.jar" ]; then
        CLASSPATH="$CLASSPATH:lib/commons-csv.jar"
    else
        echo "警告: lib目录中也未找到commons-csv jar文件"
    fi
fi

# 添加commons-io依赖
COMMONS_IO_JAR=$(find ~/.m2/repository -name "commons-io-2.15.1.jar" 2>/dev/null | head -1)
if [ -f "$COMMONS_IO_JAR" ]; then
    CLASSPATH="$CLASSPATH:$COMMONS_IO_JAR"
else
    echo "警告: 未找到commons-io-2.15.1.jar，尝试使用lib目录中的版本"
    # 检查lib目录中是否有commons-io
    if [ -f "lib/commons-io-2.15.1.jar" ]; then
        CLASSPATH="$CLASSPATH:lib/commons-io-2.15.1.jar"
    elif [ -f "lib/commons-io.jar" ]; then
        CLASSPATH="$CLASSPATH:lib/commons-io.jar"
    else
        echo "警告: lib目录中也未找到commons-io jar文件"
    fi
fi

echo "运行加密程序..."
java -cp "$CLASSPATH" com.phone.encryption.PhoneEncryptionApp "$INPUT_FILE" "$MOBILE_OUTPUT" "$MD5_OUTPUT"

if [ $? -eq 0 ]; then
    echo "加密完成！"
    echo "手机号加密结果: $MOBILE_OUTPUT"
    echo "MD5加密结果: $MD5_OUTPUT"
else
    echo "加密失败"
    exit 1
fi
