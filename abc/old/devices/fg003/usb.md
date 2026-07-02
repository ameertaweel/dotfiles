# Creating Installation USB

- Download Windows 11 ISO from Microsoft's website.
- Download Rufus.
- Burn ISO file on USB via Rufus
  Make Rufus customize Windows installation. Rufus will create an `unattend.xml`
  file in the USB because of this.
- Replace the `unattend.xml` file created by Rufus with [`unattend.xml`](unattend.xml).

## Note About `unattend.xml`

I used [this tool](https://schneegans.de/windows/unattend-generator) to generate
`unattend.xml`.
