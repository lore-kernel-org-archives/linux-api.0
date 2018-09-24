From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [patch v2] mm, thp: always specify ineligible vmas as nh in smaps
Date: Mon, 24 Sep 2018 21:56:03 +0200
Message-ID: <20180924195603.GJ18685@dhcp22.suse.cz>
References: <alpine.DEB.2.21.1809241054050.224429@chino.kir.corp.google.com>
 <e2f159f3-5373-dda4-5904-ed24d029de3c@suse.cz>
 <alpine.DEB.2.21.1809241215170.239142@chino.kir.corp.google.com>
 <alpine.DEB.2.21.1809241227370.241621@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1809241227370.241621@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>, Alexey Dobriyan <adobriyan@gmail.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon 24-09-18 12:30:07, David Rientjes wrote:
> Commit 1860033237d4 ("mm: make PR_SET_THP_DISABLE immediately active")
> introduced a regression in that userspace cannot always determine the set
> of vmas where thp is ineligible.
> 
> Userspace relies on the "nh" flag being emitted as part of /proc/pid/smaps
> to determine if a vma is eligible to be backed by hugepages.

I was under impression that nh resp hg flags only tell about the madvise
status. How do you exactly use these flags in an application?

Your eligible rules as defined here:

> + [*] A process mapping is eligible to be backed by transparent hugepages (thp)
> +     depending on system-wide settings and the mapping itself.  See
> +     Documentation/admin-guide/mm/transhuge.rst for default behavior.  If a
> +     mapping has a flag of "nh", it is not eligible to be backed by hugepages
> +     in any condition, either because of prctl(PR_SET_THP_DISABLE) or
> +     madvise(MADV_NOHUGEPAGE).  PR_SET_THP_DISABLE takes precedence over any
> +     MADV_HUGEPAGE.

doesn't seem to match the reality. I do not see all the file backed
mappings to be nh marked. So is this really about eligibility rather
than the madvise status? Maybe it is just the above documentation that
needs to be updated.

That being said, I do not object to the patch, I am just trying to
understand what is the intended usage for the flag that does try to say
more than the madvise status.
-- 
Michal Hocko
SUSE Labs
