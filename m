From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 2/4] mm: introduce fincore()
Date: Fri, 4 Jul 2014 03:12:30 -0700
Message-ID: <20140704101230.GA24688@infradead.org>
References: <1404424335-30128-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1404424335-30128-3-git-send-email-n-horiguchi@ah.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1404424335-30128-3-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: owner-linux-mm@kvack.org
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Konstantin Khlebnikov <koct9i@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>, Arnaldo Carvalho de Melo <acme@redhat.com>, Borislav Petkov <bp@alien8.de>, "Kirill A. Shutemov" <kirill@shutemov.name>, Johannes Weiner <hannes@cmpxchg.org>, Rusty Russell <rusty@rustcorp.com.au>, David Miller <davem@davemloft.net>, Andres Freund <andres@2ndquadrant.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Dave Hansen <dave.hansen@intel.com>, Christoph Hellwig <hch@infradead.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Linux API <linux-api@vger.kernel.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>
List-Id: linux-api@vger.kernel.org

On Thu, Jul 03, 2014 at 05:52:13PM -0400, Naoya Horiguchi wrote:
> This patch provides a new system call fincore(2), which provides mincore()-
> like information, i.e. page residency of a given file. But unlike mincore(),
> fincore() has a mode flag which allows us to extract detailed information
> about page cache like pfn and page flag. This kind of information is very
> helpful, for example when applications want to know the file cache status
> to control the IO on their own way.

It's still a nasty multiplexer for multiple different reporting formats
in a single system call.  How about your really just do a fincore that
mirrors mincore instead of piggybacking exports of various internal
flags (tags and page flags onto it.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
