From: KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH v5] add MAP_UNLOCKED mmap flag
Date: Thu, 14 Jan 2010 16:02:42 +0900 (JST)
Message-ID: <20100114155229.6735.A69D9226@jp.fujitsu.com>
References: <20100114092845.D719.A69D9226@jp.fujitsu.com> <20100114065008.GC18808@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100114065008.GC18808-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gleb Natapov <gleb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-api@vger.kernel.org

> On Thu, Jan 14, 2010 at 09:31:03AM +0900, KOSAKI Motohiro wrote:
> > > If application does mlockall(MCL_FUTURE) it is no longer possible to mmap
> > > file bigger than main memory or allocate big area of anonymous memory
> > > in a thread safe manner. Sometimes it is desirable to lock everything
> > > related to program execution into memory, but still be able to mmap
> > > big file or allocate huge amount of memory and allow OS to swap them on
> > > demand. MAP_UNLOCKED allows to do that.
> > >  
> > > Signed-off-by: Gleb Natapov <gleb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > ---
> > > 
> > > I get reports that people find this useful, so resending.
> > 
> > This description is still wrong. It doesn't describe why this patch is useful.
> > 
> I think the text above describes the feature it adds and its use
> case quite well. Can you elaborate what is missing in your opinion,
> or suggest alternative text please?

My point is, introducing mmap new flags need strong and clearly use-case.
All patch should have good benefit/cost balance. the code can describe the cost,
but the benefit can be only explained by the patch description.

I don't think this poor description explained bit benefit rather than cost.
you should explain why this patch is useful and not just pretty toy.
