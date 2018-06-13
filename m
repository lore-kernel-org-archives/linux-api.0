From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] mm/madvise: allow MADV_DONTNEED to free memory that is
 MLOCK_ONFAULT
Date: Wed, 13 Jun 2018 11:13:55 +0200
Message-ID: <20180613091355.GI13364@dhcp22.suse.cz>
References: <1528484212-7199-1-git-send-email-jbaron@akamai.com>
 <20180611072005.GC13364@dhcp22.suse.cz>
 <4c4de46d-c55a-99a8-469f-e1e634fb8525@akamai.com>
 <20180611150330.GQ13364@dhcp22.suse.cz>
 <775adf2d-140c-1460-857f-2de7b24bafe7@akamai.com>
 <20180612074646.GS13364@dhcp22.suse.cz>
 <5a9398f4-453c-5cb5-6bbc-f20c3affc96a@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5a9398f4-453c-5cb5-6bbc-f20c3affc96a@akamai.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Baron <jbaron@akamai.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Mel Gorman <mgorman@suse.de>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-api@vger.kernel.org, emunson@mgebm.net
List-Id: linux-api@vger.kernel.org

On Tue 12-06-18 10:11:33, Jason Baron wrote:
[...]
> Ok, I share the concern that there is a chance that userspace is relying
> on MADV_DONTNEED not free'ing locked memory. In that case, what if we
> introduce a MADV_DONTNEED_FORCE, which does everything that
> MADV_DONTNEED currently does but in addition will also free mlock areas.

What about other types of vmas that are not allowed to MADV_DONTNEED?
_FORCE suggests that the user of the API know what he is doing so why
shouldn't we allow unmapping hugetlb pages or special PFNMAPS? Or do we
want to add MADV_DONTNEED_FORCE_FOR_REAL when somebody comes with
another usecase?

I agree with Vlastimil that adding new madvise mode for niche case
sounds like a bad idea so we should better be sure that a new flag has
a reasonable semantic. Just allow mlocked pages is more of a tweak than
a proper semantic. So making it force for real requires to analyze what
that would mean for other vmas which are excluded now.
-- 
Michal Hocko
SUSE Labs
