From: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
Subject: Re: [PATCH 5/8] x86, pkeys: allocation/free syscalls
Date: Wed, 1 Jun 2016 12:37:05 -0600
Message-ID: <20160601123705.72a606e7@lwn.net>
References: <20160531152814.36E0B9EE@viggo.jf.intel.com>
	<20160531152822.FE8D405E@viggo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160531152822.FE8D405E-LXbPSdftPKxrdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Sorry, I have one more obnoxious question...

> +static inline
> +int mm_pkey_free(struct mm_struct *mm, int pkey)
> +{
> +	/*
> +	 * pkey 0 is special, always allocated and can never
> +	 * be freed.
> +	 */
> +	if (!pkey || !validate_pkey(pkey))
> +		return -EINVAL;
> +	if (!mm_pkey_is_allocated(mm, pkey))
> +		return -EINVAL;
> +
> +	mm_set_pkey_free(mm, pkey);
> +
> +	return 0;
> +}

If I read this right, it doesn't actually remove any pkey restrictions
that may have been applied while the key was allocated.  So there could be
pages with that key assigned that might do surprising things if the key is
reallocated for another use later, right?  Is that how the API is intended
to work?

Thanks,

jon
