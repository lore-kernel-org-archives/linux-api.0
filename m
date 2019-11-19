From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v25 12/12] LRNG - add interface for gathering of raw
 entropy
Date: Tue, 19 Nov 2019 09:17:55 -0800
Message-ID: <ea5e2cf5-d622-03c1-eb96-7f7e4893ae04@infradead.org>
References: <6157374.ptSnyUpaCn@positron.chronox.de>
 <2787174.DQlWHN5GGo@positron.chronox.de>
 <3610406.x8mDjznOIz@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3610406.x8mDjznOIz@positron.chronox.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?Q?Stephan_M=c3=bcller?= <smueller@chronox.de>, Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Vito Caputo <vcaputo@pengaru.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>, William Jon McCann <mccann@jhu.edu>, zhangjs <zachary@baishancloud.com>, Andy Lutomirski <luto@kernel.org>, Florian Weimer <fweimer@redhat.com>, Lennart Poettering <mzxreary@0pointer.de>, Nicolai Stange <nstange@suse.de>, "Peter, Matthias" <matth>
List-Id: linux-api@vger.kernel.org

Hi,

On 11/16/19 1:38 AM, Stephan Müller wrote:
> diff --git a/drivers/char/lrng/Kconfig b/drivers/char/lrng/Kconfig
> index e6ca3acc1e48..4ccc710832ef 100644
> --- a/drivers/char/lrng/Kconfig
> +++ b/drivers/char/lrng/Kconfig
> @@ -169,4 +169,20 @@ config LRNG_APT_CUTOFF
>  	default 325 if !LRNG_APT_BROKEN
>  	default 32 if LRNG_APT_BROKEN
>  
> +config LRNG_TESTING
> +	bool "Enable entropy test interface to LRNG noise source"
> +	select CONFIG_DEBUG_FS

	That should be spelled as DEBUG_FS and preferably would be "depends on"
	instead of 'select'.


> +	help
> +	  The test interface allows a privileged process to capture
> +	  the raw unconditioned noise that is collected by the LRNG
> +	  for statistical analysis. Extracted noise data is not used
> +	  to seed the LRNG.
> +
> +	  The raw noise data can be obtained using the lrng_raw
> +	  debugfs file. Using the option lrng_testing.boot_test=1
> +	  the raw noise of the first 1000 entropy events since boot
> +	  can be sampled.
> +
> +	  If unsure, say N.
> +
>  endif # LRNG

thanks.
-- 
~Randy
