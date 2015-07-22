From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v4 01/10] mm/hugetlb: add cache of descriptors to
 resv_map for region_add
Date: Wed, 22 Jul 2015 15:03:27 -0700
Message-ID: <20150722150327.d61964bcc129ccd190514297@linux-foundation.org>
References: <1437502184-14269-1-git-send-email-mike.kravetz@oracle.com>
	<1437502184-14269-2-git-send-email-mike.kravetz@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1437502184-14269-2-git-send-email-mike.kravetz@oracle.com>
Sender: owner-linux-mm@kvack.org
To: Mike Kravetz <mike.kravetz@oracle.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>, Davidlohr Bueso <dave@stgolabs.net>, Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>, Hillf Danton <hillf.zj@alibaba-inc.com>, Christoph Hellwig <hch@infradead.org>, Michal Hocko <mhocko@suse.cz>
List-Id: linux-api@vger.kernel.org

On Tue, 21 Jul 2015 11:09:35 -0700 Mike Kravetz <mike.kravetz@oracle.com> wrote:

> fallocate hole punch will want to remove a specific range of
> pages.  When pages are removed, their associated entries in
> the region/reserve map will also be removed.  This will break
> an assumption in the region_chg/region_add calling sequence.
> If a new region descriptor must be allocated, it is done as
> part of the region_chg processing.  In this way, region_add
> can not fail because it does not need to attempt an allocation.
> 
> To prepare for fallocate hole punch, create a "cache" of
> descriptors that can be used by region_add if necessary.
> region_chg will ensure there are sufficient entries in the
> cache.  It will be necessary to track the number of in progress
> add operations to know a sufficient number of descriptors
> reside in the cache.  A new routine region_abort is added to
> adjust this in progress count when add operations are aborted.
> vma_abort_reservation is also added for callers creating
> reservations with vma_needs_reservation/vma_commit_reservation.
> 
> ...
>
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -35,6 +35,9 @@ struct resv_map {
>  	struct kref refs;
>  	spinlock_t lock;
>  	struct list_head regions;
> +	long adds_in_progress;
> +	struct list_head rgn_cache;
> +	long rgn_cache_count;
>  };

Linux style is to spell words out fully: rgn->region.  One advantage of
doing this is that we get consistency: when there's no doubt about how
a thing is spelled we don't end up with various different terms for the
same thing.  Note that we already have resv_map.regions and struct
file_region.

To avoid a respin I think I'll just do a s/rgn/region/g on the patches
then take a look for 80 col overflow - shout at me if you dislike that.

And yes, resv_map should have been called reservation_map.  I suck.

And there's region_chg.  Who wrote this stuff.

As an off-topic cleanup, resv_map and its associated stuff could be
moved out of include/linux/hugetlb.h and made private to hugetlb.c with
some minor changes.

Finally, the data structure definition site is a great place at which
to document the overall design.  What the fields do, how they interact,
locking design, etc.  eg, what data structure is at
resv_map.region_cache, how is it managed, what purpose does it serve
etc.

And adds_in_progress is interesting.  I see the comment over
region_abort() (rgn_abort?!) but haven't quite soaked that in yet.

>
> ...
>
> @@ -312,11 +339,16 @@ static long region_add(struct resv_map *resv, long f, long t)
>   * so that the subsequent region_add call will have all the
>   * regions it needs and will not fail.
>   *
> + * Upon entry, region_chg will also examine the cache of
> + * region descriptors associated with the map.  If there

"are"

> + * not enough descriptors cached, one will be allocated
> + * for the in progress add operation.
> + *
>   * Returns the number of huge pages that need to be added
>   * to the existing reservation map for the range [f, t).
>   * This number is greater or equal to zero.  -ENOMEM is
> - * returned if a new file_region structure is needed and can
> - * not be allocated.
> + * returned if a new file_region structure or cache entry
> + * is needed and can not be allocated.
>   */
>  static long region_chg(struct resv_map *resv, long f, long t)
>  {
>
> ...
>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
