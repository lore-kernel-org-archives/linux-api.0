From: Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH] mm: introduce MADV_CLR_HUGEPAGE
Date: Wed, 31 May 2017 17:46:25 +0200
Message-ID: <20170531154625.GC302@redhat.com>
References: <20170530074408.GA7969@dhcp22.suse.cz>
 <20170530101921.GA25738@rapoport-lnx>
 <20170530103930.GB7969@dhcp22.suse.cz>
 <20170530140456.GA8412@redhat.com>
 <20170530143941.GK7969@dhcp22.suse.cz>
 <20170530154326.GB8412@redhat.com>
 <20170531120822.GL27783@dhcp22.suse.cz>
 <8FA5E4C2-D289-4AF5-AA09-6C199E58F9A5@linux.vnet.ibm.com>
 <20170531141809.GB302@redhat.com>
 <20170531143216.GR27783@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20170531143216.GR27783@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoprt <rppt@linux.vnet.ibm.com>, Vlastimil Babka <vbabka@suse.cz>, "Kirill A. Shutemov" <kirill@shutemov.name>, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Pavel Emelyanov <xemul@virtuozzo.com>, linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, May 31, 2017 at 04:32:17PM +0200, Michal Hocko wrote:
> I would assume such a patch would be backported to stable trees because
> to me it sounds like the current semantic is simply broken and needs
> fixing anyway but it shouldn't be much different from any other bugs.

So the program would need then to check also for the -stable minor
number where the patch was backported to in addition of any enterprise
kernel backport versioning.

> This is far from ideal from the "guarantee POV" of course.

Agree it's far from ideal and lack of guarantee at least for CRIU
means silent random memory corruption.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
