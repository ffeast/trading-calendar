Trading calendar
================
This is a helper tool to ease work with trading sessions schedule

The tool is basically a set of json files with manually collected schedules used from any programming environment.

Concept
=======
Answering a simple question like 'is it a trading date today on MOEX?' can be quite an excercise because general purpose date/time libraries know nothing on trading sessions.

There're numerous libraries written in high-level languages trying to guess which day is a trading day by excluding weekends and holidays.
I think such an approach isn't reliable enough plus it often implies additional code dependencies or in some cases external APIs to be used.

This tool doesn't require using any APIs online, registering somewhere etc - just pick up the .json files and use it whatever you like

Structure
=========
There are .json files (so far only a single file though) in the root folder that are supported manually and can be used from any programming environment.
There're also generators that can convert the json file into any other format - so far only .lua not to bring in a heavy json parser into .lua bots.
There's also a helper .lua library ./lua/calendar.lua build around the data to allow for even easier work with trading dates in lua

Next steps
==========
* add a dividend calendar
* add other markets (at least US)
* add events calendars (important stats announcement dates and the like)

Contriubtion
============
Contributions are welcome!
Just create a pull request with required changes - I'll review them (so you'll end up having at least a single soul who has double-checked your data) and merge it if all is fine

Development
-----------
Lua code is coverted with tests using [busted](https://olivinelabs.com/busted/) that has perfect docs and installation [manual](https://olivinelabs.com/busted/#usage).
To run lua tests just launch the following command from the ./lua folder

```bash
$ busted
```
