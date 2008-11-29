From: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RESEND][PATCH] Add /proc/mempool to display mempool usage
Date: Sat, 29 Nov 2008 15:49:07 -0800
Message-ID: <20081129234907.GA2340@kroah.com>
References: <1227980689.6354.24.camel@localhost.localdomain> <20081129214207.GA6747@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20081129214207.GA6747-2ev+ksY9ol182hYKe6nXyg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Remi Colinet <remi.colinet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-3NddpPZAyC0@public.gmane.org, torvalds-3NddpPZAyC0@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sun, Nov 30, 2008 at 12:42:07AM +0300, Alexey Dobriyan wrote:
> On Sat, Nov 29, 2008 at 06:44:49PM +0100, Remi Colinet wrote:
> > This patch add a new /proc/mempool file in order to display mempool usage.
> > 
> > The feature can be disabled with CONFIG_PROC_MEMPOOL=N during kernel
> > configuration.
> 
> We're NOT adding config option per proc file.
> 
> And can we, please, freeze /proc for not per-process stuff and open debugfs
> for random stuff, please?

debugfs has been open for random stuff since the day it was added to the
tree :)

Feel free to put this kind of thing there instead of proc.

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
