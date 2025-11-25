# 使用多阶段构建
# 阶段1：构建阶段
FROM golang:1.20 AS builder

# 设置Go环境变量（关键！）
ENV GO111MODULE=on \
    GOPROXY=https://goproxy.cn,direct \
    GONOSUMDB=*

WORKDIR /app

# 复制并下载依赖（利用Docker缓存机制）
COPY go.mod go.sum ./
RUN go mod download

# 复制源代码并构建
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o /app/app .

# 阶段2：运行阶段（轻量级镜像）
FROM alpine:3.18

# 安装基础工具（如时区工具）
RUN apk add --no-cache tzdata && \
    ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone

# 从builder阶段复制二进制文件
COPY --from=builder /app/app /app/

# 设置工作目录
WORKDIR /app

# 暴露端口（根据实际修改）
EXPOSE 8080

# 启动应用
CMD ["./app"]