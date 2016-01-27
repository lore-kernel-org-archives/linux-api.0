From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH v2 2/3] getcpu_cache: wire up ARM system call
Date: Wed, 27 Jan 2016 18:46:39 +0000 (UTC)
Message-ID: <1011987684.6168.1453920399905.JavaMail.zimbra@efficios.com>
References: <1453913683-28915-1-git-send-email-mathieu.desnoyers@efficios.com> <1453913683-28915-3-git-send-email-mathieu.desnoyers@efficios.com> <20160127181915.GA10826@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160127181915.GA10826-l+eeeJia6m9vn6HldHNs0ANdhmdF6hFW@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Jan 27, 2016, at 1:19 PM, Russell King - ARM Linux linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org wrote:

> On Wed, Jan 27, 2016 at 11:54:42AM -0500, Mathieu Desnoyers wrote:
>> Wire up the getcpu cache system call on 32-bit ARM. Call the
> 
> You should note that your chosen system call number of 391 is temporary
> here and can't be relied upon as we have to wire up the new
> copy_file_range() call on ARM (which I've just committed the patch for.)
> 
> I'd much prefer the wiring up to be either an entirely separate patch
> (which must be submitted to me, and I'll merge between -rc1 and -rc2
> along with any other syscall updates) or you leave the wiring up to me.
> 
> This is so that I can ensure that (a) system calls numbers are not
> duplicated and (b) ensure that we follow the same logical order as x86
> where possible.

Just to make sure I understand: you would perfer if I split this
patch into two: one that adds the getcpu_cache_handle_notify_resume()
call in the resume notifier ("getcpu_cache ARM architecture support"),
and a separate patch for wiring up the system call ?

Thanks,

Mathieu

> 
> Thanks.
> 
> --
> RMK's Patch system: http://www.arm.linux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
> according to speedtest.net.

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
