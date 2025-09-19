# 使用官方Python 3.10 slim版基础镜像
FROM python:3.10-slim

# 安装 rembg 和 Pillow 所需的系统依赖
# 这些库是进行图像处理和背景移除所必需的
RUN apt-get update && apt-get install -y \
    libjpeg-dev \
    zlib1g-dev \
    libpng-dev \
    netcat-traditional \
    && rm -rf /var/lib/apt/lists/*

# 设置容器内的工作目录
WORKDIR /app

# 将 requirements.txt 拷贝到容器中，并安装所有Python依赖
# --no-cache-dir 标志可以减少镜像大小
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# 将所有应用代码拷贝到容器中
COPY . .

# 暴露端口，Cloud Run 默认使用 8080 端口
ENV PORT 8080
EXPOSE $PORT

# 启动 Uvicorn 服务器来运行你的 FastAPI 应用
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]