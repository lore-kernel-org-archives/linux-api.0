From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v28 07/12] LRNG - add kernel crypto API PRNG extension
Date: Wed, 15 Jan 2020 16:15:46 -0800
Message-ID: <d98e7a45-3d1b-8119-1ed0-87aea0f3c6f3@infradead.org>
References: <6157374.ptSnyUpaCn@positron.chronox.de>
 <2641155.iNH938UiKq@positron.chronox.de>
 <5951792.lmNsirYsPE@positron.chronox.de>
 <526421170.FD02tCEzJt@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <526421170.FD02tCEzJt@positron.chronox.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?Q?Stephan_M=c3=bcller?= <smueller@chronox.de>, Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Vito Caputo <vcaputo@pengaru.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>, William Jon McCann <mccann@jhu.edu>, zhangjs <zachary@baishancloud.com>, Andy Lutomirski <luto@kernel.org>, Florian Weimer <fweimer@redhat.com>, Lennart Poettering <mzxreary@0pointer.de>, Nicolai Stange <nstange@suse.de>, "Peter, Matthias" <matth>
List-Id: linux-api@vger.kernel.org

On 1/15/20 2:34 AM, Stephan Müller wrote:
> 
> CC: "Eric W. Biederman" <ebiederm@xmission.com>
> CC: "Alexander E. Patrakov" <patrakov@gmail.com>
> CC: "Ahmed S. Darwish" <darwish.07@gmail.com>
> CC: "Theodore Y. Ts'o" <tytso@mit.edu>
> CC: Willy Tarreau <w@1wt.eu>
> CC: Matthew Garrett <mjg59@srcf.ucam.org>
> CC: Vito Caputo <vcaputo@pengaru.com>
> CC: Andreas Dilger <adilger.kernel@dilger.ca>
> CC: Jan Kara <jack@suse.cz>
> CC: Ray Strode <rstrode@redhat.com>
> CC: William Jon McCann <mccann@jhu.edu>
> CC: zhangjs <zachary@baishancloud.com>
> CC: Andy Lutomirski <luto@kernel.org>
> CC: Florian Weimer <fweimer@redhat.com>
> CC: Lennart Poettering <mzxreary@0pointer.de>
> CC: Nicolai Stange <nstange@suse.de>
> Reviewed-by: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
> Reviewed-by: Roman Drahtmueller <draht@schaltsekun.de>
> Tested-by: Roman Drahtmüller <draht@schaltsekun.de>
> Tested-by: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
> Tested-by: Neil Horman <nhorman@redhat.com>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> ---
>  drivers/char/lrng/Kconfig      |  10 +
>  drivers/char/lrng/Makefile     |   1 +
>  drivers/char/lrng/lrng_kcapi.c | 327 +++++++++++++++++++++++++++++++++
>  3 files changed, 338 insertions(+)
>  create mode 100644 drivers/char/lrng/lrng_kcapi.c
> 
> diff --git a/drivers/char/lrng/Kconfig b/drivers/char/lrng/Kconfig
> index 15fb623d9d1f..0d070a3897dd 100644
> --- a/drivers/char/lrng/Kconfig
> +++ b/drivers/char/lrng/Kconfig
> @@ -80,6 +80,16 @@ config LRNG_DRBG
>  	  Enable the SP800-90A DRBG support for the LRNG. Once the
>  	  module is loaded, output from /dev/random, /dev/urandom,
>  	  getrandom(2), or get_random_bytes is provided by a DRBG.
> +
> +config LRNG_KCAPI
> +	tristate "Kernel Crypto API support for the LRNG"
> +	select CRYPTO_RNG

Don't select CRYPTO_RNG unless you know that CRYPTO is set/enabled.

> +	help
> +	  Enable the support for generic pseudo-random number
> +	  generators offered by the kernel crypto API with the
> +	  LRNG. Once the module is loaded, output from /dev/random,
> +	  /dev/urandom, getrandom(2), or get_random_bytes is
> +	  provided by the selected kernel crypto API RNG.
>  endif # LRNG_DRNG_SWITCH
>  
>  endif # LRNG


-- 
~Randy
Reported-by: Randy Dunlap <rdunlap@infradead.org>
