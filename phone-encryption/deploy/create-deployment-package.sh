#!/bin/bash

# 创建跨平台部署包打包脚本
# 用法: ./create-deployment-package.sh [版本号]

set -e

# 获取版本号
VERSION=${1:-1.0.0}
PACKAGE_NAME="phone-encryption-deploy-${VERSION}"

echo "正在创建跨平台部署包: ${PACKAGE_NAME}"

# 获取当前脚本所在目录
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DEPLOY_DIR="${SCRIPT_DIR}"
PARENT_DIR="$(dirname "${DEPLOY_DIR}")"

# 创建临时目录
TEMP_DIR=$(mktemp -d)
echo "使用临时目录: ${TEMP_DIR}"

# 复制部署文件到临时目录
echo "复制部署文件..."
cp -r "${DEPLOY_DIR}" "${TEMP_DIR}/${PACKAGE_NAME}"

# 确保运行脚本有执行权限
chmod +x "${TEMP_DIR}/${PACKAGE_NAME}/run-standalone.sh"

# 进入临时目录
cd "${TEMP_DIR}"

# 创建压缩包 (使用相对路径确保跨平台兼容性)
echo "创建压缩包..."
tar -czf "${PACKAGE_NAME}.tar.gz" "${PACKAGE_NAME}"

# 移动压缩包到父目录
mv "${PACKAGE_NAME}.tar.gz" "${PARENT_DIR}/"

# 清理临时目录
echo "清理临时文件..."
rm -rf "${TEMP_DIR}"

echo "部署包创建完成: ${PARENT_DIR}/${PACKAGE_NAME}.tar.gz"
echo ""
echo "使用方法:"
echo "1. 解压: tar -xzf ${PACKAGE_NAME}.tar.gz"
echo "2. 进入目录: cd ${PACKAGE_NAME}"
echo "3. 运行程序: ./run-standalone.sh input.csv output_encrypted.csv output_md5.csv"
echo ""
echo "或者直接运行: ./run-standalone.sh test_phones_with_md5.csv encrypted_phones.csv md5_hashes.csv"
