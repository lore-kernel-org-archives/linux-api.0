From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: Can we drop upstream Linux x32 support?
Date: Thu, 13 Dec 2018 12:40:25 +0000
Message-ID: <20181213124025.bczxzj6ez34joo6v@localhost>
References: <CALCETrXoRAibsbWa9nfbDrt0iEuebMnCMhSFg-d9W-J2g8mDjw@mail.gmail.com>
 <CAHk-=wi_Kp=3XmGDdzmadzFSPFvuL+aAJ6ZPAR=o4z=KwYT2vw@mail.gmail.com>
 <Pine.BSM.4.64L.1812112150480.21176@herc.mirbsd.org>
 <CALCETrWgpAX7FV23zHmid83SsgnwFMKD4a_-xSEgB6v0kJR5sA@mail.gmail.com>
 <Pine.BSM.4.64L.1812112327500.21176@herc.mirbsd.org>
 <CALCETrXf0rmadycxmpGxd41qP9X+PAjyGHTwbGhKyp6oMKMRrA@mail.gmail.com>
 <Pine.BSM.4.64L.1812120231410.21176@herc.mirbsd.org>
 <CALCETrUYn=S=hmJ0tKdm2LoSgkWchY2_65sH7hJZp7wfS30giw@mail.gmail.com>
 <20181212165237.GT23599@brightrain.aerifal.cx>
 <CALCETrV6+YAazq7vY_aR=4kXc4ykXb1Se7hgvHeEVJtbZ91=Qg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrV6+YAazq7vY_aR=4kXc4ykXb1Se7hgvHeEVJtbZ91=Qg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Rich Felker <dalias@libc.org>, tg@mirbsd.de, Linus Torvalds <torvalds@linux-foundation.org>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>, Florian Weimer <fweimer@redhat.com>, Mike Frysinger <vapier@gentoo.org>, "H. J. Lu" <hjl.tools@gmail.com>, x32@buildd.debian.org, Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>
List-Id: linux-api@vger.kernel.org

On Wed, Dec 12, 2018 at 10:03:30AM -0800, Andy Lutomirski wrote:
> On Wed, Dec 12, 2018 at 8:52 AM Rich Felker <dalias@libc.org> wrote:
> > On Wed, Dec 12, 2018 at 08:39:53AM -0800, Andy Lutomirski wrote:
> > > I'm proposing another alternative.  Given that x32 already proves that
> > > the user bitness model doesn't have to match the kernel model (in x32,
> > > user "long" is 32-bit but the kernel ABI "long" is 64-bit), I'm
> > > proposing extending this to just make the kernel ABI be LP64.  So
> > > __kernel_size_t would be 64-bit and pointers in kernel data structures
> > > would be 64-bit.  In other words, most or all of the kernel ABI would
> > > just match x86_64.
> > >
> > > As far as I can tell, the only thing that really needs unusual
> > > toolchain features here is that C doesn't have an extra-wide pointer
> > > type.  The kernel headers would need a way to say "this pointer is
> > > still logically a pointer, and user code may assume that it's 32 bits,
> > > but it has 8-byte alignment."
> >
> > None of this works on the userspace/C side, nor should any attempt be
> > made to make it work. Types fundamentally cannot have alignments
> > larger than their size. If you want to make the alignment of some
> > pointers 8, you have to make their size 8, and then you just have LP64
> > again if you did it for all pointers.
> >
> > If on the other hand you tried to make just some pointers "wide
> > pointers", you'd also be completely breaking the specified API
> > contracts of standard interfaces. For example in struct iovec's
> > iov_base, &foo->iov_base is no longer a valid pointer to an object of
> > type void* that you can pass to interfaces expecting void**. Sloppy
> > misunderstandings like what you're making now are exactly why x32 is
> > already broken and buggy (&foo->tv_nsec already has wrong type for
> > struct timespec foo).
> 
> I don't think it's quite that broken.  For the struct iovec example,
> we currently have:
> 
>            struct iovec {
>                void  *iov_base;    /* Starting address */
>                size_t iov_len;     /* Number of bytes to transfer */
>            };
> 
> we could have, instead: (pardon any whitespace damage)
> 
>            struct iovec {
>                void  *iov_base;    /* Starting address */
>                uint32_t __pad0;
>                size_t iov_len;     /* Number of bytes to transfer */
>                uint32_t __pad1;
>            } __attribute__((aligned(8));
> 
> or the same thing but where iov_len is uint64_t.  A pointer to
> iov_base still works exactly as expected.  Something would need to be
> done to ensure that the padding is all zeroed, which might be a real
> problem.

We looked at this approach briefly for arm64/ILP32 and zeroing the pads
was the biggest problem. User programs would not explicitly zero the pad
and I'm not sure the compiler would be any smarter. This means it's the
kernel's responsibility to zero the pad (around get_user,
copy_from_user), so it doesn't actually simplify the kernel side of the
syscall interface.

If the data flow goes the other way (kernel to user), this approach
works fine.

> No one wants to actually type all the macro gunk into the headers to
> make this work, but this type of transformation is what I have in mind
> when the compiler is asked to handle the headers.  Or there could
> potentially be a tool that automatically consumes the uapi headers and
> spits out modified headers like this.

If the compiler can handle the zeroing, that would be great, though not
sure how (some __attribute__((zero)) which generates a type constructor
for such structure; it kind of departs from what the C language offers).

> Realistically, I think a much better model would be to use true ILP32
> code, where all the memory layouts in the uapi match i386.

The conclusion we came to on arm64 was that an ILP32 ABI should not
really be any different from a _new_ 32-bit architecture ABI. It differs
from arm32 a bit (different syscall numbers, off_t is 64-bit,
sigcontext) but not significantly as it is still able to use the
majority of the compat_sys_* wrappers.

-- 
Catalin
