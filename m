From: Rick Altherr <raltherr-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch v6 0/3] JTAG driver introduction
Date: Thu, 24 Aug 2017 14:37:06 -0700
Message-ID: <CAPLgG==Jj=Ys=SvhOCspSfunbWnuqPySvW9RfuqE8HYnG4C=ZQ@mail.gmail.com>
References: <1503418256-5215-1-git-send-email-oleksandrs@mellanox.com> <CACRpkdZePXyo8Q36mBH7OnJU3E=yWPWSGkGUOH=zJFMjM=Yrhw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACRpkdZePXyo8Q36mBH7OnJU3E=yWPWSGkGUOH=zJFMjM=Yrhw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Oleksandr Shamray <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, jiri-rHqAuBHg3fBzbRFIqnYvSA@public.gmane.org, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, system-sw-low-level-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, OpenBMC Maillist <openbmc-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, openocd-devel-owner-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, mec-WqBc5aa1uDFeoWH0uzbU5w@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, vadimp-45czdsxZ+A5DPfheJLI6IQ@public.gmane.org, Tobias Klauser <tklauser-93Khv+1bN0NyDzI6CaY1VQ@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Aug 24, 2017 at 2:07 PM, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> On Tue, Aug 22, 2017 at 6:10 PM, Oleksandr Shamray
> <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>
>> SoC which are not equipped with JTAG master interface, can be built
>> on top of JTAG core driver infrastructure, by applying bit-banging of
>> TDI, TDO, TCK and TMS pins within the hardware specific driver.
>
> I guess you mean it should then use GPIO lines for bit-banging?
>
> I was wondering about how some JTAG clients like openOCD does
> this in some cases.
>

Many common uses of OpenOCD leverage USB devices, such as FTDI FT232R,
that have a command queue for bitbanging operations.  Managing these
via libusb is ugly but platform-agnostic.

> In my worst nightmare they export GPIO lines using
> the horrid ABI in /sys/gpio/*
>

https://sourceforge.net/p/openocd/code/ci/v0.10.0/tree/src/jtag/drivers/sysfsgpio.c

While that is certainly horrible (and slow), mapping in the GPIO
registers via /dev/mem strikes me as worse:

https://sourceforge.net/p/openocd/code/ci/v0.10.0/tree/src/jtag/drivers/bcm2835gpio.c

> In best case they use the GPIO character device or even
> libgpiod.
>
> But having a JTAG abstraction inside the kernel that can
> grab a few lines for JTAG defined in a device tree, ACPI DSDT
> or similar makes sense too, as it abstracts the hardware so the
> JTAG client can then just open whatever /dev/jtag0 is on the machine
> and go ahead without having to bother about what GPIO lines
> are connected exactly where.
>
> Yours,
> Linus Walleij
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
