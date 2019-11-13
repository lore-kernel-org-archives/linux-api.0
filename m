From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v24 01/12] Linux Random Number Generator
Date: Wed, 13 Nov 2019 01:25:58 +0100
Message-ID: <2264655.zbyk6f8WaQ@positron.chronox.de>
References: <2369119.jSEA3qhmGI@positron.chronox.de> <201911130807.RnsJ5SVf%lkp@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201911130807.RnsJ5SVf%lkp@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@lists.01.org, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Vito Caputo <vcaputo@pengaru.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>, William Jon McCann <mccann@jhu.edu>, zhangjs <zachary@baishancloud.com>, Andy Lutomirski <luto@kernel.org>, Florian Weimer <fweimer@redhat.com>, Lennart Poettering <mzxreary@0pointer.de>, Ni
List-Id: linux-api@vger.kernel.org

Am Mittwoch, 13. November 2019, 01:14:05 CET schrieb kbuild test robot:

Hi kbuild,

> Hi "Stephan,
> 
> Thank you for the patch! Yet something to improve:
> 
> [auto build test ERROR on char-misc/char-misc-testing]
> [also build test ERROR on v5.4-rc7 next-20191112]
> [if your patch is applied to the wrong git tree, please drop us a note to
> help improve the system. BTW, we also suggest to use '--base' option to
> specify the base tree in git format-patch, please see
> https://stackoverflow.com/a/37406982]
> 
> url:   
> https://github.com/0day-ci/linux/commits/Stephan-M-ller/dev-random-a-new-ap
> proach-with-full-SP800-90B-compliance/20191113-040847 base:  
> https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
> 01b59c763fe2de845b65900485b141fdd7bbf93e config: mips-allmodconfig
> (attached as .config)
> compiler: mips-linux-gcc (GCC) 7.4.0
> reproduce:
>         wget
> https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O
> ~/bin/make.cross chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         GCC_VERSION=7.4.0 make.cross ARCH=mips
> 
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>    drivers/char/lrng/lrng_sw_noise.c: In function 
'add_interrupt_randomness':
> >> drivers/char/lrng/lrng_sw_noise.c:145:23: error: invalid application of
> >> 'sizeof' to incomplete type 'struct pt_regs'
>        size_t n = (sizeof(struct pt_regs) / sizeof(u32));
>                           ^~~~~~
> 
> >> drivers/char/lrng/lrng_sw_noise.c:147:9: error: implicit declaration of
> >> function 'instruction_pointer'; did you mean 'instruction_hazard'?
> >> [-Werror=implicit-function-declaration]
>        ip = instruction_pointer(regs);
>             ^~~~~~~~~~~~~~~~~~~
>             instruction_hazard
>    cc1: some warnings being treated as errors
> 
> vim +145 drivers/char/lrng/lrng_sw_noise.c

Thank you for the report.

Both issues are fixed by including <asm/ptrace.h>.

This will be fixed with the next installment of the patch.
> 
>    125
>    126	/**
>    127	 * Hot code path - Callback for interrupt handler
>    128	 */
>    129	void add_interrupt_randomness(int irq, int irq_flags)
>    130	{
>    131		lrng_time_process();
>    132
>    133		if (!lrng_pool_highres_timer()) {
>    134			struct pt_regs *regs = get_irq_regs();
>    135			static atomic_t reg_idx = ATOMIC_INIT(0);
>    136			u64 ip;
>    137
>    138			lrng_pool_lfsr_u32(jiffies);
>    139			lrng_pool_lfsr_u32(irq);
>    140			lrng_pool_lfsr_u32(irq_flags);
>    141
>    142			if (regs) {
>    143				u32 *ptr = (u32 *)regs;
>    144				int reg_ptr = atomic_add_return_relaxed(1, 
&reg_idx);
> 
>  > 145				size_t n = (sizeof(struct pt_regs) / 
sizeof(u32));
> 
>    146
> 
>  > 147				ip = instruction_pointer(regs);
> 
> ---
> 0-DAY kernel test infrastructure                 Open Source Technology
> Center https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel
> Corporation


Ciao
Stephan
