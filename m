From: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] hpsa: convert DEVICE_ATTR to RO|WO|RW and show methods
 must use scnprintf
Date: Tue, 30 Jun 2015 09:38:03 -0700
Message-ID: <20150630163803.GC30564@kroah.com>
References: <DDB9C85B850785449757F9914A034FCB3F8EC219@G4W3219.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <DDB9C85B850785449757F9914A034FCB3F8EC219-MCKW7lC+H9ISZAcGdq5asR6epYMZPwEe5NbjCUgZEJk@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Seymour, Shane M" <shane.seymour-VXdhtT5mjnY@public.gmane.org>
Cc: ISS StorageDev <iss_storagedev-VXdhtT5mjnY@public.gmane.org>, "James Bottomley (JBottomley-O3H1v1f1dlM@public.gmane.org)" <JBottomley-O3H1v1f1dlM@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jun 30, 2015 at 05:22:20AM +0000, Seymour, Shane M wrote:
> 
> Changed DEVICE_ATTR macro usage to DEVICE_ATTR_RO|WO|RW.
> This also forced some show/store function names to change.
> 
> Changed all show method sprint/snprintf usage to scnprintf per
> Documentation/filesystems/sysfs.txt.

There's no need to change sprintf() to scnprintf() at all, that's just
useless churn.

> 
> Signed-off-by: Shane Seymour <shane.seymour-VXdhtT5mjnY@public.gmane.org>
> ---
> --- a/drivers/scsi/hpsa.c	2015-06-25 15:52:15.633031319 -0500
> +++ b/drivers/scsi/hpsa.c	2015-06-29 17:28:24.628475369 -0500
> @@ -376,7 +376,7 @@ static int check_for_busy(struct ctlr_in
>  }
>  
>  static u32 lockup_detected(struct ctlr_info *h);
> -static ssize_t host_show_lockup_detected(struct device *dev,
> +static ssize_t lockup_detected_show(struct device *dev,
>  		struct device_attribute *attr, char *buf)
>  {
>  	int ld;
> @@ -386,10 +386,10 @@ static ssize_t host_show_lockup_detected
>  	h = shost_to_hba(shost);
>  	ld = lockup_detected(h);
>  
> -	return sprintf(buf, "ld=%d\n", ld);
> +	return scnprintf(buf, PAGE_SIZE, "ld=%d\n", ld);

Like here, it's obvious that the original will never overflow, so don't
even worry about checking, it's pointless.

So please don't change this.

greg k-h
