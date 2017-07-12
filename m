From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 1/1] mm/mremap: add MREMAP_MIRROR flag for existing
 mirroring functionality
Date: Wed, 12 Jul 2017 13:46:55 +0200
Message-ID: <20170712114655.GG28912@dhcp22.suse.cz>
References: <1499357846-7481-1-git-send-email-mike.kravetz@oracle.com>
 <1499357846-7481-2-git-send-email-mike.kravetz@oracle.com>
 <20170711123642.GC11936@dhcp22.suse.cz>
 <7f14334f-81d1-7698-d694-37278f05a78e@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <7f14334f-81d1-7698-d694-37278f05a78e-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Aaron Lu <aaron.lu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Kirill A . Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue 11-07-17 11:23:19, Mike Kravetz wrote:
> On 07/11/2017 05:36 AM, Michal Hocko wrote:
[...]
> > Anyway the patch should fail with -EINVAL on private mappings as Kirill
> > already pointed out
> 
> Yes.  I think this should be a separate patch.  As mentioned earlier,
> mremap today creates a new/additional private mapping if called in this
> way with old_size == 0.  To me, this is a bug.

Not only that. It clears existing ptes in the old mapping so the content
is lost. That is quite unexpected behavior. Now it is hard to assume
whether somebody relies on the behavior (I can easily imagine somebody
doing backup&clear in atomic way) so failing with EINVAL might break
userspace so I am not longer sure. Anyway this really needs to be
documented.
-- 
Michal Hocko
SUSE Labs
