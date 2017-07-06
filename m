From: Mike Rapoport <rppt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [RFC PATCH v2] userfaultfd: Add feature to request for a signal
 delivery
Date: Thu, 6 Jul 2017 15:09:50 +0300
Message-ID: <20170706120949.GE9625@rapoport-lnx>
References: <ff16daf5-7ba0-3dc2-7f73-eb7db8336df7@oracle.com>
 <20170704182806.GB4070@rapoport-lnx>
 <c1fa4d29-cbc9-6606-3e1f-9953078900a3@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <c1fa4d29-cbc9-6606-3e1f-9953078900a3-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "prakash.sangappa" <prakash.sangappa-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jul 05, 2017 at 05:41:14PM -0700, prakash.sangappa wrote:
> 
> 
> On 07/04/2017 11:28 AM, Mike Rapoport wrote:
> >On Tue, Jun 27, 2017 at 09:08:40AM -0700, Prakash Sangappa wrote:
> >>Applications like the database use hugetlbfs for performance reason.
> >>Files on hugetlbfs filesystem are created and huge pages allocated
> >>using fallocate() API. Pages are deallocated/freed using fallocate() hole
> >>punching support. These files are mmap'ed and accessed by many
> >>single threaded processes as shared memory.  The database keeps
> >>track of which offsets in the hugetlbfs file have pages allocated.
> >>

[ ... ]

> >>+     *
> >>+     * UFFD_FEATURE_SIGBUS feature means no page-fault
> >>+     * (UFFD_EVENT_PAGEFAULT) event will be delivered, instead
> >>+     * a SIGBUS signal will be sent to the faulting process.
> >>+     * The application process can enable this behavior by adding
> >>+     * it to uffdio_api.features.
> >I think that it maybe worth making UFFD_FEATURE_SIGBUS mutually exclusive
> >with the non-cooperative events. There is no point of having monitor if the
> >page fault handler will anyway just kill the faulting process.
> 
> 
> Will this not be too restrictive?. The non-cooperative events could
> still be useful if an application wants to track changes
> to VA ranges that are registered even though it expects
> a signal on page fault.


I wouldn't say that we must make UFFD_FEATURE_SIGBUS mutually exclusive
with other events, but, IMHO, it's something we should at least think
about.

In my view, if you anyway have uffd monitor, you may process page faults
there as well and then there is no actual need in UFFD_FEATURE_SIGBUS.

-- 
Sincerely yours,
Mike.
