From: Jiri Kosina <jikos@kernel.org>
Subject: Re: [PATCH] mm/mincore: allow for making sys_mincore() privileged
Date: Sun, 6 Jan 2019 00:09:02 +0100 (CET)
Message-ID: <nycvar.YFH.7.76.1901060001590.16954@cbobk.fhfr.pm>
References: <nycvar.YFH.7.76.1901051817390.16954@cbobk.fhfr.pm> <CAG48ez2jAp9xkPXQmVXm0PqNrFGscg9BufQRem2UD8FGX-YzPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG48ez2jAp9xkPXQmVXm0PqNrFGscg9BufQRem2UD8FGX-YzPw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, Michal Hocko <mhocko@suse.com>, Linux-MM <linux-mm@kvack.org>, kernel list <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Sat, 5 Jan 2019, Jann Horn wrote:

> > Provide vm.mincore_privileged sysctl, which makes it possible to mincore()
> > start returning -EPERM in case it's invoked by a process lacking
> > CAP_SYS_ADMIN.
> >
> > The default behavior stays "mincore() can be used by anybody" in order to
> > be conservative with respect to userspace behavior.
> >
> > [1] https://www.theregister.co.uk/2019/01/05/boffins_beat_page_cache/
> 
> Just checking: I guess /proc/$pid/pagemap (iow, the pagemap_read()
> handler) is less problematic because it only returns data about the
> state of page tables, and doesn't query the address_space? In other
> words, it permits monitoring evictions, but non-intrusively detecting
> that something has been loaded into memory by another process is
> harder?

So I was just about to immediately reply that we don't expose pagemap 
anymore due to rowhammer, but apparently that's not true any more 
(this behavioud was originally introduced by ab676b7d6fbf, but then 
changed via 1c90308e7a77 (and further adjusted for swap entries in 
ab6ecf247a, but I guess that's not all that interesting).

Hmm.

But unless it has been mapped with MAP_POPULATE (whcih is outside the 
attacker's control), there is no guarantee that the mappings would 
actually be there, right?

-- 
Jiri Kosina
SUSE Labs
