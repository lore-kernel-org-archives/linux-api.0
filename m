From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v24 01/12] Linux Random Number Generator
Date: Wed, 13 Nov 2019 00:15:18 +0100
Message-ID: <2207651.LDDDoSycXZ@positron.chronox.de>
References: <2369119.jSEA3qhmGI@positron.chronox.de> <201911130648.YIqEERFA%lkp@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201911130648.YIqEERFA%lkp@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@lists.01.org, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Vito Caputo <vcaputo@pengaru.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>, William Jon McCann <mccann@jhu.edu>, zhangjs <zachary@baishancloud.com>, Andy Lutomirski <luto@kernel.org>, Florian Weimer <fweimer@redhat.com>, Lennart Poettering <mzxreary@0pointer.de>, Ni
List-Id: linux-api@vger.kernel.org

Am Dienstag, 12. November 2019, 23:30:29 CET schrieb kbuild test robot:

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
> 01b59c763fe2de845b65900485b141fdd7bbf93e config:
> i386-randconfig-f003-201945 (attached as .config)
> compiler: gcc-7 (Debian 7.4.0-14) 7.4.0
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=i386
> 
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>    In file included from <command-line>:0:0:
> 
>    include/linux/lrng.h: In function 'lrng_set_drng_cb':
> >> include/linux/lrng.h:80:61: error: 'EOPNOTSUPP' undeclared (first use in
> >> this function)

I need to include errno.h in lrng.h.

Thank you, it will be fixed in the next installment.

>     lrng_set_drng_cb(const struct lrng_crypto_cb *cb) { return -EOPNOTSUPP;
> } ^~~~~~~~~~ include/linux/lrng.h:80:61: note: each undeclared identifier
> is reported only once for each function it appears in
> 
> vim +/EOPNOTSUPP +80 include/linux/lrng.h
> 
>     74
>     75	/* Register cryptographic backend */
>     76	#ifdef CONFIG_LRNG_DRNG_SWITCH
>     77	int lrng_set_drng_cb(const struct lrng_crypto_cb *cb);
>     78	#else	/* CONFIG_LRNG_DRNG_SWITCH */
>     79	static inline int
> 
>   > 80	lrng_set_drng_cb(const struct lrng_crypto_cb *cb) { return
>   > -EOPNOTSUPP; }
>     81	#endif	/* CONFIG_LRNG_DRNG_SWITCH */
>     82
> 
> ---
> 0-DAY kernel test infrastructure                 Open Source Technology
> Center https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel
> Corporation


Ciao
Stephan
