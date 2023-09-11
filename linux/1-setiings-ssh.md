SSH-ключи используются для идентификации пользователя при подключении к серверу по SSH-протоколу. Используйте этот способ вместо аутентификации по паролю.

SSH-ключи представляют собой пару — закрытый и открытый ключ. Закрытый должен храниться в закрытом доступе у пользователя, открытый остается на сервере и размещается в файле .authorized_keys.



1. Настройка надежного ssh
vim /etc/ssh/sshd_config
    Port 22 (меняем порт > 1024)
    PubkeyAuthentication yes #включаем по ключу
    PasswordAuthentication no #отключаем по паролю
service sshd restart
2. Установка ssh ключа
    ssh-keygen #можно без пароля
3. Установка ключа на удаленную машину (на машине admina)
    ssh-copy-id -i ~/.ssh/id_rsa.pub root@<ip>
    или
    cat .ssh/id_rsa.pub | ssh root@<ip> 'cat >> .ssh/authorized_keys'
4. Для тонкой настройки (автоматизация) по хостам можно использовать: (на машине admina)
vim /etc/ssh/ssh_config
    Host test.loc
    Port 2007
    User root
    IdentityFile <id_rsa> #private key
ssh test.loc #без доп параметров


Можно и так
rsync -v root@192.168.0.2:/root/.ssh/id_mykey /home/myuser/.ssh/


Рекомендуемые для изменения директивы в конфиге демоне:

Port — смена порта, где располагается служба по умолчанию.
PubkeyAuthentication yes — включение авторизации по ssh-ключам.
PermitEmptyPasswords no — запрет использования пустых паролей.
PasswordAuthentication no — запрет авторизации по паролю в принципе.  (не меняйте, пока не убедитесь, что авторизация по SSH-ключам работает)

Опционально
ListenAddress 188.120.242.XXX — указываем конкретный IP, на котором будет располагаться служба. По умолчанию на всех.
PermitRootLogin no — запрет авторизации пользователя root.
AllowUsers User1 User2 — разрешение на подключение конкретных пользователей.

~/.ssh - скрытая служебная директория ssh в директории пользователя.
~/.ssh/authorized_keys — файл с открытыми ключами.
ssh-copy-id — команда для копирования ssh-ключей на удаленный сервер


Доп. материал 
https://habr.com/ru/companies/skillfactory/articles/503466/ ssh-agent