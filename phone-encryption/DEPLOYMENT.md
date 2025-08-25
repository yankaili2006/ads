# 部署指南

## 前置要求

1. **Java 11+**: 确保系统已安装Java 11或更高版本
2. **第三方JAR包**: 获取 `adex-platform-udf-1.0.0-jar-with-dependencies.jar`
3. **Maven (可选)**: 如果使用Maven构建

## 快速开始

### 步骤1: 准备第三方JAR包

将第三方加密JAR包放入lib目录：

```bash
cd phone-encryption
mkdir -p lib
# 将 adex-platform-udf-1.0.0-jar-with-dependencies.jar 复制到 lib/ 目录
```

### 步骤2: 构建项目

**方法A: 使用Maven (推荐)**
```bash
mvn clean package
```

**方法B: 使用构建脚本**
```bash
./build.sh
```

### 步骤3: 准备输入数据

创建包含手机号的CSV文件，每行一个手机号：

```csv
13800138000
13900139000
15000150000
...
```

### 步骤4: 运行加密

```bash
# 使用Maven构建的JAR
java -jar target/phone-encryption-1.0-SNAPSHOT-jar-with-dependencies.jar input.csv output.csv

# 或使用手动构建的JAR
java -jar target/phone-encryption.jar input.csv output.csv
```

### 步骤5: 验证结果

输出文件将包含两列：原手机号和加密结果

## 性能优化建议

### 对于1亿行数据处理

1. **内存配置**: 增加JVM堆内存
   ```bash
   java -Xmx8g -jar target/phone-encryption.jar input.csv output.csv
   ```

2. **批量处理**: 程序已内置批量处理机制，每10000条记录输出进度

3. **磁盘IO**: 使用SSD存储提高读写速度

4. **CPU优化**: 程序自动使用所有可用CPU核心

### 监控进度

程序会定期输出处理进度：
```
Processed 10000 records
Processed 20000 records
...
```

## 错误处理

### 常见问题

1. **ClassNotFoundException**: 确保第三方JAR包在lib目录中
2. **OutOfMemoryError**: 增加JVM堆内存 (-Xmx)
3. **文件不存在**: 检查输入文件路径
4. **权限问题**: 确保有输出文件的写入权限

### 日志查看

程序会输出错误信息到控制台，加密失败的行会跳过并继续处理。

## 生产环境部署

### 服务器要求

- **CPU**: 多核心处理器 (8核以上推荐)
- **内存**: 16GB+ RAM (根据数据量调整)
- **存储**: SSD硬盘，足够的空间存储输入输出文件
- **网络**: 如果需要从远程获取数据

### 部署步骤

1. 将构建好的JAR文件复制到服务器
2. 创建lib目录并放入第三方JAR包
3. 准备输入数据文件
4. 运行加密程序
5. 验证输出结果

### 批量处理脚本示例

```bash
#!/bin/bash
# batch_process.sh

INPUT_DIR="/data/input"
OUTPUT_DIR="/data/output"
JAR_FILE="/app/phone-encryption.jar"

for file in $INPUT_DIR/*.csv; do
    filename=$(basename "$file")
    output_file="$OUTPUT_DIR/encrypted_$filename"
    
    echo "Processing $filename -> $output_file"
    java -Xmx8g -jar "$JAR_FILE" "$file" "$output_file"
    
    if [ $? -eq 0 ]; then
        echo "Completed: $filename"
    else
        echo "Failed: $filename"
    fi
done
```

## 监控和维护

### 监控指标

- 处理速度 (记录/秒)
- 内存使用情况
- CPU利用率
- 磁盘IO

### 日志管理

建议重定向输出到日志文件：
```bash
java -jar phone-encryption.jar input.csv output.csv 2>&1 | tee processing.log
```

## 故障排除

### 性能问题

如果处理速度慢：
1. 检查磁盘IO性能
2. 增加JVM内存
3. 确认CPU没有其他高负载任务

### 内存问题

如果出现内存不足：
```bash
# 增加堆内存
java -Xmx16g -jar phone-encryption.jar input.csv output.csv

# 使用G1垃圾收集器
java -Xmx16g -XX:+UseG1GC -jar phone-encryption.jar input.csv output.csv
```

### 数据完整性

处理完成后建议验证：
1. 输出文件行数应与输入文件相同（减去错误行）
2. 随机抽样验证加密结果
