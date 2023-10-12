# Sethup SSH in Termux 

1. open terminal and pase following command to install openssh service in termux.

    ```sh
    sudo apt install openssh

2. Now start ssh in termunx
    ```sh
    sshd

3. Check the status of ssh if SSH is running or not
    ```sh
    ps -a | grep sshd

4. To kill ssh service run the following command.
    ```sh
    pkill sshd