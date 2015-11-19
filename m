From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v5 4/6] mm, proc: reduce cost of /proc/pid/smaps for
 unpopulated shmem mappings
Date: Thu, 19 Nov 2015 11:13:33 +0100
Message-ID: <20151119101333.GC8494@dhcp22.suse.cz>
References: <1447838976-17607-1-git-send-email-vbabka@suse.cz>
 <1447838976-17607-5-git-send-email-vbabka@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1447838976-17607-5-git-send-email-vbabka@suse.cz>
Sender: owner-linux-mm@kvack.org
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Jerome Marchand <jmarchan@redhat.com>, Hugh Dickins <hughd@google.com>, Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
List-Id: linux-api@vger.kernel.org

On Wed 18-11-15 10:29:34, Vlastimil Babka wrote:
> Following the previous patch, further reduction of /proc/pid/smaps cost is
> possible for private writable shmem mappings with unpopulated areas where
> the page walk invokes the .pte_hole function. We can use radix tree iterator
> for each such area instead of calling find_get_entry() in a loop. This is
> possible at the extra maintenance cost of introducing another shmem function
> shmem_partial_swap_usage().
> 
> To demonstrate the diference, I have measured this on a process that creates a
> private writable 2GB mapping of a partially swapped out /dev/shm/file (which
> cannot employ the optimizations from the prvious patch) and doesn't populate it
> at all. I time how long does it take to cat /proc/pid/smaps of this process 100
> times.
> 
> Before this patch:
> 
> real    0m3.831s
> user    0m0.180s
> sys     0m3.212s
> 
> After this patch:
> 
> real    0m1.176s
> user    0m0.180s
> sys     0m0.684s
> 
> The time is similar to case where radix tree iterator is employed on the whole
> mapping.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Looks good as well.
Acked-by: Michal Hocko <mhocko@suse.com>
[...]
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
