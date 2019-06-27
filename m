From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH v3 1/5] mm: introduce MADV_COLD
Date: Thu, 27 Jun 2019 07:36:50 -0700
Message-ID: <d9341eb3-08eb-3c2b-9786-00b8a4f59953@intel.com>
References: <20190627115405.255259-1-minchan@kernel.org>
 <20190627115405.255259-2-minchan@kernel.org>
 <343599f9-3d99-b74f-1732-368e584fa5ef@intel.com>
 <20190627140203.GB5303@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190627140203.GB5303@dhcp22.suse.cz>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Tim Murray <timmurray@google.com>, Joel Fernandes <joel@joelfernandes.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Colascione <dancol@google.com>, Shakeel Butt <shakeelb@google.com>, Sonny Rao <sonnyrao@google.com>, oleksandr@redhat.com, hdanton@sina.com, lizeb@google.com, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On 6/27/19 7:02 AM, Michal Hocko wrote:
>> Is the LRU behavior part of the interface or the implementation?
>>
>> I ask because we've got something in between tossing something down the
>> LRU and swapping it: page migration.  Specifically, on a system with
>> slower memory media (like persistent memory) we just migrate a page
>> instead of discarding it at reclaim:
> But we already do have interfaces for migrating the memory
> (move_pages(2)). Why should this interface duplicate that interface?
> I believe the only purpose of these two new madvise modes is to provide
> a non-destructive MADV_{DONTNEED,FREE} alteternatives. In other words,
> pageout vs. age interface.

The existing interface's problem for this case is that it has to know
exact locations where the memory is and where it should go.  For
instance, if you have two sockets, you very likely want to demote DRAM
to the persistent memory DIMM sitting next to it and not go
cross-socket.  To do _that_, you need to know where the existing
allocation lies so you can find the appropriate destination node.

That's not a problem for existing NUMA-enlightened apps, but it is for
everything else.

For MADV_COLD, if we defined it like this, I think we could use it for
both purposes (demotion and LRU movement):

	Pages in the specified regions will be treated as less-recently-
	accessed compared to pages in the system with similar access
	frequencies.  In contrast to MADV_DONTNEED, the contents of the
	region are preserved.

It would be nice not to talk about reclaim at all since we're not
promising reclaim per se.
