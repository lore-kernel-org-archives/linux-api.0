From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: Re: [PATCH v4 23/79] rds.h: use __u8, __u16, __s16, __u32 and __s64
 from linux/types.h
Date: Fri, 16 Oct 2015 01:39:11 +0300
Message-ID: <20151015223911.GH6104@lakka.kapsi.fi>
References: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
 <1444888618-4506-24-git-send-email-mikko.rapeli@iki.fi>
 <20151015110614.GL948@oracle.com>
 <20151015220025.GG6104@lakka.kapsi.fi>
 <20151015222105.GA12132@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151015222105.GA12132-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sowmini Varadhan <sowmini.varadhan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Oct 15, 2015 at 06:21:05PM -0400, Sowmini Varadhan wrote:
> On (10/16/15 01:00), Mikko Rapeli wrote:
> > 
> > What kind of portability should exported userspace headers from Linux kernel
> > need?
> > 
> > Reviews to my previous changes NACKed <stdint.h> usage and
> > Documentation/CodingStyle chapter 5 says:
> > 
> >  (e) Types safe for use in userspace.
> > 
> >      In certain structures which are visible to userspace, we cannot
> >      require C99 types and cannot use the 'u32' form above. Thus, we
> >      use __u32 and similar types in all structures which are shared
> >      with userspace.
> 
> Let's be clear: we are not talking about u32 vs __u32, we are talking
> about uint32_t vs __u32 in your patch. 
> 
> I dont have the context of your "previous changes NACKed.." etc.
> Why can we not require C99 types in rds.h?

Links to all previous reviews are here:
https://lkml.org/lkml/2015/10/15/22

"uint32_t vs __u32" nail is:
https://lkml.org/lkml/2015/6/1/160

> Why isnt that a problem for, say, <netinet/in.h> which includes
> <stdint.h>?

<netinet/in.h> isn't from Linux kernel, it comes from libc.
<linux/in.h> is from Linux kernel and that does not include <stdint.h>.

But this brough <linux/libc-compat.h> to my attention so thanks for that.
Maybe the <time.h> vs. <linux/time.h> conflict could be resolved with it.

-Mikko
