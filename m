From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH RFC 4/5] mm/ksm, proc: introduce remote merge
Date: Thu, 16 May 2019 18:09:44 +0200
Message-ID: <CAG48ez0-ytaDNVa7TiMaa4nR-nMEh_ZgND-sXjiw+RzZFmMqhw@mail.gmail.com>
References: <20190516094234.9116-1-oleksandr@redhat.com> <20190516094234.9116-5-oleksandr@redhat.com>
 <CAG48ez2yXw_PJXO-mS=Qw5rkLpG6zDPd0saMhhGk09-du2bpaA@mail.gmail.com>
 <20190516142013.sf2vitmksvbkb33f@butterfly.localdomain> <20190516144323.pzkvs6hapf3czorz@butterfly.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190516144323.pzkvs6hapf3czorz@butterfly.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleksandr Natalenko <oleksandr@redhat.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, Kirill Tkhai <ktkhai@virtuozzo.com>, Hugh Dickins <hughd@google.com>, Alexey Dobriyan <adobriyan@gmail.com>, Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, Matthew Wilcox <willy@infradead.org>, Pavel Tatashin <pasha.tatashin@soleen.com>, Greg KH <greg@kroah.com>, Suren Baghdasaryan <surenb@google.com>, Minchan Kim <minchan@kernel.org>, Timofey Titovets <nefelim4ag@gmail.com>, Aaron Tomlin <atomlin@redhat.com>, Grzegorz Halat <ghalat@redhat.com>, Linux-MM <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, May 16, 2019 at 4:43 PM Oleksandr Natalenko
<oleksandr@redhat.com> wrote:
> On Thu, May 16, 2019 at 04:20:13PM +0200, Oleksandr Natalenko wrote:
> > > [...]
> > > > @@ -2960,15 +2962,63 @@ static int proc_stack_depth(struct seq_file *m, struct pid_namespace *ns,
> > > >  static ssize_t madvise_write(struct file *file, const char __user *buf,
> > > >                 size_t count, loff_t *ppos)
> > > >  {
> > > > +       /* For now, only KSM hints are implemented */
> > > > +#ifdef CONFIG_KSM
> > > > +       char buffer[PROC_NUMBUF];
> > > > +       int behaviour;
> > > >         struct task_struct *task;
> > > > +       struct mm_struct *mm;
> > > > +       int err = 0;
> > > > +       struct vm_area_struct *vma;
> > > > +
> > > > +       memset(buffer, 0, sizeof(buffer));
> > > > +       if (count > sizeof(buffer) - 1)
> > > > +               count = sizeof(buffer) - 1;
> > > > +       if (copy_from_user(buffer, buf, count))
> > > > +               return -EFAULT;
> > > > +
> > > > +       if (!memcmp("merge", buffer, min(sizeof("merge")-1, count)))
> > >
> > > This means that you also match on something like "mergeblah". Just use strcmp().
> >
> > I agree. Just to make it more interesting I must say that
> >
> >    /sys/kernel/mm/transparent_hugepage/enabled
> >
> > uses memcmp in the very same way, and thus echoing "alwaysssss" or
> > "madviseeee" works perfectly there, and it was like that from the very
> > beginning, it seems. Should we fix it, or it became (zomg) a public API?
>
> Actually, maybe, the reason for using memcmp is to handle "echo"
> properly: by default it puts a newline character at the end, so if we use
> just strcmp, echo should be called with -n, otherwise strcmp won't match
> the string.
>
> Huh?

Ah, yes, other code like e.g. proc_setgroups_write() uses strncmp()
and then has an extra check to make sure everything trailing is
whitespace.
