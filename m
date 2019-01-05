From: Jiri Kosina <jikos@kernel.org>
Subject: Re: [PATCH] mm/mincore: allow for making sys_mincore() privileged
Date: Sat, 5 Jan 2019 20:24:03 +0100 (CET)
Message-ID: <nycvar.YFH.7.76.1901052016250.16954@cbobk.fhfr.pm>
References: <nycvar.YFH.7.76.1901051817390.16954@cbobk.fhfr.pm> <d4846cb2-2a4b-b8b3-daac-e5f51751bbf1@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <d4846cb2-2a4b-b8b3-daac-e5f51751bbf1@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Sat, 5 Jan 2019, Vlastimil Babka wrote:

> > There are possibilities [1] how mincore() could be used as a converyor of 
> > a sidechannel information about pagecache metadata.
> > 
> > Provide vm.mincore_privileged sysctl, which makes it possible to mincore() 
> > start returning -EPERM in case it's invoked by a process lacking 
> > CAP_SYS_ADMIN.
> 
> Haven't checked the details yet, but wouldn't it be safe if anonymous private
> mincore() kept working, and restrictions were applied only to page cache?

I was considering that, but then I decided not to do so, as that'd make 
the interface even more confusing and semantics non-obvious in the 
'privileged' case.

> > The default behavior stays "mincore() can be used by anybody" in order to 
> > be conservative with respect to userspace behavior.
> 
> What if we lied instead of returned -EPERM, to not break userspace so 
> obviously? I guess false positive would be the safer lie?

So your proposal basically would be

if (privileged && !CAP_SYS_ADMIN)
	if (pagecache)
		return false;
	else
		return do_mincore()

right ?

I think userspace would hate us for that semantics, but on the other hand 
I can sort of understand the 'mincore() is racy anyway, so what' argument, 
if that's what you are suggesting.

But then, I have no idea what userspace is using mincore() for. 
https://codesearch.debian.net/search?q=mincore might provide some insight 
I guess (thanks Matthew).

-- 
Jiri Kosina
SUSE Labs
