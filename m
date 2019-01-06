From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] mm/mincore: allow for making sys_mincore() privileged
Date: Sat, 5 Jan 2019 16:22:47 -0800
Message-ID: <CAHk-=wiT=ov+6zYcnw_64ihYf74Amzqs67iVGtJMQq65PxiVYw@mail.gmail.com>
References: <nycvar.YFH.7.76.1901051817390.16954@cbobk.fhfr.pm>
 <CAG48ez2jAp9xkPXQmVXm0PqNrFGscg9BufQRem2UD8FGX-YzPw@mail.gmail.com>
 <CAHk-=whL4sZiM=JcdQAYQvHm7h7xEtVUh+gYGYhoSk4vi38tXg@mail.gmail.com>
 <CAHk-=wg5Kk+r36=jcGBaLUj+gjopjgiW5eyvkdMqvn0jFkD_iQ@mail.gmail.com>
 <CAHk-=wiMQeCEKESWTmm15x79NjEjNwFvjZ=9XenxY7yH8zqa7A@mail.gmail.com> <20190106001138.GW6310@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190106001138.GW6310@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: Jann Horn <jannh@google.com>, Jiri Kosina <jikos@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, Michal Hocko <mhocko@suse.com>, Linux-MM <linux-mm@kvack.org>, kernel list <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Sat, Jan 5, 2019 at 4:11 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> FreeBSD claims to have a manpage from SunOS 4.1.3 with mincore (!)
>
> https://www.freebsd.org/cgi/man.cgi?query=mincore&apropos=0&sektion=0&manpath=SunOS+4.1.3&arch=default&format=html
>
> DESCRIPTION
>        mincore()  returns  the primary memory residency status of pages in the
>        address space covered by mappings in the range [addr, addr + len).

It's still not clear that "primary memory residency status" actually means.

Does it mean "mapped", or does it mean "exists in caches and doesn't need IO".

I don't even know what kind of caches SunOS 4.1.3 had. The Linux
implementation depends on the page cache, and wouldn't work (at least
not very well) in a system that has a traditional disk buffer cache.

Anyway, I guess it's mostly moot. From a "does this cause regressions"
standpoint, the only thing that matters is really whatever Linux
programs that have used this since it was introduced 18+ years ago.

But I think my patch to just rip out all that page lookup, and just
base it on the page table state has the fundamental advantage that it
gets rid of code. Maybe I should jst commit it, and see if anything
breaks? We do have options in case things break, and then we'd at
least know who cares (and perhaps a lot more information of _why_ they
care).

                     Linus
