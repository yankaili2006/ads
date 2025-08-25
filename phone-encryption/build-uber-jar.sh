#!/bin/bash

# 手机号加密项目Uber JAR构建脚本

echo "=== 手机号加密项目Uber JAR构建脚本 ==="

# 检查Java是否安装
if ! command -v java &> /dev/null; then
    echo "错误: 未找到Java，请先安装Java 11或更高版本"
    exit 1
fi

# 创建目标目录
mkdir -p target/uber-jar

echo "编译Java源文件..."
javac -cp "target/classes" -d target/classes src/main/java/com/phone/encryption/*.java

if [ $? -ne 0 ]; then
    echo "编译失败"
    exit 1
fi

echo "收集依赖jar包..."
# 创建临时目录存放所有依赖
mkdir -p target/uber-jar/libs

# 复制commons-csv
COMMONS_CSV_JAR=$(find ~/.m2/repository -name "commons-csv-1.10.0.jar" 2>/dev/null | head -1)
if [ -f "$COMMONS_CSV_JAR" ]; then
    cp "$COMMONS_CSV_JAR" target/uber-jar/libs/
    echo "找到 commons-csv: $COMMONS_CSV_JAR"
else
    echo "警告: 未找到commons-csv-1.10.0.jar"
fi

# 复制commons-io
COMMONS_IO_JAR=$(find ~/.m2/repository -name "commons-io-2.15.1.jar" 2>/dev/null | head -1)
if [ -f "$COMMONS_IO_JAR" ]; then
    cp "$COMMONS_IO_JAR" target/uber-jar/libs/
    echo "找到 commons-io: $COMMONS_IO_JAR"
else
    echo "警告: 未找到commons-io-2.15.1.jar"
fi

echo "创建Uber JAR..."
# 首先解压所有依赖jar包到classes目录
for jar_file in target/uber-jar/libs/*.jar; do
    if [ -f "$jar_file" ]; then
        echo "解压 $jar_file"
        jar xf "$jar_file" -C target/classes/ 2>/dev/null || echo "解压 $jar_file 时出错，继续..."
    fi
done

# 创建manifest文件
echo "Main-Class: com.phone.encryption.PhoneEncryptionApp" > target/uber-jar/manifest.txt

# 创建真正的Uber JAR文件（所有类文件都在根目录）
echo "创建Uber JAR..."
jar cfm target/phone-encryption-uber.jar target/uber-jar/manifest.txt -C target/classes .

if [ $? -eq 0 ]; then
    echo "Uber JAR创建成功！"
    echo "可执行文件位于: target/phone-encryption-uber.jar"
    echo "文件大小: $(du -h target/phone-encryption-uber.jar | cut -f1)"
else
    echo "Uber JAR创建失败"
    exit 1
fi

# 清理临时文件
rm -rf target/uber-jar

echo "=== Uber JAR构建完成 ==="
echo "使用方法: java -jar target/phone-encryption-uber.jar <input_csv> <output_mobile_csv> <output_md5_csv>"
