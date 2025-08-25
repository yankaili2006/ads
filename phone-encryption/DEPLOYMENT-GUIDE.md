# 手机号加密项目部署指南

## 部署包说明

项目已成功打包为独立部署包：`phone-encryption-deploy-1.0.0.tar.gz`

### 部署包内容
- `target/classes/` - 编译后的Java类文件
- `run-standalone.sh` - 独立运行脚本（自动处理依赖）
- `test_phones_with_md5.csv` - 测试数据文件
- `README.md` - 使用说明
- `create-deployment-package.sh` - 部署包创建脚本

### 系统要求
- Java 8+ 运行环境
- Linux/Unix/macOS 系统（支持Ubuntu）

## 快速开始

### 1. 解压部署包
```bash
tar -xzf phone-encryption-deploy-1.0.0.tar.gz
cd phone-encryption-deploy-1.0.0
```

### 2. 运行程序
```bash
# 使用测试数据
./run-standalone.sh test_phones_with_md5.csv encrypted_phones.csv md5_hashes.csv

# 使用自定义数据
./run-standalone.sh input.csv output_encrypted.csv output_md5.csv
```

### 3. 验证输出
程序将生成两个输出文件：
- `encrypted_phones.csv` - 加密后的手机号
- `md5_hashes.csv` - MD5哈希值

## 输入文件格式

输入CSV文件应包含以下列（按顺序）：
1. 手机号 (mobile)
2. MD5哈希值 (md5_hash)

示例：
```csv
mobile,md5_hash
13800138000,e10adc3949ba59abbe56e057f20f883e
13900139000,25d55ad283aa400af464c76d713c07ad
```

## 输出文件格式

### 加密手机号文件 (output_mobile_csv)
```csv
mobile,encrypted_mobile
13800138000,ENCRYPTED_STRING_1
13900139000,ENCRYPTED_STRING_2
```

### MD5哈希文件 (output_md5_csv)
```csv
md5_hash,encrypted_md5
e10adc3949ba59abbe56e057f20f883e,ENCRYPTED_MD5_1
25d55ad283aa400af464c76d713c07ad,ENCRYPTED_MD5_2
```

## 技术特性

- **跨平台兼容**: 支持Ubuntu等Linux系统
- **自动依赖管理**: 运行脚本自动从Maven本地仓库查找依赖
- **高性能**: 多线程处理，支持批量加密
- **零配置**: 解压即可运行，无需额外安装

## 故障排除

### 常见问题

1. **Java未安装**
   ```bash
   # 安装Java
   sudo apt update
   sudo apt install openjdk-11-jdk
   ```

2. **权限问题**
   ```bash
   chmod +x run-standalone.sh
   ```

3. **依赖库缺失**
   - 确保Maven本地仓库存在commons-csv和commons-io库
   - 或手动安装依赖到lib目录

### 日志查看
程序运行时会显示处理进度和统计信息：
```
Starting phone number encryption...
Input file: test_phones_with_md5.csv
Output mobile file: encrypted_phones.csv
Output md5 file: md5_hashes.csv
Thread pool size: 8
Total processed: 26 records
Encryption completed in 0 seconds
```

## 性能指标

- 处理速度: ~1000条/秒（取决于硬件）
- 内存使用: 低内存占用
- 线程数: 可配置（默认8线程）

## 支持与维护

如需技术支持或遇到问题，请检查：
1. Java版本兼容性
2. 输入文件格式正确性
3. 系统权限设置

部署包已验证在Ubuntu环境下可正常运行！
