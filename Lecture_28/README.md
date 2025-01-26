# lesson_28
## AWS CloudFormation

Створено файл з конфігурацією інфраструктури [lecture28.yml](lecture28.yml)

Створено S3 bucket, в який поміщено файл з конфігурацією.

Далі було створено Stack через AWS Console з підключенням до Amazon S3 URL.

Після старту все успішно відпрацювало та були створені всі ресурси.

![Outputs](image-3.png)

![alt text](image.png)

Далі спробував перейменувати `myVPC` на `myVPCdr`, щоб перевірити на Drifts.

![alt text](image-1.png)

![alt text](image-2.png)

Далі спробував видалити стек через CLI:

```
bekmukhambetov@ZenBook:~$ aws cloudformation delete-stack --stack-name testVadym
```
Стек успішно видалено:

![delete-stack](image-4.png)