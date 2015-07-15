From: Manfred Schlaegl <manfred.schlaegl-RbZlAiThDcE@public.gmane.org>
Subject: [RFC PATCH 0/2] drm: add support for for clk and de polarity & gpu:
 ipu-v3: use clock and de polarity
Date: Wed, 15 Jul 2015 17:44:27 +0200
Message-ID: <55A67FDB.8010602@gmx.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Philipp Zabel <p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, Jean-Christophe Plagniol-Villard <plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org>, Tomi Valkeinen <tomi.valkeinen-l0cyMroinI0@public.gmane.org>
Cc: dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Manfred Schlaegl <manfred.schlaegl-hfTNJOUbDMh54TAoqtyWWQ@public.gmane.org>, Steve Longerbeam <slongerbeam-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Deepak Das <deepak_das-nmGgyN9QBj3QT0dZR+AlfA@public.gmane.org>, Jiada Wang <jiada_wang-nmGgyN9QBj3QT0dZR+AlfA@public.gmane.org>, linux-fbdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hello!

These patches address a problem we ran into using parallel displays
with Freescale i.MX53 and i.MX6 SoC's.
In short: We wanted to change the clock signal polarity by using
display-timing in the devicetree description, but the output signal stayed
unchanged.

Parallel displays may have different polarities for clock and data enable
signals. (Clock polarity is also a topic on LVDS displays). This is the
reason why there are some properties in devicetree display-timing [1]
called
 * pixelclk-active .. pixel clock polarity
 * de-active .. data enable pulse polarity

This properties are correctly represented in struct display_timings [2]
and struct videomode [3] by using enum display_flags [3].
But when it comes to struct drm_display_mode [4] there are no
representations for this.
The properties are "lost in conversion" and never reach imx drm. (or 
other drm drivers).

Changing this would be especially important for embedded devices where
parallel(RGB) and LVDS displays are still widely used and drm already
plays an important role.

Following two patches will
 1. Introduce representation of clock and data enable polarities
     in struct drm_display_mode analog to hsync/vsync signals.
   * "drm: add support for for clk and de polarity"
 2. Implicitly enable usage of the newly introduced flags in 
     imx drm (with respect to devicetree compatibility.)
   * "gpu: ipu-v3: use clock and de polarity from videomode"

I'm aware that introducing new flags in struct drm_display_mode affects
user space too and therefore has to be considered carefully.
As I'm not really deep in drm user space your suggestions are very
welcome.

best regards,
manfred


[1] Documentation/devicetree/bindings/video/display-timing.txt
[2] include/video/display_timing.h
[3] include/video/videomode.h
[4] include/drm/drm_modes.h
