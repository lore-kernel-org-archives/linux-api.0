From: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>
Subject: Re: [PATCH, RFC] Remove fasync() BKL usage, take 3325
Date: Fri, 23 Jan 2009 07:15:57 +0100
Message-ID: <20090123061557.GM15750@one.firstfloor.org>
References: <20090115153211.663df310@bike.lwn.net> <20090122065104.2787df2d.akpm@linux-foundation.org> <20090122221500.4c62aa54@tpl> <20090122213105.74142908.akpm@linux-foundation.org> <1232689549.5202.385.camel@calx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1232689549.5202.385.camel@calx>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org, viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org
List-Id: linux-api@vger.kernel.org

> I have to agree with Christoph. The priority here is breaking down the
> BKL and document all the things being protected by it and we've got a
> reasonably obvious patch in that direction. Meanwhile, there's not
> currently a pressing demand to make fasync in particular scale that I'm
> aware of.

The classic case is a high throughput network server that uses async
sockets. It has to call F_SETFL on each new socket it opens.

> Having a single big lock here is quite possibly something we'll want to
> fix down the road, agreed, but until we can actually measure it hurting
> us, debating about whether to use a bit lock or reuse an existing lock
> or add a new lock to all struct files is a bit premature.

I think i would agree with you if we didn't have a better patch
already, but if there's one it doesn't make sense not to use it.

-Andi

-- 
ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org -- Speaking for myself only.
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
