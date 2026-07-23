# Step1
# Build the Frontend
# Stage 1: Build React Frontend
FROM node:16-alpine AS frontend-builder
WORKDIR /app/frontend
COPY frontend/package*.json ./
RUN npm install && npm install axios
COPY frontend/ ./
RUN npm run build

# Stage 2: Build Backend + Serve Frontend
FROM node:16-alpine AS runner
WORKDIR /app
COPY backend/package*.json ./
RUN npm install --production
COPY --from=frontend-builder /app/frontend/build ./frontend/build
COPY backend/ ./
EXPOSE 5000
CMD ["node", "server.js"]