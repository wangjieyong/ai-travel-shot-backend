# 使用官方Python基础镜像
FROM python:3.10-slim

# 安装 rembg 和 Pillow 所需的系统依赖
# 注意：这可以解决容器启动时依赖缺失的问题
RUN apt-get update && apt-get install -y \
    libjpeg-dev \
    zlib1g-dev \
    libpng-dev \
    netcat-traditional \
    && rm -rf /var/lib/apt/lists/*

# 设置工作目录
WORKDIR /app

# 拷贝 requirements.txt 并安装Python依赖
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# 拷贝整个应用代码
COPY . .

# 暴露端口，Cloud Run默认使用8080
ENV PORT 8080
EXPOSE $PORT

# 启动Uvicorn服务器
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]