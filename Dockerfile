# 阶段1：构建可执行二进制文件
FROM golang:1.20 AS builder

WORKDIR /app

# 复制模组文件并获取依赖
COPY go.mod go.sum ./
RUN go mod download

# 复制源码并构建
COPY . .
RUN go build -o /app/bin/app ./main.go  # 替换为你的主程序路径

# 阶段2：使用轻量镜像运行
FROM alpine:3.18

WORKDIR /app
COPY --from=builder /app/bin/app .

# 暴露端口（根据实际修改）
 EXPOSE 8080

# 运行二进制文件
CMD ["./app"]