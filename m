From: Andy Lutomirski <luto@kernel.org>
Subject: Re: Can we drop upstream Linux x32 support?
Date: Fri, 14 Dec 2018 13:24:28 -0800
Message-ID: <CALCETrV0fVLZKG6JrOvzvOzP06UxhZW=LbHpPXbonoeFdPJB1A@mail.gmail.com>
References: <CALCETrXoRAibsbWa9nfbDrt0iEuebMnCMhSFg-d9W-J2g8mDjw@mail.gmail.com>
 <6577ac4f-524c-37f4-a4d0-6eb94ec7d9a5@schoebel-theuer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6577ac4f-524c-37f4-a4d0-6eb94ec7d9a5@schoebel-theuer.de>
Sender: linux-kernel-owner@vger.kernel.org
To: thomas@schoebel-theuer.de
Cc: Andrew Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>, Florian Weimer <fweimer@redhat.com>, Mike Frysinger <vapier@gentoo.org>, "H. J. Lu" <hjl.tools@gmail.com>, Rich Felker <dalias@libc.org>, x32@buildd.debian.org, Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

On Fri, Dec 14, 2018 at 1:22 PM Thomas Sch=C3=B6bel-Theuer
<thomas@schoebel-theuer.de> wrote:
>
> On 12/11/18 02:23, Andy Lutomirski wrote:
> > I'm seriously considering sending a patch to remove x32 support from
> > upstream Linux.
>
> I am downstream maintainer of several self-patched kernels at 1&1 Ionos.
> The kernels are rolled out to several tenthousands of production servers
> running in several datacenters and in multiple continents.
>
> Currently, we have a few thousands of servers relying on 32bit ABIs in
> some thousands of VMs and/or containers of various types (LXC, OpenVZ, et=
c).

I should clarify again: I am not suggesting that we drop 32-bit
support in the forseeable future.  (Well, I might eventually suggest
that we drop support for 32-bit *hardware* at some point, but not for
32-bit compat software.)  Linux's compat code is quite robust and is
even fairly maintainable.

I'm talking about x32, which is a different beast.
