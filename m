From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH RFC 4/5] mm/ksm, proc: introduce remote merge
Date: Thu, 16 May 2019 18:06:24 +0200
Message-ID: <CAG48ez0teQk+rVnRmr=xcM8PJ_8UZC3hSi7PABx-qunz+5=DGg@mail.gmail.com>
References: <20190516094234.9116-1-oleksandr@redhat.com> <20190516094234.9116-5-oleksandr@redhat.com>
 <CAG48ez2yXw_PJXO-mS=Qw5rkLpG6zDPd0saMhhGk09-du2bpaA@mail.gmail.com> <20190516142013.sf2vitmksvbkb33f@butterfly.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190516142013.sf2vitmksvbkb33f@butterfly.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleksandr Natalenko <oleksandr@redhat.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, Kirill Tkhai <ktkhai@virtuozzo.com>, Hugh Dickins <hughd@google.com>, Alexey Dobriyan <adobriyan@gmail.com>, Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, Matthew Wilcox <willy@infradead.org>, Pavel Tatashin <pasha.tatashin@soleen.com>, Greg KH <greg@kroah.com>, Suren Baghdasaryan <surenb@google.com>, Minchan Kim <minchan@kernel.org>, Timofey Titovets <nefelim4ag@gmail.com>, Aaron Tomlin <atomlin@redhat.com>, Grzegorz Halat <ghalat@redhat.com>, Linux-MM <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, May 16, 2019 at 4:20 PM Oleksandr Natalenko
<oleksandr@redhat.com> wrote:
> On Thu, May 16, 2019 at 12:00:24PM +0200, Jann Horn wrote:
> > On Thu, May 16, 2019 at 11:43 AM Oleksandr Natalenko
> > <oleksandr@redhat.com> wrote:
> > > Use previously introduced remote madvise knob to mark task's
> > > anonymous memory as mergeable.
> > >
> > > To force merging task's VMAs, "merge" hint is used:
> > >
> > >    # echo merge > /proc/<pid>/madvise
> > >
> > > Force unmerging is done similarly:
> > >
> > >    # echo unmerge > /proc/<pid>/madvise
> > >
> > > To achieve this, previously introduced ksm_madvise_*() helpers
> > > are used.
> >
> > Why does this not require PTRACE_MODE_ATTACH_FSCREDS to the target
> > process? Enabling KSM on another process is hazardous because it
> > significantly increases the attack surface for side channels.
> >
> > (Note that if you change this to require PTRACE_MODE_ATTACH_FSCREDS,
> > you'll want to use mm_access() in the ->open handler and drop the mm
> > in ->release. mm_access() from a ->write handler is not permitted.)
>
> Sounds reasonable. So, something similar to what mem_open() & friends do
> now:
>
> static int madvise_open(...)
> ...
>         struct task_struct *task = get_proc_task(inode);
> ...
>         if (task) {
>                 mm = mm_access(task, PTRACE_MODE_ATTACH_FSCREDS);
>                 put_task_struct(task);
>                 if (!IS_ERR_OR_NULL(mm)) {
>                         mmgrab(mm);
>                         mmput(mm);
> ...
>
> Then:
>
> static ssize_t madvise_write(...)
> ...
>         if (!mmget_not_zero(mm))
>                 goto out;
>
>         down_write(&mm->mmap_sem);
>         if (!mmget_still_valid(mm))
>                 goto skip_mm;
> ...
> skip_mm:
>         up_write(&mm->mmap_sem);
>
>         mmput(mm);
> out:
>         return ...;
>
> And, finally:
>
> static int madvise_release(...)
> ...
>                 mmdrop(mm);
> ...
>
> Right?

Yeah, that looks reasonable.
