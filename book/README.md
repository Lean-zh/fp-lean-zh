# Lean 函数式编程（中文翻译）

这是《Functional Programming in Lean》的中文翻译版本，已从原mdbook框架迁移到verso框架。

## 项目结构

- `book/` - 使用verso框架的主要书籍内容
  - `FPLeanZh.lean` - 主文档文件
  - `FPLeanZh/` - 各章节的.lean文件
  - `lakefile.toml` - Lake项目配置
  - `lean-toolchain` - Lean版本规范（4.20.0）
- `examples/` - 代码示例（从原项目复制）
- `functional-programming-lean/` - 旧的mdbook版本（保留作为参考）

## 翻译规范

本项目采用注释原文、保留译文的翻译格式：
```lean
-- Original English text
对应的中文翻译
```

## 构建

```bash
cd book
lake update
lake build
```

## 开发环境

- Lean 4.20.0
- Verso（通过Lake管理）

## 贡献

欢迎贡献翻译！请参考各章节的占位符文件，将英文原文以注释形式保留，并添加对应的中文翻译。

## 译者

- Oling Cat
- Qiu233
- JiechengZhao

## 许可

本书采用知识共享署名 4.0 国际许可协议。
