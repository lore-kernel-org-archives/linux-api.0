From: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] HID: roccat: Fixed resubmit: Deprecating most Roccat
 sysfs attributes
Date: Sat, 17 Oct 2015 08:41:02 -0700
Message-ID: <20151017154102.GC4059@kroah.com>
References: <1444921209.2900.17.camel@neuromancer.tessier-ashpool>
 <20151015184944.GA1226@kroah.com>
 <1445087428.2322.10.camel@neuromancer.tessier-ashpool>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1445087428.2322.10.camel-/ZsuMndpQpv+LLWKTYdlgUWBcfzl8p5a/AviwAImx+Y@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefan Achatz <erazor_de-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Cc: jkosina-AlSwsSmVLrQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-input-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sat, Oct 17, 2015 at 03:10:28PM +0200, Stefan Achatz wrote:
> Deprecates all Roccat sysfs attributes except the ones for the old Kone by moving
> abi descriptions from testing to obsolete.
> For most devices everything can be done using the hidraw ioctls HIDIOCGFEATURE
> and HIDIOCSFEATURE, so I would suggest future removal of device specific drivers.
> The userspace tools don't use these attributes for a year now.
> The first Kone is not fully HID-compliant and will still need a module.
> 
> Fix: Resubmitting this patch, now done with 'git format-patch -M' like Greg KH suggested.

Nit, there should be a 'v2' in the [] area of the subject line, and this
line shoudl be below the --- line so it doesn't show up in the
changelog.

I don't know if Jiri wants this to be resent because of this or not, I
know I would require it...

thanks,

greg k-h
