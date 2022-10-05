# StreamRaidersBot-docker
A docker container that runs [StreamRaidersBot](https://github.com/ProjectBots/StreamRaidersBot) and exposes it via novnc

Image derived from [soff/tiny-remote-desktop](https://hub.docker.com/r/soff/tiny-remote-desktop)  

Currently using 7.3.3beta with all patches applied up to 2022/10/04 Gladiator fix.

---

## Environment Variables

Options that can be passed to modify configs inside of the container at runtime

| Variable | Description |
| -------- | ----------- |
| VNC_PASSWORD | Set the password required to access the container over VNC. |
| RESOLUTION | Set the resolution of the display inside the container (Default: "1024x768") |

## Parameters

Parameters used for setting up the bot. These are usually port assignments to forward ports from the host into the container, link a file or folder from the host to inside the container etc.  

| Parameter | Function | Description |
| --- | --- | --- |
| -p 5901:5901 | VNC | Forward host port 5901 to port 5901 inside the container |
| -p 6901:6901 | noVNC WebGUI | Forward host port 6901 to port 6901 inside the container |
| -p 3389:3389 | RDP | Forward host port 3389 to port 3389 inside the container |
| -v configs.json:/opt/srbot/data/configs.json | | Mount config file inside of the docker container allowing persistence.
| -e VARIABLE="setting" | ENV. Variables | Set the environment variables in the above section |


## Running the bot

First download and then build the docker image. If you wish to use a specific version, after the cd command run `git checkout versionHere` for example `git checkout v7.3.3beta`. The main branch should normally be setup to match the latest version of StreamRaidersBot

```
git clone https://github.com/dead-f00l/StreamRaidersBot-docker.git
cd StreamRaidersBot-docker
docker build -t srbot-docker .
```

Then run the docker image. The below command will mount the config file inside the docker (make sure it exists first in your current directory), forward the port 6901 to the noVNC service inside the container, and set the VNC password to "vncpassword". This will also remove the container once it is stopped. (remove the --rm line to stop this, this will also decrease subsequent start times)

``` 
docker run \
  --rm \
  -d \
  -v $(pwd)/configs.json:/opt/srbot/data/configs.json \
  -p 6901:6901 \ 
  -e VNC_PASSWORD="vncpassword" \
  srbot-docker 
```

Now open up your browser and access the IP of the device running docker on port 6901, enter the VNC_PASSWORD and you should be presented with StreamRaidersBot running in a little window inside your browser.  
It may take a while to launch as it initializes.