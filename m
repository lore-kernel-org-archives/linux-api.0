From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mm/mremap: Fail map duplication attempts for private
 mappings
Date: Fri, 14 Jul 2017 10:26:29 +0200
Message-ID: <20170714082629.GA2618@dhcp22.suse.cz>
References: <1499961495-8063-1-git-send-email-mike.kravetz@oracle.com>
 <4e921eb5-8741-3337-9a7d-5ec9473412da@suse.cz>
 <415625d2-1be9-71f0-ca11-a014cef98a3f@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <415625d2-1be9-71f0-ca11-a014cef98a3f-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Aaron Lu <aaron.lu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Kirill A . Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Anshuman Khandual <khandual-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu 13-07-17 15:33:47, Mike Kravetz wrote:
> On 07/13/2017 12:11 PM, Vlastimil Babka wrote:
> > [+CC linux-api]
> > 
> > On 07/13/2017 05:58 PM, Mike Kravetz wrote:
> >> mremap will create a 'duplicate' mapping if old_size == 0 is
> >> specified.  Such duplicate mappings make no sense for private
> >> mappings.  If duplication is attempted for a private mapping,
> >> mremap creates a separate private mapping unrelated to the
> >> original mapping and makes no modifications to the original.
> >> This is contrary to the purpose of mremap which should return
> >> a mapping which is in some way related to the original.
> >>
> >> Therefore, return EINVAL in the case where if an attempt is
> >> made to duplicate a private mapping.
> >>
> >> Signed-off-by: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > 
> > Acked-by: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
> > 
> 
> In another e-mail thread, Andrea makes the case that mremap(old_size == 0)
> of private file backed mappings could possibly be used for something useful.
> For example to create a private COW mapping.

What does this mean exactly? I do not see it would force CoW so again
the new mapping could fail with the basic invariant that the content
of the new mapping should match the old one (e.g. old mapping already
CoWed some pages the new mapping would still contain the origin content
unless I am missing something).

[...]
> +	/*
> +	 * !old_len  is a special case where a mapping is 'duplicated'.
> +	 * Do not allow this for private anon mappings.
> +	 */
> +	if (!old_len && vma_is_anonymous(vma) &&
> +	    !(vma->vm_flags & (VM_SHARED | VM_MAYSHARE)))
> +		return ERR_PTR(-EINVAL);

Why is vma_is_anonymous() without VM_*SHARE* check insufficient?
-- 
Michal Hocko
SUSE Labs
