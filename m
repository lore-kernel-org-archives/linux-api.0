From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v2 04/10] serial: mps2-uart: add MPS2 UART driver
Date: Mon, 8 Feb 2016 08:52:26 -0800
Message-ID: <20160208165226.GA11593@kroah.com>
References: <1454413199-26573-1-git-send-email-vladimir.murzin@arm.com>
 <1454413199-26573-5-git-send-email-vladimir.murzin@arm.com>
 <20160207071154.GA32017@kroah.com>
 <56B87928.7020803@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56B87928.7020803-5wv7dgnIgG8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladimir Murzin <vladimir.murzin-5wv7dgnIgG8@public.gmane.org>
Cc: arnd-r2nGTMty4D4@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, jslaby-AlSwsSmVLrQ@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Feb 08, 2016 at 11:16:56AM +0000, Vladimir Murzin wrote:
> On 07/02/16 07:11, Greg KH wrote:
> >> +
> >> +#define SERIAL_NAME "ttyS"
> > 
> > You can't be "ttyS", there's already a serial port named that, please
> > use a unique name and a new major/minor number (dynamic ideally).
> > 
> 
> Hi Greg,
> 
> I did s/ttyMPS/ttyS per your request for v1 [1]. I'm fine to change it
> back if you prefer that, but I'd be glad to know what I've been missing?
> 
> [1] https://lkml.org/lkml/2015/12/13/8

Yeah, I was wrong, sorry about that, my fault.

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
