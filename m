From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH v6] add MAP_UNLOCKED mmap flag
Date: Wed, 20 Jan 2010 09:24:06 +0900 (JST)
Message-ID: <20100120091051.405D.A69D9226@jp.fujitsu.com>
References: <20100119082638.GK14345@redhat.com> <84144f021001190044s397c6665qb00af48235d2d818@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <84144f021001190044s397c6665qb00af48235d2d818@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: kosaki.motohiro@jp.fujitsu.com, Gleb Natapov <gleb@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, akpm@linux-foundation.org, andrew.c.morrow@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, minchan.kim@gmail.com
List-Id: linux-api@vger.kernel.org

> Hi Gleb,
> 
> On Tue, Jan 19, 2010 at 10:26 AM, Gleb Natapov <gleb@redhat.com> wrote:
> >> design would still be broken, no? Did you try using (or extending)
> >> posix_madvise(MADV_DONTNEED) for the guest address space? It seems to
> > After mlockall() I can't even allocate guest address space. Or do you mean
> > instead of mlockall()? Then how MADV_DONTNEED will help? It just drops
> > page table for the address range (which is not what I need) and does not
> > have any long time effect.
> 
> Oh right, MADV_DONTNEED is no good.

Off topic:

posix_madvise(MADV_DONTNEED) is nop. glibc's posix_madvise(MADV_DONTNEED)
don't call linux's madvise(MADV_DONTNEED).
It's because madvise(MADV_DONTNEED) is not POSIX compliant. 

The behavior of linux madvise(MADV_DONTNEED) is similar to Solaris (or *BSD) 
madvise(MADV_FREE).




--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
