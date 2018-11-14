From: Daniel Colascione <dancol@google.com>
Subject: Re: Official Linux system wrapper library?
Date: Wed, 14 Nov 2018 07:40:46 -0800
Message-ID: <CAKOZuesta_V=doXsVLc2E6WCQvywdur3F+u2pFKaPN+CEQd+ZQ@mail.gmail.com>
References: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com>
 <bbc12da5-830e-99a7-95e3-d9da42947dc9@gmail.com> <877ehjx447.fsf@oldenburg.str.redhat.com>
 <CAKOZues5SEESpJU=6MDTrPXTA1KTZFGNQE4Lw4t0fO-WBTU62w@mail.gmail.com>
 <875zx2vhpd.fsf@oldenburg.str.redhat.com> <CAKOZuetdgk1QYhx1538-98rFpogMin=8DkPnCtU9_=ip23Vk7w@mail.gmail.com>
 <20181113193859.GJ3505@e103592.cambridge.arm.com> <5853c297-9d84-86e5-dede-aa2957562c6b@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5853c297-9d84-86e5-dede-aa2957562c6b@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Szabolcs Nagy <Szabolcs.Nagy@arm.com>
Cc: Dave P Martin <Dave.Martin@arm.com>, nd <nd@arm.com>, Florian Weimer <fweimer@redhat.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>, Willy Tarreau <w@1wt.eu>, Vlastimil Babka <vbabka@suse.cz>, Carlos O'Donell <carlos@redhat.com>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

On Wed, Nov 14, 2018 at 3:58 AM, Szabolcs Nagy <Szabolcs.Nagy@arm.com> wrote:
> On 13/11/18 19:39, Dave Martin wrote:
>> On Mon, Nov 12, 2018 at 05:19:14AM -0800, Daniel Colascione wrote:
>>> We should adopt a similar approach. Shipping a lower-level
>>> "liblinux.so" tightly bound to the kernel would not only let the
>>> kernel bypass glibc's "editorial discretion" in exposing new
>>> facilities to userspace, but would also allow for tighter user-kernel
>>> integration that one can achieve with a simplistic syscall(2)-style
>>> escape hatch. (For example, for a long time now, I've wanted to go
>>> beyond POSIX and improve the system's signal handling API, and this
>>> improvement requires userspace cooperation.) The vdso is probably too
>>> small and simplistic to serve in this role; I'd want a real library.
>>
>> Can you expand on your reasoning here?
>
> such lib creates a useless abi+api layer that
> somebody has to maintain and document (with or
> without vdso).

People already maintain the kernel man pages and are very good.

> it obviously cannot work together with a posix
> conform libc implementation for which it would
> require knowledge about

You're incorrect on this point. See programs cobbled together out of
syscall(2) invocations today: despite lack of libc integration, things
do mostly work in practice. Calling through a library can't possible
be worse, and in many ways can be much better.

> thread cancellation internals,

As I mentioned upthread, the only thing a libc needs in order to
support cancellation properly (at least the way glibc does it)
is a way to ask the kernel-provided userspace library whether a
particular program counter address belongs to a certain code sequence
immediately before the system call instruction, whatever that is.
Providing this facility is doable without deep knowledge of libc's
internals, and libc can use it without a deep knowledge of the
interface library.

> potentially TLS
> for errno

As someone else mentioned, errno is a libc construct. It's not *hard*
to support setting errno though: libc could just be required to supply
a well-defined libc_set_errno symbol that the kernel ABI library would
then use as needed.

> know libc types even ones that are
> based on compile time feature macros

This library would not have to do the things that libc does. Why would
it have to support libc's feature test macros at all?

> (and expose
> them in headers in a way that does not collide
> with libc headers)

The kernel should have a set of types and a symbol namespace
completely disjoint from libc's, with no compatibility hacks or macros
needed. (That might take some renaming kernel-side.) If libc wants to
provide a POSIX API, it can take on the responsibility for mapping the
kernel's structures to libc's, but within its namespace, the kernel
should be able to add types without fear of conflict.

> abi variants the libc supports
> (e.g. softfp, security hardened abi), libc
> internal signals (for anything that's changing
> signal masks), thread internals for syscalls that
> require coordination between all user created
> threads

Most proposed new system calls do not create threads, manipulate
signal masks, or muck with other internals, so these concerns just
don't apply. That's why syscall(2) mostly works in practice. Even if a
few new system calls *do* involve these internal details and require
closer libc coordination, the majority (e.g., the new mount API,
termios2) don't, and so can be exposed directly from the kernel
project without being blocked by glibc.

> (setxid),

A kernel-side fix here would be the cleanest approach.

> libc internal state for syscalls
> that create/destroy threads.
>
> and thus such lib does not solve the problems
> of users who actually requested wrappers for
> new syscalls (since they want to call into libc
> and create threads).
>
> there is a lot of bikesheding here by people who
> don't understand the constraints nor the use-cases.

Conversely, there's a lot of doubt-sowing from the other side that
makes shipping a kernel-provided interface library seem harder than it
is. Most new system calls do not bear on the integration concerns that
you and others are raising, and whatever problems remain can be solved
with a narrow interface between libc and a new interface library, one
that would let both evolve independently.

> an actual proposal in the thread that i think is
> worth considering is to make the linux syscall
> design process involve libc devs so the c api is
> designed together with the syscall abi.

After looking at the history of settid, signal multi-handler
registration, and other proposed improvements running into the brick
wall of glibc's API process, I think it's clear that requiring glibc
signoff on new kernel interfaces would simply lead to stagnation. It's
not as if we're approaching the problem from a position of ignorance.
The right answer is a move to an approximation of the BSD model and
bring the primary interface layer in-house.
 There's a lot of evidence that this model works.
