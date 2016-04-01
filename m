From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH] x86: Add a turbo mode sysctl
Date: Fri, 1 Apr 2016 18:10:03 +0200 (CEST)
Message-ID: <alpine.DEB.2.11.1604011803390.3978@nanos>
References: <cd6157244ae75145e2529a1d73f6174cd829ac9c.1459525715.git.luto@kernel.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cd6157244ae75145e2529a1d73f6174cd829ac9c.1459525715.git.luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, 1 Apr 2016, Andy Lutomirski wrote:
> +static void update_local_turbo_mode(void *dummy)
> +{
> +	unsigned long cr0 = read_cr0();
> +
> +	/*
> +	 * KVM doesn't properly handle CD.
> +	 *
> +	 * XXX: this may interact poorly with CPU hotplug.

Please cc these crazy folks who cleanup the hotplug mess so they can put it on
their todo list.

> +	 */
> +
> +	if (turbo_mode)
> +		write_cr0(cr0 & ~X86_CR0_CD);
> +	else
> +		write_cr0(cr0 | X86_CR0_CD);

I think proper turbo mode disable requires ~(X86_CR0_CD | X86_CR0_NW)

> +static void update_turbo_mode(void)
> +{
> +	on_each_cpu(update_local_turbo_mode, NULL, 1);
> +
> +	if (!turbo_mode)
> +		wbinvd();

You really want to do wbinvd() on each cpu to make sure that each cpu gets out
of that turbo thing.

Thanks,

	tglx
