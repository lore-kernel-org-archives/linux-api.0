From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [Y2038] [klibc] kernel/libc uapi changes for y2038
Date: Mon, 18 May 2015 15:32:12 +0200
Message-ID: <10173485.f8yUt0lQ60@wuerfel>
References: <2664016.bYZKg6FQqR@wuerfel> <Pine.BSM.4.64L.1505181214530.8249@herc.mirbsd.org>
Reply-To: musl@lists.openwall.com
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <musl-return-7695-gllmg-musl=m.gmane.org@lists.openwall.com>
List-Post: <mailto:musl@lists.openwall.com>
List-Help: <mailto:musl-help@lists.openwall.com>
List-Unsubscribe: <mailto:musl-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:musl-subscribe@lists.openwall.com>
In-Reply-To: <Pine.BSM.4.64L.1505181214530.8249@herc.mirbsd.org>
To: y2038@lists.linaro.org
Cc: Thorsten Glaser <tg@mirbsd.de>, klibc@zytor.com, libc-alpha@sourceware.org, linux-api@vger.kernel.org, musl@lists.openwall.com, linux-kernel@vger.kernel.org, Rich Felker <dalias@libc.org>, cferris@google.com, enh@google.com, "Joseph S. Myers" <joseph@codesourcery.com>
List-Id: linux-api@vger.kernel.org

On Monday 18 May 2015 12:16:48 Thorsten Glaser wrote:
> Arnd Bergmann dixit:
> 
> >In the patch series I posted recently [1], I introduce new system calls to deal
> >with modified data structures, but left the question open on how these should
> >be best accessed from libc. The patches introduce a new __kernel_time64_t type
> 
> Can we please have ioctls fixed for mixed 32/64-bit systems
> such as MIPS (o32/n32/n64) and x86 (i386/x32/amd64) first,
> before even more such chance for breakage is introduced?

It's hard because we don't even know what ioctls are affected at this point,
and I was hoping to get this part merged as a stepping stone in the process
of finding out.

The problem is that there are so many different cases we have to worry
about just for time_t:

a) ioctls that pass a data structure from include/uapi/ with time_t and
   have a properly defined (using _IOW()/_IOR()/_IORW()) command number:
   these are easy enough to find and fix.

b) ioctls that have a data structure as before but define their ioctl
   commands differently (e.g. using a literal number). I don't think
   we can fix them before we introduce the __KERNEL_TIME_BITS macro
   from my patch, because user space needs to see a different command
   number here, and we have a lot of these.

c) ioctls that are defined ad-hoc, without any uapi header containing
   the structure, but using a proper _IOW()/_IOR()/_IORW() macro.
   These are much harder to find than a), but just as easy to fix

d) ioctls that are defined ad-hoc based on a time_t value and with
   a wrong command number.
   These will be broken no matter what we do, and our only hope is
   to find all applications using them so we can fix the user space
   sources.

e) ioctls that pass a time value as a 'long' or '__u32' instead of
   'time_t'. Fixing them requires adding new ioctl commands to let
   them work beyond 2038, independent of what we do here.

f) ioctls that use structures with pointers to other structures that
   are not defined in the uapi headers. (this might not be a problem,
   I haven't been able to figure out of these are real)

All of the above are currently broken for x32, but fixing them will
likely take a few years and leave x32 still broken because of other
uses of __kernel_long_t in ioctl.

MIPS on the other hand is no more broken than any of the other 32-bit
ABIs, because it does not use 64-bit __kernel_long_t in its n32 ABI.
 
> I still need to use an amd64 chroot on my x32 system to do
> things such as set up iptables, because those ioctls break,
> because they contain data structures that contain, well,
> time types. Your proposal has a non-zero chance to bring
> these issues to i386 (and other architectures).

We should indeed not start widely deploying user space with 64-bit time_t
on 32-bit architectures until we found and fixed a good part of the
ioctls. My plan at this point is to eliminate all uses of time_t in
the kernel and replace them with time64_t or other safe types.
This way, we will eventually find all code that passes 32-bit time types
to user space and can fix it. This will take care of the time_t
related problems on x32 as well.

	Arnd
