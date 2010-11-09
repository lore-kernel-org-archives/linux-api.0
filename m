From: KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH v2 17/23] kmsg_dumper: Introduce a new 'SOFT' dump reason
Date: Tue,  9 Nov 2010 14:54:52 +0900 (JST)
Message-ID: <20101109145540.BC72.A69D9226@jp.fujitsu.com>
References: <20101108203316.22479.86025.stgit@crlf.mtv.corp.google.com> <20101109144749.BC6C.A69D9226@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101109144749.BC6C.A69D9226-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, simon.kagstrom-vI6UBbBVNY+JA8cjQkG2/g@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org, Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>, adurbin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, chavey-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Americo Wang <xiyou.wangcong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

> Hi
> 
> > It is a useful to be able to exercise kmsg_dumper implementations without
> > requiring a kernel oops or panic.  This commit adds a new reason called
> > KMSG_DUMP_SOFT, which signifies that the system isn't really going down.
> > 
> > This logic is used in a later commit that introduces the netoops driver.
> > 
> > Signed-off-by: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > ---
> > 
> > It is also possible that we not introduce KMSG_DUMP_SOFT, and simply overload
> > the existing KMSG_DUMP_OOPS reason, but I figured that this would be cleaner.
> > 
> > TODO: Make sure mtdoops and ramoops do something useful with this flag?
> 
> Yes. If userland explicitly want to log, we have no reason to refuse it. :)

I meant I think your change has no problem.




> But, I don't think KMSG_DUMP_SOFT is good name because _SOFT don't explain
> anything.
