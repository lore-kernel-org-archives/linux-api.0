From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH 2/2] kernel/fork: handle put_user errors for CLONE_PARENT_SETTID
Date: Fri, 6 Feb 2015 12:49:51 -0800
Message-ID: <CA+55aFxBuf-0UkoYCrwH_vNsWFnUkFOz5c9O_Mswe_w0BTkqbQ@mail.gmail.com>
References: <20150206162301.18031.32251.stgit@buzz>
	<20150206162303.18031.37408.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150206162303.18031.37408.stgit@buzz>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roman Gushchin <klamm-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Nikita Vetoshkin <nekto0n-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Feb 6, 2015 at 8:23 AM, Konstantin Khlebnikov
<khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org> wrote:
> Handling of flag CLONE_PARENT_SETTID has the same problem: error returned
> from put_user() is ignored. Glibc completely relies on that feature and uses
> value returned from syscall only for error checking.

I'm not seeing the advantage of the error checking part of the pacth
patch. It generates extra code, possibly changing existing interfaces,
and it doesn't actually buy us anything.

What's the upside? If somebody passes in a bad pointer, it's their
problem. For all we know, people used to pass in NULL, even if they
had the SETTID bit set. This makes it now return EFAULT.

So I don't mind moving things into copy_process(), but I *do* mind the
new error return thing.

It's actually better in this patch than in 1/2, because 1/2 was just
insane with the whole "readable vs writable" thing. That I refuse to
even look at, for fear of going blind.

                      Linus
