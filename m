From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH, RFC] Remove fasync() BKL usage, take 3325
Date: Thu, 22 Jan 2009 22:57:13 -0800
Message-ID: <20090122225713.2b2a02cc.akpm@linux-foundation.org>
References: <20090115153211.663df310@bike.lwn.net>
	<20090122065104.2787df2d.akpm@linux-foundation.org>
	<20090122221500.4c62aa54@tpl>
	<20090122213105.74142908.akpm@linux-foundation.org>
	<20090123055404.GL15750@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090123055404.GL15750-qrUzlfsMFqo/4alezvVtWx2eb7JE58TQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: corbet-T1hC0tSOHrs@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org, viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org
List-Id: linux-api@vger.kernel.org

> On Fri, 23 Jan 2009 06:54:04 +0100 Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org> wrote:
> > I don't know what "the fasync() problem" is?
> 
> The state needs to be protected while the per driver ->fasync callback
> runs, otherwise the bit can get out of sync with what the driver
> thinks it is.

That's the sort of gem which one thinks might have merited a code comment
and some changelog discussion.

> Mind you imho the best way would be to move the bit manipulation for
> that into the drivers, but that would require to change them all.

Do these mystery drivers do the ->f_flags changes under lock_kernel()?  If
so, they all should be changed to take lock_file_flgs()?

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
