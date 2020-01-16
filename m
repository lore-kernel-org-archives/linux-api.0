From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH] mm/compaction: Disable compact_unevictable_allowed on RT
Date: Thu, 16 Jan 2020 11:22:39 +0100
Message-ID: <20200116102239.m2trw3cvosn7q5a5@linutronix.de>
References: <20200115161035.893221-1-bigeasy@linutronix.de>
 <4cf4507b-0632-34e6-5985-df933559af9f@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <4cf4507b-0632-34e6-5985-df933559af9f@suse.cz>
Sender: owner-linux-mm@kvack.org
To: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Luis Chamberlain <mcgrof@kernel.org>, Kees Cook <keescook@chromium.org>, Iurii Zaikin <yzaikin@google.com>, Mel Gorman <mgorman@techsingularity.net>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 2020-01-15 23:04:19 [+0100], Vlastimil Babka wrote:
> On 1/15/2020 5:10 PM, Sebastian Andrzej Siewior wrote:
> > Since commit
> >     5bbe3547aa3ba ("mm: allow compaction of unevictable pages")
> > 
> > it is allowed to examine mlocked pages and compact them by default.
> > On -RT even minor pagefaults are problematic because it may take a few
> > 100us to resolve them and until then the task is blocked.
> 
> Fine, this makes sense on RT I guess. There might be some trade-off for
> high-order allocation latencies though. We could perhaps migrate such mlocked
> pages to pages allocated without __GFP_MOVABLE during the mlock() to at least
> somewhat prevent them being scattered all over the zones. For MCL_FUTURE,
> allocate them as unmovable from the beginning. But that can wait until issues
> are reported.
> I assume you have similar solution for NUMA balancing and whatever else can
> cause minor faults?

I've found this one while testing. Could you please point to the NUMA
balancing that might be an issue?

> > Make compact_unevictable_allowed = 0 default and remove it from /proc on
> > RT.
> 
> Removing it is maybe going too far in terms of RT kernel differences confusing
> users? Change the default sure, perhaps making it read-only, but removing?

Okay. I will make it RO then. 

> > Link: https://lore.kernel.org/linux-mm/20190710144138.qyn4tuttdq6h7kqx@linutronix.de/
> 
> In any case the sysctl Documentation/ should be updated? And perhaps also the
> mlock manpage as you noted in the older thread above?

Sure. Let me add the sysctl documentation to this patch and then I will
look into the manpage.

> Thanks,
> Vlastimil

Sebastian
