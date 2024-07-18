# helm v3.15.2 설치
yum install -y tar
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

# helm 공식 리포지토리 추가
helm repo add stable https://charts.helm.sh/stable

# prometheus 설치
# 레포지토리 추가
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

# 레포지토리 업데이트
helm repo update

# kube-prometheus-stack chart 설치
helm install prometheus-community/kube-prometheus-stack --generate-name

# 패스워드 확인
# kube-prometheus-stack-1720149533 => 생성시 정보 확인 필요
# 패스워드 생성될 때 내용 동일해서 생략 가능할듯
 kubectl get secret/kube-prometheus-stack-1720149533-grafana -o jsonpath="{.data.admin-password}"|base64 --decode;echo