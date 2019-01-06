From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] mm/mincore: allow for making sys_mincore() privileged
Date: Sat, 5 Jan 2019 16:11:38 -0800
Message-ID: <20190106001138.GW6310@bombadil.infradead.org>
References: <nycvar.YFH.7.76.1901051817390.16954@cbobk.fhfr.pm>
 <CAG48ez2jAp9xkPXQmVXm0PqNrFGscg9BufQRem2UD8FGX-YzPw@mail.gmail.com>
 <CAHk-=whL4sZiM=JcdQAYQvHm7h7xEtVUh+gYGYhoSk4vi38tXg@mail.gmail.com>
 <CAHk-=wg5Kk+r36=jcGBaLUj+gjopjgiW5eyvkdMqvn0jFkD_iQ@mail.gmail.com>
 <CAHk-=wiMQeCEKESWTmm15x79NjEjNwFvjZ=9XenxY7yH8zqa7A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHk-=wiMQeCEKESWTmm15x79NjEjNwFvjZ=9XenxY7yH8zqa7A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jann Horn <jannh@google.com>, Jiri Kosina <jikos@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, Michal Hocko <mhocko@suse.com>, Linux-MM <linux-mm@kvack.org>, kernel list <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Sat, Jan 05, 2019 at 03:39:10PM -0800, Linus Torvalds wrote:
> On Sat, Jan 5, 2019 at 3:16 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > It goes back to forever, it looks like. I can't find a reason.
> 
> mincore() was originally added in 2.3.52pre3, it looks like. Around
> 2000 or so. But sadly before the BK history.
> 
> And that comment about
> 
>   "Later we can get more picky about what "in core" means precisely."
> 
> that still exists above mincore_page() goes back to the original patch.

FreeBSD claims to have a manpage from SunOS 4.1.3 with mincore (!)

https://www.freebsd.org/cgi/man.cgi?query=mincore&apropos=0&sektion=0&manpath=SunOS+4.1.3&arch=default&format=html

DESCRIPTION
       mincore()  returns  the primary memory residency	status of pages	in the
       address space covered by	mappings in the	range [addr, addr + len).  The
       status is returned as a char-per-page in	the character array referenced
       by *vec (which the system assumes to be large enough to	encompass  all
       the  pages  in  the  address range).  The least significant bit of each
       character is set	to 1 to	indicate that the referenced page is  in  pri-
       mary  memory, 0 if it is	not.  The settings of other bits in each char-
       acter is	undefined and may contain other	information in the future.
