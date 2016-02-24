From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 0/5] getcpu_cache system call for 4.6
Date: Wed, 24 Feb 2016 12:07:28 -0800
Message-ID: <F6BC367F-127F-4254-8E4E-E7BF60A027F3@zytor.com>
References: <1456270120-7560-1-git-send-email-mathieu.desnoyers@efficios.com> <56CD091A.4060009@zytor.com> <1452699925.6549.1456286963485.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452699925.6549.1456286963485.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On February 23, 2016 8:09:23 PM PST, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
>----- On Feb 23, 2016, at 8:36 PM, H. Peter Anvin hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org wrote:
>
>> On 02/23/2016 03:28 PM, Mathieu Desnoyers wrote:
>>> Hi,
>>> 
>>> Here is a patchset implementing a cache for the CPU number of the
>>> currently running thread in user-space.
>>> 
>>> Benchmarks comparing this approach to a getcpu based on system call
>on
>>> ARM show a 44x speedup. They show a 14x speedup on x86-64 compared
>to
>>> executing lsl from a vDSO through glibc.
>>> 
>>> I'm added a man page in the changelog of patch 1/3, which shows an
>>> example usage of this new system call.
>>> 
>>> This series is based on v4.5-rc5, submitted for Linux 4.6.
>>> 
>>> Feedback is welcome,
>>> 
>> 
>> What is the resulting context switch overhead?
>
>The getcpu_cache only adds code to the thread migration path,
>and to the resume notifier. The context switch path per se is
>untouched. I would therefore expect the overhead on context
>switch to be within the noise, except if stuff like hackbench
>would be so sensitive to the size of struct task_struct that
>a single extra pointer added at the end of struct task_struct
>would throw off the benchmarks.
>
>Is that what you are concerned about ?
>
>Thanks,
>
>Mathieu

Yes, I'd like to see numbers.  It is way easy to handwave small changes away, but they add up over time.  Without numbers it is a bit hard to quantify the pro vs con.
-- 
Sent from my Android device with K-9 Mail. Please excuse brevity and formatting.
