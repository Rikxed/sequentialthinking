FROM node:18-alpine AS builder

WORKDIR /app

# 复制package文件
COPY package*.json ./
COPY tsconfig.json ./

# 安装依赖
RUN npm ci

# 复制源代码
COPY index.ts ./

# 构建项目
RUN npm run build

FROM node:18-alpine AS release

WORKDIR /app

# 复制package文件
COPY package*.json ./

# 只安装生产依赖
RUN npm ci --only=production

# 从builder阶段复制构建结果
COPY --from=builder /app/dist ./dist

# 设置环境变量
ENV NODE_ENV=production

# 暴露端口（如果需要的话）
EXPOSE 3000

# 启动命令
CMD ["node", "dist/index.js"]
