From: Oleksandr Natalenko <oleksandr@redhat.com>
Subject: Re: [PATCH RFC v2 4/4] mm/ksm: add force merging/unmerging
 documentation
Date: Wed, 15 May 2019 08:26:39 +0200
Message-ID: <20190515062639.qpqdkbrmujhnxfg7@butterfly.localdomain>
References: <20190514131654.25463-1-oleksandr@redhat.com>
 <20190514131654.25463-5-oleksandr@redhat.com>
 <CAGqmi77gESF0h8ZduHm8TTPKRqQLGFdCP15TAW5skDwZnL85YA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGqmi77gESF0h8ZduHm8TTPKRqQLGFdCP15TAW5skDwZnL85YA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Kirill Tkhai <ktkhai@virtuozzo.com>, Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, Matthew Wilcox <willy@infradead.org>, Pavel Tatashin <pasha.tatashin@soleen.com>, Aaron Tomlin <atomlin@redhat.com>, Grzegorz Halat <ghalat@redhat.com>, linux-mm@kvack.org, linux-api@vger.kernel.org, Hugh Dickins <hughd@google.com>
List-Id: linux-api@vger.kernel.org

Hi.

On Wed, May 15, 2019 at 03:53:55AM +0300, Timofey Titovets wrote:
> LGTM for whole series
> 
> Reviewed-by: Timofey Titovets <nefelim4ag@gmail.com>
> 
> вт, 14 мая 2019 г. в 16:17, Oleksandr Natalenko <oleksandr@redhat.com>:
> >
> > Document respective sysfs knob.
> >
> > Signed-off-by: Oleksandr Natalenko <oleksandr@redhat.com>
> > ---
> >  Documentation/admin-guide/mm/ksm.rst | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> >
> > diff --git a/Documentation/admin-guide/mm/ksm.rst b/Documentation/admin-guide/mm/ksm.rst
> > index 9303786632d1..4302b92910ec 100644
> > --- a/Documentation/admin-guide/mm/ksm.rst
> > +++ b/Documentation/admin-guide/mm/ksm.rst
> > @@ -78,6 +78,17 @@ KSM daemon sysfs interface
> >  The KSM daemon is controlled by sysfs files in ``/sys/kernel/mm/ksm/``,
> >  readable by all but writable only by root:
> >
> > +force_madvise
> > +        write-only control to force merging/unmerging for specific
> > +        task.
> > +
> > +        To mark the VMAs as mergeable, use:
> > +        ``echo PID > /sys/kernel/mm/ksm/force_madvise``
> > +
> > +        To unmerge all the VMAs, use:
> > +        ``echo -PID > /sys/kernel/mm/ksm/force_madvise``
> > +        (note the prepending "minus")
> > +
> In patch 3/4 you have special case with PID 0,
> may be that also must be documented here?

Thanks for the review. Yes, this is a valid point, I'll document it too.

> 
> >  pages_to_scan
> >          how many pages to scan before ksmd goes to sleep
> >          e.g. ``echo 100 > /sys/kernel/mm/ksm/pages_to_scan``.
> > --
> > 2.21.0
> >
> 
> 
> --
> Have a nice day,
> Timofey.

-- 
  Best regards,
    Oleksandr Natalenko (post-factum)
    Senior Software Maintenance Engineer
