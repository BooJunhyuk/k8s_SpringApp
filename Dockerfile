# 1. 빌드 단계
FROM openjdk:17-slim AS build
WORKDIR /app

# 애플리케이션 JAR 파일을 이미지로 복사
COPY SpringApp-0.0.1-SNAPSHOT.jar app.jar

# 2. 실행 단계
FROM openjdk:17-slim
WORKDIR /app

# 첫 번째 빌드 단계의 JAR 파일을 복사
COPY --from=build /app/app.jar app.jar

# JVM 최적화 옵션 추가 및 애플리케이션 실행
ENTRYPOINT ["java", "-XX:+UnlockExperimentalVMOptions", "-XX:+UseContainerSupport", "-XX:MaxRAMPercentage=75.0", "-jar", "app.jar"]
