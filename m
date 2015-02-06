From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] kernel/fork: handle put_user errors for
	CLONE_PARENT_SETTID
Date: Fri, 6 Feb 2015 22:07:38 +0100
Message-ID: <20150206210738.GA18332@redhat.com>
References: <20150206162301.18031.32251.stgit@buzz> <20150206162303.18031.37408.stgit@buzz> <CA+55aFxBuf-0UkoYCrwH_vNsWFnUkFOz5c9O_Mswe_w0BTkqbQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFxBuf-0UkoYCrwH_vNsWFnUkFOz5c9O_Mswe_w0BTkqbQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roman Gushchin <klamm-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Nikita Vetoshkin <nekto0n-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

I am not sure about these changes too, but

On 02/06, Linus Torvalds wrote:
>
> What's the upside? If somebody passes in a bad pointer, it's their
> problem.

Yes. But unless I am totally confused (quite possible) this put_user()
can fail even if the pointer is valid.

So at least I think Konstantin has found a real problem. Which (I think)
shoud be fixed, and this is not connected to fork.

> insane with the whole "readable vs writable" thing.

Agreed, this part doesn't look nice in any case.

Oleg.
