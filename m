From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [RFC PATCH] userfaultfd: Add feature to request for a signal
 delivery
Date: Thu, 29 Jun 2017 10:09:10 +0200
Message-ID: <20170629080910.GC31603@dhcp22.suse.cz>
References: <9363561f-a9cd-7ab6-9c11-ab9a99dc89f1@oracle.com>
 <20170627070643.GA28078@dhcp22.suse.cz>
 <20170627153557.GB10091@rapoport-lnx>
 <51508e99-d2dd-894f-8d8a-678e3747c1ee@oracle.com>
 <20170628131806.GD10091@rapoport-lnx>
 <3a8e0042-4c49-3ec8-c59f-9036f8e54621@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <3a8e0042-4c49-3ec8-c59f-9036f8e54621@oracle.com>
Sender: owner-linux-mm@kvack.org
To: Prakash Sangappa <prakash.sangappa@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>, Mike Kravetz <mike.kravetz@oracle.com>, Dave Hansen <dave.hansen@intel.com>, Christoph Hellwig <hch@infradead.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed 28-06-17 11:23:32, Prakash Sangappa wrote:
> 
> 
> On 6/28/17 6:18 AM, Mike Rapoport wrote:
[...]
> >I've just been thinking that maybe it would be possible to use
> >UFFD_EVENT_REMOVE for this case. We anyway need to implement the generation
> >of UFFD_EVENT_REMOVE for the case of hole punching in hugetlbfs for
> >non-cooperative userfaultfd. It could be that it will solve your issue as
> >well.
> >
> 
> Will this result in a signal delivery?
> 
> In the use case described, the database application does not need any event
> for  hole punching. Basically, just a signal for any invalid access to
> mapped area over holes in the file.

OK, but it would be better to think that through for other potential
usecases so that this doesn't end up as a single hugetlb feature. E.g.
what should happen if a regular anonymous memory gets swapped out?
Should we deliver signal as well? How does userspace tell whether this
was a no backing page from unavailable backing page?
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
