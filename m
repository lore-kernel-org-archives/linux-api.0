From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v7 3/6] mm: Introduce VM_LOCKONFAULT
Date: Tue, 25 Aug 2015 20:58:29 +0200
Message-ID: <20150825185829.GA10222@dhcp22.suse.cz>
References: <1439097776-27695-1-git-send-email-emunson@akamai.com>
 <1439097776-27695-4-git-send-email-emunson@akamai.com>
 <20150812115909.GA5182@dhcp22.suse.cz>
 <20150819213345.GB4536@akamai.com>
 <20150820075611.GD4780@dhcp22.suse.cz>
 <20150820170309.GA11557@akamai.com>
 <20150821072552.GF23723@dhcp22.suse.cz>
 <20150821183132.GA12835@akamai.com>
 <20150825134154.GB6285@dhcp22.suse.cz>
 <20150825142902.GF17005@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150825142902.GF17005-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue 25-08-15 10:29:02, Eric B Munson wrote:
> On Tue, 25 Aug 2015, Michal Hocko wrote:
[...]
> > Considering the current behavior I do not thing it would be terrible
> > thing to do what Konstantin was suggesting and populate only the full
> > ranges in a best effort mode (it is done so anyway) and document the
> > behavior properly.
> > "
> >        If the memory segment specified by old_address and old_size is
> >        locked (using mlock(2) or similar), then this lock is maintained
> >        when the segment is resized and/or relocated. As a consequence,
> >        the amount of memory locked by the process may change.
> > 
> >        If the range is already fully populated and the range is
> >        enlarged the new range is attempted to be fully populated
> >        as well to preserve the full mlock semantic but there is no
> >        guarantee this will succeed. Partially populated (e.g. created by
> >        mlock(MLOCK_ONFAULT)) ranges do not have the full mlock semantic
> >        so they are not populated on resize.
> > "
> 
> You are proposing that mremap would scan the PTEs as Vlastimil has
> suggested?

As Vlastimil pointed out this would be unnecessarily too costly. But I
am wondering whether we should populate at all during mremap considering
the full mlock semantic is not guaranteed anyway. Man page mentions only
that the lock is maintained which will be true without population as
well.

If somebody really depends on the current (and broken) implementation we
can offer MREMAP_POPULATE which would do a best effort population. This
would be independent on the locked state and would be usable for other
mappings as well (the usecase would be to save page fault overhead by
batching them).

If this would be seen as an unacceptable user visible change of behavior
then we can go with the VMA flag but I would still prefer to not export
it to the userspace so that we have a way to change this in future.
-- 
Michal Hocko
SUSE Labs
