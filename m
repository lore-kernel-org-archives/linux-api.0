From: Cyril Hrubis <chrubis@suse.cz>
Subject: Re: [PATCH] mm,mremap: Bail out earlier in mremap_to under map
 pressure
Date: Fri, 1 Mar 2019 16:25:48 +0100
Message-ID: <20190301152547.GA25732@rei>
References: <20190226091314.18446-1-osalvador@suse.de>
 <20190226140428.3e7c8188eda6a54f9da08c43@linux-foundation.org>
 <20190227213205.5wdjucqdgfqx33tr@d104.suse.de>
 <5edcfeb8-4f53-0fe6-1e5b-c1e485f91d0d@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5edcfeb8-4f53-0fe6-1e5b-c1e485f91d0d@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Oscar Salvador <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, hughd@google.com, kirill@shutemov.name, joel@joelfernandes.org, jglisse@redhat.com, yang.shi@linux.alibaba.com, mgorman@techsingularity.net
List-Id: linux-api@vger.kernel.org

Hi!
> Hopefully the only program that would start failing would be a LTP test
> testing the current behavior near the limit (if such test exists). And
> that can be adjusted.

There does not seem to be a mremap() test that would do such a thing, so
we should be safe :-).

BTW there was a similar fix for mmap() with MAP_FIXED that caused a LTP
test to fail and was fixed in:

commit e8420a8ece80b3fe810415ecf061d54ca7fab266
Author: Cyril Hrubis <chrubis@suse.cz>
Date:   Mon Apr 29 15:08:33 2013 -0700

    mm/mmap: check for RLIMIT_AS before unmapping

And I haven't heard of any breakages so far so I guess that this very
similar situation and that the possibility of breaking real world
applications here is really low.

-- 
Cyril Hrubis
chrubis@suse.cz
