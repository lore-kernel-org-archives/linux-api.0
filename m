From: Rich Felker <dalias@libc.org>
Subject: Re: [PATCH v2 2/4] Add fchmodat4(), a new syscall
Date: Tue, 16 Jul 2019 22:40:46 -0400
Message-ID: <20190717024046.GI1506@brightrain.aerifal.cx>
References: <20190717012719.5524-1-palmer@sifive.com>
 <20190717012719.5524-3-palmer@sifive.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190717012719.5524-3-palmer@sifive.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Palmer Dabbelt <palmer@sifive.com>
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, rth@twiddle.net, ink@jurassic.park.msu.ru, mattst88@gmail.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will@kernel.org, tony.luck@intel.com, fenghua.yu@intel.com, geert@linux-m68k.org, monstr@monstr.eu, ralf@linux-mips.org, paul.burton@mips.com, jhogan@kernel.org, James.Bottomley@HansenPartnership.com, deller@gmx.de, benh@kernel.crashing.org, paulus@samba.org, mpe@ellerman.id.au, heiko.carstens@de.ibm.com, gor@linux.ibm.com, borntraeger@de.ibm.com, ysato@users.sourceforge.jp, davem@davemloft.net, luto@kernel.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, x86@kernel.org, peterz@infradead.org, acme@kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Jul 16, 2019 at 06:27:17PM -0700, Palmer Dabbelt wrote:
> man 3p says that fchmodat() takes a flags argument, but the Linux
> syscall does not.  There doesn't appear to be a good userspace
> workaround for this issue but the implementation in the kernel is pretty
> straight-forward.  The specific use case where the missing flags came up
> was WRT a fuse filesystem implemenation, but the functionality is pretty
> generic so I'm assuming there would be other use cases.

Note that we do have a workaround in musl libc with O_PATH and
/proc/self/fd, but a syscall that allows a proper fix with the ugly
workaround only in the fallback path for old kernels will be much
appreciated!

What about also doing a new SYS_faccessat4 with working AT_EACCESS
flag? The workaround we have to do for it is far worse.

Rich
