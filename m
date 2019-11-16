From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v25 01/12] Linux Random Number Generator
Date: Sat, 16 Nov 2019 12:25:21 +0100 (CET)
Message-ID: <alpine.DEB.2.21.1911161216540.14348@nanos.tec.linutronix.de>
References: <6157374.ptSnyUpaCn@positron.chronox.de> <2787174.DQlWHN5GGo@positron.chronox.de> <2645285.kI0haNqfm4@positron.chronox.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-279224958-1573903523=:14348"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2645285.kI0haNqfm4@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Vito Caputo <vcaputo@pengaru.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>, William Jon McCann <mccann@jhu.edu>, zhangjs <zachary@baishancloud.com>, Andy Lutomirski <luto@kernel.org>, Florian Weimer <fweimer@redhat.com>, Lennart Poettering <mzxreary@0pointer.de>, Nicolai Stange <nstange@sus>
List-Id: linux-api@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-279224958-1573903523=:14348
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Sat, 16 Nov 2019, Stephan Müller wrote:
> +/**
> + * Hot code path - Callback for interrupt handler
> + */
> +void add_interrupt_randomness(int irq, int irq_flags)
> +{
> +	lrng_time_process();
> +
> +	if (!lrng_pool_highres_timer()) {
> +		struct pt_regs *regs = get_irq_regs();
> +		static atomic_t reg_idx = ATOMIC_INIT(0);
> +		u64 ip;
> +
> +		lrng_pool_lfsr_u32(jiffies);
> +		lrng_pool_lfsr_u32(irq);
> +		lrng_pool_lfsr_u32(irq_flags);
> +
> +		if (regs) {
> +			u32 *ptr = (u32 *)regs;
> +			int reg_ptr = atomic_add_return_relaxed(1, &reg_idx);
> +			size_t n = (sizeof(struct pt_regs) / sizeof(u32));
> +
> +			ip = instruction_pointer(regs);
> +			lrng_pool_lfsr_u32(*(ptr + (reg_ptr % n)));
> +		} else
> +			ip = _RET_IP_;
> +
> +		lrng_pool_lfsr_u32(ip >> 32);
> +		lrng_pool_lfsr_u32(ip);
> +	}

Is there a way to avoid all that processing right in the interrupt hot
path and just store the raw data for later processing?

Thanks,

	tglx

     
--8323329-279224958-1573903523=:14348--
