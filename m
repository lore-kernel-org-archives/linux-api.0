From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v10 7/7] mm: Don't split THP page when syscall is called
Date: Tue, 8 Jul 2014 12:48:10 +0300
Message-ID: <20140708094810.GB3490@node.dhcp.inet.fi>
References: <1404694438-10272-1-git-send-email-minchan@kernel.org>
 <1404694438-10272-8-git-send-email-minchan@kernel.org>
 <20140707111303.GC23150@node.dhcp.inet.fi>
 <20140708013038.GD6076@bbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20140708013038.GD6076@bbox>
Sender: owner-linux-mm@kvack.org
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Michael Kerrisk <mtk.manpages@gmail.com>, Linux API <linux-api@vger.kernel.org>, Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Mel Gorman <mgorman@suse.de>, Jason Evans <je@fb.com>, Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 08, 2014 at 10:30:38AM +0900, Minchan Kim wrote:
> Actually, I did but found no problem except CONFIG_DEBUG_VM but rollback
> after peeking [1].
> When I read the description in detail by your review, I think we can remove
> BUG_ON(PageTransHuge(page)) in try_to_unmap and go with no split for lazyfree
> page because they are not in swapcache any more so the assumption of [1] is
> not valid. Will do it in next revision.

No. try_to_unmap() knows nothing about PMDs, so page_check_address() will
always return NULL for THP and you will not unmap anything.

-- 
 Kirill A. Shutemov

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
