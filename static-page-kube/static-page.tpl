---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: static-page
  name: static-page
  namespace: jenkins
spec:
  replicas: 1
  selector:
    matchLabels:
      app: static-page
  template:
    metadata:
      labels:
        app: static-page
    spec:
      containers:
        - image: gregory78/static-page:${TAG}
          imagePullPolicy: IfNotPresent
          name: static-page

---
apiVersion: v1
kind: Service
metadata:
  labels:
    app: static-page
  name: static-page
  namespace: jenkins
spec:
  ports:
    - port: 8080
      protocol: TCP
      targetPort: 8080
  selector:
    app: static-page
  type: LoadBalancer

---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  generation: 1
  name: static-page
  namespace: jenkins
spec:
  ingressClassName: nginx
  rules:
    - host: cp1.cluster.local
      http:
        paths:
          - backend:
              service:
                name: static-page
                port:
                  number: 8080
            path: /
            pathType: Prefix
status:
  loadBalancer: {}
