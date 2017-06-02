From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] mm: make PR_SET_THP_DISABLE immediately active
Date: Fri, 2 Jun 2017 22:55:12 +0200
Message-ID: <f9e8a159-7a25-6813-f909-11c4ae58adf3@suse.cz>
References: <1496415802-30944-1-git-send-email-rppt@linux.vnet.ibm.com>
 <20170602125059.66209870607085b84c257593@linux-foundation.org>
 <8a810c81-6a72-2af0-a450-6f03c71d8cca@suse.cz>
 <20170602134038.13728cb77678ae1a7d7128a4@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170602134038.13728cb77678ae1a7d7128a4-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Mike Rapoport <rppt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Pavel Emelyanov <xemul-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 06/02/2017 10:40 PM, Andrew Morton wrote:
> On Fri, 2 Jun 2017 22:31:47 +0200 Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org> wrote:
>>> Perhaps we should be adding new prctl modes to select this new
>>> behaviour and leave the existing PR_SET_THP_DISABLE behaviour as-is?
>>
>> I think we can reasonably assume that most users of the prctl do just
>> the fork() & exec() thing, so they will be unaffected.
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

Using madvise(MADV_NOHUGEPAGE) seems reasonabler to me, with the same
effect. And it's older (2.6.38).

> But who knows - people do all sorts of
> inventive things.

Yeah :( but we can hope they don't even know that the prctl currently
behaves they way it does - man page doesn't suggest it would, and most
of us in this thread found it surprising.

>> And as usual, if
>> somebody does complain in the end, we revert and try the other way?
> 
> But by then it's too late - the new behaviour will be out in the field.

Revert in stable then?
But I don't think this patch should go to stable. I understand right
that CRIU will switch to the UFFDIO_COPY approach and doesn't need the
prctl change/new madvise anymore?
