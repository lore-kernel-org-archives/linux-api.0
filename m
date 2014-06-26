From: Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH v2] mm: export NR_SHMEM via sysinfo(2) / si_meminfo()
 interfaces
Date: Thu, 26 Jun 2014 16:06:44 -0400
Message-ID: <53AC7D54.4010407@redhat.com>
References: <198dc298821a20a476656dccc85a8d77f166c61a.1403812625.git.aquini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <198dc298821a20a476656dccc85a8d77f166c61a.1403812625.git.aquini@redhat.com>
Sender: owner-linux-mm@kvack.org
To: Rafael Aquini <aquini@redhat.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 06/26/2014 04:00 PM, Rafael Aquini wrote:
> Historically, we exported shared pages to userspace via sysinfo(2) sharedram
> and /proc/meminfo's "MemShared" fields. With the advent of tmpfs, from kernel
> v2.4 onward, that old way for accounting shared mem was deemed inaccurate and
> we started to export a hard-coded 0 for sysinfo.sharedram. Later on, during
> the 2.6 timeframe, "MemShared" got re-introduced to /proc/meminfo re-branded
> as "Shmem", but we're still reporting sysinfo.sharedmem as that old hard-coded
> zero, which makes the "shared memory" report inconsistent across interfaces.
> 
> This patch leverages the addition of explicit accounting for pages used by
> shmem/tmpfs -- "4b02108 mm: oom analysis: add shmem vmstat" -- in order to
> make the users of sysinfo(2) and si_meminfo*() friends aware of that
> vmstat entry and make them report it consistently across the interfaces,
> as well to make sysinfo(2) returned data consistent with our current API
> documentation states.
> 
> Signed-off-by: Rafael Aquini <aquini@redhat.com>

Acked-by: Rik van Riel <riel@redhat.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
