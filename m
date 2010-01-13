From: Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH v5] add MAP_UNLOCKED mmap flag
Date: Wed, 13 Jan 2010 09:31:52 -0800
Message-ID: <20100113173152.GA2666@sequoia.sous-sol.org>
References: <20100113093119.GT7549@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20100113093119.GT7549@redhat.com>
Sender: owner-linux-mm@kvack.org
To: Gleb Natapov <gleb@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, akpm@linux-foundation.org
List-Id: linux-api@vger.kernel.org

* Gleb Natapov (gleb@redhat.com) wrote:
> If application does mlockall(MCL_FUTURE) it is no longer possible to mmap
> file bigger than main memory or allocate big area of anonymous memory
> in a thread safe manner. Sometimes it is desirable to lock everything
> related to program execution into memory, but still be able to mmap
> big file or allocate huge amount of memory and allow OS to swap them on
> demand. MAP_UNLOCKED allows to do that.
>  
> Signed-off-by: Gleb Natapov <gleb@redhat.com>

Looks good to me.

Acked-by: Chris Wright <chrisw@sous-sol.org>

thanks,
-chris

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
