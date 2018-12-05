From: Joseph Myers <joseph@codesourcery.com>
Subject: Re: [PATCH] Y2038: provide kernel support indication
Date: Wed, 5 Dec 2018 13:48:02 +0000
Message-ID: <alpine.DEB.2.21.1812051337210.13925@digraph.polyomino.org.uk>
References: <20180919071303.26636-1-albert.aribaud@3adev.fr> <alpine.DEB.2.21.1809191300420.14910@digraph.polyomino.org.uk> <20180924235639.716a4cb4@athena> <alpine.DEB.2.21.1809251656190.14070@digraph.polyomino.org.uk> <20180925213635.70084f61@athena>
 <CAK8P3a17ZpOKx=p1Y2FgruM3GMcdOtiwaQqPvmg5xZQpFP2fCQ@mail.gmail.com> <20181205124926.7d433994@athena> <CAK8P3a0vZhfW_o3OhYBhwRmKCXA0jAAuODxmzHt+rwJkKO45ZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <libc-alpha-return-97971-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <CAK8P3a0vZhfW_o3OhYBhwRmKCXA0jAAuODxmzHt+rwJkKO45ZA@mail.gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Albert ARIBAUD <albert.aribaud@3adev.fr>, GNU C Library <libc-alpha@sourceware.org>, Firoz Khan <firoz.khan@linaro.org>, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, 5 Dec 2018, Arnd Bergmann wrote:

>   The most logical way to do this in the kernel now is actually to
>   have the newly assigned number point to the same syscall
>   implementation on all architectures, both 32-bit and 64-bit.

If you have (redundant) new numbers on 64-bit, glibc should not use those 
at all on 64-bit until the minimum kernel version is new enough to be sure 
they are available, to avoid unnecessary runtime fallback code.  Cf. how 
on socketcall architectures it made sense to keep using just socketcall 
for accept4 / recvmmsg / sendmmsg, rather than using the separate syscalls 
with runtime fallback to socketcall (in the cases where syscalls were 
added later than socketcall support), unless the configured minimum kernel 
version is recent enough to ensure the syscall is available.

(That does not prevent glibc having local #undef / #define to be able to 
use the new *names* unconditionally while still using the old numbers, if 
that proves useful.)

> I think it's important that we only do this when we are called from
> an application with 64-bit time_t: When a user calls gettimeofday()
> with 64-bit time_t, that should try clock_gettime64(2) and fall back
> to clock_gettime(2) or gettimeofday(2) if that is unavailable. However
> an application using gettimeofday() with a 32-bit time_t should
> directly call gettimeofday(2) in the kernel but not try clock_gettime64()
> first. Without that distinction, the kernel cannot return -ENOSYS
> if we configure it to break compatibility with 32-bit time_t interfaces
> and the application might seem to work correctly despite being
> broken in 2038.

By design, all nontrivial 32-bit time interfaces in glibc for 32-bit 
architectures should end up as simple wrappers round the implementations 
using 64-bit time internally, to avoid duplication of complicated code 
(previous versions of the Y2038 patches e.g. duplicated hundreds of lines 
of pthread_mutex_timedlock implementation, which is clearly not a 
maintainable approach).  That means many 32-bit interfaces *will* end up 
using 64-bit syscalls (with fallback to 32-bit if the 64-bit syscalls are 
unavailable at runtime), even if some simple functions that really are 
just one syscall for 32-bit still call the old syscall.

-- 
Joseph S. Myers
joseph@codesourcery.com
