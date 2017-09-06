From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH 1/2] pidmap(2)
Date: Wed, 6 Sep 2017 10:30:04 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1709061029270.1843@nanos>
References: <20170905190500.GA13746@avx2> <20170905155320.a683a4853b21a3be32d8b529@linux-foundation.org> <d538b917-3e3e-827c-7ca0-5493961cf6f1@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <d538b917-3e3e-827c-7ca0-5493961cf6f1-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tatsiana Brouka <Tatsiana_Brouka-uRwfk40T5oI@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Aliaksandr Patseyenak <Aliaksandr_Patseyenak1-uRwfk40T5oI@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, 5 Sep 2017, Randy Dunlap wrote:
> On 09/05/17 15:53, Andrew Morton wrote:
> > On Tue, 5 Sep 2017 22:05:00 +0300 Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > 
> >> Implement system call for bulk retrieveing of pids in binary form.
> >>
> >> Using /proc is slower than necessary: 3 syscalls + another 3 for each thread +
> >> converting with atoi().
> >>
> >> /proc may be not mounted especially in containers. Natural extension of
> >> hidepid=2 efforts is to not mount /proc at all.
> >>
> >> It could be used by programs like ps, top or CRIU. Speed increase will
> >> become more drastic once combined with bulk retrieval of process statistics.
> > 
> > The patches are performance optimizations, but their changelogs contain
> > no performance measurements!
> > 
> > Demonstration of some compelling real-world performance benefits would
> > help things along a lot.
> > 
> 
> also, I expect that the tiny kernel people will want kconfig options for
> these syscalls.

And of course that stuff wants the corresponding man pages written up.

Thanks,

	tglx
