From: Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>
Subject: Re: [PATCH v6] add MAP_UNLOCKED mmap flag
Date: Mon, 18 Jan 2010 16:09:35 +0200
Message-ID: <84144f021001180609r4d7fbbd0p972d5bc0e227d09a@mail.gmail.com>
References: <20100118133755.GG30698@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100118133755.GG30698-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gleb Natapov <gleb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, andrew.c.morrow-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Gleb,

On Mon, Jan 18, 2010 at 3:37 PM, Gleb Natapov <gleb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> The current interaction between mlockall(MCL_FUTURE) and mmap has a
> deficiency. In 'normal' mode, without MCL_FUTURE in force, the default
> is that new memory mappings are not locked, but mmap provides MAP_LOCKED
> specifically to override that default. However, with MCL_FUTURE toggled
> to on, there is no analogous way to tell mmap to override the default. The
> proposed MAP_UNLOCKED flag would resolve this deficiency.
>
> The benefit of the patch is that it makes it possible for an application
> which has previously called mlockall(MCL_FUTURE) to selectively exempt
> new memory mappings from memory locking, on a per-mmap-call basis. There
> is currently no thread-safe way for an application to do this as
> toggling MCL_FUTURE around calls to mmap is racy in a multi-threaded
> context. Other threads may manipulate the address space during the
> window where MCL_FUTURE is off, subverting the programmers intended
> memory locking semantics.
>
> The ability to exempt specific memory mappings from memory locking is
> necessary when the region to be mapped is larger than physical memory.
> In such cases a call to mmap the region cannot succeed, unless
> MAP_UNLOCKED is available.

The changelog doesn't mention what kind of applications would want to
use this. Are there some? Using mlockall(MCL_FUTURE) but then having
some memory regions MAP_UNLOCKED sounds like a strange combination to
me.
