From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v3] add support for Freescale's MMA8653FC 10 bit
 accelerometer
Date: Thu, 19 Mar 2015 16:03:52 +0000
Message-ID: <20150319160349.GD25967@leverpostej>
References: <1426703538-16919-1-git-send-email-martink@posteo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1426703538-16919-1-git-send-email-martink-1KBjaw7Xf1+zQB+pC5nmwQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Martin Kepplinger <martink-1KBjaw7Xf1+zQB+pC5nmwQ@public.gmane.org>
Cc: "robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <Pawel.Moll-5wv7dgnIgG8@public.gmane.org>, "ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org" <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, "galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org" <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, "dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "alexander.stein-93q1YBGzJSMe9JSWTWOYM3xStJ4P+DSV@public.gmane.org" <alexander.stein-93q1YBGzJSMe9JSWTWOYM3xStJ4P+DSV@public.gmane.org>, "hadess-0MeiytkfxGOsTnJN9+BGXg@public.gmane.org" <hadess-0MeiytkfxGOsTnJN9+BGXg@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-input-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-input-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Martin Kepplinger <martin.kepplinger-SN7IsUiht6C/RdPyistoZJqQE7yCjDx5@public.gmane.org>, Christoph Muellner <christoph.muellner-SN7IsUiht6C/RdPyistoZJqQE7yCjDx5@public.gmane.org>
List-Id: linux-api@vger.kernel.org

> diff --git a/Documentation/devicetree/bindings/misc/fsl,mma8653fc.txt b/Documentation/devicetree/bindings/misc/fsl,mma8653fc.txt
> new file mode 100644
> index 0000000..3921acb
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/misc/fsl,mma8653fc.txt
> @@ -0,0 +1,96 @@
> +Freescale MMA8653FC 3-axis Accelerometer
> +
> +Required properties:
> +- compatible
> +       "fsl,mma8653fc"
> +- reg
> +       I2C address
> +
> +Optional properties:
> +
> +- interrupt-parent
> +       a phandle for the interrupt controller (see
> +       Documentation/devicetree/bindings/interrupt-controller/interrupts.txt)
> +- interrupts
> +       interrupt line to which the chip is connected
> +- int1
> +       set to use interrupt line 1 instead of 2

If you have two interrupt output lines, you should have two entries in
interrupts.

You can use interrupt-names to determine which line(s) are wired up.

I don't believe that you need this property.

> +- int_active_high
> +       set interrupt line active high

s/_/-/ in property names please. 

What happens if this isn't set? Is it active-low, or edge-triggered?

It feels like we should be able to query when we need to set this from
the IRQ(s).

> +- ir_freefall_motion_x
> +       activate freefall/motion interrupts on x axis
> +- ir_freefall_motion_y
> +       activate freefall/motion interrupts on y axis
> +- ir_freefall_motion_z
> +       activate freefall/motion interrupts on z axis
> +- irq_threshold
> +       0 < value < 8000: threshold for motion interrupts in mg
> +- ir_landscape_portrait
> +       activate landscape/portrait interrupts
> +- ir_data_ready:
> +       activate data-ready interrupts
> +       Interrupt events can be activated in any combination.

These all sounds like they would be better as runtime options. I don't
see why these should necessarily be in the DT.

> +- range
> +       2, 4, or 8: range in g, default: 2

Likewise.

It would be nice to have a better qualified name than "range".

> +- auto_wake_sleep
> +       auto sleep mode (lower frequency)
> +- motion_mode
> +       use motion mode instead of freefall mode (trigger if >threshold).
> +       per default an interrupt occurs if motion values fall below the
> +       value set in "threshold" and therefore can detect free fall on the
> +       vertical axis (depending on the position of the device).
> +       Setting this values inverts the behaviour and an interrupt occurs
> +       above the threshold value, so usually activate horizontal axis in
> +       this case.

These both sound like they would be better as runtime options.

> +
> +- x-offset
> +       0 < value < 500: calibration offset in mg
> +       this value has an offset of 250 itself:
> +       0 is -250mg, 250 is 0 mg, 500 is 250mg
> +- y-offset
> +       see x-offset
> +- z-offset
> +       see x-offset

I'm unsure about these; it really depends on what the calibration is
for.

Mark.
