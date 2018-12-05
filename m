From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] Y2038: provide kernel support indication
Date: Wed, 5 Dec 2018 15:26:14 +0100
Message-ID: <CAK8P3a25W8NXY9e=DMzL-jd4+69ecZMyrWGxYDPP4MuH-Ng-9Q@mail.gmail.com>
References: <20180919071303.26636-1-albert.aribaud@3adev.fr>
 <alpine.DEB.2.21.1809191300420.14910@digraph.polyomino.org.uk>
 <20180924235639.716a4cb4@athena> <alpine.DEB.2.21.1809251656190.14070@digraph.polyomino.org.uk>
 <20180925213635.70084f61@athena> <CAK8P3a17ZpOKx=p1Y2FgruM3GMcdOtiwaQqPvmg5xZQpFP2fCQ@mail.gmail.com>
 <20181205124926.7d433994@athena> <CAK8P3a0vZhfW_o3OhYBhwRmKCXA0jAAuODxmzHt+rwJkKO45ZA@mail.gmail.com>
 <alpine.DEB.2.21.1812051337210.13925@digraph.polyomino.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <libc-alpha-return-97975-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <alpine.DEB.2.21.1812051337210.13925@digraph.polyomino.org.uk>
To: Joseph Myers <joseph@codesourcery.com>
Cc: Albert ARIBAUD <albert.aribaud@3adev.fr>, GNU C Library <libc-alpha@sourceware.org>, Firoz Khan <firoz.khan@linaro.org>, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Dec 5, 2018 at 2:48 PM Joseph Myers <joseph@codesourcery.com> wrote:
> On Wed, 5 Dec 2018, Arnd Bergmann wrote:
>
> > I think it's important that we only do this when we are called from
> > an application with 64-bit time_t: When a user calls gettimeofday()
> > with 64-bit time_t, that should try clock_gettime64(2) and fall back
> > to clock_gettime(2) or gettimeofday(2) if that is unavailable. However
> > an application using gettimeofday() with a 32-bit time_t should
> > directly call gettimeofday(2) in the kernel but not try clock_gettime64()
> > first. Without that distinction, the kernel cannot return -ENOSYS
> > if we configure it to break compatibility with 32-bit time_t interfaces
> > and the application might seem to work correctly despite being
> > broken in 2038.
>
> By design, all nontrivial 32-bit time interfaces in glibc for 32-bit
> architectures should end up as simple wrappers round the implementations
> using 64-bit time internally, to avoid duplication of complicated code
> (previous versions of the Y2038 patches e.g. duplicated hundreds of lines
> of pthread_mutex_timedlock implementation, which is clearly not a
> maintainable approach).  That means many 32-bit interfaces *will* end up
> using 64-bit syscalls (with fallback to 32-bit if the 64-bit syscalls are
> unavailable at runtime), even if some simple functions that really are
> just one syscall for 32-bit still call the old syscall.

That would make it very hard to deploy a glibc based system
with strict y2038 requirements. If we can no longer guarantee the
basic assumption that old applications keep using the old system
calls, then I think we instead need a way to build glibc itself without
support for the 32-bit time_t interfaces, e.g. using a --disable-time32
configuration switch to force a link-time error for any application
or library that has not been built against the 64-bit time_t interfaces.

The default would of course remain providing backwards compatibility
with all applications to allow a gradual migration from 32-bit time_t
to 64-bit time_t. If all 32-bit time_t calls are just wrappers around
either the internal implementation using 64-bit time_t or around
a simple system call, then it should at least be easy to make them
optional for users that need them not work.

Would that be something you can do?

      Arnd
