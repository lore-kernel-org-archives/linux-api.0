From: Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RESEND][PATCH] Add /proc/mempool to display mempool usage
Date: Sun, 30 Nov 2008 00:42:07 +0300
Message-ID: <20081129214207.GA6747@x200.localdomain>
References: <1227980689.6354.24.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1227980689.6354.24.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Remi Colinet <remi.colinet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-3NddpPZAyC0@public.gmane.org, torvalds-3NddpPZAyC0@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sat, Nov 29, 2008 at 06:44:49PM +0100, Remi Colinet wrote:
> This patch add a new /proc/mempool file in order to display mempool usage.
> 
> The feature can be disabled with CONFIG_PROC_MEMPOOL=N during kernel
> configuration.

We're NOT adding config option per proc file.

And can we, please, freeze /proc for not per-process stuff and open debugfs
for random stuff, please?
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
