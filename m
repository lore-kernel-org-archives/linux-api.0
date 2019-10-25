From: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] mm: allow unmapped hole at head side of mbind range
Date: Thu, 24 Oct 2019 19:32:39 -0700 (PDT)
Message-ID: <alpine.LSU.2.11.1910241900070.1096@eggly.anvils>
References: <TY2PR04MB29753892EBAD17D9E8FECBAEE86A0@TY2PR04MB2975.apcprd04.prod.outlook.com> <c90d668a-9abc-df1b-8b9c-70a6e6afd94a@suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c90d668a-9abc-df1b-8b9c-70a6e6afd94a@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Li Xinhai <xinhai.li@outlook.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, 24 Oct 2019, Vlastimil Babka wrote:

> + linux-api
> 
> On 10/24/19 9:35 AM, Li Xinhai wrote:
> > From: Li Xinhai  <xinhai.li@outlook.com>
> > 
> > mbind_range silently ignore unmapped hole at middle and tail of the 
> > specified range, but report EFAULT if hole at head side.
> 
> 
> Hmm that's unfortunate. mbind() manpage says:
> 
> EFAULT Part or all of the memory range specified by nodemask and maxnode
> points outside your accessible address space.  Or, there was an unmapped
> hole in  the  specified  memory range specified by addr and len.
> 
> That sounds like any hole inside the specified range should return
> EFAULT.

Yes (though an exception is allowed when restoring to default).

> But perhaps it can be also interpreted as you suggest, that the
> whole range is an unmapped hole.  There's some risk of breaking existing
> userspace if we change it either way.
> 
> > It is more reasonable to support silently ignore holes at any part of 
> > the range, only report EFAULT if the whole range is in hole.
> > 
> > Signed-off-by: Li Xinhai <xinhai.li@outlook.com>

Xinhai, I'm sceptical about this patch: is it something you found
by code inspection, or something you found when using mbind()?

I've not looked long enough to be certain, nor experimented, but:

mbind_range() is only one stage of the mbind() syscall implementation,
and is preceded by queue_pages_range(): look what queue_pages_test_walk()
does when MPOL_MF_DISCONTIG_OK not set.

My impression is that mbind_range() is merely correcting an omission
from the checks already made my queue_pages_test_walk() (an odd way
to proceed, I admit: would be better to check initially than later).

I do think that you should not make this change without considering
MPOL_MF_DISCONTIG_OK and its intention.

Hugh

> > ---
> > 
> >  mm/mempolicy.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > 
> > diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> > index 4ae967bcf954..ae160d9936d9 100644
> > --- a/mm/mempolicy.c
> > +++ b/mm/mempolicy.c
> > @@ -738,7 +738,7 @@ static int mbind_range(struct mm_struct *mm, unsigned long start,
> >         unsigned long vmend;
> >  
> >         vma = find_vma(mm, start);
> > -       if (!vma || vma->vm_start > start)
> > +       if (!vma || vma->vm_start >= end)
> >                 return -EFAULT;
> >  
> >         prev = vma->vm_prev;
> > 
