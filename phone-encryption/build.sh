#!/bin/bash

# 手机号加密项目构建脚本

echo "=== 手机号加密项目构建脚本 ==="

# 检查Java是否安装
if ! command -v java &> /dev/null; then
    echo "错误: 未找到Java，请先安装Java 11或更高版本"
    exit 1
fi

# 检查Maven是否安装
if command -v mvn &> /dev/null; then
    echo "使用Maven构建项目..."
    mvn clean compile
    if [ $? -eq 0 ]; then
        echo "编译成功！"
        echo "打包可执行JAR..."
        mvn package
        if [ $? -eq 0 ]; then
            echo "构建完成！可执行JAR位于: target/phone-encryption-1.0-SNAPSHOT-jar-with-dependencies.jar"
        else
            echo "打包失败"
        fi
    else
        echo "编译失败"
    fi
else
    echo "警告: 未找到Maven，尝试手动编译..."
    
    # 创建classes目录
    mkdir -p target/classes
    
    # 手动编译Java文件（指定Java 17兼容性）
    echo "编译Java源文件..."
    javac -cp "lib/*" -d target/classes -source 17 -target 17 src/main/java/com/phone/encryption/*.java
    
    if [ $? -eq 0 ]; then
        echo "编译成功！"
        echo "创建可执行JAR..."
        
        # 创建manifest文件
        echo "Main-Class: com.phone.encryption.PhoneEncryptionApp" > manifest.txt
        echo "Class-Path: lib/adex-platform-udf-1.0.0-jar-with-dependencies.jar" >> manifest.txt
        
        # 创建JAR文件
        jar cfm target/phone-encryption.jar manifest.txt -C target/classes .
        
        if [ $? -eq 0 ]; then
            echo "JAR创建成功！可执行文件位于: target/phone-encryption.jar"
            echo "注意：运行前请确保第三方jar包在lib目录中"
        else
            echo "JAR创建失败"
        fi
        
        # 清理临时文件
        rm manifest.txt
    else
        echo "编译失败"
    fi
fi

echo "=== 构建脚本完成 ==="
