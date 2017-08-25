From: Rick Altherr <raltherr-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch v6 0/3] JTAG driver introduction
Date: Fri, 25 Aug 2017 09:53:40 -0700
Message-ID: <CAPLgG=ke+5kX5TuTtciVCxtCr6agpFMo-6peXfhbE0UCvy6M3w@mail.gmail.com>
References: <1503418256-5215-1-git-send-email-oleksandrs@mellanox.com>
 <CACRpkdZePXyo8Q36mBH7OnJU3E=yWPWSGkGUOH=zJFMjM=Yrhw@mail.gmail.com>
 <CAPLgG==Jj=Ys=SvhOCspSfunbWnuqPySvW9RfuqE8HYnG4C=ZQ@mail.gmail.com>
 <CACRpkdbozWaL0RXyZXjzxYK3JHiqYziSkTGSgGORdptX-rwR8A@mail.gmail.com> <593cd0d3-8e06-0992-c155-1322014c0477@longlandclan.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <593cd0d3-8e06-0992-c155-1322014c0477-3e+Fe6x+DsgJbe36r25VNhCuuivNXqWP@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stuart Longland <stuartl-3e+Fe6x+DsgJbe36r25VNhCuuivNXqWP@public.gmane.org>
Cc: Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Oleksandr Shamray <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, =?UTF-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri-rHqAuBHg3fBzbRFIqnYvSA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, system-sw-low-level-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, OpenBMC Maillist <openbmc-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, openocd-devel-owner-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, mec-WqBc5aa1uDFeoWH0uzbU5w@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tobias Klauser <tklauser-93Khv+1bN0NyDzI6CaY1VQ@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Aug 25, 2017 at 1:50 AM, Stuart Longland
<stuartl-3e+Fe6x+DsgJbe36r25VNhCuuivNXqWP@public.gmane.org> wrote:
> [Note: dropping vadimp-45czdsxZ+A5DPfheJLI6IQ@public.gmane.org as SMTP server complained about the
> DNS server returning NXDOMAIN.  Apologies.]
> On 25/08/17 18:32, Linus Walleij wrote:
>> Gnah!
>> Whoever writes a slot-in replacement making the character device
>> take precendence wins lots of karma.
>
> What would such a replacement look like though?

See Linus's comments about using the existing kernel GPIO chardev
interface.  It already supports requesting multiple GPIO line state
changes in a single request.

>
> Some sort of system whereby you can read/write single-line commands as
> if talking to a GPIO expander over a UART?
>
> Would you access the GPIOs one by one, or would you perhaps map them
> into a bitmap (maybe arbitrarily, up to 64-bits wide) and perform masked
> operations on the bitmap?
>
> I'm no fan of the sysfs GPIO interface, but it beats poking around at
> registers behind the kernel's back.
> --
> Stuart Longland (aka Redhatter, VK4MSL)
>
> I haven't lost my mind...
>   ...it's backed up on a tape somewhere.
>
