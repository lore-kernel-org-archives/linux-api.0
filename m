From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH V2] mm: Allow userland to request that the kernel clear
 memory on release
Date: Fri, 26 Apr 2019 16:03:26 +0200
Message-ID: <CAG48ez1OS7DeeEtv5jhO6wtMA2M2A_Bp3-ndS+sP=UoFuMiREw@mail.gmail.com>
References: <CACdnJuup-y1xAO93wr+nr6ARacxJ9YXgaceQK9TLktE7shab1w@mail.gmail.com>
 <20190424211038.204001-1-matthewgarrett@google.com> <20190425121410.GC1144@dhcp22.suse.cz>
 <CAG48ez0x6QiFpqXbimB9ZV-jS5UJJWhzg9XiAWncQL+phfKkPA@mail.gmail.com>
 <20190426053135.GC12337@dhcp22.suse.cz> <CAG48ez1MGyAd5tE=JLmjkFqou-VvsQHcJ5TU5f8_L43km9eoYA@mail.gmail.com>
 <20190426134722.GH22245@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190426134722.GH22245@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Matthew Garrett <matthewgarrett@google.com>, Linux-MM <linux-mm@kvack.org>, kernel list <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg59@google.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Apr 26, 2019 at 3:47 PM Michal Hocko <mhocko@kernel.org> wrote:
> On Fri 26-04-19 15:33:25, Jann Horn wrote:
> > On Fri, Apr 26, 2019 at 7:31 AM Michal Hocko <mhocko@kernel.org> wrote:
> > > On Thu 25-04-19 14:42:52, Jann Horn wrote:
> > > > On Thu, Apr 25, 2019 at 2:14 PM Michal Hocko <mhocko@kernel.org> wrote:
> > > > [...]
> > > > > On Wed 24-04-19 14:10:39, Matthew Garrett wrote:
> > > > > > From: Matthew Garrett <mjg59@google.com>
> > > > > >
> > > > > > Applications that hold secrets and wish to avoid them leaking can use
> > > > > > mlock() to prevent the page from being pushed out to swap and
> > > > > > MADV_DONTDUMP to prevent it from being included in core dumps. Applications
> > > > > > can also use atexit() handlers to overwrite secrets on application exit.
> > > > > > However, if an attacker can reboot the system into another OS, they can
> > > > > > dump the contents of RAM and extract secrets. We can avoid this by setting
> > > > > > CONFIG_RESET_ATTACK_MITIGATION on UEFI systems in order to request that the
> > > > > > firmware wipe the contents of RAM before booting another OS, but this means
> > > > > > rebooting takes a *long* time - the expected behaviour is for a clean
> > > > > > shutdown to remove the request after scrubbing secrets from RAM in order to
> > > > > > avoid this.
> > > > > >
> > > > > > Unfortunately, if an application exits uncleanly, its secrets may still be
> > > > > > present in RAM. This can't be easily fixed in userland (eg, if the OOM
> > > > > > killer decides to kill a process holding secrets, we're not going to be able
> > > > > > to avoid that), so this patch adds a new flag to madvise() to allow userland
> > > > > > to request that the kernel clear the covered pages whenever the page
> > > > > > reference count hits zero. Since vm_flags is already full on 32-bit, it
> > > > > > will only work on 64-bit systems.
> > > > [...]
> > > > > > diff --git a/mm/madvise.c b/mm/madvise.c
> > > > > > index 21a7881a2db4..989c2fde15cf 100644
> > > > > > --- a/mm/madvise.c
> > > > > > +++ b/mm/madvise.c
> > > > > > @@ -92,6 +92,22 @@ static long madvise_behavior(struct vm_area_struct *vma,
> > > > > >       case MADV_KEEPONFORK:
> > > > > >               new_flags &= ~VM_WIPEONFORK;
> > > > > >               break;
> > > > > > +     case MADV_WIPEONRELEASE:
> > > > > > +             /* MADV_WIPEONRELEASE is only supported on anonymous memory. */
> > > > > > +             if (VM_WIPEONRELEASE == 0 || vma->vm_file ||
> > > > > > +                 vma->vm_flags & VM_SHARED) {
> > > > > > +                     error = -EINVAL;
> > > > > > +                     goto out;
> > > > > > +             }
> > > > > > +             new_flags |= VM_WIPEONRELEASE;
> > > > > > +             break;
> > > >
> > > > An interesting effect of this is that it will be possible to set this
> > > > on a CoW anon VMA in a fork() child, and then the semantics in the
> > > > parent will be subtly different - e.g. if the parent vmsplice()d a
> > > > CoWed page into a pipe, then forked an unprivileged child, the child
> > >
> > > Maybe a stupid question. How do you fork an unprivileged child (without
> > > exec)? Child would have to drop priviledges on its own, no?
> >
> > Sorry, yes, that's what I meant.
>
> But then the VMA is gone along with the flag so why does it matter?

But in theory, the page might still be used somewhere, e.g. as data in
a pipe (into which the parent wrote it) or whatever. Parent
vmsplice()s a page into a pipe, parent exits, child marks the VMA as
WIPEONRELEASE and exits, page gets wiped, someone else reads the page
from the pipe.

Yes, this is very theoretical, and you'd have to write some pretty
weird software for this to matter. But it doesn't seem clean to me to
allow a child to affect the data in e.g. a pipe that it isn't supposed
to have access to like this.

Then again, this could probably already happen, since do_wp_page()
reuses pages depending on only the mapcount, without looking at the
refcount.
