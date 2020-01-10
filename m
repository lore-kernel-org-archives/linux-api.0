From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v27 12/12] LRNG - add power-on and runtime self-tests
Date: Thu, 9 Jan 2020 16:22:51 -0800
Message-ID: <2f225250-c1e1-c6e1-026c-9c63853ab7d1@infradead.org>
References: <6157374.ptSnyUpaCn@positron.chronox.de>
 <2722222.P16TYeLAVu@positron.chronox.de>
 <2641155.iNH938UiKq@positron.chronox.de>
 <2355906.JbblJTOqSk@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <2355906.JbblJTOqSk@positron.chronox.de>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
To: =?UTF-8?Q?Stephan_M=c3=bcller?= <smueller@chronox.de>, Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Vito Caputo <vcaputo@pengaru.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>, William Jon McCann <mccann@jhu.edu>, zhangjs <zachary@baishancloud.com>, Andy Lutomirski <luto@kernel.org>, Florian Weimer <fweimer@redhat.com>, Lennart Poettering <mzxreary@0pointer.de>, Nicolai Stange <nstange@suse.de>, "Peter, Matthias" <matth>
List-Id: linux-api@vger.kernel.org

Hi,

On 1/9/20 12:35 AM, Stephan Müller wrote:

> ---
>  drivers/char/lrng/Kconfig         |  25 ++
>  drivers/char/lrng/Makefile        |   1 +
>  drivers/char/lrng/lrng_selftest.c | 418 ++++++++++++++++++++++++++++++
>  3 files changed, 444 insertions(+)
>  create mode 100644 drivers/char/lrng/lrng_selftest.c
> 
> diff --git a/drivers/char/lrng/Kconfig b/drivers/char/lrng/Kconfig
> index 394066aa5a86..e9827e7df715 100644
> --- a/drivers/char/lrng/Kconfig
> +++ b/drivers/char/lrng/Kconfig
> @@ -175,4 +175,29 @@ config LRNG_TESTING
>  
>  	  If unsure, say N.
>  
> +config LRNG_SELFTEST
> +	bool "Enable power-on and on-demand self-tests"
> +	help
> +	  The power-on self tests are executed during boot time

	               self-tests

> +	  covering the ChaCha20 DRNG, the LFSR processing and the
> +	  time stamp management of the LRNG.
> +
> +	  The on-demand self-tests are triggered by writing any
> +	  value into the SysFS file selftest_status. At the same
> +	  time, when reading this file, the test status is
> +	  returned. A zero indicates that all tests were executed
> +	  successfully.
> +
> +	  If unsure, say Y.
> +
> +if LRNG_SELFTEST
> +
> +config LRNG_SELFTEST_PANIC
> +	bool "Panic the kernel upon self-test failure"
> +	help
> +	  If the option is enabled, the kernel is terminated if an
> +	  LRNG power-on self-test failure is detected.
> +
> +endif # LRNG_SELFTEST
> +
>  endif # LRNG


-- 
~Randy
