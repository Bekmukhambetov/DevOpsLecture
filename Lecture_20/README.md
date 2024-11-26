# lesson_20
# Selfhosted K8s

📌 Завдання 1: Створення StatefulSet для Redis-кластера
Кроки:

1. Створіть PersistentVolumeClaim (PVC) для зберігання даних Redis. Кожен под у StatefulSet використовуватиме свій окремий том для зберігання даних.

На цьому етапі я створив файл [redis-pvc.yml](configs/redis-pvc.yml), але вирішив реалізувати PVC через використання PersistentVolumeTemplates у конфігурації StatefulSet. Перед цим я також створив файл [redis-pv.yml](configs/redis-pv.yml) для створення двох томів PV, щоб забезпечити можливість прив’язки PVC до існуючих томів.

```
[root@k8s-master kuber]# kubectl apply -f redis-pv.yaml
persistentvolume/redis-pv-0 created
persistentvolume/redis-pv-1 created
[root@k8s-master kuber]# kubectl get pv
NAME         CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM   STORAGECLASS   VOLUMEATTRIBUTESCLASS   REASON   AGE
redis-pv-0   1Gi        RWO            Retain           Available                          <unset>                          3s
redis-pv-1   1Gi        RWO            Retain           Available                          <unset>                          3s
```
2. Створіть StatefulSet для Redis із налаштуваннями для запуску двох реплік. Кожна репліка повинна мати стабільне ім’я та доступ до постійного тому.

Далі StatefulSet

[redis-statefulset.yml](configs/redis-statefulset.yml)
```
[root@k8s-master kuber]# kubectl apply -f redis-statefulset.yaml
statefulset.apps/redis created
[root@k8s-master kuber]# kubectl get pvc
NAME                 STATUS   VOLUME       CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
redis-data-redis-0   Bound    redis-pv-0   1Gi        RWO                           <unset>                 17s
redis-data-redis-1   Bound    redis-pv-1   1Gi        RWO                           <unset>                 13s
```
3. Створіть Service для Redis: Service для StatefulSet потрібен для доступу до Redis. Використовуйте тип Service ClusterIP для внутрішньої взаємодії між подами.

[redis-service.yml](configs/redis-service.yml)
```
[root@k8s-master kuber]# kubectl apply -f redis-service.yaml
service/redis-service unchanged
```
4. Перевірка роботи: після створення StatefulSet перевірте, чи запущені поди (kubectl get pods) і чи мають вони стабільні імена, наприклад, redis-0, redis-1. Застосовуйте команду kubectl exec для підключення до кожного пода та перевірки збереження даних між перезапусками.

```
[root@k8s-master kuber]# kubectl exec -it redis-0 -- redis-cli
127.0.0.1:6379> SET mykey "Hello, Redis!"
OK
127.0.0.1:6379> get mykey
"Hello, Redis!"
127.0.0.1:6379>
[root@k8s-master kuber]# kubectl delete pod redis-0
pod "redis-0" deleted
[root@k8s-master kuber]# kubectl get pods
NAME      READY   STATUS    RESTARTS   AGE
redis-0   1/1     Running   0          7s
redis-1   1/1     Running   0          29m
[root@k8s-master kuber]# kubectl exec -it redis-0 -- redis-cli
127.0.0.1:6379> get mykey
"Hello, Redis!"
127.0.0.1:6379>
```
📌 Завдання 2: Налаштування Falco в Kubernetes за допомогою DaemonSet

1. Налаштуйте DaemonSet для Falco:
  * Розробіть конфігурацію DaemonSet, яка розгорне Falco на кожному вузлі. Falco повинен працювати з привілейованим доступом для моніторингу системних викликів.
```
securityContext:
  privileged: true
```

2. Налаштуйте монтування системних директорій: для того, щоб Falco міг правильно збирати системні події, потрібно змонтувати такі директорії:
  * /proc — директорія, що містить інформацію про запущені процеси, це треба для доступу до процесів на вузлі
  * /boot — може містити дані про конфігурації ядра, що дає змогу Falco краще розпізнавати події
  * /lib/modules — тут розташовані модулі ядра, доступ до них дозволяє Falco використовувати eBPF для збору даних
  * /var/run/docker.sock — дає Falco доступ до Docker-сокета для контролю подій, пов’язаних з контейнерами — важливо, якщо вузол використовує Docker як рантайм
  * /usr — дозволяє доступ до системних бібліотек і утиліт, необхідних для розширення функціональності Falco
```
volumeMounts:
  - mountPath: /host/proc
    name: proc
    readOnly: true
  - mountPath: /host/boot
    name: boot
    readOnly: true
  - mountPath: /host/lib/modules
    name: lib-modules
    readOnly: true
  - mountPath: /host/run/containerd/containerd.sock  #замість /var/run/docker.sock - run/containerd/containerd.sock
    name: containerd-sock
    readOnly: true
  - mountPath: /host/usr
    name: usr
    readOnly: true
```

3. Обмежте використання ресурсів:
  * Для Falco потрібно встановити обмеження на застосування ресурсів (CPU і пам’ять), щоб він не впливав на роботу інших сервісів на вузлі
  * Встановіть, наприклад, 100m CPU і 256Mi пам’яті як ліміти, а також 100m CPU і 128Mi пам’яті як мінімальні запити
```
resources:
 limits:
  memory: 256Mi
  cpu: 100m
 requests:
  memory: 128Mi
  cpu: 100m
```

4. Створіть YAML-файл конфігурації DaemonSet:
  * Створіть YAML-файл, який відповідає вимогам і запускає Falco на кожному вузлі
  * Переконайтеся, що всі потрібні директорії змонтовані для коректної роботи Falco
  
  [falco-ds.yml](configs/falco-ds.yml)

5. Перевірка розгортання та роботи Falco:

Після застосування YAML-файлу за допомогою команди kubectl apply -f falco-daemonset.yaml

  * Перевірте, чи всі поди Falco запущені на кожному вузлі kubectl get pods -l app=falco -n kube-system
  * Переконайтеся, що кожен под Falco працює в статусі Running
```
[root@k8s-master kuber]# kubectl apply -f falco-ds.yml
daemonset.apps/falco configured
[root@k8s-master kuber]# kubectl get pods -l app=falco -n kube-system
NAME          READY   STATUS    RESTARTS   AGE
falco-lstvs   1/1     Running   0          6s
falco-p564z   1/1     Running   0          7s
```
6.  Перевірка логів Falco для виявлення подій:

  * Виконайте команду для перегляду логів одного з подів Falco kubectl logs -l app=falco -n kube-system
  * Переконайтеся, що Falco генерує сповіщення про події — логи можуть містити інформацію про такі дії, як-от доступ до файлів, створення нових процесів або взаємодія з Docker

```
[root@k8s-master kuber]# kubectl logs -l app=falco -n kube-system
2024-11-26T19:58:46+0000: System info: Linux version 6.1.115-126.197.amzn2023.x86_64 (mockbuild@ip-10-0-32-224) (gcc (GCC) 11.4.1 20230605 (Red Hat 11.4.1-2), GNU ld version 2.39-6.amzn2023.0.10) #1 SMP PREEMPT_DYNAMIC Tue Nov  5 17:36:57 UTC 2024
2024-11-26T19:58:46+0000: Loading rules from:
2024-11-26T19:58:47+0000:    /etc/falco/falco_rules.yaml | schema validation: ok
2024-11-26T19:58:47+0000:    /etc/falco/falco_rules.local.yaml | schema validation: none
2024-11-26T19:58:47+0000: The chosen syscall buffer dimension is: 8388608 bytes (8 MBs)
2024-11-26T19:58:47+0000: Starting health webserver with threadiness 2, listening on 0.0.0.0:8765
2024-11-26T19:58:47+0000: Loaded event sources: syscall
2024-11-26T19:58:47+0000: Enabled event sources: syscall
2024-11-26T19:58:47+0000: Opening 'syscall' source with modern BPF probe.
2024-11-26T19:58:47+0000: One ring buffer every '2' CPUs.
2024-11-26T19:58:44+0000: System info: Linux version 6.1.115-126.197.amzn2023.x86_64 (mockbuild@ip-10-0-32-224) (gcc (GCC) 11.4.1 20230605 (Red Hat 11.4.1-2), GNU ld version 2.39-6.amzn2023.0.10) #1 SMP PREEMPT_DYNAMIC Tue Nov  5 17:36:57 UTC 2024
2024-11-26T19:58:44+0000: Loading rules from:
2024-11-26T19:58:45+0000:    /etc/falco/falco_rules.yaml | schema validation: ok
2024-11-26T19:58:45+0000:    /etc/falco/falco_rules.local.yaml | schema validation: none
2024-11-26T19:58:45+0000: The chosen syscall buffer dimension is: 8388608 bytes (8 MBs)
2024-11-26T19:58:45+0000: Starting health webserver with threadiness 2, listening on 0.0.0.0:8765
2024-11-26T19:58:45+0000: Loaded event sources: syscall
2024-11-26T19:58:45+0000: Enabled event sources: syscall
2024-11-26T19:58:45+0000: Opening 'syscall' source with modern BPF probe.
2024-11-26T19:58:45+0000: One ring buffer every '2' CPUs.
```