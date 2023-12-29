# Browserbox

Browserbox provides images for common browsers for use with [Distrobox](https://github.com/89luca89/distrobox).

## Supported Browsers

| Browser   | Image         | Install                                                                   |
| --------- | ------------- | ------------------------------------------------------------------------- |
| Brave     | `bravebox`    | `distrobox create -i ghcr.io/eyecantcu/bravebox:latest -n bravebox`       |
| Chrome    | `chromebox`   | `distrobox create -i ghcr.io/eyecantcu/chromebox:latest -n chromebox`     |
| Chromium  | `chromiumbox` | `distrobox create -i ghcr.io/eyecantcu/chromiumbox:latest -n chromiumbox` |
| Firefox   | `firebox`     | `distrobox create -i ghcr.io/eyecantcu/firebox:latest -n firebox`         |
| Floorp    | `floorpbox`   | `distrobox create -i ghcr.io/eyecantcu/floorpbox:latest -n floorpbox`     |

# Post-install

After the image has been retrieved, you now need to export the browser.

`distrobox enter <IMAGE NAME> -- 'bash -c "distrobox-export --app <BROWSER>"'`

For browsers using the blink engine, you can force them to use Wayland.

`distrobox enter <IMAGE NAME> -- 'bash -c "distrobox-export --app <BROWSER> --extra-flags \"--ozone-platform=wayland --disable-features=WaylandFractionalScaleV1\""'`

Fractional scaling is disabled in this example as I have encountered numerous issues leaving it enabled under Wayland.

## Notes

* NVIDIA users need to pass the `--nvidia` flag to `distrobox create...` for proper GPU support.
* Generally speaking, I'd recommend using the Flatpak versions of these browsers.
* For proper icon support under wayland, the .desktop file must match the name of the program. You can move the .desktop file created in `~/.local/share/applications` from `CONTAINER-BROWSER-NAME.desktop` to `BROWSER-NAME.desktop` assuming you are not using multiple of the same browser.
