# softkvm

## Background

* Used [marcelhoffs/input-switcher](https://github.com/marcelhoffs/input-switcher) as basis for my keyboard/mouse switching scripts.
* [todbot/hidapitester](https://github.com/todbot/hidapitester) is tool for sending messages to mouse and keyboard drivers
* nirsoft's [ControlMyMonitor](https://www.nirsoft.net/utils/control_my_monitor.html) is used to send DDC/CI messages to my display
  * specifically [How to set monitor input source](https://www.nirsoft.net/articles/set_monitor_input_source_command_line.html)


## yq

wget https://github.com/mikefarah/yq/releases/download/v4.21.1/yq_linux_amd64.tar.gz -O - |  tar xz ./yq_linux_amd64 && sudo mv yq_linux_amd64 /usr/bin/yq
