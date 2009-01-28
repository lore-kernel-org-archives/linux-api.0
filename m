From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH, RFC] Remove fasync() BKL usage, take 3325
Date: Tue, 27 Jan 2009 16:55:04 -0800
Message-ID: <20090127165504.53ed7a2d.akpm@linux-foundation.org>
References: <20090115153211.663df310@bike.lwn.net>
	<20090122065104.2787df2d.akpm@linux-foundation.org>
	<20090122203248.GA20159@infradead.org>
	<20090123045646.GK15750@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090123045646.GK15750-qrUzlfsMFqo/4alezvVtWx2eb7JE58TQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org, viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, 23 Jan 2009 05:56:46 +0100
Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org> wrote:

> On Thu, Jan 22, 2009 at 03:32:49PM -0500, Christoph Hellwig wrote:
> > On Thu, Jan 22, 2009 at 06:51:04AM -0800, Andrew Morton wrote:
> > > OK, replacing a lock_kernel() with a spin_lock(&global_lock) is pretty
> > > straightforwad.  But it's really really sad.  It basically leaves a great
> > > big FIXME in there.  It'd be better to fix it.
> > 
> > 
> > Umm, we've been discussiong this in and out a guestimated million times.
> > 
> > Let's go forward with Jon's patch which is on obvious improvement and
> > if it shows problems later on we can revisit it.
> 
> The point was that we already have a better patch from Oleg.
> 

Where is this patch?
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
