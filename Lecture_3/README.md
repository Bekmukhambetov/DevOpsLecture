# lecture3

Оскільки Virtual Box в мене вже був встановлений, процес встановлення не зможу показати.
Відкриваємо Virtual Box
![alt text](image.png)

Натискаємо Створити 

Вводимо необхідні дані та обираємо iso image

![alt text](image-1.png)
![alt text](image-2.png)

Налаштовуємо параметри віртуальної машини

![alt text](image-3.png)
![alt text](image-4.png)
![alt text](image-5.png)

Додаємо проміжний адаптер

![alt text](image-6.png)

Далі процес втановлення операційної системи
![alt text](image-7.png)
![alt text](image-8.png)
![alt text](image-9.png)
![alt text](image-10.png)

Запуск команди yum update
![alt text](image-11.png)

Зловив таку хрінь (не вистачило ресурсів напевно)
![alt text](image-12.png)

Додаю озу та процесори.

_Зміна параметрів віртуальної машини, а саме збільшення озу та кількості процесорів повпливала на її продуктивність в кращу сторону_

![alt text](image-13.png)
![alt text](image-14.png)

Збільшення розміру диска
_Захожу в \Файл\tools\Virtual Media Manager і збільшую розмір диска_

![alt text](image-28.png)
![alt text](image-29.png)

Підключився по ssh для зручності 

![alt text](image-16.png)

Встановлення nginx і його запуск

![alt text](image-17.png)

Вроцес створення снепшоту 

![alt text](image-18.png)

Запуск команди видалення

![alt text](image-19.png)
![alt text](image-20.png)

Відновлення з снепшоту

![alt text](image-21.png)

Після відновлення все працює

_знімок допоміг відновити початковий стан системи після виконання зловісної команди rm -rf / !!!_
![alt text](image-22.png)

Налаштувати спільні папки між основною машиною і VM, щоб мати можливість обмінюватися файлами між ними.
Спершу маунтимо диск з гостьовими доповненнями

![alt text](image-24.png)

створюємо спільну папку

![alt text](image-25.png)

 
```
sudo yum install epel-release
sudo yum install dkms
sudo /sbin/rcvboxadd setup
```
далі заходимо на віртуалку і маунтимо диск в систему
```
sudo mount /dev/cdrom /mnt
```
запускаємо встановлення гостьових доповнень
```
sudo /mnt/VBoxLinuxAdditions.run
```
маунтимо спільну папку
```
sudo mount -t vboxsf -o rw,uid=1000,gid=1000 share ~/host
```
![alt text](image-27.png)
![alt text](image-26.png)

звісно не все так просто, бо потрібно було пооновлювати пакети, погратись з версіями та сумісностями...