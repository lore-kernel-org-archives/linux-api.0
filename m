From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v2 1/3] pagemap: add mmap-exclusive bit for marking pages
 mapped only here
Date: Tue, 12 May 2015 13:40:55 +0300
Message-ID: <20150512104055.GB18365@node.dhcp.inet.fi>
References: <20150512090156.24768.2521.stgit@buzz>
 <20150512094303.24768.10282.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20150512094303.24768.10282.stgit@buzz>
Sender: owner-linux-mm@kvack.org
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: linux-mm@kvack.org, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Mark Williamson <mwilliamson@undo-software.com>, Pavel Emelyanov <xemul@parallels.com>, linux-api@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Vlastimil Babka <vbabka@suse.cz>, Pavel Machek <pavel@ucw.cz>, Mark Seaborn <mseaborn@chromium.org>, Linus Torvalds <torvalds@linux-foundation.org>, Daniel James <djames@undo-software.com>, Finn Grimwood <fgrimwood@undo-software.com>
List-Id: linux-api@vger.kernel.org

On Tue, May 12, 2015 at 12:43:03PM +0300, Konstantin Khlebnikov wrote:
> This patch sets bit 56 in pagemap if this page is mapped only once.
> It allows to detect exclusively used pages without exposing PFN:
> 
> present file exclusive state
> 0       0    0         non-present
> 1       1    0         file page mapped somewhere else
> 1       1    1         file page mapped only here
> 1       0    0         anon non-CoWed page (shared with parent/child)
> 1       0    1         anon CoWed page (or never forked)

Probably, worth noting that file-private pages are anon in this context.

-- 
 Kirill A. Shutemov

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
