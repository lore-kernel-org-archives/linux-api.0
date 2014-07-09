From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 0/3] mm: introduce fincore() v3
Date: Wed, 9 Jul 2014 01:51:59 -0700
Message-ID: <20140709085159.GA10693@infradead.org>
References: <1404756006-23794-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <20140708121618.GA2554@infradead.org>
 <20140708132755.GA24698@nhori>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20140708132755.GA24698@nhori>
Sender: owner-linux-mm@kvack.org
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Konstantin Khlebnikov <koct9i@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>, Arnaldo Carvalho de Melo <acme@redhat.com>, Borislav Petkov <bp@alien8.de>, "Kirill A. Shutemov" <kirill@shutemov.name>, Johannes Weiner <hannes@cmpxchg.org>, Rusty Russell <rusty@rustcorp.com.au>, David Miller <davem@davemloft.net>, Andres Freund <andres@2ndquadrant.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Dave Hansen <dave.hansen@intel.com>, Dave Chinner <david@fromorbit.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Linux API <linux-api@vger.kernel.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 08, 2014 at 09:27:55AM -0400, Naoya Horiguchi wrote:
> On Tue, Jul 08, 2014 at 05:16:18AM -0700, Christoph Hellwig wrote:
> > Still a hard NAK for exposing page flags in a syscall ABI.  These are
> > way to volatile to go into an application interface.
> 
> Is there any specific reason that exporting via syscall ABI is more
> volatile than exporting via procfs as /proc/kpageflags alreadly does?

An optional proc debug output is very different from an actual system
call.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
