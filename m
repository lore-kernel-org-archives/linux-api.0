From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH] usb: core: add usb3 lpm sysfs
Date: Tue, 28 Apr 2015 12:42:24 +0200
Message-ID: <20150428104224.GB540@kroah.com>
References: <20150419034612.GA31576@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150419034612.GA31576-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Zhuang Jin Can <jin.can.zhuang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org, dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, pmladek-AlSwsSmVLrQ@public.gmane.org, peter.chen-KZfg59tc24xl57MIdRCFDg@public.gmane.org, jwerner-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sun, Apr 19, 2015 at 11:46:12AM +0800, Zhuang Jin Can wrote:
> Some usb3 devices may not support usb3 lpm well.
> The patch adds a sysfs to enable/disable u1 or u2 of the port.The
> settings apply to both before and after device enumeration.
> Supported values are "0" - u1 and u2 are disabled, "u1" - only u1 is
> enabled, "u2" - only u2 is enabled, "u1_u2" - u1 and u2 are enabled.
> 
> The interface is useful for testing some USB3 devices during
> development, and provides a way to disable usb3 lpm if the issues can
> not be fixed in final products.

How is a user supposed to "know" to make this setting for a device?  Why
can't the kernel automatically set this value properly?  Why does it
need to be a kernel issue at all?

And when you are doing development of broken devices, the kernel doesn't
have to support you, you can run with debugging patches of your own
until you fix your firmware :)

thanks,

greg k-h
