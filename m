From: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
Subject: Re: [PATCH, RFC] Remove fasync() BKL usage, take 3325
Date: Thu, 22 Jan 2009 22:21:41 -0700
Message-ID: <20090122222141.4a9501e1@tpl>
References: <20090115153211.663df310@bike.lwn.net>
	<20090122065104.2787df2d.akpm@linux-foundation.org>
	<20090122160935.GI15750@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090122160935.GI15750-qrUzlfsMFqo/4alezvVtWx2eb7JE58TQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org, viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, 22 Jan 2009 17:09:35 +0100
Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org> wrote:

> > OK, replacing a lock_kernel() with a spin_lock(&global_lock) is
> > pretty straightforwad.  But it's really really sad.  It basically
> > leaves a great big FIXME in there.  It'd be better to fix it.  
> 
> Also it might be that it's even worse than the BKL.

I don't quite see how now.  Like the BKL, it's a spinlock.

> It would still require a bitlock because some state in the low
> level fasync needs to be protected.
> 
> Oleg has a proposal to do this using a flag bit which seemed
> reasonable to me.

I didn't see a reason to add a one-off custom locking regime for such a
non-hot-path situation.  But it would certainly work; if we want to go
that way I'll not fight it.

jon
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
