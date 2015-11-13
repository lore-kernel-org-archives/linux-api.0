From: Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v3 03/17] arch: uapi: asm: mman.h: Let MADV_FREE have
 same value for all architectures
Date: Fri, 13 Nov 2015 15:18:55 +0900
Message-ID: <20151113061855.GD5235@bbox>
References: <1447302793-5376-1-git-send-email-minchan@kernel.org>
 <1447302793-5376-4-git-send-email-minchan@kernel.org>
 <20151112112753.GC22481@node.shutemov.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20151112112753.GC22481@node.shutemov.name>
Content-Disposition: inline
Sender: linux-arch-owner@vger.kernel.org
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Michael Kerrisk <mtk.manpages@gmail.com>, linux-api@vger.kernel.org, Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Jason Evans <je@fb.com>, Daniel Micay <danielmicay@gmail.com>, Shaohua Li <shli@kernel.org>, Michal Hocko <mhocko@suse.cz>, yalin.wang2010@gmail.com, Chen Gang <gang.chen.5i5j@gmail.com>, "rth@twiddle.net" <rth@twiddle.net>, "ink@jurassic.park.msu.ru" <ink@jurassic.park.msu.ru>, "mattst88@gmail.com" <mattst88@gmail.com>, Ralf Baechle <ralf@linux-mips.org>, "jejb@parisc-linux.org" <jejb@parisc-linux.org>, "deller@gmx.de" <deller@gmx.de>, "chris@zankel.net" <chris@zankel.net>, "jcmvbkbc@gmail.com" <jcmvbkbc@gmail.com>, Arnd
List-Id: linux-api@vger.kernel.org

On Thu, Nov 12, 2015 at 01:27:53PM +0200, Kirill A. Shutemov wrote:
> On Thu, Nov 12, 2015 at 01:32:59PM +0900, Minchan Kim wrote:
> > From: Chen Gang <gang.chen.5i5j@gmail.com>
> > 
> > For uapi, need try to let all macros have same value, and MADV_FREE is
> > added into main branch recently, so need redefine MADV_FREE for it.
> > 
> > At present, '8' can be shared with all architectures, so redefine it to
> > '8'.
> 
> Why not fold the patch into thre previous one?

Because it was a little bit arguable at that time whether we could use
number 8 for all of arches. If so, simply I can drop this patch only.
