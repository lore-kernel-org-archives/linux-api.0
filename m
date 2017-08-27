From: Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [patch v6 0/3] JTAG driver introduction
Date: Mon, 28 Aug 2017 00:30:05 +0200
Message-ID: <CACRpkdb75L5BrYN+V-BMwzrRm8_Wtymr3d08eMWt43FiBpH5Qg@mail.gmail.com>
References: <1503418256-5215-1-git-send-email-oleksandrs@mellanox.com>
 <CACRpkdZePXyo8Q36mBH7OnJU3E=yWPWSGkGUOH=zJFMjM=Yrhw@mail.gmail.com>
 <CAPLgG==Jj=Ys=SvhOCspSfunbWnuqPySvW9RfuqE8HYnG4C=ZQ@mail.gmail.com>
 <CACRpkdbozWaL0RXyZXjzxYK3JHiqYziSkTGSgGORdptX-rwR8A@mail.gmail.com> <CAPLgG=mv1p98e4Vzso1N-VU=1MSotkTmnF+DcDTXPcd3q-n8HA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPLgG=mv1p98e4Vzso1N-VU=1MSotkTmnF+DcDTXPcd3q-n8HA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rick Altherr <raltherr-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Oleksandr Shamray <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, =?UTF-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri-rHqAuBHg3fBzbRFIqnYvSA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, system-sw-low-level-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, OpenBMC Maillist <openbmc-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, openocd-devel-owner-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, mec-WqBc5aa1uDFeoWH0uzbU5w@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, vadimp-45czdsxZ+A5DPfheJLI6IQ@public.gmane.org, Tobias Klauser <tklauser-93Khv+1bN0NyDzI6CaY1VQ@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Aug 25, 2017 at 6:52 PM, Rick Altherr <raltherr-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:

>> Incidentally, people are sending patches to expose the FTDI
>> expanders as common GPIO chips under Linux, so we can
>> internally in the kernel or from the usersapce character device
>> access them as "some GPIOs".
>
> I know my team at Google has an internal patch for exactly that.  FTDI
> expanders are complicated as they can be used as UART, GPIO, I2C, SPI
> depending on configuration.  Our project was using a mix of I2C and
> GPIO so I directly my team to approach it as an MFD.  I'd like to see
> all of these use cases handled by the kernel but I understand the
> other viewpoint of relying on libusb for cross-platform compatiblity.

Hm. I see. But I see people pushing the in-kernel method so I think
it will eventually win out.

>>>> In my worst nightmare they export GPIO lines using
>>>> the horrid ABI in /sys/gpio/*
>>>
>>> https://sourceforge.net/p/openocd/code/ci/v0.10.0/tree/src/jtag/drivers/sysfsgpio.c
>>
>> Gnah!
>> Whoever writes a slot-in replacement making the character device
>> take precendence wins lots of karma.
>
> If they show up at Linux Plumbers or visit San Jose, I'll take them to
> dinner.  I didn't see any docs for the chardev in Documentation.  I
> _think_ I understand how it works from reading the relevant sections
> of gpiolib.c but I can see how users end up using sysfs instead.

I intended tools/gpio/* to be the documentation:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/tools/gpio

If we need more written documentation we can do it I guess,

Yours,
Linus Walleij
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
