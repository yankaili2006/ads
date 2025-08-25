#!/bin/bash

# 测试部署包是否正常工作
set -e

echo "=== 测试部署包 ==="

# 解压部署包
echo "解压部署包..."
tar -xzf phone-encryption-deploy-1.0.0.tar.gz

# 进入部署目录
cd phone-encryption-deploy-1.0.0

echo "当前目录: $(pwd)"
echo "文件列表:"
ls -la

# 测试运行脚本
echo "测试运行脚本权限..."
chmod +x run-standalone.sh

echo "运行测试..."
./run-standalone.sh test_phones_with_md5.csv test_output_encrypted.csv test_output_md5.csv

# 检查输出文件
echo "检查输出文件..."
if [ -f "test_output_encrypted.csv" ] && [ -f "test_output_md5.csv" ]; then
    echo "✓ 输出文件创建成功"
    echo "加密文件行数: $(wc -l < test_output_encrypted.csv)"
    echo "MD5文件行数: $(wc -l < test_output_md5.csv)"
else
    echo "✗ 输出文件创建失败"
    exit 1
fi

echo "=== 测试完成 ==="
echo "部署包在Ubuntu环境下可以正常运行！"
