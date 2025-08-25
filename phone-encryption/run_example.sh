#!/bin/bash

# 手机号加密项目运行示例

echo "=== 手机号加密项目运行示例 ==="

# 检查是否已构建
if [ ! -f "target/phone-encryption-1.0-SNAPSHOT-jar-with-dependencies.jar" ] && [ ! -f "target/phone-encryption.jar" ]; then
    echo "未找到可执行JAR文件，请先运行 build.sh 构建项目"
    exit 1
fi

# 检查测试文件是否存在
if [ ! -f "test_phones.csv" ]; then
    echo "测试文件 test_phones.csv 不存在"
    exit 1
fi

# 检查lib目录和第三方jar包
if [ ! -d "lib" ]; then
    echo "警告: lib目录不存在，请创建并放入第三方jar包"
    mkdir -p lib
    echo "请将 adex-platform-udf-1.0.0-jar-with-dependencies.jar 放入 lib/ 目录后重新运行"
    exit 1
fi

if [ ! -f "lib/adex-platform-udf-1.0.0-jar-with-dependencies.jar" ]; then
    echo "错误: 未找到第三方jar包 lib/adex-platform-udf-1.0.0-jar-with-dependencies.jar"
    echo "请将第三方jar包放入lib目录后重新运行"
    exit 1
fi

echo "开始加密测试数据..."

# 确定使用哪个JAR文件
if [ -f "target/phone-encryption-1.0-SNAPSHOT-jar-with-dependencies.jar" ]; then
    JAR_FILE="target/phone-encryption-1.0-SNAPSHOT-jar-with-dependencies.jar"
elif [ -f "target/phone-encryption.jar" ]; then
    JAR_FILE="target/phone-encryption.jar"
fi

# 运行加密程序
echo "运行加密程序..."
java -jar "$JAR_FILE" test_phones.csv encrypted_phones.csv

if [ $? -eq 0 ]; then
    echo "加密完成！"
    echo "查看加密结果:"
    echo "=== 加密结果前10行 ==="
    head -n 10 encrypted_phones.csv
    echo "======================"
    echo "加密结果保存到: encrypted_phones.csv"
else
    echo "加密过程中出现错误"
fi

echo "=== 运行示例完成 ==="
