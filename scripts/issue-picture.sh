#!/bin/bash

cat | sudo tee /etc/issue > /dev/null
echo | sudo tee -a /etc/issue > /dev/null
echo 'Arch Linux \r (\l)' | sudo tee -a /etc/issue > /dev/null
echo | sudo tee -a /etc/issue > /dev/null

