From: Rick Altherr <raltherr-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch v6 0/3] JTAG driver introduction
Date: Fri, 25 Aug 2017 09:52:25 -0700
Message-ID: <CAPLgG=mv1p98e4Vzso1N-VU=1MSotkTmnF+DcDTXPcd3q-n8HA@mail.gmail.com>
References: <1503418256-5215-1-git-send-email-oleksandrs@mellanox.com>
 <CACRpkdZePXyo8Q36mBH7OnJU3E=yWPWSGkGUOH=zJFMjM=Yrhw@mail.gmail.com>
 <CAPLgG==Jj=Ys=SvhOCspSfunbWnuqPySvW9RfuqE8HYnG4C=ZQ@mail.gmail.com> <CACRpkdbozWaL0RXyZXjzxYK3JHiqYziSkTGSgGORdptX-rwR8A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACRpkdbozWaL0RXyZXjzxYK3JHiqYziSkTGSgGORdptX-rwR8A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Oleksandr Shamray <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, =?UTF-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri-rHqAuBHg3fBzbRFIqnYvSA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, system-sw-low-level-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, OpenBMC Maillist <openbmc-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, openocd-devel-owner-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, mec-WqBc5aa1uDFeoWH0uzbU5w@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, vadimp-45czdsxZ+A5DPfheJLI6IQ@public.gmane.org, Tobias Klauser <tklauser-93Khv+1bN0NyDzI6CaY1VQ@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Aug 25, 2017 at 1:32 AM, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> On Thu, Aug 24, 2017 at 11:37 PM, Rick Altherr <raltherr-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>> On Thu, Aug 24, 2017 at 2:07 PM, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>>> On Tue, Aug 22, 2017 at 6:10 PM, Oleksandr Shamray
>>> <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>>>
>>>> SoC which are not equipped with JTAG master interface, can be built
>>>> on top of JTAG core driver infrastructure, by applying bit-banging of
>>>> TDI, TDO, TCK and TMS pins within the hardware specific driver.
>>>
>>> I guess you mean it should then use GPIO lines for bit-banging?
>>>
>>> I was wondering about how some JTAG clients like openOCD does
>>> this in some cases.
>>
>> Many common uses of OpenOCD leverage USB devices, such as FTDI FT232R,
>> that have a command queue for bitbanging operations.  Managing these
>> via libusb is ugly but platform-agnostic.
>
> Incidentally, people are sending patches to expose the FTDI
> expanders as common GPIO chips under Linux, so we can
> internally in the kernel or from the usersapce character device
> access them as "some GPIOs".
>

I know my team at Google has an internal patch for exactly that.  FTDI
expanders are complicated as they can be used as UART, GPIO, I2C, SPI
depending on configuration.  Our project was using a mix of I2C and
GPIO so I directly my team to approach it as an MFD.  I'd like to see
all of these use cases handled by the kernel but I understand the
other viewpoint of relying on libusb for cross-platform compatiblity.

>>> In my worst nightmare they export GPIO lines using
>>> the horrid ABI in /sys/gpio/*
>>
>> https://sourceforge.net/p/openocd/code/ci/v0.10.0/tree/src/jtag/drivers/sysfsgpio.c
>
> Gnah!
> Whoever writes a slot-in replacement making the character device
> take precendence wins lots of karma.
>

If they show up at Linux Plumbers or visit San Jose, I'll take them to
dinner.  I didn't see any docs for the chardev in Documentation.  I
_think_ I understand how it works from reading the relevant sections
of gpiolib.c but I can see how users end up using sysfs instead.

>> While that is certainly horrible (and slow), mapping in the GPIO
>> registers via /dev/mem strikes me as worse:
>>
>> https://sourceforge.net/p/openocd/code/ci/v0.10.0/tree/src/jtag/drivers/bcm2835gpio.c
>
> Yeah that is quite horrible.
>
> There were reasons to do things like that, but since we have
> developed .set_multiple() to hammer several lines in a register
> at once, the same efficiency can be achieved using the standard
> character device.

Agreed that that helps with user-space GPIO-based JTAG
implementations.  The problem this patch series is trying to address
is for SoCs like the Aspeed AST2400/2500 that include a hardware
accelerated JTAG master.  It _can_ be run in a pure-software mode
where it acts like GPIOs but the intended use case is to operate an
interrupt-driven state machine.  That requires a higher-level
abstraction for managing the standard JTAG state machine.  Similar to
GPIO .set_multiple, user-space feeding a JTAG kernel API a buffer of
JTAG state changes would be useful.  That's how I recall OpenOCD's
internals working: run short (1-7?) state change sequences to move to
the next decision point.  I know of at least one vendor pushing for
the use of JTAG on BMCs as a way to debug host processors in large
deployments instead of using dongles.  I'm supportive of the adding a
JTAG driver abstraction.  I haven't reviewed this patch series in
detail yet.

>
> Yours,
> Linus Walleij
