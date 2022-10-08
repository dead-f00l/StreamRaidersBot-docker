# StreamRaidersBot-docker
A docker container that runs [StreamRaidersBot](https://github.com/ProjectBots/StreamRaidersBot) and exposes it via novnc

Image derived from [soff/tiny-remote-desktop](https://hub.docker.com/r/soff/tiny-remote-desktop)  

Currently using 7.4.2beta with all patches applied up to 2022/10/04 Gladiator fix.

---

## Warning

It is strongly recommended to not have any of the ports used in this container opened directly to the Internet. Ideally it would be on a private network that you VPN into.  
Opening these ports to the wider internet is done so at your own risk.

---

## Environment Variables

Options that can be passed to modify configs inside of the container at runtime

| Variable | Description |
| -------- | ----------- |
| VNC_PASSWORD | Set the password required to access the container over VNC. |
| RESOLUTION | Set the resolution of the display inside the container (Default: "1024x768") |
| TZ | Set the timezone in the container. [Timezone Options](https://manpages.ubuntu.com/manpages/focal/man3/DateTime::TimeZone::Catalog.3pm.html) |

## Parameters

Parameters used for setting up the bot. These are usually port assignments to forward ports from the host into the container, link a file or folder from the host to inside the container etc.  

| Parameter | Function | Description |
| --- | --- | --- |
| -p 5901:5901 | VNC | Forward host port 5901 to port 5901 inside the container |
| -p 6901:6901 | noVNC WebGUI | Forward host port 6901 to port 6901 inside the container |
| -v configs.json:/opt/srbot/data/configs.json | | Mount config file inside of the docker container allowing persistence.
| -e VARIABLE="setting" | ENV. Variables | Set the environment variables in the above section |

## Running the bot

The below command will will be the basic command you can run to get started. It will forward the port 6901 on the host to the noVNC service inside the container, and set the VNC password to "vncpassword".  The first run may take a little while to "Initialize" but as long as you don't destroy the container, subsequent runs will be quicker and your config will persist.

``` 
docker run \
  -d \
  --name srbot \
  -p 6901:6901 \
  -e VNC_PASSWORD="vncpassword" \
  deadf00l/streamraidersbot 
```

Now open up your browser and access the IP of the device running docker on port 6901, enter the VNC_PASSWORD and you should be presented with StreamRaidersBot running in a little window inside your browser.  
It may take a while to launch as it initializes.

To paste into the bot using noVNC, there is an expanding menu on the left which include a button for clipboard. If you paste something into the text area this button provides, it will replace the clipboard inside the vnc window with its content. Similarly, if you copy something from the vnc window, this box will be updated to contain what was copied.

To easily extract your current config out from the container to include it later if you need to destroy the current container, run the below command which will pull the config out to your current directory.

```
docker cp srbot:/opt/srbot/data/configs.json .
```

This config can then be included in subsequent runs by using the below command instead of the first.

``` 
docker run \
  -d \
  --name srbot \
  -v $(pwd)/configs.json:/opt/srbot/data/configs.json \
  -p 6901:6901 \
  -e VNC_PASSWORD="vncpassword" \
  deadf00l/streamraidersbot
```

## Thanks

A huge thanks to ProjectBots and the other contributors for creating the StreamRaidersBot software. If you use it and like it, please contribute or donate to them! (Donate links are in the software, Help > Donators).
