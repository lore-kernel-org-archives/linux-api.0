From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 5/8] mm: move lazily freed pages to inactive list
Date: Wed, 4 Nov 2015 09:15:12 +0100
Message-ID: <20151104081512.GB29607@dhcp22.suse.cz>
References: <1446188504-28023-1-git-send-email-minchan@kernel.org>
 <1446188504-28023-6-git-send-email-minchan@kernel.org>
 <20151030172212.GB44946@kernel.org>
 <20151103005223.GD17906@bbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151103005223.GD17906@bbox>
Sender: linux-kernel-owner@vger.kernel.org
To: Minchan Kim <minchan@kernel.org>
Cc: Shaohua Li <shli@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Michael Kerrisk <mtk.manpages@gmail.com>, linux-api@vger.kernel.org, Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>, zhangyanfei@cn.fujitsu.com, Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Jason Evans <je@fb.com>, Daniel Micay <danielmicay@gmail.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, yalin.wang2010@gmail.com, "Wang, Yalin" <Yalin.Wang@sonymobile.com>
List-Id: linux-api@vger.kernel.org

On Tue 03-11-15 09:52:23, Minchan Kim wrote:
[...]
> I believe adding new LRU list would be controversial(ie, not trivial)
> for maintainer POV even though code wouldn't be complicated.
> So, I want to see problems in *real practice*, not any theoritical
> test program before diving into that.
> To see such voice of request, we should release the syscall.
> So, I want to push this first.

Completely agreed. The functionality is useful already and a new LRU
list is not justified yet.
-- 
Michal Hocko
SUSE Labs
