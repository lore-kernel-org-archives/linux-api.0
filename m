From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Subject: Re: [PATCH v2 07/29] ARM: add kexec_file_load system call number
Date: Fri, 25 Jan 2019 16:21:06 +0000
Message-ID: <20190125162106.axfhoxxdutkmaeh3@e5254000004ec.dyn.armlinux.org.uk>
References: <20190118161835.2259170-1-arnd@arndb.de>
 <20190118161835.2259170-8-arnd@arndb.de>
 <20190125154359.GG25901@arrakis.emea.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190125154359.GG25901@arrakis.emea.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, y2038@lists.linaro.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, mattst88@gmail.com, will.deacon@arm.com, tony.luck@intel.com, fenghua.yu@intel.com, geert@linux-m68k.org, monstr@monstr.eu, paul.burton@mips.com, deller@gmx.de, benh@kernel.crashing.org, mpe@ellerman.id.au, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, dalias@libc.org, davem@davemloft.net, luto@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org, jcmvbkbc@gmail.com, akpm@linux-foundation.org, deepa.kernel@gmail.com, ebiederm@xmission.com, firoz.khan@linaro.org, linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.or
List-Id: linux-api@vger.kernel.org

On Fri, Jan 25, 2019 at 03:43:59PM +0000, Catalin Marinas wrote:
> On Fri, Jan 18, 2019 at 05:18:13PM +0100, Arnd Bergmann wrote:
> > diff --git a/arch/arm/tools/syscall.tbl b/arch/arm/tools/syscall.tbl
> > index 86de9eb34296..20ed7e026723 100644
> > --- a/arch/arm/tools/syscall.tbl
> > +++ b/arch/arm/tools/syscall.tbl
> > @@ -415,3 +415,4 @@
> >  398	common	rseq			sys_rseq
> >  399	common	io_pgetevents		sys_io_pgetevents
> >  400	common	migrate_pages		sys_migrate_pages
> > +401	common	kexec_file_load		sys_kexec_file_load
> 
> I presume on arm32 this would still return -ENOSYS.

Yes, I already checked.  If CONFIG_KEXEC_FILE is not set, then
kernel/kexec_file.c is not built, and we fall back to the stub
in kernel/sys_ni.c.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
