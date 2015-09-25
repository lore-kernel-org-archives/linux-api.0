From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v3 4/4] mm, procfs: Display VmAnon, VmFile and VmShm in
 /proc/pid/status
Date: Fri, 25 Sep 2015 15:29:07 +0200
Message-ID: <20150925132907.GK16497@dhcp22.suse.cz>
References: <1438779685-5227-1-git-send-email-vbabka@suse.cz>
 <1438779685-5227-5-git-send-email-vbabka@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1438779685-5227-5-git-send-email-vbabka@suse.cz>
Sender: owner-linux-mm@kvack.org
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jerome Marchand <jmarchan@redhat.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Randy Dunlap <rdunlap@infradead.org>, linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Linux API <linux-api@vger.kernel.org>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Minchan Kim <minchan@kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed 05-08-15 15:01:25, Vlastimil Babka wrote:
> From: Jerome Marchand <jmarchan@redhat.com>
> 
> It's currently inconvenient to retrieve MM_ANONPAGES value from status
> and statm files and there is no way to separate MM_FILEPAGES and
> MM_SHMEMPAGES. Add VmAnon, VmFile and VmShm lines in /proc/<pid>/status
> to solve these issues.

Yes this is definitely an improvement. I have no strong opinion on
naming. VmFOO is consistent with the rest (e.g. VmData, Stk...)

> 
> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Acked-by: Michal Hocko <mhocko@suse.com>
[...]
> @@ -82,7 +91,7 @@ unsigned long task_statm(struct mm_struct *mm,
>  			 unsigned long *data, unsigned long *resident)
>  {
>  	*shared = get_mm_counter(mm, MM_FILEPAGES) +
> -		get_mm_counter(mm, MM_SHMEMPAGES);
> +		get_mm_counter_shmem(mm);
>  	*text = (PAGE_ALIGN(mm->end_code) - (mm->start_code & PAGE_MASK))
>  								>> PAGE_SHIFT;
>  	*data = mm->total_vm - mm->shared_vm;

Ahh, so you have fixed up the compilation issue from previous patch
here... This really belong to the previous patch as already noted.
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
