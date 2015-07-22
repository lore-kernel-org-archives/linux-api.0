From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v4 03/10] mm/hugetlb: expose hugetlb fault mutex for use
 by fallocate
Date: Wed, 22 Jul 2015 15:03:32 -0700
Message-ID: <20150722150332.9bf0735389f8dc57f720daf5@linux-foundation.org>
References: <1437502184-14269-1-git-send-email-mike.kravetz@oracle.com>
	<1437502184-14269-4-git-send-email-mike.kravetz@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1437502184-14269-4-git-send-email-mike.kravetz@oracle.com>
Sender: owner-linux-mm@kvack.org
To: Mike Kravetz <mike.kravetz@oracle.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>, Davidlohr Bueso <dave@stgolabs.net>, Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>, Hillf Danton <hillf.zj@alibaba-inc.com>, Christoph Hellwig <hch@infradead.org>, Michal Hocko <mhocko@suse.cz>
List-Id: linux-api@vger.kernel.org

On Tue, 21 Jul 2015 11:09:37 -0700 Mike Kravetz <mike.kravetz@oracle.com> wrote:

> Minor name changes to
> be more consistent with other global hugetlb symbols.
> 
> ...
>
> -	kfree(htlb_fault_mutex_table);
> +	kfree(hugetlb_fault_mutex_table);

yay ;)

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
