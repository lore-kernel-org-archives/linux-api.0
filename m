From: =?UTF-8?Q?Mika_Penttil=c3=a4?= <mika.penttila@nextfour.com>
Subject: Re: [PATCH v5 01/12] mm: support madvise(MADV_FREE)
Date: Mon, 30 Nov 2015 10:20:25 +0200
Message-ID: <565C06C9.7040906@nextfour.com>
References: <1448865583-2446-1-git-send-email-minchan@kernel.org>
 <1448865583-2446-2-git-send-email-minchan@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1448865583-2446-2-git-send-email-minchan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Minchan Kim <minchan@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, Michael Kerrisk <mtk.manpages@gmail.com>, linux-api@vger.kernel.org, Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Jason Evans <je@fb.com>, Daniel Micay <danielmicay@gmail.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, Shaohua Li <shli@kernel.org>, Michal Hocko <mhocko@suse.cz>, yalin.wang2010@gmail.com, Andy Lutomirski <luto@amacapital.net>, Michal Hocko <mhocko@suse.com>
List-Id: linux-api@vger.kernel.org

> +		 * If pmd isn't transhuge but the page is THP and
> +		 * is owned by only this process, split it and
> +		 * deactivate all pages.
> +		 */
> +		if (PageTransCompound(page)) {
> +			if (page_mapcount(page) != 1)
> +				goto out;
> +			get_page(page);
> +			if (!trylock_page(page)) {
> +				put_page(page);
> +				goto out;
> +			}
> +			pte_unmap_unlock(orig_pte, ptl);
> +			if (split_huge_page(page)) {
> +				unlock_page(page);
> +				put_page(page);
> +				pte_offset_map_lock(mm, pmd, addr, &ptl);
> +				goto out;
> +			}
> +			pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
> +			pte--;
> +			addr -= PAGE_SIZE;
> +			continue;
> +		}

looks like this leaks page count if split_huge_page() is succesfull
(returns zero).

--Mika
