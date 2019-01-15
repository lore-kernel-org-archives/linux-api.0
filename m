From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 15/15] arch: add pkey and rseq syscall numbers everywhere
Date: Tue, 15 Jan 2019 15:47:14 +0100
Message-ID: <CAK8P3a1Xb4z-mbhBTPZ0Cpy0Hy_s2wwT-8UG9yO6AGbUTjdkyw@mail.gmail.com>
References: <20190110162435.309262-1-arnd@arndb.de>
 <20190110162435.309262-16-arnd@arndb.de>
 <20190115115229.mcrmmpwdmjxf2cra@e5254000004ec.dyn.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20190115115229.mcrmmpwdmjxf2cra@e5254000004ec.dyn.armlinux.org.uk>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc: Rich Felker <dalias@libc.org>, linux-ia64@vger.kernel.org, Linux-sh list <linux-sh@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Dominik Brodowski <linux@dominikbrodowski.net>, linux-mips@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>, Deepa Dinamani <deepa.kernel@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>, sparclinux <sparclinux@vger.kernel.org>, linux-s390 <linux-s390@vger.kernel.org>, Davidlohr Bueso <dave@stgolabs.net>, y2038 Mailman List <y2038@lists.linaro.org>, Michael Ellerman <mpe@ellerman.id.au>, Helge Deller <deller@gmx.de>, the arch/x86 maintainers <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Firoz Khan <firoz.khan@linaro.org>, Matt Turner <mattst88@gmail.com>, Fenghua Yu <fenghua.yu@intel.com>, Will Deacon <will.deacon@arm.com>linux-m68k <linux>
List-Id: linux-api@vger.kernel.org

On Tue, Jan 15, 2019 at 12:52 PM Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Thu, Jan 10, 2019 at 05:24:35PM +0100, Arnd Bergmann wrote:
> > Most architectures define system call numbers for the rseq and pkey system
> > calls, even when they don't support the features, and perhaps never will.
> >
> > Only a few architectures are missing these, so just define them anyway
> > for consistency. If we decide to add them later to one of these, the
> > system call numbers won't get out of sync then.
>
> I was lambasted for adding the pkey syscalls for 32-bit ARM in 2016,
> which will probably never support it.  Why has the attitude towards
> this kind of thing now apparently become acceptable?

I was (and still am) a bit unsure about this one. A number of architectures
added the numbers that won't ever support them, but I wasn't sure if
any of those that didn't add them might need it later.

I tried to just go by the rule that anything that we list in
asm-generic/unistd.h
is probably important enough that we want to list it everywhere, even if
that includes a couple that we end up being rather architecture specific.

I'm happy to drop this patch if you or others feel that we're better off
without it though.

      Arnd
