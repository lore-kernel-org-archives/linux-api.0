From: Christopher Lameter <cl@linux.com>
Subject: Re: [PATCH v1 4/4] mm: introduce MADV_PAGEOUT
Date: Tue, 4 Jun 2019 15:38:20 +0000
Message-ID: <0100016b232425c9-64a09298-59ba-48b8-9aa3-e7e1ad2d316c-000000@email.amazonses.com>
References: <20190603053655.127730-1-minchan@kernel.org> <20190603053655.127730-5-minchan@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190603053655.127730-5-minchan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Tim Murray <timmurray@google.com>, Joel Fernandes <joel@joelfernandes.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Colascione <dancol@google.com>, Shakeel Butt <shakeelb@google.com>, Sonny Rao <sonnyrao@google.com>, Brian Geffon <bgeffon@google.com>, jannh@google.com, oleg@redhat.com, christian@brauner.io, oleksandr@redhat.com, hdanton@sina.com
List-Id: linux-api@vger.kernel.org

On Mon, 3 Jun 2019, Minchan Kim wrote:

> @@ -415,6 +416,128 @@ static long madvise_cold(struct vm_area_struct *vma,
>  	return 0;
>  }
>
> +static int madvise_pageout_pte_range(pmd_t *pmd, unsigned long addr,
> +				unsigned long end, struct mm_walk *walk)
> +{
> +	pte_t *orig_pte, *pte, ptent;
> +	spinlock_t *ptl;
> +	LIST_HEAD(page_list);
> +	struct page *page;
> +	int isolated = 0;
> +	struct vm_area_struct *vma = walk->vma;
> +	unsigned long next;
> +
> +	if (fatal_signal_pending(current))
> +		return -EINTR;
> +
> +	next = pmd_addr_end(addr, end);
> +	if (pmd_trans_huge(*pmd)) {
> +		ptl = pmd_trans_huge_lock(pmd, vma);
> +		if (!ptl)
> +			return 0;
> +
> +		if (is_huge_zero_pmd(*pmd))
> +			goto huge_unlock;
> +
> +		page = pmd_page(*pmd);
> +		if (page_mapcount(page) > 1)
> +			goto huge_unlock;
> +
> +		if (next - addr != HPAGE_PMD_SIZE) {
> +			int err;
> +
> +			get_page(page);
> +			spin_unlock(ptl);
> +			lock_page(page);
> +			err = split_huge_page(page);
> +			unlock_page(page);
> +			put_page(page);
> +			if (!err)
> +				goto regular_page;
> +			return 0;
> +		}

I have seen this before multiple times. Is there a way to avoid
replicating the whole shebang?
