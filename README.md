# txgio/anki
Anki running inside Docker.

## How it works
It uses X11 client/server architecture to redirect the screen to a X Server. (for example, XMing on Windows. You can also bind it directly to a Linux socket on a Linux environment).

It uses a pulseaudio client to redirect the audio to a pulseaudio server. (on Windows environments, you can use the pulseaudio package available at [https://www.freedesktop.org/wiki/Software/PulseAudio/Ports/Windows/Support/](https://www.freedesktop.org/wiki/Software/PulseAudio/Ports/Windows/Support/). [Here](https://parseq.co.uk/wordpress/archives/setting-up-pulseaudio-1-0-beta-for-windows)'s a useful guide to configure it)

## How to run it

### Windows Environment (Docker Toolbox, a.k.a. boot2docker Virtualbox VM)

#### Preparing the X and Audio servers on Windows
* Download and install [XMing](https://sourceforge.net/projects/xming/).
* Configure XMing to accept connections from the 192.168.99.100 IP Address (or your Docker Virtual Machine IP Address) by including it in the "C:\Program Files (x86)\Xming\X0.hosts" file.
* Download and install [Pulseaudio](https://www.freedesktop.org/wiki/Software/PulseAudio/Ports/Windows/Support/) (Just extract the downloaded zip somewhere). I tested it with the 1.1 version.
* Configure pulseaudio to open a network connection and allow anonymous access by including "load-module module-native-protocol-tcp listen=0.0.0.0 auth-anonymous=1" in the "<pulseaudio-extraction-dir>\pulseaudio-1.1\etc\pulse\default.pa" file.
* Configure the pulseaudio daemon to keep it running even if it's idle by including "exit-idle-time = -1" in the "<pulseaudio-extraction-dir>\pulseaudio-1.1\etc\pulse\daemon.conf".
* Run XMing server from the Desktop shortcut.
* Run pulseaudio server by running the "<pulseaudio-extraction-dir>\pulseaudio-1.1\bin\pulseaudio.exe". Ignore any possible warnings.

#### Running the container
* Execute the following command:

```
docker run -d -e DISPLAY=192.168.99.1:0.0 -e PULSE_SERVER=192.168.99.1 txgio/anki:2.0.45
```

The Anki window should popup on your Windows screen and the audio should also play on your Windows machine.

* To map a local folder to store the Anki data and/or addons, execute:

```
docker run -d -e DISPLAY=192.168.99.1:0.0 -e PULSE_SERVER=192.168.99.1 -v $(pwd)/anki-data:/home/anki-user/Documents/Anki txgio/anki:2.0.45
```

Although the above method to map the data should work on a Linux machine, on a Windows environment it won't work properly, because SQLite doesn't quite work over a VirtualBox share.

So I also provide some utility images to import and/or export data between your local Windows machine and the Anki container. To do that just follow my instructions:
* Create the Anki container (or a data container if you prefer (actually I prefer the data container, since if I need to change the X Server and Pulse Sever IP Addresses it would be easier)):

```
docker create --name anki-japanese -e DISPLAY=192.168.99.1:0.0 -e PULSE_SERVER=192.168.99.1 txgio/anki:2.0.45
```

* Now import the local data by using my importing image:

```
docker run -it --rm -v $(pwd)/anki-data:/import --volumes-from anki-japanese txgio/anki:import
```

So now the container anki-japanese has all of the data and can run with your existing Anki profile(s). I suggest you to keep this anki-japanese container and start to review Anki only using it.

* Start the container:

```
docker start anki-japanese
```

If you need to change the IPs of the X Server or Pulseaudio server, just use this container as a data container and create another one using the volumes from it (--volumes-from).

* Now if you want to export the data back to your local machine just use the following procedure:

```
docker run -it --rm -v $(pwd)/anki-data:/export --volumes-from anki-japanese txgio/anki:export
```

#### Stoping the container

You can't use docker stop to stop this container gracefully. Apparently Anki traps the SIGINT signal to stop gracefully. (You can see that in the file aqt/main.py on the Anki repository). So, to stop it gracefully you will need to issue (if you stop it by using docker stop your data might not be saved, so be aware):

```
docker kill --signal=SIGINT anki-japanese
``` 

### Linux Environment
TODO

# Credits
* [@rmoehn](https://github.com/rmoehn) and his gist [https://gist.github.com/rmoehn/1d82f433f517e3002124df52f7a73678](https://gist.github.com/rmoehn/1d82f433f517e3002124df52f7a73678).
* [http://fabiorehm.com/blog/2014/09/11/running-gui-apps-with-docker/](http://fabiorehm.com/blog/2014/09/11/running-gui-apps-with-docker/)
* [https://github.com/jfrazelle/dockerfiles/blob/master/spotify/Dockerfile](http://fabiorehm.com/blog/2014/09/11/running-gui-apps-with-docker/)