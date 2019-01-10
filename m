From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 00/15] arch: synchronize syscall tables in preparation for y2038
Date: Thu, 10 Jan 2019 23:42:32 +0100
Message-ID: <CAK8P3a2f4SCJXrm6HWO9UKY-akSW+ONNpOvQOtYbia_fRo9ciQ@mail.gmail.com>
References: <20190110162435.309262-1-arnd@arndb.de> <alpine.DEB.2.21.1901101808220.31458@digraph.polyomino.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1901101808220.31458@digraph.polyomino.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Joseph Myers <joseph@codesourcery.com>
Cc: y2038 Mailman List <y2038@lists.linaro.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Matt Turner <mattst88@gmail.com>, Russell King - ARM Linux <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Michal Simek <monstr@monstr.eu>, Paul Burton <paul.burton@mips.com>, Helge Deller <deller@gmx.de>, Michael Ellerman <mpe@ellerman.id.au>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Rich Felker <dalias@libc.org>, David Miller <davem@davemloft.net>
List-Id: linux-api@vger.kernel.org

On Thu, Jan 10, 2019 at 7:10 PM Joseph Myers <joseph@codesourcery.com> wrote:
>
> On Thu, 10 Jan 2019, Arnd Bergmann wrote:
>
> > - Add system calls that have not yet been integrated into all
> >   architectures but that we definitely want there.
>
> glibc has a note that alpha lacks statfs64, any plans for that?

Good catch, I missed that because all other 64-bit architectures
have a statfs() call with 64-bit fields. I see that it also has an
osf_statfs64 structure and system call with lots of padding and some
oddly sized fields: f_type, f_flags and f_namemax are only 16 bits
wide, the rest is all 64-bit.

Adding the regular statfs64() should be easy enough, we just need to
decide which layout to use:

a) use the currently unused 'struct statfs64' as provided by the
    alpha uapi headers, which has a 32-bit __statfs_word but
    64-bit f_blocks, f_bfree, f_bavail, f_files, and f_ffree.

b) copy asm-generic/statfs.h to the alpha asm/statfs.h and
    change statfs64 to have the regular layout that we use
    on all other 64-bit architectures, using all 64-bit fields.

The other open question for alpha (as mentioned in one of the
patches I sent) would be whether to add get{eg,eu,g,p,pp,u}id()
with the regular calling conventions.

       Arnd
