From: Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v2 0/6] Harden userfaultfd
Date: Wed, 12 Feb 2020 12:14:16 -0500
Message-ID: <20200212171416.GD1083891@xz-x1>
References: <20200211225547.235083-1-dancol@google.com>
 <202002112332.BE71455@keescook>
 <CAG48ez0ogRxvCK1aCnviN+nBqp6gmbUD7NjaMKvA7bF=esAc1A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <CAG48ez0ogRxvCK1aCnviN+nBqp6gmbUD7NjaMKvA7bF=esAc1A@mail.gmail.com>
Content-Disposition: inline
Sender: owner-linux-security-module@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: Kees Cook <keescook@chromium.org>, Daniel Colascione <dancol@google.com>, Tim Murray <timmurray@google.com>, Nosh Minwalla <nosh@google.com>, Nick Kralevich <nnk@google.com>, Lokesh Gidra <lokeshgidra@google.com>, kernel list <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, SElinux list <selinux@vger.kernel.org>, Andrea Arcangeli <aarcange@redhat.com>, Mike Rapoport <rppt@linux.ibm.com>, linux-security-module <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Feb 12, 2020 at 05:54:35PM +0100, Jann Horn wrote:
> On Wed, Feb 12, 2020 at 8:51 AM Kees Cook <keescook@chromium.org> wrote:
> > On Tue, Feb 11, 2020 at 02:55:41PM -0800, Daniel Colascione wrote:
> > >   Let userfaultfd opt out of handling kernel-mode faults
> > >   Add a new sysctl for limiting userfaultfd to user mode faults
> >
> > Now this I'm very interested in. Can you go into more detail about two
> > things:
> [...]
> > - Why is this needed in addition to the existing vm.unprivileged_userfaultfd
> >   sysctl? (And should this maybe just be another setting for that
> >   sysctl, like "2"?)
> >
> > As to the mechanics of the change, I'm not sure I like the idea of adding
> > a UAPI flag for this. Why not just retain the permission check done at
> > open() and if kernelmode faults aren't allowed, ignore them? This would
> > require no changes to existing programs and gains the desired defense.
> > (And, I think, the sysctl value could be bumped to "2" as that's a
> > better default state -- does qemu actually need kernelmode traps?)
> 
> I think this might be necessary for I/O emulation? As in, if before
> getting migrated, the guest writes some data into a buffer, then the
> guest gets migrated, and then while the postcopy migration stuff is
> still running, the guest tells QEMU to write that data from
> guest-physical memory to disk or whatever; I think in that case, QEMU
> will do something like a pwrite() syscall where the userspace pointer
> points into the memory area containing guest-physical memory, which
> would return -EFAULT if userfaultfd was restricted to userspace
> accesses.
> 
> This was described in this old presentation about why userfaultfd is
> better than a SIGSEGV handler:
> https://drive.google.com/file/d/0BzyAwvVlQckeSzlCSDFmRHVybzQ/view
> (slide 6) (recording at https://youtu.be/pC8cWWRVSPw?t=463)

Right. AFAICT QEMU uses it far more than disk IOs.  A guest page can
be accessed by any kernel component on the destination host during a
postcopy procedure.  It can be as simple as when a vcpu writes to a
missing guest page which still resides on the source host, then KVM
will get a page fault and trap into userfaultfd asking for that page.
The same thing happens to other modules like vhost, etc., as long as a
missing guest page is touched by a kernel module.

Thanks,

-- 
Peter Xu
