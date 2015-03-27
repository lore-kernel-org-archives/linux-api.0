From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: Re: [PATCH v2 3/4] mm, shmem: Add shmem resident memory accounting
Date: Fri, 27 Mar 2015 20:09:09 +0300
Message-ID: <55158EB5.5040301@yandex-team.ru>
References: <1427474441-17708-1-git-send-email-vbabka@suse.cz> <1427474441-17708-4-git-send-email-vbabka@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1427474441-17708-4-git-send-email-vbabka@suse.cz>
Sender: linux-doc-owner@vger.kernel.org
To: Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org, Jerome Marchand <jmarchan@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org, Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.cz>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Randy Dunlap <rdunlap@infradead.org>, linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 27.03.2015 19:40, Vlastimil Babka wrote:
> From: Jerome Marchand <jmarchan@redhat.com>
>
> Currently looking at /proc/<pid>/status or statm, there is no way to
> distinguish shmem pages from pages mapped to a regular file (shmem
> pages are mapped to /dev/zero), even though their implication in
> actual memory use is quite different.
> This patch adds MM_SHMEMPAGES counter to mm_rss_stat to account for
> shmem pages instead of MM_FILEPAGES.
>
> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---


> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -327,9 +327,12 @@ struct core_state {
>   };
>
>   enum {
> -	MM_FILEPAGES,
> -	MM_ANONPAGES,
> -	MM_SWAPENTS,
> +	MM_FILEPAGES,	/* Resident file mapping pages */
> +	MM_ANONPAGES,	/* Resident anonymous pages */
> +	MM_SWAPENTS,	/* Anonymous swap entries */
> +#ifdef CONFIG_SHMEM
> +	MM_SHMEMPAGES,	/* Resident shared memory pages */
> +#endif

I prefer to keep that counter unconditionally:
kernel has MM_SWAPENTS even without CONFIG_SWAP.

>   	NR_MM_COUNTERS
>   };
>
