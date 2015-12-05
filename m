From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH v2 00/13] MADV_FREE support
Date: Sat, 5 Dec 2015 12:10:42 +0100
Message-ID: <20151205111042.GA11598@amd>
References: <1446600367-7976-1-git-send-email-minchan@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1446600367-7976-1-git-send-email-minchan@kernel.org>
Sender: owner-linux-mm@kvack.org
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Michael Kerrisk <mtk.manpages@gmail.com>, linux-api@vger.kernel.org, Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Jason Evans <je@fb.com>, Daniel Micay <danielmicay@gmail.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, Shaohua Li <shli@kernel.org>, Michal Hocko <mhocko@suse.cz>, yalin.wang2010@gmail.com
List-Id: linux-api@vger.kernel.org

On Wed 2015-11-04 10:25:54, Minchan Kim wrote:
> MADV_FREE is on linux-next so long time. The reason was two, I think.
> 
> 1. MADV_FREE code on reclaim path was really mess.

Could you explain what MADV_FREE does?

Comment in code says 'free the page only when there's memory
pressure'. So I mark my caches MADV_FREE, no memory pressure, I can
keep using it? And if there's memory pressure, what happens? I get
zeros? SIGSEGV?

Thanks,
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
