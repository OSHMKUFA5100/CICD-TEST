# 阶段 1: 构建阶段 (使用大镜像，包含编译工具)
FROM golang:1.21-alpine AS builder

# 设置工作目录
WORKDIR /app

# 复制 Go 模块文件 (如果存在 go.mod/go.sum)
# COPY go.mod ./
# COPY go.sum ./

# 复制主文件
COPY . ./

# 编译应用程序
# CGO_ENABLED=0 禁止 C 库链接，生成完全静态的二进制文件，更具可移植性
RUN CGO_ENABLED=0 go build -ldflags "-s -w" -o /go-app main.go


# 阶段 2: 运行阶段 (使用小镜像，只包含必要的运行环境)
FROM alpine:latest

# 设置工作目录
WORKDIR /root/

# 从构建阶段复制编译好的二进制文件
COPY --from=builder /hello .

# 暴露端口
EXPOSE 8080

# 启动应用程序
CMD ["./hello"]