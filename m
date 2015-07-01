From: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] hpsa: convert DEVICE_ATTR to RO|WO|RW and show
 methods must not use snprintf
Date: Tue, 30 Jun 2015 19:29:43 -0700
Message-ID: <20150701022943.GA22097@kroah.com>
References: <DDB9C85B850785449757F9914A034FCB4442D0E6@G9W0766.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <DDB9C85B850785449757F9914A034FCB4442D0E6-4I1V4pQFGigSZAcGdq5asR6epYMZPwEe5NbjCUgZEJk@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Seymour, Shane M" <shane.seymour-VXdhtT5mjnY@public.gmane.org>
Cc: ISS StorageDev <iss_storagedev-VXdhtT5mjnY@public.gmane.org>, "James Bottomley (JBottomley-O3H1v1f1dlM@public.gmane.org)" <JBottomley-O3H1v1f1dlM@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jul 01, 2015 at 01:56:03AM +0000, Seymour, Shane M wrote:
> 
> Changed DEVICE_ATTR macro usage to DEVICE_ATTR_RO|WO|RW.
> This also forced some show/store function names to change.
> 
> Changed all show method snprintf() usage to scnprintf() per
> Documentation/filesystems/sysfs.txt.

Forgot to mention this before, but you are doing two different things,
so this really should be 2 different patches.

But I'm not the scsi maintainer, maybe they have more lax acceptance
rules here :)

thanks,

greg k-h
