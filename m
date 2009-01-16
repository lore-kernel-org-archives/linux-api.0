From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v6 0/5] Add preadv & pwritev system calls.
Date: Fri, 16 Jan 2009 18:52:04 +0100
Message-ID: <200901161852.04953.arnd@arndb.de>
References: <1232124344-25892-1-git-send-email-kraxel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1232124344-25892-1-git-send-email-kraxel@redhat.com>
Content-Disposition: inline
Sender: linux-arch-owner@vger.kernel.org
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, aarcange@redhat.com, Ulrich Drepper <drepper@redhat.com>
List-Id: linux-api@vger.kernel.org

On Friday 16 January 2009, Gerd Hoffmann wrote:
> Next round of the preadv & pwritev patch series. =A0Had no review com=
ments
> to fix. =A0That means it is ready to be merged, right?

In general, getting no feedback does not mean something's ready ;-)

Your patches look pretty polished though, and IIRC the only
real objection was to whether or not the syscalls should be
there in the first place. Did you get any feedback from Ulrich
Drepper as to whether he plans to add support to glibc?

> Changes:
> =A0- compat_sys_{read,write}v bugfix patch dropped (merged).
> =A0- rebase to latest git, adapt to CVE-2009-0029 changes.
>=20
> How to proceed now? =A0Is there a syscall maintainer where I could qu=
eue
> up the patches? =A0If not, anyone (akpm?) willng to pick this up? =A0=
Should
> I try to send to Linus directly?
>=20
> What is the usual way to handle the arch-specific syscall windup? =A0=
I'd
> prefer to leave that to the arch maintainers as they know best what
> needs to be done, is that ok? =A0Right now only x86 (/me) and mips (p=
atch
> from Ralf Baechle) is covered ...

I'd say get it into linux-next as a git tree, then let the arch maintai=
ners
send you the missing patches to hook up the syscalls so that it can go
in as one chunk.

Have you done the glibc patch already? You probably also need to provid=
e
an alternative user space implementation based on a pread/pwrite loop f=
or
older kernels.

	Arnd <><
