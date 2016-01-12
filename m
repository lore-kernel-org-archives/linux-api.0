From: Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>
Subject: RE: [RFC PATCH 0/3] Implement getcpu_cache system call
Date: Tue, 12 Jan 2016 21:02:12 +0000
Message-ID: <5CDDBDF2D36D9F43B9F5E99003F6A0D49A1426A5@PRN-MBX02-1.TheFacebook.com>
References: <1451977320-4886-1-git-send-email-mathieu.desnoyers@efficios.com>
 <DDB9C85B850785449757F9914A034FCB4450ACF7@G9W0766.americas.hpqcorp.net>
 <20160111230306.GC28717@cloud>
 <137700396.343696.1452559758752.JavaMail.zimbra@efficios.com>
 <20160112024549.GA6488@x>
 <9F8D25C2-B5EE-479D-BD61-0FE466962B9E@fb.com>,<467525713.343916.1452604549209.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <467525713.343916.1452604549209.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Shane M Seymour <shane.seymour-ZPxbGqLxI0U@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org



> One idea I have would be to let the kernel reserve some space either after the
> first stack address (for a stack growing down) or at the beginning of the
> allocated TLS area for each thread in copy_thread_tls() by fiddling with
> sp or the tls base address when creating a thread.

Could this be implemented by having glibc use a well known symbol name to define the per-thread TLS area? If an high performance application wants to avoid any relocations in accessing this variable it would define it and that definition would override glibc's. This is how things work with malloc. glibc has a default malloc implementation but we link jemalloc directly into our binaries. in addition to changing the malloc implementation this means that calls to malloc don't go through the PLT.

-b--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
