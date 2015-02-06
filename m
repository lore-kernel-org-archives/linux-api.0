From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH 2/2] kernel/fork: handle put_user errors for CLONE_PARENT_SETTID
Date: Fri, 6 Feb 2015 14:10:58 -0800
Message-ID: <CA+55aFy_C3BzmyJwNT7ExcaOc7GxvSeBRAFf3idYCSEtP8Ntag@mail.gmail.com>
References: <20150206162301.18031.32251.stgit@buzz>
	<20150206162303.18031.37408.stgit@buzz>
	<CA+55aFxBuf-0UkoYCrwH_vNsWFnUkFOz5c9O_Mswe_w0BTkqbQ@mail.gmail.com>
	<CALYGNiMv021=WC2uXsjo5zT8JwewweZUDdk0x8FGHh9V5j6bFQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALYGNiMv021=WC2uXsjo5zT8JwewweZUDdk0x8FGHh9V5j6bFQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roman Gushchin <klamm-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Nikita Vetoshkin <nekto0n-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Feb 6, 2015 at 1:13 PM, Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> Currently that works fine only because kernel retries 0-order allocations
> endlessly. But pagefault_out_of_memory() is never called for non-user PF.
> For kernel PF all oom-kills are triggered by buddy-allocator.

This makes no sense.

You're trying to fix what you perceive as a problem in the page fault
handling in some totally different place.

If *that* is what you are worried about, then damnit, just fix the
page fault handler for the kernel case to send a signal or something
for VM_FAULT_ENOMEM. Or, better yet, make it just trigger oom at
return to user space - we could add a _TIF_OOM flag, for example, and
make it part of the user-return logic (do_notify_resume), kind of how
_TIF_SIGPENDING triggers a signal.

Don't try to make horrible code in insane places that have nothing to
do with the fundamental problem. Why did you pick this particular
get/put user anyway? There are tons others that we don't test, why did
you happen pick these and then make it have that horrible and
senseless error handling?

Because at *NO* point was it obvious that that patch had anything at
all to do with "out of memory". Not in the code, not in your commit
messages, *nowhere*.

There is no way in hell I will take that kind of changes when you
didn't even articulate why you wanted to do them in the commit
messages, and the patches didn't look like they had anything to do
with oom either.

                    Linus
