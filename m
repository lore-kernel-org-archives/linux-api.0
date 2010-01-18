From: KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: + prctl-add-pr_set_proctitle_area-option-for-prctl.patch added to -mm tree
Date: Mon, 18 Jan 2010 10:48:29 +0900 (JST)
Message-ID: <20100118104802.AE2A.A69D9226@jp.fujitsu.com>
References: <20100118093413.AE1C.A69D9226@jp.fujitsu.com> <4B53BD61.9040609@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B53BD61.9040609-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mm-commits-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bdonlan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, drepper-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tss-X3B1VOXEql0@public.gmane.org, xiyou.wangcong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

> On 01/17/2010 04:56 PM, KOSAKI Motohiro wrote:
> >>
> >> Sorry for the late feedback...
> >>
> >> On the subject of this patch: would it also make sense to have a prctl()
> >> to give the kernel the address of the "environ" variable, so that
> >> /proc/*/environ can give the *current* environment inside the process
> >> (which is otherwise strictly a user-space matter) as opposed to the
> >> initial environment passed by the kernel (unless modified in-place)?
> > 
> > Thank you good comments! 
> > I have two comments.
> > 
> > 1 Yes, to change /proc/*/environ makes lots sense. probably.
> >   My last worry is, If security aware daemon want to hide environment intentionally,
> >   it should be able to do. iow, automatical environ area finding seems bad. 
> >   probably we need new prctl or new syscall.
> 
> Finding environ automatically is not only bad, but totally impractical
> (how would the kernel know where environ is?)  However, libc could
> invoke a prctl to point the kernel at environ.

Sure. okey, I'm prepare such new prctl.
