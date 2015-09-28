From: Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v7 04/11] task_isolation: provide strict mode configurable
 signal
Date: Mon, 28 Sep 2015 17:54:59 -0400
Message-ID: <5609B733.90005@ezchip.com>
References: <1443453446-7827-1-git-send-email-cmetcalf@ezchip.com>
 <1443453446-7827-5-git-send-email-cmetcalf@ezchip.com>
 <CALCETrXaWaUwWnOz16RAqjFP9tZm=tp74xWacXjqa36TWB9BfQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrXaWaUwWnOz16RAqjFP9tZm=tp74xWacXjqa36TWB9BfQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Gilad Ben Yossef <giladb-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 09/28/2015 04:54 PM, Andy Lutomirski wrote:
> On Mon, Sep 28, 2015 at 11:17 AM, Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org> wrote:
>> Allow userspace to override the default SIGKILL delivered
>> when a task_isolation process in STRICT mode does a syscall
>> or otherwise synchronously enters the kernel.
>>
>> In addition to being able to set the signal, we now also
>> pass whether or not the interruption was from a syscall in
>> the si_code field of the siginfo.
>>
>> Signed-off-by: Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
>> ---
>>   include/uapi/linux/prctl.h |  2 ++
>>   kernel/isolation.c         | 17 +++++++++++++----
>>   2 files changed, 15 insertions(+), 4 deletions(-)
>>
>> diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
>> index 2b8038b0d1e1..a5582ace987f 100644
>> --- a/include/uapi/linux/prctl.h
>> +++ b/include/uapi/linux/prctl.h
>> @@ -202,5 +202,7 @@ struct prctl_mm_map {
>>   #define PR_GET_TASK_ISOLATION          49
>>   # define PR_TASK_ISOLATION_ENABLE      (1 << 0)
>>   # define PR_TASK_ISOLATION_STRICT      (1 << 1)
>> +# define PR_TASK_ISOLATION_SET_SIG(sig)        (((sig) & 0x7f) << 8)
>> +# define PR_TASK_ISOLATION_GET_SIG(bits) (((bits) >> 8) & 0x7f)
>>
>>   #endif /* _LINUX_PRCTL_H */
>> diff --git a/kernel/isolation.c b/kernel/isolation.c
>> index 3779ba670472..44bafcd08bca 100644
>> --- a/kernel/isolation.c
>> +++ b/kernel/isolation.c
>> @@ -77,14 +77,23 @@ void task_isolation_enter(void)
>>          }
>>   }
>>
>> -static void kill_task_isolation_strict_task(void)
>> +static void kill_task_isolation_strict_task(int is_syscall)
>>   {
>> +       siginfo_t info = {};
>> +       int sig;
>> +
>>          /* RCU should have been enabled prior to this point. */
>>          RCU_LOCKDEP_WARN(!rcu_is_watching(), "kernel entry without RCU");
>>
>>          dump_stack();
>>          current->task_isolation_flags &= ~PR_TASK_ISOLATION_ENABLE;
>> -       send_sig(SIGKILL, current, 1);
>> +
>> +       sig = PR_TASK_ISOLATION_GET_SIG(current->task_isolation_flags);
>> +       if (sig == 0)
>> +               sig = SIGKILL;
>> +       info.si_signo = sig;
>> +       info.si_code = is_syscall;
> I think this needs real SI_ defines.

Yeah, it's a fair point, but of course SIGKILL has no SI_ defines
at all right now.  I'm tempted to suggest we just back out setting
si_code altogether.  It might be worth a one-line console message
(a la show_signal_message()), and use that to pack in the extra
information, instead of trying to fuss with the siginfo data.

>> +       send_sig_info(sig, &info, current);
>>   }
>>
>>   /*
>> @@ -103,7 +112,7 @@ void task_isolation_syscall(int syscall)
>>
>>          pr_warn("%s/%d: task_isolation strict mode violated by syscall %d\n",
>>                  current->comm, current->pid, syscall);
>> -       kill_task_isolation_strict_task();
>> +       kill_task_isolation_strict_task(1);
> No magic numbers please.

I think mooted by the above, but, good point.

-- 
Chris Metcalf, EZChip Semiconductor
http://www.ezchip.com
