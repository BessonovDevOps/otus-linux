# Инструкции

* [Как начать Git](git_quick_start.md)
* [Как начать Vagrant](vagrant_quick_start.md)

## otus-linux

Используйте этот [Vagrantfile](Vagrantfile) - для тестового стенда.

## Задание №1 сборка ядра centos7 произвольной версии.

### 1. Информация о текущей версии системы и ядра

  ```bash   
    sudo -i   
    cat /etc/redhat-release   
    uname -r   
    yum list installed kernel-*   
  ```   

### 2. Установка инструментов разработчика и зависимостей для сборки ядра.

  ```bash   
    yum install -y rpm-build elfutils-libelf-devel ncurses-devel make gcc bc openssl-devel   
    yum install -y wget   
  ```

### 3. Сборка и установка ядра.

  ```bash   
    cd /usr/src && wget  https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.19.36.tar.xz   
    tar xvf linux-4.19.36.tar.xz && mv linux-4.19.36 linux   
    cp /boot/config-* linux/.config   
    cd linux/   
    # при необходимости внесения изменений в конфигурацию ядра выполнить   
    make menuconfig   
    # сохранить изменения завершить редактирования   
    make rpm-pkg   
    # после завершения сборки пакетов ядра (длительная операция) проверить наличие пакетов   
    ls ~/rpmbuild/RPMS/x86_64/   
    # установить пакеты   
    rpm -iUv ~/rpmbuild/RPMS/x86_64/*.rpm   
    # перезапустить систему   
    init 6   
  ```