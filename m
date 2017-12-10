From: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: pkeys: Support setting access rights for signal handlers
Date: Sat, 9 Dec 2017 16:17:36 -0800
Message-ID: <c034f693-95d1-65b8-2031-b969c2771fed@intel.com>
References: <5fee976a-42d4-d469-7058-b78ad8897219@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5fee976a-42d4-d469-7058-b78ad8897219-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-x86_64-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 12/09/2017 01:16 PM, Florian Weimer wrote:
> The attached patch addresses a problem with the current x86 pkey
> implementation, which makes default-readable pkeys unusable from signal
> handlers because the default init_pkru value blocks access.

Thanks for looking into this!

What do you mean by "default-readable pkeys"?

I think you mean that, for any data that needs to be accessed to enter a
signal handler, it must be set to pkey=0 with the current
implementation.  All other keys are inaccessible when entering a signal
handler because the "init" value disables access.

My only nit with this is whether it is the *right* interface.  The
signal vs. XSAVE state thing is pretty x86 specific and I doubt that
this will be the last feature that we encounter that needs special
signal behavior.

A question more for the x86 maintainers is whether they would rather see
a pkeys-specific interface for this, or an XSAVE-specific interface
where you could specify a non-init XSAVE state for a set of XSAVE
components.
