From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [patch] mremap.2: Add description of old_size == 0 functionality
Date: Mon, 25 Sep 2017 14:35:08 +0200
Message-ID: <20170925123508.pzjbe7wgwagnr5li@dhcp22.suse.cz>
References: <20170915213745.6821-1-mike.kravetz@oracle.com>
 <a6e59a7f-fd15-9e49-356e-ed439f17e9df@oracle.com>
 <fb013ae6-6f47-248b-db8b-a0abae530377@redhat.com>
 <ee87215d-9704-7269-4ec1-226f2e32a751@oracle.com>
 <a5d279cb-a015-f74c-2e40-a231aa7f7a8c@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <a5d279cb-a015-f74c-2e40-a231aa7f7a8c-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Kirill A . Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Anshuman Khandual <khandual-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue 19-09-17 14:11:19, Florian Weimer wrote:
> On 09/18/2017 07:11 PM, Mike Kravetz wrote:
[...]
> > I can drop this wording, but would still like to suggest memfd_create as
> > the preferred method of creating duplicate mappings.  It would be good if
> > others on Cc: could comment as well.
> 
> mremap seems to work with non-anonymous mappings, too:

only for shared mappings in fact. Because once we have CoW then mremap
will not provide you with the same content as the original mapping.

[...]

> > Just curious, does glibc make use of this today?  Or, is this just something
> > that you think may be useful.
> 
> To my knowledge, we do not use this today.  But it certainly looks very
> useful.

What would be the usecase. I mean why don't you simply create a new
mapping by a plain mmap when you have no guarantee about the same
content?
-- 
Michal Hocko
SUSE Labs
