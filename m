From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 3/4] arch: Register fchmodat4, usually as syscall 434
Date: Wed, 17 Jul 2019 09:54:02 +0200
Message-ID: <CAK8P3a2SGNJXqbHGFhVoPDZLpPYWGDVJ42D2476DLPU4nvf85g@mail.gmail.com>
References: <20190717012719.5524-1-palmer@sifive.com>
 <20190717012719.5524-4-palmer@sifive.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <20190717012719.5524-4-palmer@sifive.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: Palmer Dabbelt <palmer@sifive.com>
Cc: Rich Felker <dalias@libc.org>, Catalin Marinas <catalin.marinas@arm.com>, Linux-sh list <linux-sh@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Stefan Agner <stefan@agner.ch>, linux-mips@vger.kernel.org, James Bottomley <James.Bottomley@hansenpartnership.com>, Namhyung Kim <namhyung@kernel.org>, kim.phillips@arm.com, Paul Mackerras <paulus@samba.org>, Deepa Dinamani <deepa.kernel@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>, sparclinux <sparclinux@vger.kernel.org>, linux-ia64@vger.kernel.org, Will Deacon <will@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, linux-s390 <linux-s390@vger.kernel.org>, Hannes Reinecke <hare@suse.com>, Yoshinori Sato <ysato@users.sourceforge.jp>, Helge Deller <deller@gmx.de>, the arch/x86 maintainers <x86@kernel.org>, Russell King - ARM Linux <linux@armlinux.org.uk>, Christian
List-Id: linux-api@vger.kernel.org

On Wed, Jul 17, 2019 at 3:29 AM Palmer Dabbelt <palmer@sifive.com> wrote:
>
> This registers the new fchmodat4 syscall in most places as nuber 434,
> with alpha being the exception where it's 544.  I found all these sites
> by grepping for fspick, which I assume has found me everything.

434 is now pidfd_open, the next free one is 436.

>  arch/alpha/kernel/syscalls/syscall.tbl      | 1 +
>  arch/arm/tools/syscall.tbl                  | 1 +
>  arch/arm64/include/asm/unistd32.h           | 2 ++

You missed arch/arm64/include/asm/unistd.h, which
contains __NR_compat_syscalls

      Arnd
