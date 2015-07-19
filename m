From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v4 3/5] pagemap: rework hugetlb and thp report
Date: Sun, 19 Jul 2015 14:10:19 +0300
Message-ID: <20150719111019.GA2392@node.dhcp.inet.fi>
References: <20150714152516.29844.69929.stgit@buzz>
 <20150714153738.29844.39039.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20150714153738.29844.39039.stgit@buzz>
Sender: owner-linux-mm@kvack.org
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, Mark Williamson <mwilliamson@undo-software.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Jul 14, 2015 at 06:37:39PM +0300, Konstantin Khlebnikov wrote:
> @@ -1073,35 +1047,48 @@ static int pagemap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>  	pte_t *pte, *orig_pte;
>  	int err = 0;
>  
> -	if (pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
> -		u64 flags = 0;
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +	if (pmd_trans_huge_lock(pmdp, vma, &ptl) == 1) {

#ifdef is redundant. pmd_trans_huge_lock() always return 0 for !THP.

-- 
 Kirill A. Shutemov

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
