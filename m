From: Hugh Dickins <hugh-DTz5qymZ9yRBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] getrusage: fill ru_ixrss, ru_idrss and ru_isrss values
Date: Thu, 15 Jan 2009 19:09:30 +0000 (GMT)
Message-ID: <Pine.LNX.4.64.0901151826200.23056@blonde.anvils>
References: <20090115153827.459ec787@psychotron.englab.brq.redhat.com>
 <20090115154656.72e01ce9@psychotron.englab.brq.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090115154656.72e01ce9-YzwxZg+R7evSU73v1vjTzyO4YDw3rz4rAInAS/Ez/D0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jiri Pirko <jpirko-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, niemi-6DIZ2vNPO+SsTnJN9+BGXg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, 15 Jan 2009, Jiri Pirko wrote:
> 
> This patch makes three values in rusage structure filled in getrusage
> syscall. These values are in KB units so as the ->ru_maxrss value. They
> are ru_ixrss, ru_idrss and ru_isrss. Note that also these values are
> wrongly converted from pages to KBs by GNU time application (patch
> posted to app. maintainer).

I've a suspicion that you're driven by the desire to fill in struct
rusage with plausible non-zero values.  That's a laudable desire;
but adding bloat to struct signal_struct and struct task_struct and
the processing at critical junctures will need stronger justification.

Please provide testimonials from sysadmins explaining the need for
this information and how it will be put to good use: for very very
many of our users it is going to be bloat and nothing more.

A quick look at three popular distros shows that those all have
CONFIG_TASK_XACCT=y, and I bet their enterprise equivalents do too.
I was going to use that as an argument against the bloat; but you
can rightly turn it around to a demonstration of the thirst for
better statistics!

However, I'll always tend to be arguing against bloat, and I know
far too little about what's useful to sysadmins: others will judge
that balance better.  And I really ought to apologize for flinging
around the word "bloat": it's too easy a way to short-circuit and
poison reasonable discussion.

But on looking closer, there's a stronger reason to oppose this patch.
You're trying to add support for the struct rusage fields
	long	ru_maxrss;		/* maximum resident set size */
	long	ru_ixrss;		/* integral shared memory size */
	long	ru_idrss;		/* integral unshared data size */
	long	ru_isrss;		/* integral unshared stack size */
And your previous patch added support for the first of those fields,
correctly based on hiwater of anon_rss+file_rss already accounted.

The next three fields, the subject of this patch, are named ru_XXrss:
though the 80-column comment omits to say "resident set" before "size",
I believe they'd be expected to account (subdivided) resident set sizes?

Yet your numbers originate from total_vm, shared_vm and stack_vm:
which just come from extents of vmas, being only upper limits on
the respective subdivisions of rss.  (It was otherwise in 2.4:
but the cripplingly great expense of maintaining the original
stats led wli to replace them by the vm_stat_account heuristic.)

So I'm afraid your ru_ixrss, ru_idrss, ru_isrss would actually
be more misleading than leaving zeroes in there.

Hugh
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
