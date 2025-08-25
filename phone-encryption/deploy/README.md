# 手机号加密项目部署包

这是一个可以直接运行的手机号加密工具，支持批量加密手机号和MD5值。

## 文件结构

```
deploy/
├── run-standalone.sh      # 独立运行脚本
├── target/                # 编译后的类文件
│   └── classes/
│       └── com/phone/encryption/*.class
└── README.md             # 本说明文件
```

## 运行要求

- Java 11 或更高版本
- Linux/macOS 系统（Windows系统需要修改脚本）

## 使用方法

1. 确保系统已安装Java 11+
2. 运行加密程序：

```bash
./run-standalone.sh <输入CSV文件> <手机号输出文件> <MD5输出文件>
```

### 示例

```bash
./run-standalone.sh test_phones_with_md5.csv encrypted_mobile.csv encrypted_md5.csv
```

## 输入文件格式

输入CSV文件应包含两列：
- 第一列：手机号
- 第二列：MD5值

示例：
```
13800138000,5f4dcc3b5aa765d61d8327deb882cf99
13900139000,e10adc3949ba59abbe56e057f20f883e
```

## 输出文件格式

程序会生成两个输出文件：
1. 手机号加密结果文件（只包含加密后的手机号）
2. MD5加密结果文件（只包含加密后的MD5值）

## 注意事项

- 程序会自动从Maven本地仓库查找依赖的jar包
- 如果依赖包不存在，脚本会显示警告但会继续运行
- 程序支持多线程处理，默认使用8个线程

## 性能

- 单线程处理速度：约 1000-2000 条/秒
- 多线程处理速度：约 8000-15000 条/秒（8线程）
- 支持处理上亿条数据
