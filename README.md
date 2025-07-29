# Brc4 License Tool

**By T00ls - cxaqhq**

一个用于生成和解析许可证文件的工具，提供图形用户界面（GUI）和命令行界面（CLI）两种操作模式。

## 功能特性

- **许可证生成**: 根据用户信息、日期范围和原始xmodlib.bin文件生成加密的许可证文件
- **许可证解析**: 解析现有的许可证文件，显示其中包含的信息
- **双模式支持**: 支持GUI和CLI两种操作模式
- **现代化界面**: GUI模式提供直观易用的图形界面

## 项目结构

```
.
├── src/                    # 源代码目录
│   ├── go.mod             # Go模块文件
│   ├── go.sum             # Go依赖校验文件
│   ├── main.go            # 主程序入口
│   ├── gui.go             # GUI界面实现
│   ├── lic.go             # 许可证处理逻辑
│   └── myaes.go           # AES加密实现
├── release/               # 编译输出目录
│   ├── brc4_gui_darwin_arm64      # macOS ARM64版本
│   └── brc4_gui_windows_amd64.exe # Windows 64位版本
├── build_gui_only.sh      # GUI版本构建脚本
└── README.md              # 项目说明文档
```

## 编译

### 一键编译GUI版本（推荐）

使用构建脚本可以编译Windows和macOS平台的GUI版本：

```bash
./build_gui_only.sh
```

这将生成：
- **macOS ARM64版本**: `release/brc4_gui_darwin_arm64` (Apple Silicon)
- **Windows 64位版本**: `release/brc4_gui_windows_amd64.exe`
- **Linux版本**: 提供编译脚本参考（需要在Linux平台上编译）

### 单独编译

#### 本地平台编译
```bash
cd src
go build -o ../release/brc4_gui .
```

#### 跨平台GUI编译

由于GUI版本依赖CGO，跨平台编译有一定限制：

**Windows版本**（需要mingw-w64）：
```bash
# 安装mingw-w64（如果未安装）
# macOS: brew install mingw-w64
# Ubuntu: sudo apt-get install gcc-mingw-w64

# 编译Windows版本
cd src
CGO_ENABLED=1 GOOS=windows GOARCH=amd64 CC=x86_64-w64-mingw32-gcc go build -o ../release/brc4_gui_windows_amd64.exe .
```

**Linux版本**（建议在Linux平台上编译）：
```bash
# 在Linux上编译
cd src
go build -o ../release/brc4_gui_linux_amd64 .
GOARCH=arm64 go build -o ../release/brc4_gui_linux_arm64 .
```

**注意**：GUI版本的跨平台编译比CLI版本复杂，建议在目标平台上直接编译或使用提供的构建脚本。

#### 支持的平台和架构

- **Windows**: AMD64 (x86_64)
- **Linux**: AMD64 (x86_64) - 需要在Linux平台编译
- **macOS**: ARM64 (Apple Silicon)

## 使用说明图片

以下是GUI界面的使用说明截图，按照操作顺序展示：

### 1. 主界面
![主界面](截屏2025-07-29%20下午8.16.05.png)

### 2. 生成许可证界面
![生成许可证界面](截屏2025-07-29%20下午8.16.12.png)

### 3. 解析许可证界面
![解析许可证界面](截屏2025-07-29%20下午8.16.28.png)

## 使用方法

### GUI模式（推荐）

#### 启动GUI
```bash
# macOS ARM64版本
./release/brc4_gui_darwin_arm64

# Windows版本
./release/brc4_gui_windows_amd64.exe

# 或者明确指定GUI模式
./release/brc4_gui_darwin_arm64 gui
```

GUI模式提供两个主要功能标签页：

#### 1. 生成许可证
- **日期设置**: 设置许可证的开始和结束日期（格式：MM-DD-YYYY）
- **用户信息**: 输入用户名、邮箱和标记信息
- **许可证设置**: 
  - 设置16字节的许可证密钥
  - 选择原始xmodlib.bin文件
  - 指定输出文件路径
- 点击"生成许可证"按钮完成生成

#### 2. 解析许可证
- 选择要解析的许可证文件（.bin格式）
- 点击"解析许可证"按钮
- 查看解析结果，包括：
  - 开始日期和结束日期
  - 用户名和邮箱
  - 标记信息

### CLI模式

#### 生成许可证
```bash
./release/brc4_gui_darwin_arm64 gen \
  --date-start "01-01-2024" \
  --date-end "12-31-2024" \
  --user "用户名" \
  --email "user@example.com" \
  --payloads "xmodlib.bin" \
  --output "new_license.bin" \
```

#### 解析许可证
```bash
./release/brc4_gui_darwin_arm64 dec --input "license.bin"
```

#### 查看帮助
```bash
# 查看总体帮助
./release/brc4_gui_darwin_arm64

# 查看生成命令帮助
./release/brc4_gui_darwin_arm64 gen --help

# 查看解析命令帮助
./release/brc4_gui_darwin_arm64 dec --help
```

## 参数说明

### 生成许可证参数
- `--date-start`: 开始日期（MM-DD-YYYY格式，默认为当前日期）
- `--date-end`: 结束日期（MM-DD-YYYY格式，必需）
- `--user`: 用户名（必需）
- `--email`: 邮箱地址（必需）
- `--payloads`: 原始xmodlib.bin文件路径（必需）
- `--output`: 输出文件路径（默认："new_xmodlib.bin"）

### 解析许可证参数
- `--input`: 输入的许可证文件路径（默认："xmodlib.bin"）

## 文件格式

- **输入文件**: 原始xmodlib.bin文件（二进制格式）
- **输出文件**: 加密的许可证文件（.bin格式）
- **许可证文件**: 包含用户信息和时间限制的加密文件

## 注意事项

1. **日期格式**: 所有日期必须使用MM-DD-YYYY格式
2. **密钥长度**: 许可证密钥必须恰好是16字节
3. **文件权限**: 确保对输入文件有读取权限，对输出目录有写入权限
4. **原始xmodlib.bin文件**: 生成许可证时需要提供有效的原始xmodlib.bin文件

## 技术特性

- **加密算法**: 使用AES-128-ECB加密
- **GUI框架**: 基于Fyne v2构建的现代化界面
- **跨平台**: 支持Windows、macOS和Linux
- **文件对话框**: 支持图形化文件选择
- **错误处理**: 完善的错误提示和验证机制

## 开发信息

- **开发者**: T00ls - cxaqhq
- **语言**: Go
- **GUI框架**: Fyne v2
- **Go版本**: 1.18+
