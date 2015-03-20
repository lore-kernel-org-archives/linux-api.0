From: Martin Kepplinger <martin.kepplinger@theobroma-systems.com>
Subject: Re: [PATCH v3] add support for Freescale's MMA8653FC 10 bit accelerometer
Date: Fri, 20 Mar 2015 12:37:14 +0100
Message-ID: <550C066A.1060207@theobroma-systems.com>
References: <1426703538-16919-1-git-send-email-martink@posteo.de> <20150319160349.GD25967@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-input-owner@vger.kernel.org>
In-Reply-To: <20150319160349.GD25967@leverpostej>
Sender: linux-input-owner@vger.kernel.org
To: Mark Rutland <mark.rutland@arm.com>, Martin Kepplinger <martink@posteo.de>
Cc: "robh+dt@kernel.org" <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>, "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>, "galak@codeaurora.org" <galak@codeaurora.org>, "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>, "alexander.stein@systec-electronic.com" <alexander.stein@systec-electronic.com>, "hadess@hadess.net" <hadess@hadess.net>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Muellner <christoph.muellner@theobroma-systems.com>
List-Id: linux-api@vger.kernel.org

Am 2015-03-19 um 17:03 schrieb Mark Rutland:
>> diff --git a/Documentation/devicetree/bindings/misc/fsl,mma8653fc.txt b/Documentation/devicetree/bindings/misc/fsl,mma8653fc.txt
>> new file mode 100644
>> index 0000000..3921acb
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/misc/fsl,mma8653fc.txt
>> @@ -0,0 +1,96 @@
>> +Freescale MMA8653FC 3-axis Accelerometer
>> +
>> +Required properties:
>> +- compatible
>> +       "fsl,mma8653fc"
>> +- reg
>> +       I2C address
>> +
>> +Optional properties:
>> +
>> +- interrupt-parent
>> +       a phandle for the interrupt controller (see
>> +       Documentation/devicetree/bindings/interrupt-controller/interrupts.txt)
>> +- interrupts
>> +       interrupt line to which the chip is connected
>> +- int1
>> +       set to use interrupt line 1 instead of 2
> 
> If you have two interrupt output lines, you should have two entries in
> interrupts.
> 
> You can use interrupt-names to determine which line(s) are wired up.
> 

You can't use both interrupt lines. You have to decide on one and all
your selected interrupt sources will be on this one line.

> I don't believe that you need this property.
> 
>> +- int_active_high
>> +       set interrupt line active high
> 
> s/_/-/ in property names please. 
> 
> What happens if this isn't set? Is it active-low, or edge-triggered?
> 
> It feels like we should be able to query when we need to set this from
> the IRQ(s).

It's active low per default. I investigated and couldn't successfully
use active high. In v4 of the patch, this option is gone and documented.

> 
>> +- ir_freefall_motion_x
>> +       activate freefall/motion interrupts on x axis
>> +- ir_freefall_motion_y
>> +       activate freefall/motion interrupts on y axis
>> +- ir_freefall_motion_z
>> +       activate freefall/motion interrupts on z axis
>> +- irq_threshold
>> +       0 < value < 8000: threshold for motion interrupts in mg
>> +- ir_landscape_portrait
>> +       activate landscape/portrait interrupts
>> +- ir_data_ready:
>> +       activate data-ready interrupts
>> +       Interrupt events can be activated in any combination.
> 
> These all sounds like they would be better as runtime options. I don't
> see why these should necessarily be in the DT.

First, I don't really want to expand the sysfs ABI much. Second, there
are use cases that don't need these at runtime and it would seem to make
it even harder for systems to use this driver.

> 
>> +- range
>> +       2, 4, or 8: range in g, default: 2
> 
> Likewise.
> 
> It would be nice to have a better qualified name than "range".

I use "dynamic-range" in v4 of the patch.

> 
>> +- auto_wake_sleep
>> +       auto sleep mode (lower frequency)
>> +- motion_mode
>> +       use motion mode instead of freefall mode (trigger if >threshold).
>> +       per default an interrupt occurs if motion values fall below the
>> +       value set in "threshold" and therefore can detect free fall on the
>> +       vertical axis (depending on the position of the device).
>> +       Setting this values inverts the behaviour and an interrupt occurs
>> +       above the threshold value, so usually activate horizontal axis in
>> +       this case.
> 
> These both sound like they would be better as runtime options.
> 
>> +
>> +- x-offset
>> +       0 < value < 500: calibration offset in mg
>> +       this value has an offset of 250 itself:
>> +       0 is -250mg, 250 is 0 mg, 500 is 250mg
>> +- y-offset
>> +       see x-offset
>> +- z-offset
>> +       see x-offset
> 
> I'm unsure about these; it really depends on what the calibration is
> for.

this is better documented in v4 of the patch.

> 
> Mark.
> 

thanks for reviewing!

                                      martin
