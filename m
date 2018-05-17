From: Yann Droneaud <ydroneaud@opteya.com>
Subject: Re: [RFC PATCH] UAPI: Document auxvec AT_* namespace policy and
 note reservations
Date: Thu, 17 May 2018 18:00:28 +0200
Message-ID: <a30a44883d7cf06c4bb06feb33784905497b234c.camel@opteya.com>
References: <1526480447-18185-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1526480447-18185-1-git-send-email-Dave.Martin@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org
Cc: x86@kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Richard Henderson <rth@twiddle.net>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Matt Turner <mattst88@gmail.com>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Michal Simek <monstr@monstr.eu>, Ralf Baechle <ralf@linux-mips.org>, James Hogan <jhogan@kernel.org>, Greentime Hu <green.hu@gmail.com>, Vincent Chen <deanbo422@gmail.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Palmer Dabbelt <palmer@sifive.com>, Albert Ou <albert@sifive.com>, Martin
List-Id: linux-api@vger.kernel.org

Hi,

Le mercredi 16 mai 2018 à 15:20 +0100, Dave Martin a écrit :
> There are constraints on defining AT_* auxvec tags that are not
> obvious to the casual maintainer of either the global
> <uapi/linux/auxvec.h> or the arch-specific headers.  This is likely
> to lead to mistakes.  (I certainly fell foul of it...)
> 
> For the benefit of future maintainers, this patch collects the
> relevant information in one place, documenting how the namespace
> needs to be managed, and noting all the values currently in use.
> 
> Maintaining a global list may result in some merge conflicts, but
> AT_* values are not added frequently.  I'm open to suggestions on
> the best approach.
> 
> I also assume that values 38 and 39 may have been used for
> historical purposes, such as an architecture that is no longer
> supported.  If they have definitely never been used for anything,
> they could be removed from the "reserved" list.
> 

Some of those AT_* values are described in getauxval(3) man-page:

http://man7.org/linux/man-pages/man3/getauxval.3.html

https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git/tree/man3/g
etauxval.3?id=4eae8eb731386d81797d5c30365426722410874e

And glibc provides <elf.h> with definitions for almost all AT_*,
regardless of the current target architecture:

https://sourceware.org/git/?p=glibc.git;a=blob;f=elf/elf.h;h=954f3266f7
11ab83996670ea504a17dcf668e061;hb=23158b08a0908f381459f273a984c6fd32836
3cb#l1135

Also, despite not being listed as a reserved namespace by POSIX, one
should try to avoid name collision with other AT_ constants,
those used with *at() functions (openat(), etc.):

- AT_EACCESS 
- AT_EMPTY_PATH
- AT_FDCWD
- AT_NO_AUTOMOUNT
- AT_REMOVEDIR
- AT_STATX_DONT_SYNC
- AT_STATX_FORCE_SYNC
- AT_STATX_SYNC_AS_STAT
- AT_SYMLINK_FOLLOW
- AT_SYMLINK_NOFOLLOW

http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/fcntl.h.html

http://pubs.opengroup.org/onlinepubs/9699919799/functions/V2_chap02.htm
l#tag_15_02_02

https://sourceware.org/git/?p=glibc.git;a=blob;f=io/fcntl.h;h=3d239e8f0
9f7ce0a3106621be327e1ea4cd1a3e7;hb=23158b08a0908f381459f273a984c6fd3283
63cb#l142

And there's also AT_ANYNET and AT_ANYNODE from ddp (aka. AppleTalk)

http://man7.org/linux/man-pages/man7/ddp.7.html

Regards.

-- 
Yann Droneaud
OPTEYA
