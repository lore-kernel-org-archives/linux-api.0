From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH v3 1/3] mm: introduce fincore()
Date: Tue, 08 Jul 2014 12:42:58 -0700
Message-ID: <53BC49C2.8090409@intel.com>
References: <1404756006-23794-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1404756006-23794-2-git-send-email-n-horiguchi@ah.jp.nec.com> <53BAEE95.50807@intel.com> <20140708190326.GA28595@nhori>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20140708190326.GA28595@nhori>
Sender: owner-linux-mm@kvack.org
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Konstantin Khlebnikov <koct9i@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>, Arnaldo Carvalho de Melo <acme@redhat.com>, Borislav Petkov <bp@alien8.de>, "Kirill A. Shutemov" <kirill@shutemov.name>, Johannes Weiner <hannes@cmpxchg.org>, Rusty Russell <rusty@rustcorp.com.au>, David Miller <davem@davemloft.net>, Andres Freund <andres@2ndquadrant.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Linux API <linux-api@vger.kernel.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>, Kees Cook <kees@outflux.net>
List-Id: linux-api@vger.kernel.org

On 07/08/2014 12:03 PM, Naoya Horiguchi wrote:
>> > The biggest question for me, though, is whether we want to start
>> > designing these per-page interfaces to consider different page sizes, or
>> > whether we're going to just continue to pretend that the entire world is
>> > 4k pages.  Using FINCORE_BMAP on 1GB hugetlbfs files would be a bit
>> > silly, for instance.
> I didn't answer this question, sorry.
> 
> In my option, hugetlbfs pages should be handled as one hugepage (not as
> many 4kB pages) to avoid lots of meaningless data transfer, as you pointed
> out. And the current patch already works like that.

Just reading the code, I don't see any way that pc_shift gets passed
down in to the do_fincore() loop.  I don't see it getting reflected in
to 'nr' or 'nr_pages' in there, and I can't see how:

	jump = iter.index - fc->pgstart - nr;

can possibly be right since iter.index is being kept against the offset
in the userspace buffer (4k pages) and 'nr' and fc->pgstart are
essentially done in the huge page size.

If you had a 2-page 1GB-hpage_size() hugetlbfs file, you would only have
two pages in the radix tree, and only two iterations of
radix_tree_for_each_slot().  It would only set the first two bytes of a
256k BMAP buffer since only two pages were encountered in the radix tree.

Or am I reading your code wrong again?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
