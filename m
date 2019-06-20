From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v2 4/5] mm: introduce MADV_PAGEOUT
Date: Thu, 20 Jun 2019 11:22:09 +0200
Message-ID: <20190620092209.GD12083@dhcp22.suse.cz>
References: <20190610111252.239156-1-minchan@kernel.org>
 <20190610111252.239156-5-minchan@kernel.org>
 <20190619132450.GQ2968@dhcp22.suse.cz>
 <20190620041620.GB105727@google.com>
 <20190620070444.GB12083@dhcp22.suse.cz>
 <20190620084040.GD105727@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190620084040.GD105727@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Tim Murray <timmurray@google.com>, Joel Fernandes <joel@joelfernandes.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Colascione <dancol@google.com>, Shakeel Butt <shakeelb@google.com>, Sonny Rao <sonnyrao@google.com>, Brian Geffon <bgeffon@google.com>, jannh@google.com, oleg@redhat.com, christian@brauner.io, oleksandr@redhat.com, hdanton@sina.com, lizeb@google.com
List-Id: linux-api@vger.kernel.org

On Thu 20-06-19 17:40:40, Minchan Kim wrote:
> > > > Pushing out a shared page cache
> > > > is possible even now but this interface gives a much easier tool to
> > > > evict shared state and perform all sorts of timing attacks. Unless I am
> > > > missing something we should be doing something similar to mincore and
> > > > ignore shared pages without a writeable access or at least document why
> > > > we do not care.
> > > 
> > > I'm not sure IIUC side channel attach. As you mentioned, without this syscall,
> > > 1. they already can do that simply by memory hogging
> > 
> > This is way much more harder for practical attacks because the reclaim
> > logic is not fully under the attackers control. Having a direct tool to
> > reclaim memory directly then just opens doors to measure the other
> > consumers of that memory and all sorts of side channel.
> 
> Not sure it's much more harder. It's really easy on my experience.
> Just creating new memory hogger and consume memory step by step until
> you newly allocated pages will be reclaimed.

You can contain an untrusted application into a memcg and it will only
reclaim its own working set.

> > > 2. If we need fix MADV_PAGEOUT, that means we need to fix MADV_DONTNEED, too?
> > 
> > nope because MADV_DONTNEED doesn't unmap from other processes.
> 
> Hmm, I don't understand. MADV_PAGEOUT doesn't unmap from other
> processes, either.

Either I am confused or missing something. shrink_page_list does
try_to_unmap and that unmaps from all processes, right?

> Could you elborate it a bit more what's your concern?

If you manage to unmap from a remote process then you can measure delays
implied from the refault and that information can be used to infer what
the remote application is doing.
-- 
Michal Hocko
SUSE Labs
