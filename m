From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [patch] mremap.2: Add description of old_size == 0 functionality
Date: Mon, 25 Sep 2017 16:52:38 +0200
Message-ID: <20170925145238.gic2n37ffc6ytyvx@dhcp22.suse.cz>
References: <20170915213745.6821-1-mike.kravetz@oracle.com>
 <a6e59a7f-fd15-9e49-356e-ed439f17e9df@oracle.com>
 <fb013ae6-6f47-248b-db8b-a0abae530377@redhat.com>
 <ee87215d-9704-7269-4ec1-226f2e32a751@oracle.com>
 <a5d279cb-a015-f74c-2e40-a231aa7f7a8c@redhat.com>
 <20170925123508.pzjbe7wgwagnr5li@dhcp22.suse.cz>
 <e301609c-b2ac-24d1-c349-8d25e5123258@redhat.com>
 <20170925125207.4tu24sbpnihljknu@dhcp22.suse.cz>
 <765cd0cb-aa35-187c-456d-05d8752caa04@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <765cd0cb-aa35-187c-456d-05d8752caa04-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Kirill A . Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Anshuman Khandual <khandual-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon 25-09-17 15:16:09, Florian Weimer wrote:
> On 09/25/2017 02:52 PM, Michal Hocko wrote:
> > So, how are you going to deal with the CoW and the implementation which
> > basically means that the newm mmap content is not the same as the
> > original one?
> 
> I don't understand why CoW would kick in.

So you can guarantee nobody is going to write to that memory? Moreover
for the anonymous mapping you really get zero pages rather than the
original content AFAIR.

> The approach I outlined is
> desirable because it avoids the need to modify any executable pages, so this
> is not a concern.  The point is to create a potentially unbounded number of
> thunks *without* run-time code generation.
> 
> If the file is rewritten on disk, that's already undefined today, so it's
> not something we need to be concerned with.  (Anything which replaces ELF
> files needs to use the rename-into-place approach anyway.)

Yeah that part is not all that interesting.
-- 
Michal Hocko
SUSE Labs
