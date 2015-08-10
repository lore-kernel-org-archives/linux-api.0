From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH 1/3] firmware: introduce sysfs driver for QEMU's fw_cfg
 device
Date: Mon, 10 Aug 2015 12:15:09 -0700
Message-ID: <20150810191509.GA7264@kroah.com>
References: <cover.1439220623.git.somlo@cmu.edu>
 <3b039351aba44759627fa77a0003dad685a9f21d.1439220623.git.somlo@cmu.edu>
 <20150810183054.GA18817@kroah.com>
 <20150810190222.GN31816@HEDWIG.INI.CMU.EDU>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150810190222.GN31816-h65ZQ0r4j6KKUezXOiBB2eW1CriLhL8O@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Gabriel L. Somlo" <somlo-D+Gtc/HYRWM@public.gmane.org>
Cc: ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, zajec5-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, paul-DWxLp4Yu+b8AvxtiuMwx3w@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jordan.l.justen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, gleb-RmZWMc9puTNJc61us3aD9laTQe2KTcn/@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, eblake-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, rjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kernelnewbies-7JyXY6prKcjpASu1u0TL5ti2O/JbrIOy@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Aug 10, 2015 at 03:02:22PM -0400, Gabriel L. Somlo wrote:
> Mainly, qemu's fw_cfg is a read-only "device", so one wouldn't ever
> care to try writing anything to it. /sys/firmware/... feels like a fit
> because fw_cfg contains binary blobs originally meant to be used by
> the bios (it's how SeaBIOS and OVMF pull smbios and acpi tables out of
> the host and set them up in guest memory before booting the guest kernel,
> as one of the many examples).
> 
> The most similar example (and the existing driver I used as an example
> during implementation) is dmi-sysfs.c, which also exposes all the
> metadata for each smbios table as numeric (or string) read-only attributes,
> and has a "raw" attribute which allows dumping each table in its
> entirety. Same thing here -- I want to expose the name, size, and
> select key for each blob, but also allow access to the "payload", i.e.
> the blob itself.

That's great, and you can have these "blobs" be an attribute for a
struct device.  Just using a "raw" kobject as you are is hard, as you
have seen, and messy.  Making it a "real" device makes this all much
easier and simpler.

Now if you want to keep things in /sys/firmware/ that's another issue,
and would have to stay as a kobject.  so maybe it does need to remain,
need to think about that...

thanks,

greg k-h
