From: Zach Brown <zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org>
Subject: Re: [PATCH, RFC -v2] random: introduce getrandom(2) system call
Date: Thu, 17 Jul 2014 14:57:14 -0700
Message-ID: <20140717215714.GF24196@lenny.home.zabbo.net>
References: <1405633100-4889-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1405633100-4889-1-git-send-email-tytso-3s7WtUTddSA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Cc: Linux Kernel Developers List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, beck-7YlrpqBBQ3VAfugRpC6u6w@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Jul 17, 2014 at 05:38:20PM -0400, Theodore Ts'o wrote:
> The getrandom(2) system call was requested by the LibreSSL Portable
> developers.  It is analoguous to the getentropy(2) system call in
> OpenBSD.

> +SYSCALL_DEFINE3(getrandom, char __user *, buf, size_t, count,
> +		unsigned int, flags)
> +{
> +	int r;
> +
> +	if (flags & ~(GRND_NONBLOCK|GRND_RANDOM))
> +		return -EINVAL;
> +
> +	if (count > INT_MAX)
> +		count = INT_MAX;
> +
> +	if (flags & GRND_RANDOM)
> +		return _random_read(flags & GRND_NONBLOCK, buf, count);
> +	if (flags & GRND_NONBLOCK) {
> +		if (!completion_done(&urandom_initialized))
> +			return -EAGAIN;
> +	} else {
> +		r = wait_for_completion_interruptible(&urandom_initialized);
> +		if (r)
> +			return r;
> +	}
> +	return urandom_read(NULL, buf, count, NULL);
> +}

I like how tiny this ends up being.  Feel free to add my rb:.

Reviewed-by: Zach Brown <zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org>

- z
