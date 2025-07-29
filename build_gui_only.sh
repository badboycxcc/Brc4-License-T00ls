#!/bin/bash

# GUI版本专用构建脚本
# 支持平台：Windows x86、macOS ARM64
# 不编译Linux版本，但提供编译脚本参考

echo "开始构建GUI版本..."
echo "目标平台：Windows x86、macOS ARM64"
echo ""

# 创建release目录
echo "创建release目录..."
mkdir -p release

# 清理之前的构建文件
echo "清理之前的构建文件..."
rm -f release/brc4_gui_*

# 1. 编译macOS ARM64版本
echo "1. 正在编译macOS ARM64版本..."
cd src
CGO_ENABLED=1 GOOS=darwin GOARCH=arm64 go build -o ../release/brc4_gui_darwin_arm64 .
if [ $? -eq 0 ]; then
    echo "✓ macOS ARM64版本编译成功: release/brc4_gui_darwin_arm64"
else
    echo "✗ macOS ARM64版本编译失败"
fi
cd ..

# 2. 编译Windows x86版本
echo "\n2. 正在编译Windows x86版本..."
if command -v x86_64-w64-mingw32-gcc &> /dev/null; then
    cd src
    CGO_ENABLED=1 GOOS=windows GOARCH=amd64 CC=x86_64-w64-mingw32-gcc go build -o ../release/brc4_gui_windows_amd64.exe .
    if [ $? -eq 0 ]; then
        echo "✓ Windows x86版本编译成功: release/brc4_gui_windows_amd64.exe"
    else
        echo "✗ Windows x86版本编译失败"
    fi
    cd ..
else
    echo "⚠ 跳过Windows编译 - 需要安装mingw-w64交叉编译工具"
    echo "  安装命令: brew install mingw-w64"
fi

echo "\n=== 构建完成 ==="
echo "生成的GUI版本 (存放在release目录):"
ls -la release/brc4_gui_* 2>/dev/null

echo "\n📱 可用的GUI版本:"
if [ -f "release/brc4_gui_darwin_arm64" ]; then
    echo "  - release/brc4_gui_darwin_arm64      - macOS ARM64 (Apple Silicon)"
fi
if [ -f "release/brc4_gui_windows_amd64.exe" ]; then
    echo "  - release/brc4_gui_windows_amd64.exe - Windows x86 64位"
fi

echo "\n📖 使用方法:"
echo "  macOS: ./release/brc4_gui_darwin_arm64"
echo "  Windows: release/brc4_gui_windows_amd64.exe"

echo "\n📋 Linux编译脚本参考 (需要在Linux系统上执行):"
echo "  # 在Linux系统上编译GUI版本"
echo "  cd src && go build -o ../release/brc4_gui_linux_amd64 ."
echo "  # 或使用Docker (需要Docker守护进程运行)"
echo "  docker run --rm -v \$(pwd):/app -w /app/src -e CGO_ENABLED=1 -e GOOS=linux -e GOARCH=amd64 golang:1.21-bullseye sh -c \"apt-get update && apt-get install -y libgl1-mesa-dev xorg-dev && go build -o ../release/brc4_gui_linux_amd64 .\""

echo "\n注意事项:"
echo "1. GUI版本依赖CGO和图形库"
echo "2. Windows版本可以直接运行"
echo "3. macOS版本针对Apple Silicon优化"
echo "4. Linux版本需要在Linux平台上编译或使用Docker"
echo "5. 所有二进制文件存放在release目录下"