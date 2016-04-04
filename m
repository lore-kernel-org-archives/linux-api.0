From: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
Subject: Re: [PATCH] x86: Add a turbo mode sysctl
Date: Mon, 4 Apr 2016 09:48:23 +0300
Message-ID: <57020E37.4000302@kyup.com>
References: <cd6157244ae75145e2529a1d73f6174cd829ac9c.1459525715.git.luto@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cd6157244ae75145e2529a1d73f6174cd829ac9c.1459525715.git.luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org



On 04/01/2016 06:49 PM, Andy Lutomirski wrote:
> Sadly, hardware turbo mode buttons are few and far between in these
> degenerate times.  Add a software control at /proc/sys/turbo_mode.
> 
> Unfortunately, Linux graphical environments have become very
> heavy-weight and are essentially unusable on non-Turbo systems.  The
> VT console works very well, though.
> 
> Due to KVM limitations, turbo mode is permanently on in a KVM guest.
> 
> Signed-off-by: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  arch/x86/mm/pat.c | 63 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 61 insertions(+), 2 deletions(-)


The name of the sysctl really sucks, it just control whether caching is
enabled/disabled. Now, having said that I realize there are multiple
sysctl that contain "cache" in their names. But can you come up with a
more descriptive name, directly relating to what the sysctl does and now
what its actual effects are :)? Also, aren't caches enabled by the
kernel when the system is booting, according to SDM1/section 9.3 caches
are disabled after reset and I assume the kernel does enable them when
it's booting?
