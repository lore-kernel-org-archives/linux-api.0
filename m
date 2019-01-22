From: "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Subject: Re: Can we drop upstream Linux x32 support?
Date: Tue, 22 Jan 2019 14:34:11 +0100
Message-ID: <d6542485-87ba-7d57-29bb-4077bda17809@metux.net>
References: <CALCETrXoRAibsbWa9nfbDrt0iEuebMnCMhSFg-d9W-J2g8mDjw@mail.gmail.com>
 <6577ac4f-524c-37f4-a4d0-6eb94ec7d9a5@schoebel-theuer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6577ac4f-524c-37f4-a4d0-6eb94ec7d9a5@schoebel-theuer.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?Q?Thomas_Sch=c3=b6bel-Theuer?= <thomas@schoebel-theuer.de>, Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>, Florian Weimer <fweimer@redhat.com>, Mike Frysinger <vapier@gentoo.org>, "H. J. Lu" <hjl.tools@gmail.com>, Rich Felker <dalias@libc.org>, x32@buildd.debian.org, Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

On 14.12.18 22:16, Thomas Schöbel-Theuer wrote:

Hi,

> Currently, we have a few thousands of servers relying on 32bit ABIs in> some thousands of VMs and/or containers of various types (LXC,
OpenVZ,> etc).
Similar w/ my clients, but in Industrie/Embedded/i4.0 world. We have
thousands of devices in the field, that need support for at least a
decade.

Right now, I'm working on a new device, that - even having a 64bit cpu -
will still run 32bit userland for various reasons (memory footprint
is one of them).

Even on the data center side, where we have *a lot* of containers
(eg. container-based microservices on minimal distros like alpine
or ptxdist - as well as many different, often highly specialized,
legacy applications), 32bit userland indeed is a major factor.

Dropping it would have huge economic consequences:

* massive costs for re-deployment / migration of thousands of different
  applications
* field roll of thousands of different embedded / industrial devices,
  as a major cpu arch
* huge increase in memory consumption and io load in container-
  based microservice environments
* loosing x86 for a huge portion of the embedded / small devices world

I don't even dare to estimate the economic damage. (not even speaking
about reputation loss of the Linux community)

> Here is my private opinion, not speaking for 1&1: at some point the> future, 32bit userspace support needs to be dropped anyway, somewhen
in> future. This is inevitable in the very long term.

Very, very, long term. Just the devices I'm coping w/ will have
remaining lifetime of at least 10..15 years. That's a really long time
in IT world. Nobody knows whether x86 at all will play a big role then.

> 1) please release / declare a new LTS kernel, with upstream support for
> at least 5 years (as usual). Currently, only 4.4 and 4.9 are marked as
> LTS. Either mark another existing stable kernel as LTS, or a future one.

That might be okay in enterprise world (even though, here I'm regularily
stumbling across much older code in production), but in industrial
world, the product lifetimes are much longer - 20+yrs years
usualstandard.are pretty common.

--mtx

-- 
Enrico Weigelt, metux IT consult
Free software and Linux embedded engineering
info@metux.net -- +49-151-27565287
