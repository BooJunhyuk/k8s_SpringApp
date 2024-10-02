# K8S_SpringApp
<!-- Add Image Here -->

여기에 아키텍처 이미지 추가

<!-- Add Badge Here (https://shields.io/) -->

<!-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -->


## 목적

어쩌구저쩌구


## Getting Started
### Docker
**docker image build**

```bash
docker build -t springapp:0.0.1 .
```

```bash
[+] Building 0.6s (9/9) FINISHED                                                                                        docker:default
 => [internal] load build definition from Dockerfile                                                                              0.0s
 => => transferring dockerfile: 537B                                                                                              0.0s
 => [internal] load metadata for docker.io/library/openjdk:17-slim                                                                0.0s
 => [internal] load .dockerignore                                                                                                 0.0s
 => => transferring context: 2B                                                                                                   0.0s
 => [internal] load build context                                                                                                 0.2s
 => => transferring context: 20.04MB                                                                                              0.2s
 => [build 1/3] FROM docker.io/library/openjdk:17-slim                                                                            0.0s
 => CACHED [build 2/3] WORKDIR /app                                                                                               0.0s
 => [build 3/3] COPY SpringApp-0.0.1-SNAPSHOT.jar app.jar                                                                         0.1s
 => [stage-1 3/3] COPY --from=build /app/app.jar app.jar                                                                          0.1s
 => exporting to image                                                                                                            0.1s
 => => exporting layers                                                                                                           0.1s
 => => writing image sha256:c2011c012282b25ae1beb42df8620b9604b0a3df5584e2e3bc4d87289ea4ad02                                      0.0s
 => => naming to docker.io/library/springapp:0.0.1                                                                                0.0s
```

**docker login 확인**

```bash
docker login
```

```bash
Authenticating with existing credentials...
WARNING! Your password will be stored unencrypted in /home/ubuntu/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credential-stores

Login Succeeded
```

**docker image에 tag 설정**

```bash
docker tag springapp:0.0.1 boo811/springapp:0.0.1
```

**dockerhub에 push**

```bash
docker push boo811/springapp:0.0.1
```

```bash
The push refers to repository [docker.io/boo811/springapp]
1520d62c1def: Pushed 
b2ab99759f68: Pushed 
6be690267e47: Mounted from library/openjdk 
13a34b6fff78: Mounted from library/openjdk 
9c1b6dd6c1e6: Mounted from library/openjdk 
0.0.1: digest: sha256:831ea5a30eac0d950e28c5bb9e19742c8930f58068b4a367163f6dd658ab03c3 size: 1371
```

![image](https://github.com/user-attachments/assets/d7cff05a-fe43-4df7-9c3c-a0450cec4517)

<!-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -->

## K8S

**deployment 적용**

```bash
kubectl apply -f deployment.yaml
```
생성
```bash
deployment.apps/springapp-deployment created
```

**service 적용**

```bash
kubectl apply -f service.yaml
```
생성
```bash
service/springapp-service created
```
<!-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -->
## Check

**확인 내용**

deployment.yaml의 생성할 파드의 개수
```
replicas: 3
```
pod 3개 맞는지 check

service의 External-ip가 설정되어 있는지 check

```bash
kubectl get all
```

![image 1](https://github.com/user-attachments/assets/0b528b90-d569-4d1e-aa90-2603491abf0e)


**배포상태확인**

```bash
kubectl logs springapp-deployment-9758bbc6b-4h2w7
kubectl logs springapp-deployment-9758bbc6b-4l2zf
kubectl logs springapp-deployment-9758bbc6b-dsmg6
```

![image 2](https://github.com/user-attachments/assets/e8e10d65-507c-47ad-b6de-20999497ff73)


![image 3](https://github.com/user-attachments/assets/cef0e69f-b91c-4aa7-937c-ff0b9032d647)


![image 4](https://github.com/user-attachments/assets/ad01741d-11a0-495f-a223-c0408a6ce684)


**vscode사용 시 port 추가**

![image 5](https://github.com/user-attachments/assets/aa013759-c85d-4512-8eb6-0c54f0075e8f)


**localhost:80/test로 접속**

![image 6](https://github.com/user-attachments/assets/3bc7567c-7d64-4c82-b8d7-65072560ef5d)



**워크로드 페이지**

![image 7](https://github.com/user-attachments/assets/85357e56-68d0-4a91-9784-de296a809175)


![image 8](https://github.com/user-attachments/assets/f9e0daf5-59bf-4f86-9cb4-736d077a334b)



## 트러블슈팅
<!-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -->
service.yaml 파일의 targetPort를 8080으로 해서 localhost에 접속이 불가능

```bash
apiVersion: v1
kind: Service
metadata:
  name: springapp-service
spec:
  selector:
    app: springapp
  ports:
    - protocol: TCP
      port: 80 
      targetPort: 8080 
  type: LoadBalancer
```

application.properties의 server.port는 8900으로 되어 있음

![image 9](https://github.com/user-attachments/assets/1d365280-706f-40ea-995b-42903c1d67c7)


service.yaml 파일의 targetPort를 8900으로 변경해주고 

```bash
apiVersion: v1
kind: Service
metadata:
  name: springapp-service
spec:
  selector:
    app: springapp
  ports:
    - protocol: TCP
      port: 80 # local에서 접속하는 port 
      targetPort: 8900 # springapp이 실행되는 port 
  type: LoadBalancer  # LoadBalancer 유형을 사용하여 외부 접근 가능

```

deployment, service 삭제 후 

다시 적용하면 정상적으로 실행가능!!
