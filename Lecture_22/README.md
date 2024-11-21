# lesson_22
# AWS Basics

## Опис
Опис завдання 

1. Створення та налаштування VPC

* Створіть нову VPC:
  * Використайте консоль AWS для створення VPC.
  * Виберіть CIDR-блок
![alt text](image-2.png)
* Створіть дві підмережі в VPC:
  * Створіть одну публічну підмережу з CIDR-блоком.
  * Створіть одну приватну підмережу з CIDR-блоком.
![alt text](image-3.png)
* Створіть та налаштуйте інтернет-шлюз (Internet Gateway):
  * Прив'яжіть інтернет-шлюз до вашої VPC.
![alt text](image-4.png)
  * Налаштуйте таблиці маршрутизації для забезпечення доступу до інтернету з публічної підмережі.
![alt text](image-5.png)
2. Налаштування груп безпеки (Security Groups) та списків контролю доступу (ACL)

* Додайте правила для дозволу вхідного HTTP та SSH трафіку з будь-якої IP-адреси.
![alt text](image-1.png)
3. Запуск інстансу EC2

* Запустіть новий інстанс EC2:
  * Використайте Amazon Linux 2 AMI.
  * Виберіть тип інстансу, наприклад, t2.micro. Оскільки він безкоштовний.
  * Прив'яжіть інстанс до публічної підмережі.
  * Використайте Security Group, створену на попередньому кроці.
  * Завантажте та використайте SSH-ключ для доступу до інстансу.
![alt text](image-6.png)
4. Призначення еластичної IP-адреси (EIP)

* Створіть та призначте EIP до вашого інстансу:
  * Створіть нову EIP в AWS консолі.
  * Прив'яжіть EIP до запущеного інстансу EC2.
  ![alt text](image-7.png)
  ![alt text](image-8.png)
