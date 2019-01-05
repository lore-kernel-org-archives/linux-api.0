From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] mm/mincore: allow for making sys_mincore() privileged
Date: Sat, 5 Jan 2019 15:05:43 -0800
Message-ID: <CAHk-=whL4sZiM=JcdQAYQvHm7h7xEtVUh+gYGYhoSk4vi38tXg@mail.gmail.com>
References: <nycvar.YFH.7.76.1901051817390.16954@cbobk.fhfr.pm> <CAG48ez2jAp9xkPXQmVXm0PqNrFGscg9BufQRem2UD8FGX-YzPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG48ez2jAp9xkPXQmVXm0PqNrFGscg9BufQRem2UD8FGX-YzPw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: Jiri Kosina <jikos@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, Michal Hocko <mhocko@suse.com>, Linux-MM <linux-mm@kvack.org>, kernel list <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Sat, Jan 5, 2019 at 2:55 PM Jann Horn <jannh@google.com> wrote:
>
> Just checking: I guess /proc/$pid/pagemap (iow, the pagemap_read()
> handler) is less problematic because it only returns data about the
> state of page tables, and doesn't query the address_space? In other
> words, it permits monitoring evictions, but non-intrusively detecting
> that something has been loaded into memory by another process is
> harder?

Yes. I think it was brought up during the original report, but to use
the pagemap for this, you'd basically need to first populate all the
pages, and then wait for pageout.

So pagemap *does* leak very similar data, but it's much harder to use
as an attack vector.

That said, I think "mincore()" is just the simple one. You *can* (and
this was also discussed on the security list) do things like

 - fault in a single page

 - the kernel will opportunistically fault in pages that it already
has available _around_ that page.

 - then use pagemap (or just _timing_ - no real kernel support needed)
to see if those pages are now mapped in your address space

so honestly, mincore is just the "big hammer" and easy way to get at
some of this data. But it's probably worth closing exactly because
it's easy. There are other ways to get at the "are these pages mapped"
information, but they are a lot more combersome to use.

Side note: maybe we could just remove the "__mincore_unmapped_range()"
thing entirely, and basically make mincore() do what pagemap does,
which is to say "are the pages mapped in this VM".

That would be nicer than my patch, simply because removing code is
always nice. And arguably it's a better semantic anyway.

                Linus
