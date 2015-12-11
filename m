From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH V4][for-next]mm: add a new vector based madvise syscall
Date: Fri, 11 Dec 2015 19:31:33 +0100
Message-ID: <20151211183133.GR15533@two.firstfloor.org>
References: <d01698140a51cf9b2ce233c7574c2ece9f6fa241.1449791762.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <d01698140a51cf9b2ce233c7574c2ece9f6fa241.1449791762.git.shli@fb.com>
Sender: owner-linux-mm@kvack.org
To: Shaohua Li <shli@fb.com>
Cc: linux-mm@kvack.org, linux-api@vger.kernel.org, Kernel-team@fb.com, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Andrea Arcangeli <aarcange@redhat.com>, Andi Kleen <andi@firstfloor.org>, Minchan Kim <minchan@kernel.org>, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org

On Thu, Dec 10, 2015 at 04:03:37PM -0800, Shaohua Li wrote:
> In jemalloc, a free(3) doesn't immediately free the memory to OS even
> the memory is page aligned/size, and hope the memory can be reused soon.
> Later the virtual address becomes fragmented, and more and more free
> memory are aggregated. If the free memory size is large, jemalloc uses
> madvise(DONT_NEED) to actually free the memory back to OS.
> 

Looks good to me now.

-Andi

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
