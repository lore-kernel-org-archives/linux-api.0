From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v28 01/12] Linux Random Number Generator
Date: Wed, 15 Jan 2020 16:11:40 -0800
Message-ID: <3a8d5d2d-d54f-cf18-0c93-dbe8cd91ed12@infradead.org>
References: <6157374.ptSnyUpaCn@positron.chronox.de>
 <2641155.iNH938UiKq@positron.chronox.de>
 <5951792.lmNsirYsPE@positron.chronox.de>
 <2211028.KG5F5qfgHC@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2211028.KG5F5qfgHC@positron.chronox.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?Q?Stephan_M=c3=bcller?= <smueller@chronox.de>, Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Vito Caputo <vcaputo@pengaru.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>, William Jon McCann <mccann@jhu.edu>, zhangjs <zachary@baishancloud.com>, Andy Lutomirski <luto@kernel.org>, Florian Weimer <fweimer@redhat.com>, Lennart Poettering <mzxreary@0pointer.de>, Nicolai Stange <nstange@suse.de>, "Peter, Matthias" <matth>
List-Id: linux-api@vger.kernel.org

Hi,

On 1/15/20 2:31 AM, Stephan Müller wrote:

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
> Mathematical aspects Reviewed-by: "Peter, Matthias" <matthias.peter@bsi.bund.de>
> Reviewed-by: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
> Reviewed-by: Roman Drahtmueller <draht@schaltsekun.de>
> Tested-by: Roman Drahtmüller <draht@schaltsekun.de>
> Tested-by: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
> Tested-by: Neil Horman <nhorman@redhat.com>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> ---
>  MAINTAINERS                         |   7 +
>  drivers/char/Kconfig                |   2 +
>  drivers/char/Makefile               |   9 +-
>  drivers/char/lrng/Kconfig           |  67 +++
>  drivers/char/lrng/Makefile          |   9 +
>  drivers/char/lrng/lrng_archrandom.c |  94 ++++
>  drivers/char/lrng/lrng_aux.c        | 148 +++++++
>  drivers/char/lrng/lrng_chacha20.c   | 265 ++++++++++++
>  drivers/char/lrng/lrng_chacha20.h   |  25 ++
>  drivers/char/lrng/lrng_drng.c       | 400 +++++++++++++++++
>  drivers/char/lrng/lrng_interfaces.c | 638 ++++++++++++++++++++++++++++
>  drivers/char/lrng/lrng_internal.h   | 296 +++++++++++++
>  drivers/char/lrng/lrng_lfsr.h       | 152 +++++++
>  drivers/char/lrng/lrng_pool.c       | 588 +++++++++++++++++++++++++
>  drivers/char/lrng/lrng_sw_noise.c   | 102 +++++
>  drivers/char/lrng/lrng_sw_noise.h   |  57 +++
>  include/linux/lrng.h                |  63 +++
>  17 files changed, 2921 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/char/lrng/Kconfig
>  create mode 100644 drivers/char/lrng/Makefile
>  create mode 100644 drivers/char/lrng/lrng_archrandom.c
>  create mode 100644 drivers/char/lrng/lrng_aux.c
>  create mode 100644 drivers/char/lrng/lrng_chacha20.c
>  create mode 100644 drivers/char/lrng/lrng_chacha20.h
>  create mode 100644 drivers/char/lrng/lrng_drng.c
>  create mode 100644 drivers/char/lrng/lrng_interfaces.c
>  create mode 100644 drivers/char/lrng/lrng_internal.h
>  create mode 100644 drivers/char/lrng/lrng_lfsr.h
>  create mode 100644 drivers/char/lrng/lrng_pool.c
>  create mode 100644 drivers/char/lrng/lrng_sw_noise.c
>  create mode 100644 drivers/char/lrng/lrng_sw_noise.h
>  create mode 100644 include/linux/lrng.h
> 

> diff --git a/drivers/char/lrng/Kconfig b/drivers/char/lrng/Kconfig
> new file mode 100644
> index 000000000000..56f13efd3592
> --- /dev/null
> +++ b/drivers/char/lrng/Kconfig
> @@ -0,0 +1,67 @@
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# Linux Random Number Generator configuration
> +#
> +
> +menuconfig LRNG
> +	bool "Linux Random Number Generator"

This should probably depend on CRYPTO and/or some other CRYPTO_xxx symbols.
Or (worst case) select them.  :(

This message (when CONFIG_CRYPTO is disabled and no crypto facilities are enabled)
should be avoidable when the correct Kconfig entries are used:

../drivers/char/lrng/lrng_drbg.c:38:2: error: #error "Unknown DRBG in use"
 #error "Unknown DRBG in use"


> +	help
> +	  The Linux Random Number Generator (LRNG) is the replacement
> +	  of the existing /dev/random provided with drivers/char/random.c.
> +	  It generates entropy from different noise sources and
> +	  delivers significant entropy during boot.
> +
> +if LRNG
> +
> +choice
> +	prompt "LRNG Entropy Pool Size"
> +	default LRNG_POOL_SIZE_4096
> +	help
> +	  Select the size of the LRNG entropy pool. The size of the
> +	  entropy pool is relevant for the amount of entropy that
> +	  the LRNG can maintain as a maximum. The larger the size
> +	  of the entropy pool is the more entropy can be maintained
> +	  but the less often older entropic values are overwritten
> +	  with new entropy.
> +
> +	config LRNG_POOL_SIZE_512
> +		bool "512 bits"
> +
> +	config LRNG_POOL_SIZE_1024
> +		bool "1024 bits"
> +
> +	config LRNG_POOL_SIZE_2048
> +		bool "2048 bits"
> +
> +	config LRNG_POOL_SIZE_4096
> +		bool "4096 bits (default)"
> +
> +	config LRNG_POOL_SIZE_8192
> +		bool "8192 bits"
> +
> +	config LRNG_POOL_SIZE_16384
> +		bool "16384 bits"
> +
> +	config LRNG_POOL_SIZE_32768
> +		bool "32768 bits"
> +
> +	config LRNG_POOL_SIZE_65536
> +		bool "65536 bits"
> +
> +	config LRNG_POOL_SIZE_131072
> +		bool "131072 bits"
> +endchoice
> +
> +config LRNG_POOL_SIZE
> +	int
> +	default 0 if LRNG_POOL_SIZE_512
> +	default 1 if LRNG_POOL_SIZE_1024
> +	default 2 if LRNG_POOL_SIZE_2048
> +	default 3 if LRNG_POOL_SIZE_4096
> +	default 4 if LRNG_POOL_SIZE_8192
> +	default 5 if LRNG_POOL_SIZE_16384
> +	default 6 if LRNG_POOL_SIZE_32768
> +	default 7 if LRNG_POOL_SIZE_65536
> +	default 8 if LRNG_POOL_SIZE_131072
> +
> +endif # LRNG

> diff --git a/drivers/char/lrng/lrng_archrandom.c b/drivers/char/lrng/lrng_archrandom.c
> new file mode 100644
> index 000000000000..eeba708d025f
> --- /dev/null
> +++ b/drivers/char/lrng/lrng_archrandom.c
> @@ -0,0 +1,94 @@
> +// SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
> +/*
> + * LRNG Fast Noise Source: CPU-based noise source
> + *
> + * Copyright (C) 2016 - 2020, Stephan Mueller <smueller@chronox.de>
> + */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include <linux/random.h>
> +
> +#include "lrng_internal.h"
> +
> +/*
> + * Estimated entropy of data is a 32th of LRNG_DRNG_SECURITY_STRENGTH_BITS.
> + * As we have no ability to review the implementation of those noise sources,
> + * it is prudent to have a conservative estimate here.
> + */
> +#define LRNG_ARCHRANDOM_DEFAULT_STRENGTH (LRNG_DRNG_SECURITY_STRENGTH_BITS>>5)
> +#define LRNG_ARCHRANDOM_TRUST_CPU_STRENGTH LRNG_DRNG_SECURITY_STRENGTH_BITS
> +#ifdef CONFIG_RANDOM_TRUST_CPU
> +static u32 archrandom = LRNG_ARCHRANDOM_TRUST_CPU_STRENGTH;
> +#else
> +static u32 archrandom = LRNG_ARCHRANDOM_DEFAULT_STRENGTH;
> +#endif
> +module_param(archrandom, uint, 0644);
> +MODULE_PARM_DESC(archrandom, "Entropy in bits of 256 data bits from CPU noise "
> +			     "source (e.g. RDRAND)");

Please put the string on one line like several other MODULE_PARM_DESC() are done:

+MODULE_PARM_DESC(archrandom,
+		"Entropy in bits of 256 data bits from CPU noise source (e.g. RDRAND)");


With CONFIG_CRYPTO disabled, these warnings happen:

WARNING: unmet direct dependencies detected for CRYPTO_DRBG_MENU
  Depends on [n]: CRYPTO [=n]
  Selected by [m]:
  - LRNG_DRBG [=m] && LRNG [=y] && LRNG_DRNG_SWITCH [=y]

WARNING: unmet direct dependencies detected for CRYPTO_RNG
  Depends on [n]: CRYPTO [=n]
  Selected by [m]:
  - LRNG_KCAPI [=m] && LRNG [=y] && LRNG_DRNG_SWITCH [=y]

../drivers/char/lrng/lrng_drbg.c: In function ‘lrng_hash_name’:
../drivers/char/lrng/lrng_drbg.c:225:1: warning: control reaches end of non-void function [-Wreturn-type]
 }
 ^
../drivers/char/lrng/lrng_drbg.c: In function ‘lrng_drbg_name’:
../drivers/char/lrng/lrng_drbg.c:220:1: warning: control reaches end of non-void function [-Wreturn-type]
 }
 ^

and build errors happen also, which can be prevented with Kconfig fixes.

-- 
~Randy
Reported-by: Randy Dunlap <rdunlap@infradead.org>
