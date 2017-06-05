From: Mike Rapoport <rppt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] mm: make PR_SET_THP_DISABLE immediately active
Date: Mon, 5 Jun 2017 10:05:14 +0300
Message-ID: <20170605070513.GA4159@rapoport-lnx>
References: <1496415802-30944-1-git-send-email-rppt@linux.vnet.ibm.com>
 <20170602125059.66209870607085b84c257593@linux-foundation.org>
 <8a810c81-6a72-2af0-a450-6f03c71d8cca@suse.cz>
 <20170602134038.13728cb77678ae1a7d7128a4@linux-foundation.org>
 <f9e8a159-7a25-6813-f909-11c4ae58adf3@suse.cz>
 <CAAB5A6A-D7A1-4C06-9A07-D7EF56278EE5@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAB5A6A-D7A1-4C06-9A07-D7EF56278EE5-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Pavel Emelyanov <xemul-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sat, Jun 03, 2017 at 01:34:52PM +0300, Mike Rapoprt wrote:
> 
> 
> On June 2, 2017 11:55:12 PM GMT+03:00, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org> wrote:
> >On 06/02/2017 10:40 PM, Andrew Morton wrote:
> >> On Fri, 2 Jun 2017 22:31:47 +0200 Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
> >wrote:
> >>>> Perhaps we should be adding new prctl modes to select this new
> >>>> behaviour and leave the existing PR_SET_THP_DISABLE behaviour
> >as-is?
> >>>
> >>> I think we can reasonably assume that most users of the prctl do
> >just
> >>> the fork() & exec() thing, so they will be unaffected.
> >> 
> >> That sounds optimistic.  Perhaps people are using the current
> >behaviour
> >> to set on particular mapping to MMF_DISABLE_THP, with
> >> 
> >> 	prctl(PR_SET_THP_DISABLE)
> >> 	mmap()
> >> 	prctl(PR_CLR_THP_DISABLE)
> >> 
> >> ?
> >> 
> >> Seems a reasonable thing to do.
> >
> >Using madvise(MADV_NOHUGEPAGE) seems reasonabler to me, with the same
> >effect. And it's older (2.6.38).
> >
> >> But who knows - people do all sorts of
> >> inventive things.
> >
> >Yeah :( but we can hope they don't even know that the prctl currently
> >behaves they way it does - man page doesn't suggest it would, and most
> >of us in this thread found it surprising.
> >
> >>> And as usual, if
> >>> somebody does complain in the end, we revert and try the other way?
> >> 
> >> But by then it's too late - the new behaviour will be out in the
> >field.
> >
> >Revert in stable then?
> >But I don't think this patch should go to stable. I understand right
> >that CRIU will switch to the UFFDIO_COPY approach and doesn't need the
> >prctl change/new madvise anymore?
> 
> Yes, we are going to use UFFDIO_COPY. We still might want to have control
> over THP in the future without changing per-VMA flags, though.

Unfortunately, I was over optimistic about ability of CRIU to use
UFFDIO_COPY for pre-copy part :(
I was too concentrated on the simplified flow and overlooked some important
details. After I've spent some time trying to actually implement usage of
UFFDIO_COPY, I realized that registering memory with userfault at that
point of the restore flow quite contradicts CRIU architecture :(

That said, we would really want to have the interface this patch proposes.
 
-- 
Sincerely yours,
Mike.
