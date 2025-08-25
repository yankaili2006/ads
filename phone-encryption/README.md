# 手机号加密项目

这是一个Java项目，用于对1亿行手机号数据进行ECDH加密。

## 功能特性

- 使用第三方jar包 `adex-platform-udf-1.0.0-jar-with-dependencies.jar` 进行加密
- 支持多线程处理，提高处理1亿行数据的性能
- 输入输出均为CSV格式
- 使用固定的ECDH私钥进行加密

## 项目结构

```
phone-encryption/
├── src/main/java/com/phone/encryption/
│   ├── EcdhEncUdfWrapper.java    # 第三方jar包包装类
│   ├── PhoneEncryptionApp.java   # 主应用程序
│   └── EcdhEncUdf.java           # 原有的加密实现（可选）
├── lib/
│   └── adex-platform-udf-1.0.0-jar-with-dependencies.jar  # 第三方加密jar包
├── pom.xml                       # Maven配置文件
└── README.md                     # 项目说明
```

## 安装依赖

1. 将第三方jar包 `adex-platform-udf-1.0.0-jar-with-dependencies.jar` 放入 `lib/` 目录
2. 使用Maven编译项目：
   ```bash
   mvn clean compile
   ```

## 构建可执行JAR

```bash
mvn clean package
```

这将在 `target/` 目录生成 `phone-encryption-1.0-SNAPSHOT-jar-with-dependencies.jar`

## 使用方法

### 基本用法

```bash
java -jar target/phone-encryption-1.0-SNAPSHOT-jar-with-dependencies.jar input.csv output.csv
```

### 参数说明

- `input.csv`: 输入CSV文件，每行包含一个手机号
- `output.csv`: 输出CSV文件，每行包含原手机号和加密后的结果

### 输入文件格式

输入CSV文件应该包含手机号，每行一个：

```
13800138000
13900139000
15000150000
...
```

### 输出文件格式

输出CSV文件将包含两列：原手机号和加密后的结果：

```
13800138000,encrypted_string_1
13900139000,encrypted_string_2
15000150000,encrypted_string_3
...
```

## 加密算法

使用ECDH加密算法，固定私钥：
`3737899807937706933536983736398972767192608452658617578224077173161969606234`

## 性能优化

- 多线程处理：使用线程池并行处理数据
- 批量处理：每处理10000条记录输出进度信息
- 内存优化：使用流式处理避免内存溢出

## 注意事项

1. 确保第三方jar包已放置在 `lib/` 目录
2. 输入文件应为UTF-8编码
3. 处理1亿行数据可能需要较长时间，建议在性能较好的服务器上运行
4. 输出文件会实时写入，确保有足够的磁盘空间

## 错误处理

- 程序会跳过空行和格式错误的行
- 加密失败的行会输出错误信息但继续处理
- 程序会定期输出处理进度

## 版本信息

- Java版本: 11+
- Maven版本: 3.6+
- 第三方jar: adex-platform-udf-1.0.0
