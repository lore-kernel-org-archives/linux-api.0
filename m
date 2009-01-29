From: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>
Subject: Re: [PATCH, RFC] Remove fasync() BKL usage, take 3325
Date: Thu, 29 Jan 2009 15:37:56 +0100
Message-ID: <20090129143756.GF7533@one.firstfloor.org>
References: <20090115153211.663df310@bike.lwn.net> <20090122065104.2787df2d.akpm@linux-foundation.org> <20090122203248.GA20159@infradead.org> <20090123045646.GK15750@one.firstfloor.org> <20090127165504.53ed7a2d.akpm@linux-foundation.org> <20090128031439.GA11025@redhat.com> <20090128173618.GA3174@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20090128173618.GA3174-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, corbet-T1hC0tSOHrs@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Jan 28, 2009 at 12:36:18PM -0500, Christoph Hellwig wrote:
> On Wed, Jan 28, 2009 at 04:14:39AM +0100, Oleg Nesterov wrote:
> > I didn't send the actual patch. The idea is,
> > 
> > 	can't we use O_LOCK_FLAGS bit? I agree, it is a bit ugly,
> > 	and I won't insist if you don't like is.
> > 
> > 		static inline int try_lock_f_flags(struct file *file)
> > 		{
> > 			return !test_and_set_bit(O_LOCK_FLAGS, file->f_flags);
> > 		}
> 
> ->f_flags is an unsigned int and the bit macros need an unsigned long.
> Increasing the size of struct file for this is probably a bad idea.


I think very few architectures actually need the unsigned long.

For 2.4 I had a hack (when it did still matter for struct page)
to define a new type for this that denoted the minimal type size
needed here.

That could be reintroduced. Then only the few archs which really
require unsigned long here would pay the overhead.

-Andi

-- 
ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org -- Speaking for myself only.
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
