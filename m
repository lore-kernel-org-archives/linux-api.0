From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH RFC] mm: add MAP_EXCLUSIVE to create exclusive user mappings
Date: Tue, 29 Oct 2019 10:00:55 -0700
Message-ID: <CALCETrUuuc4DS0cdMBtS550Wkp0x9ND3M3SgtaMgyRROnDR5Kg@mail.gmail.com>
References: <1572171452-7958-1-git-send-email-rppt@kernel.org>
 <CA5C22D9-BC3E-4B69-8DD9-4D3B75E40BD5@amacapital.net> <20191029093254.GE18773@rapoport-lnx>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191029093254.GE18773@rapoport-lnx>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Rapoport <rppt@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, James Bottomley <jejb@linux.ibm.com>, Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Linux API <linux-api@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, X86 ML <x86@kernel.org>, Mike Rapoport <rppt@linux.ibm.com>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 29, 2019 at 2:33 AM Mike Rapoport <rppt@kernel.org> wrote:
>
> On Mon, Oct 28, 2019 at 02:44:23PM -0600, Andy Lutomirski wrote:
> >
> > > On Oct 27, 2019, at 4:17 AM, Mike Rapoport <rppt@kernel.org> wrote:
> > >
> > > =EF=BB=BFFrom: Mike Rapoport <rppt@linux.ibm.com>
> > >
> > > Hi,
> > >
> > > The patch below aims to allow applications to create mappins that hav=
e
> > > pages visible only to the owning process. Such mappings could be used=
 to
> > > store secrets so that these secrets are not visible neither to other
> > > processes nor to the kernel.
> > >
> > > I've only tested the basic functionality, the changes should be verif=
ied
> > > against THP/migration/compaction. Yet, I'd appreciate early feedback.
> >
> > I=E2=80=99ve contemplated the concept a fair amount, and I think you sh=
ould
> > consider a change to the API. In particular, rather than having it be a
> > MAP_ flag, make it a chardev.  You can, at least at first, allow only
> > MAP_SHARED, and admins can decide who gets to use it.  It might also pl=
ay
> > better with the VM overall, and you won=E2=80=99t need a VM_ flag for i=
t =E2=80=94 you
> > can just wire up .fault to do the right thing.
>
> I think mmap()/mprotect()/madvise() are the natural APIs for such
> interface.

Then you have a whole bunch of questions to answer.  For example:

What happens if you mprotect() or similar when the mapping is already
in use in a way that's incompatible with MAP_EXCLUSIVE?

Is it actually reasonable to malloc() some memory and then make it exclusiv=
e?

Are you permitted to map a file MAP_EXCLUSIVE?  What does it mean?

What does MAP_PRIVATE | MAP_EXCLUSIVE do?

How does one pass exclusive memory via SCM_RIGHTS?  (If it's a
memfd-like or chardev interface, it's trivial.  mmap(), not so much.)

And finally, there's my personal giant pet peeve: a major use of this
will be for virtualization.  I suspect that a lot of people would like
the majority of KVM guest memory to be unmapped from the host
pagetables.  But people might also like for guest memory to be
unmapped in *QEMU's* pagetables, and mmap() is a basically worthless
interface for this.  Getting fd-backed memory into a guest will take
some possibly major work in the kernel, but getting vma-backed memory
into a guest without mapping it in the host user address space seems
much, much worse.

> Switching to a chardev doesn't solve the major problem of direct
> map fragmentation and defeats the ability to use exclusive memory mapping=
s
> with the existing allocators, while mprotect() and madvise() do not.
>

Will people really want to do malloc() and then remap it exclusive?
This sounds dubiously useful at best.
