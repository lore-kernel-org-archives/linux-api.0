From: "Joseph S. Myers" <joseph@codesourcery.com>
Subject: Re: 2038 Kernel Summit Discussion Fodder
Date: Wed, 13 Aug 2014 15:37:57 +0000
Message-ID: <Pine.LNX.4.64.1408131518430.19863@digraph.polyomino.org.uk>
References: <CALAqxLUcfaJnxdmkn6mucepNk3QaCQdcSPLRjjeKsk_OTp=uLA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALAqxLUcfaJnxdmkn6mucepNk3QaCQdcSPLRjjeKsk_OTp=uLA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Stultz <john.stultz@linaro.org>
Cc: ksummit-discuss@lists.linuxfoundation.org, lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Arnd Bergmann <arnd@arndb.de>, "H. Peter Anvin" <hpa@zytor.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, 13 Aug 2014, John Stultz wrote:

> 2) Userspace ABI modifications: This includes how we expose the new 
> 64bit time_t and related structures to userland via syscalls and ioctls, 

Note the point from previous discussions that whenever the kernel takes a 
64-bit timespec value from 32-bit userspace (which should include x32), 
the upper 32 bits of the nanoseconds value should be ignored for POSIX 
compatibility (but maximum compatibility with existing x32 userspace means 
you should still write those bits as 0 when writing such a value out to 
userspace).

> Basically this is the same as the above, where the kernel provides both
> legacy and new time_t related interfaces. However, the libc would make a
> version break, migrating to using 64bit time_t types and syscalls. Legacy
> applications would still work using the old glibc version, but this would
> provide a stronger line in the sand between 2038 safe and unsafe
> applications and libraries, making it easier to avoid mixing the two.
> NetBSD developers discussed this same approach back in 2008 here:
> https://mail-index.netbsd.org/tech-userlevel/2008/03/22/msg000231.html

Given discussions lately of how it's no longer feasible to change the 
libstdc++ soname for C++11 issues 
<https://gcc.gnu.org/ml/gcc/2014-08/msg00107.html> - libstdc++ needs to 
include both old and new ABI versions of all relevant interfaces - I think 
we can assume the same is true to a much greater extent for the libc 
soname (at least on i386).  Much the same conclusion was also reached 
regarding the libc soname on S/390 in discussions of jmp_buf issues.

Technically of course you can have a port variant which does have a 
different soname - and a different GNU triplet - like the transition from 
arm-*-linux-gnu old-ABI to arm-*-linux-gnueabi EABI.  (And in principle 
distributions can allow in-place upgrades - after all, it was done for the 
move from libc5 to libc6.)  But I don't see any likelihood that's what the 
community of users and distributors on i386 would actually want.

Properly done, moving to _TIME_BITS=64 in a distribution would involve 
changing the sonames of lots of affected other libraries (while keeping 
compatibility versions under the old sonames to support existing binaries 
users may have), and it's an open question whether distributors would wish 
to do that either - or whether you get server / desktop distributions 
phasing out 32-bit support by 2038, while only embedded users, with 
control over everything being built for the device and less likelihood of 
having to deal with old binaries from ISVs, build the whole system with a 
_TIME_BITS=64 default.

> 32bit applications on 64bit kernels. In this case, we wouldn't introduce
> new 64 bit syscalls in the kernel, as the existing interfaces would just be
> typed correctly for our new virtual architecture, but we would have

The installed uapi headers would of course need conditionals in them 
(based on whatever preprocessor macro is defined in userspace for the new 
virtual architecture) to export the right ABI for each case.

-- 
Joseph S. Myers
joseph@codesourcery.com
