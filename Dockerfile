# 使用多阶段构建
# 阶段1：构建阶段
FROM golang:1.20 AS builder

# 设置Go环境变量（关键！）
ENV CGO_ENABLED 0
ENV GOPROXY https://goproxy.cn,direct

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
RUN apk update --no-cache && apk add --no-cache tzdata

WORKDIR /app

ADD go.mod .
ADD go.sum .
RUN go mod download
COPY . .


# 复制源代码并构建
RUN CGO_ENABLED=0 GOOS=linux go build -o /app/app .
RUN go build -ldflags="-s -w" -o /app/app ./main.go
# 阶段2：运行阶段（轻量级镜像）
FROM alpine:3.18

# 安装基础工具（如时区工具）
RUN apk add --no-cache tzdata && \
    ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone


FROM scratch
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=builder /usr/share/zoneinfo/Asia/Shanghai /usr/share/zoneinfo/Asia/Shanghai
ENV TZ Asia/Shanghai

WORKDIR /app
COPY --from=builder /app/app /app/app
# 暴露端口（根据实际修改）
EXPOSE 8080
# 启动应用
CMD ["./app"]