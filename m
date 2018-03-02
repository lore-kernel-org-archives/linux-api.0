From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v4 2/4] mm: Split page_type out from _map_count
Date: Fri, 2 Mar 2018 11:18:06 +0300
Message-ID: <20180302081806.aokjrb27hxqki7at@node.shutemov.name>
References: <20180301211523.21104-1-willy@infradead.org>
 <20180301211523.21104-3-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180301211523.21104-3-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-mm@kvack.org, Matthew Wilcox <mawilcox@microsoft.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-kernel@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Mar 01, 2018 at 01:15:21PM -0800, Matthew Wilcox wrote:
> From: Matthew Wilcox <mawilcox@microsoft.com>
> 
> We're already using a union of many fields here, so stop abusing the
> _map_count and make page_type its own field.  That implies renaming some

s/_map_count/_mapcount/

and in subject.

> of the machinery that creates PageBuddy, PageBalloon and PageKmemcg;
> bring back the PG_buddy, PG_balloon and PG_kmemcg names.
> 
> As suggested by Kirill, make page_type a bitmask.  Because it starts out
> life as -1 (thanks to sharing the storage with _map_count), setting a
> page flag means clearing the appropriate bit.  This gives us space for
> probably twenty or so extra bits (depending how paranoid we want to be
> about _mapcount underflow).
> 
> Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
 Kirill A. Shutemov
