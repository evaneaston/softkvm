# softkvm

Provides a switch script that allows me to automatically switch between my work and home computers.  Runs [todbot/hidapitester](https://github.com/todbot/hidapitester) to send messages to my Logi Mx Keys and Master 3 mous to switch sources.  Runs [ControlMyMonitor](https://www.nirsoft.net/utils/control_my_monitor.html) to send DDC/CI messages to switch my main, shared display.

## Notes

* meant for a couple of Windows computers, not a generalized solution
* bundles ControlMyMonitor.exe and hidapitester.exe (see references)
  * includes MultiMonitorTool.exe for looking up device ids without having to find and install it
* scripting is in bash
  * all my Window's systems run wsl2
  * vbs script is provided to automatically run switch.sh in wsl's default distro's bash (assumes location of wsl distro user matches host os %USERNAME%)
  * assumes yq is already installed
  * config.yml is very specific to my setup and needs changing if any of the components is replaced (sometimes too if I move my monitor cable to different port on a computer or hub) 

## References

* [marcelhoffs/input-switcher](https://github.com/marcelhoffs/input-switcher) as basis for my keyboard/mouse switching scripts.
* [todbot/hidapitester](https://github.com/todbot/hidapitester) is tool for sending messages to mouse and keyboard drivers
* nirsoft's [ControlMyMonitor](https://www.nirsoft.net/utils/control_my_monitor.html) is used to send DDC/CI messages to my display
  * specifically [How to set monitor input source](https://www.nirsoft.net/articles/set_monitor_input_source_command_line.html)
* nirsoft's [MultiMonitorTool](https://www.nirsoft.net/utils/multi_monitor_tool.html)
* [yq](https://github.com/mikefarah/yq) for parsing yaml
