From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] mm/mincore: allow for making sys_mincore() privileged
Date: Fri, 18 Jan 2019 06:23:02 -0800
Message-ID: <20190118142302.GC50184@devbig004.ftw2.facebook.com>
References: <nycvar.YFH.7.76.1901051817390.16954@cbobk.fhfr.pm>
 <CAHk-=wicks2BEwm1BhdvEj_P3yawmvQuG3NOnjhdrUDEtTGizw@mail.gmail.com>
 <nycvar.YFH.7.76.1901052108390.16954@cbobk.fhfr.pm>
 <CAHk-=whGmE4QVr6NbgHnrVGVENfM3s1y6GNbsfh8PcOg=6bpqw@mail.gmail.com>
 <nycvar.YFH.7.76.1901052131480.16954@cbobk.fhfr.pm>
 <CAHk-=wgrSKyN23yp-npq6+J-4pGqbzxb3mJ183PryjHw7PWDyA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHk-=wgrSKyN23yp-npq6+J-4pGqbzxb3mJ183PryjHw7PWDyA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jiri Kosina <jikos@kernel.org>, Masatake YAMATO <yamato@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hello, Linus.

On Sat, Jan 05, 2019 at 01:54:03PM -0800, Linus Torvalds wrote:
> And the first hit is 'fincore', which probably nobody cares about
> anyway, but it does
> 
>     fd = open (name, O_RDONLY)
>     ..
>     mmap(window, len, PROT_NONE, MAP_PRIVATE, ..

So, folks here have been using fincore(1) for diagnostic purposes and
are also looking to expand on it to investigate per-cgroup cache
usages (mmap -> mincore -> /proc/self/pagemap -> /proc/kpagecgroup ->
cgroup path).

These are all root-only usages to find out what's going on with the
whole page cache.  We aren't attached to doing things this particular
way but it'd suck if there's no way.

Thanks.

-- 
tejun
