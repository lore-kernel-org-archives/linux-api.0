From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mm: make PR_SET_THP_DISABLE immediately active
Date: Sat, 3 Jun 2017 09:40:01 +0200
Message-ID: <20170603073959.GC21524@dhcp22.suse.cz>
References: <1496415802-30944-1-git-send-email-rppt@linux.vnet.ibm.com>
 <20170602125059.66209870607085b84c257593@linux-foundation.org>
 <8a810c81-6a72-2af0-a450-6f03c71d8cca@suse.cz>
 <20170602134038.13728cb77678ae1a7d7128a4@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170602134038.13728cb77678ae1a7d7128a4-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Mike Rapoport <rppt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Pavel Emelyanov <xemul-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri 02-06-17 13:40:38, Andrew Morton wrote:
> On Fri, 2 Jun 2017 22:31:47 +0200 Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org> wrote:
> 
> > On 06/02/2017 09:50 PM, Andrew Morton wrote:
> > > On Fri,  2 Jun 2017 18:03:22 +0300 "Mike Rapoport" <rppt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:
> > > 
> > >> PR_SET_THP_DISABLE has a rather subtle semantic. It doesn't affect any
> > >> existing mapping because it only updated mm->def_flags which is a template
> > >> for new mappings. The mappings created after prctl(PR_SET_THP_DISABLE) have
> > >> VM_NOHUGEPAGE flag set.  This can be quite surprising for all those
> > >> applications which do not do prctl(); fork() & exec() and want to control
> > >> their own THP behavior.
> > >>
> > >> Another usecase when the immediate semantic of the prctl might be useful is
> > >> a combination of pre- and post-copy migration of containers with CRIU.  In
> > >> this case CRIU populates a part of a memory region with data that was saved
> > >> during the pre-copy stage. Afterwards, the region is registered with
> > >> userfaultfd and CRIU expects to get page faults for the parts of the region
> > >> that were not yet populated. However, khugepaged collapses the pages and
> > >> the expected page faults do not occur.
> > >>
> > >> In more general case, the prctl(PR_SET_THP_DISABLE) could be used as a
> > >> temporary mechanism for enabling/disabling THP process wide.
> > >>
> > >> Implementation wise, a new MMF_DISABLE_THP flag is added. This flag is
> > >> tested when decision whether to use huge pages is taken either during page
> > >> fault of at the time of THP collapse.
> > >>
> > >> It should be noted, that the new implementation makes PR_SET_THP_DISABLE
> > >> master override to any per-VMA setting, which was not the case previously.
> > >>
> > >> Fixes: a0715cc22601 ("mm, thp: add VM_INIT_DEF_MASK and PRCTL_THP_DISABLE")
> > > 
> > > "Fixes" is a bit strong.  I'd say "alters".  And significantly altering
> > > the runtime behaviour of a three-year-old interface is rather a worry,
> > > no?
> > > 
> > > Perhaps we should be adding new prctl modes to select this new
> > > behaviour and leave the existing PR_SET_THP_DISABLE behaviour as-is?
> > 
> > I think we can reasonably assume that most users of the prctl do just
> > the fork() & exec() thing, so they will be unaffected.
> 
> That sounds optimistic.  Perhaps people are using the current behaviour
> to set on particular mapping to MMF_DISABLE_THP, with
> 
> 	prctl(PR_SET_THP_DISABLE)
> 	mmap()
> 	prctl(PR_CLR_THP_DISABLE)
> 
> ?
> 
> Seems a reasonable thing to do.

Is it? The documentation is not very specific but it is clear about the
scope being thread (I would argue process would be more approapriate
but whatever) "Set the state of the "THP disable" flag for the calling
thread." So the above seems like an incorrect usage to me.

> But who knows - people do all sorts of inventive things.

well yes.

> > And as usual, if
> > somebody does complain in the end, we revert and try the other way?
> 
> But by then it's too late - the new behaviour will be out in the field.

Well, the interface is currently broken for anything other than prctl
& exec. And those will work properly even with the patch. So I am not
really sure whether keeping the current status quo is reasonable.

-- 
Michal Hocko
SUSE Labs
