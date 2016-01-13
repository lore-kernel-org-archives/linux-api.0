From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH 0/3] Implement getcpu_cache system call
Date: Wed, 13 Jan 2016 00:22:29 +0000 (UTC)
Message-ID: <484967406.344576.1452644549992.JavaMail.zimbra@efficios.com>
References: <1451977320-4886-1-git-send-email-mathieu.desnoyers@efficios.com> <DDB9C85B850785449757F9914A034FCB4450ACF7@G9W0766.americas.hpqcorp.net> <20160111230306.GC28717@cloud> <137700396.343696.1452559758752.JavaMail.zimbra@efficios.com> <20160112024549.GA6488@x> <9F8D25C2-B5EE-479D-BD61-0FE466962B9E@fb.com> <467525713.343916.1452604549209.JavaMail.zimbra@efficios.com> <5CDDBDF2D36D9F43B9F5E99003F6A0D49A1426A5@PRN-MBX02-1.TheFacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5CDDBDF2D36D9F43B9F5E99003F6A0D49A1426A5-f8hGUhss0nh9TZdEUguypQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>
Cc: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Shane M Seymour <shane.seymour-ZPxbGqLxI0U@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Jan 12, 2016, at 4:02 PM, Ben Maurer bmaurer-b10kYP2dOMg@public.gmane.org wrote:

>> One idea I have would be to let the kernel reserve some space either after the
>> first stack address (for a stack growing down) or at the beginning of the
>> allocated TLS area for each thread in copy_thread_tls() by fiddling with
>> sp or the tls base address when creating a thread.
> 
> Could this be implemented by having glibc use a well known symbol name to define
> the per-thread TLS area? If an high performance application wants to avoid any
> relocations in accessing this variable it would define it and that definition
> would override glibc's. This is how things work with malloc. glibc has a
> default malloc implementation but we link jemalloc directly into our binaries.
> in addition to changing the malloc implementation this means that calls to
> malloc don't go through the PLT.

Just to make sure I understand your proposal: defining a well known symbol
with a weak attribute in glibc (or bionic...), e.g.:

int32_t __thread __attribute__((weak)) __getcpu_cache;

so that applications which care about bypassing the PLT can override it with:

int32_t __thread __getcpu_cache;

glibc/bionic would be responsible for calling the getcpu_cache() system call
to register/unregister this TLS variable for each thread.

One thing I would like to figure out is whether we can use this in a way that
would allow introducing getcpu_cache() into applications and libraries
(e.g. lttng-ust tracer) before it gets implemented into glibc, in a way that
would keep forward compatibility for whenever it gets introduced in glibc.

We can declare __getcpu_cache as a weak symbol in arbitrary libraries, and
make them register/unregister the cache through the getcpu_cache syscall.
The main thing that I would need to tweak at the kernel level within the
system call would be to keep a refcount of the number of times the
__getcpu_cache is registered per thread. This would allow multiple registrations,
one per library (e.g. lttng-ust) and one for glibc, but we would validate
that they all register the exact same address for a given thread.

The reference counting trick should also work for cases where applications
define a non-weak __getcpu_cache, and want to call the getcpu_cache
system call to register it themselves (before glibc adds support for it).

Thoughts ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
