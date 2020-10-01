# Zendesk Application Tools

[Zendesk App Tools]{https://github.com/zendesk/zendesk_apps_tools} docker image to develop locally.

:warning: when you run this image, please don't forget to override the command to something like that:

```shell
zat server --app-id={YOUR_APP_ID} --bind=0.0.0.0 -p dist
```
