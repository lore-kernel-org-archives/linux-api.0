From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v9 00/24] ILP32 for ARM64
Date: Thu, 18 Oct 2018 12:14:36 +0100
Message-ID: <20181018111435.GA237391@arrakis.emea.arm.com>
References: <20180516081910.10067-1-ynorov@caviumnetworks.com>
 <CALCETrVuabkb5ZQOSgQQTEq8CrS602NBpAkE2=4n982r1f5reQ@mail.gmail.com>
 <CAK8P3a1Yhhv1TcQTcF0MinicGovgp_0g_sXqADe3fjVTtOK_aw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAK8P3a1Yhhv1TcQTcF0MinicGovgp_0g_sXqADe3fjVTtOK_aw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andy Lutomirski <luto@amacapital.net>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Yury Norov <ynorov@caviumnetworks.com>, Philipp Tomsich <philipp.tomsich@theobroma-systems.com>, Joseph Myers <joseph@codesourcery.com>, linux-arch <linux-arch@vger.kernel.org>, Steve Ellcey <sellcey@caviumnetworks.com>, Prasun Kapoor <Prasun.Kapoor@caviumnetworks.com>, Andreas Schwab <schwab@suse.de>, Alexander Graf <agraf@suse.de>, Geert Uytterhoeven <geert@linux-m68k.org>, Bamvor Zhangjian <bamv2005@gmail.com>, Dave Martin <Dave.Martin@arm.com>, Adam Borowski <kilobyte@angband.pl>, "Manuel A. Fernandez Montecelo" <manuel.montezelo@gmail.com>, James Hogan <james.hogan@imgtec>
List-Id: linux-api@vger.kernel.org

On Sun, Oct 14, 2018 at 09:49:01PM +0200, Arnd Bergmann wrote:
> On Sat, Oct 13, 2018 at 9:36 PM Andy Lutomirski <luto@amacapital.net> wrote:
> >
> > On Wed, May 16, 2018 at 1:19 AM Yury Norov <ynorov@caviumnetworks.com> wrote:
> > >
> > > This series enables AARCH64 with ILP32 mode.
> > >
> > > As supporting work, it introduces ARCH_32BIT_OFF_T configuration
> > > option that is enabled for existing 32-bit architectures but disabled
> > > for new arches (so 64-bit off_t userspace type is used by new userspace).
> > > Also it deprecates getrlimit and setrlimit syscalls prior to prlimit64.
> >
> > Second, ILP32 user code is highly unlikely
> > to end up with the same struct layout as ILP64 code.  The latter seems
> > like it should be solved entirely in userspace by adding a way to
> > annotate a structure as being a kernel ABI structure and getting the
> > toolchain to lay it out as if it were ILP64 even though the target is
> > ILP32.
> 
> The syscall ABI could be almost completely abstracted in glibc, the
> main issue is ioctl and a couple of related interfaces that pass data
> structures (read() on /dev/input/*, mmap on /dev/snd/*
> or raw sockets, fcntl).

There is another case on struct siginfo which has some pointers and it
wouldn't look like an LP64 structure at all (and glibc doesn't normally
intercept the sighandler call to rewrite the structure). We could add
padding around void * members as the kernel zeros them, I don't recall
the kernel reading these pointers from user. Anyway, using something
that resembles compat_siginfo looked the simplest for ILP32.

-- 
Catalin
