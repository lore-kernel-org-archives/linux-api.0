From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v5 04/10] serial: mps2-uart: add MPS2 UART driver
Date: Thu, 7 Apr 2016 07:43:11 -0700
Message-ID: <20160407144311.GC10853@kroah.com>
References: <1459519381-34441-1-git-send-email-vladimir.murzin@arm.com>
 <1459519381-34441-5-git-send-email-vladimir.murzin@arm.com>
 <57065ABA.4080506@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <57065ABA.4080506-5wv7dgnIgG8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladimir Murzin <vladimir.murzin-5wv7dgnIgG8@public.gmane.org>
Cc: arnd-r2nGTMty4D4@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, liviu.dudau-5wv7dgnIgG8@public.gmane.org, sudeep.holla-5wv7dgnIgG8@public.gmane.org, lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, peter-WaGBZJeGNqdsbIuE7sb01tBPR1lH4CV8@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Apr 07, 2016 at 02:03:54PM +0100, Vladimir Murzin wrote:
> On 01/04/16 15:02, Vladimir Murzin wrote:
> > This driver adds support to the UART controller found on ARM MPS2
> > platform.
> > 
> > Signed-off-by: Vladimir Murzin <vladimir.murzin-5wv7dgnIgG8@public.gmane.org>
> > ---
> >  drivers/tty/serial/Kconfig       |   12 +
> >  drivers/tty/serial/Makefile      |    1 +
> >  drivers/tty/serial/mps2-uart.c   |  598 ++++++++++++++++++++++++++++++++++++++
> >  include/uapi/linux/serial_core.h |    3 +
> >  4 files changed, 614 insertions(+)
> >  create mode 100644 drivers/tty/serial/mps2-uart.c
> 
> Greg, any comments from you?

No idea, first I've seen of this, and there's no patch here...
