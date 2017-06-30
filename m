From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH] userfaultfd: Add feature to request for a signal
 delivery
Date: Fri, 30 Jun 2017 11:47:35 +0200
Message-ID: <20170630094718.GE22917@dhcp22.suse.cz>
References: <9363561f-a9cd-7ab6-9c11-ab9a99dc89f1@oracle.com>
 <20170627070643.GA28078@dhcp22.suse.cz>
 <20170627153557.GB10091@rapoport-lnx>
 <51508e99-d2dd-894f-8d8a-678e3747c1ee@oracle.com>
 <20170628131806.GD10091@rapoport-lnx>
 <3a8e0042-4c49-3ec8-c59f-9036f8e54621@oracle.com>
 <20170629080910.GC31603@dhcp22.suse.cz>
 <936bde7b-1913-5589-22f4-9bbfdb6a8dd5@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <936bde7b-1913-5589-22f4-9bbfdb6a8dd5-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "prakash.sangappa" <prakash.sangappa-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Mike Rapoport <rppt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

[CC John, the thread started
http://lkml.kernel.org/r/9363561f-a9cd-7ab6-9c11-ab9a99dc89f1-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org]

On Thu 29-06-17 14:41:22, prakash.sangappa wrote:
> 
> 
> On 06/29/2017 01:09 AM, Michal Hocko wrote:
> >On Wed 28-06-17 11:23:32, Prakash Sangappa wrote:
> >>
> >>On 6/28/17 6:18 AM, Mike Rapoport wrote:
> >[...]
> >>>I've just been thinking that maybe it would be possible to use
> >>>UFFD_EVENT_REMOVE for this case. We anyway need to implement the generation
> >>>of UFFD_EVENT_REMOVE for the case of hole punching in hugetlbfs for
> >>>non-cooperative userfaultfd. It could be that it will solve your issue as
> >>>well.
> >>>
> >>Will this result in a signal delivery?
> >>
> >>In the use case described, the database application does not need any event
> >>for  hole punching. Basically, just a signal for any invalid access to
> >>mapped area over holes in the file.
> >OK, but it would be better to think that through for other potential
> >usecases so that this doesn't end up as a single hugetlb feature. E.g.
> >what should happen if a regular anonymous memory gets swapped out?
> >Should we deliver signal as well? How does userspace tell whether this
> >was a no backing page from unavailable backing page?
> 
> This may not be useful in all cases. Potential, it could be used
> with use of mlock() on anonymous memory to ensure any access
> to memory that is not locked is caught, again for robustness
> purpose.

The thing I wanted to point out is that not only this should be a single
usecase thing (I believe others will pop out as well - see below) but it
should also be well defined as this is a user visible API. Please try to
write a patch to the userfaultfd man page to clarify the exact semantic.
This should help the further discussion.

As an aside, I rememeber that prior to MADV_FREE there was long
discussion about lazy freeing of memory from userspace. Some users
wanted to be signalled when their memory was freed by the system so that
they could rebuild the original content (e.g. uncompressed images in
memory). It seems like MADV_FREE + this signalling could be used for
that usecase. John would surely know more about those usecases.
-- 
Michal Hocko
SUSE Labs
