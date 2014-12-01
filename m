From: Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH] proc, pidns: Add highpid
Date: Mon, 1 Dec 2014 20:39:11 +0400
Message-ID: <CALYGNiM0C3RND_3yVzCMUtzoo33kG5jS+C1KL19j8JYf150-Og@mail.gmail.com>
References: <b0f6c4df0e8ef8afcc7b786edecb4be8c752941e.1417215468.git.luto@amacapital.net>
	<CALYGNiOV9Ms=JW5sOhdmh2BmR1v+4obE8DQ0v+3rgQYkh=h2GQ@mail.gmail.com>
	<CALCETrW0Kmi+bJSSegjD4pSZoYhDMyQUJALZY72r388giV+ruQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrW0Kmi+bJSSegjD4pSZoYhDMyQUJALZY72r388giV+ruQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, systemd Mailing List <systemd-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Greg Kroah-Hartman <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Cyrill Gorcunov <gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, =?UTF-8?B?0JXQvNC10LvRjNGP0L3QvtCyINCf0LDQstC10Ls=?= <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Dec 1, 2014 at 7:21 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
> On Sun, Nov 30, 2014 at 11:03 PM, Konstantin Khlebnikov
> <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> Hmm. What about per-task/thread UUID? exported via separate file: /proc/PID/uuid
>> It could be created at the first access, thus this wouldn't shlowdown clone().
>> Also it could be droped at execve(), so it'll describe execution
>> context more precisely than pid.
>>
>
> I'd be all for this if it weren't for two issues:
>
> 1. This thing needs to work as soon as init is started, and we can't
> reliably generate random numbers that early.
>
> 2. Migration / CRIU is rather fundamentally at odds with making
> anything universally unique, as opposed to just per-user-ns.
>
> So, given that I don't think we can actually provide a universally
> unique pid-like thing, I'd rather not even try.

Well... another idea: what about pid generation counter? Of course it
should be per-pid-ns.
As I see struct upid has nice 32-bit hole next to 'nr' field. (on
64-bit systems)

>
> That being said, I want to rework this a little bit.  I think that
> highpid should be restricted to the range 2^32 through 2^64 - 4096.
> The former prevents anyone from confusing highpid with regular pid,
> and the latter means that we don't need to worry about confusion
> between errors and valid highpids (e.g. -1 will never be a highpid).
>
> Implementing that will be only mildly annoying.
>
> --Andy
>
>> On Sat, Nov 29, 2014 at 2:05 AM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>>> Pid reuse is common, which means that it's difficult or impossible
>>> to read information about a pid from /proc without races.
>>>
>>> This introduces a second number associated with each (task, pidns)
>>> pair called highpid.  Highpid is a 64-bit number, and, barring
>>> extremely unlikely circumstances or outright error, a (highpid, pid)
>>> will never be reused.
>>>
>>> With just this change, a program can open /proc/PID/status, read the
>>> "Highpid" field, and confirm that it has the expected value.  If the
>>> pid has been reused, then highpid will be different.
>>>
>>> The initial implementation is straightforward: highpid is simply a
>>> 64-bit counter. If a high-end system can fork every 3 ns (which
>>> would be amazing, given that just allocating a pid requires at
>>> atomic operation), it would take well over 1000 years for highpid to
>>> wrap.
>>>
>>> For CRIU's benefit, the next highpid can be set by a privileged
>>> user.
>>>
>>> NB: The sysctl stuff only works on 64-bit systems.  If the approach
>>> looks good, I'll fix that somehow.
>>>
>>> Signed-off-by: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
>>> ---
>>>
>>> If this goes in, there's plenty of room to add new interfaces to
>>> make this more useful.  For example, we could add a fancier tgkill
>>> that adds and validates hightgid and highpid, and we might want to
>>> add a syscall to read one's own hightgid and highpid.  These would
>>> be quite useful for pidfiles.
>>>
>>> David, would this be useful for kdbus?
>>>
>>> CRIU people: will this be unduly difficult to support in CRIU?
>>>
>>> If you all think this is a good idea, I'll fix the sysctl stuff and
>>> document it.  It might also be worth adding "Hightgid" to status.
>>>
>>>  fs/proc/array.c               |  5 ++++-
>>>  include/linux/pid.h           |  2 ++
>>>  include/linux/pid_namespace.h |  1 +
>>>  kernel/pid.c                  | 19 +++++++++++++++----
>>>  kernel/pid_namespace.c        | 22 ++++++++++++++++++++++
>>>  5 files changed, 44 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/fs/proc/array.c b/fs/proc/array.c
>>> index cd3653e4f35c..f1e0e69d19f9 100644
>>> --- a/fs/proc/array.c
>>> +++ b/fs/proc/array.c
>>> @@ -159,6 +159,7 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
>>>         int g;
>>>         struct fdtable *fdt = NULL;
>>>         const struct cred *cred;
>>> +       const struct upid *upid;
>>>         pid_t ppid, tpid;
>>>
>>>         rcu_read_lock();
>>> @@ -170,12 +171,14 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
>>>                 if (tracer)
>>>                         tpid = task_pid_nr_ns(tracer, ns);
>>>         }
>>> +       upid = pid_upid_ns(pid, ns);
>>>         cred = get_task_cred(p);
>>>         seq_printf(m,
>>>                 "State:\t%s\n"
>>>                 "Tgid:\t%d\n"
>>>                 "Ngid:\t%d\n"
>>>                 "Pid:\t%d\n"
>>> +               "Highpid:\t%llu\n"
>>>                 "PPid:\t%d\n"
>>>                 "TracerPid:\t%d\n"
>>>                 "Uid:\t%d\t%d\t%d\t%d\n"
>>> @@ -183,7 +186,7 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
>>>                 get_task_state(p),
>>>                 task_tgid_nr_ns(p, ns),
>>>                 task_numa_group_id(p),
>>> -               pid_nr_ns(pid, ns),
>>> +               upid ? upid->nr : 0, upid ? upid->highnr : 0,
>>>                 ppid, tpid,
>>>                 from_kuid_munged(user_ns, cred->uid),
>>>                 from_kuid_munged(user_ns, cred->euid),
>>> diff --git a/include/linux/pid.h b/include/linux/pid.h
>>> index 23705a53abba..ece70b64d04c 100644
>>> --- a/include/linux/pid.h
>>> +++ b/include/linux/pid.h
>>> @@ -51,6 +51,7 @@ struct upid {
>>>         /* Try to keep pid_chain in the same cacheline as nr for find_vpid */
>>>         int nr;
>>>         struct pid_namespace *ns;
>>> +       u64 highnr;
>>>         struct hlist_node pid_chain;
>>>  };
>>>
>>> @@ -170,6 +171,7 @@ static inline pid_t pid_nr(struct pid *pid)
>>>  }
>>>
>>>  pid_t pid_nr_ns(struct pid *pid, struct pid_namespace *ns);
>>> +const struct upid *pid_upid_ns(struct pid *pid, struct pid_namespace *ns);
>>>  pid_t pid_vnr(struct pid *pid);
>>>
>>>  #define do_each_pid_task(pid, type, task)                              \
>>> diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
>>> index 1997ffc295a7..1f9f0455d7ef 100644
>>> --- a/include/linux/pid_namespace.h
>>> +++ b/include/linux/pid_namespace.h
>>> @@ -26,6 +26,7 @@ struct pid_namespace {
>>>         struct rcu_head rcu;
>>>         int last_pid;
>>>         unsigned int nr_hashed;
>>> +       atomic64_t next_highpid;
>>>         struct task_struct *child_reaper;
>>>         struct kmem_cache *pid_cachep;
>>>         unsigned int level;
>>> diff --git a/kernel/pid.c b/kernel/pid.c
>>> index 9b9a26698144..863d11a9bfbf 100644
>>> --- a/kernel/pid.c
>>> +++ b/kernel/pid.c
>>> @@ -312,6 +312,8 @@ struct pid *alloc_pid(struct pid_namespace *ns)
>>>
>>>                 pid->numbers[i].nr = nr;
>>>                 pid->numbers[i].ns = tmp;
>>> +               pid->numbers[i].highnr =
>>> +                       atomic64_inc_return(&tmp->next_highpid) - 1;
>>>                 tmp = tmp->parent;
>>>         }
>>>
>>> @@ -492,17 +494,26 @@ struct pid *find_get_pid(pid_t nr)
>>>  }
>>>  EXPORT_SYMBOL_GPL(find_get_pid);
>>>
>>> -pid_t pid_nr_ns(struct pid *pid, struct pid_namespace *ns)
>>> +const struct upid *pid_upid_ns(struct pid *pid, struct pid_namespace *ns)
>>>  {
>>>         struct upid *upid;
>>> -       pid_t nr = 0;
>>>
>>>         if (pid && ns->level <= pid->level) {
>>>                 upid = &pid->numbers[ns->level];
>>>                 if (upid->ns == ns)
>>> -                       nr = upid->nr;
>>> +                       return upid;
>>>         }
>>> -       return nr;
>>> +       return NULL;
>>> +}
>>> +EXPORT_SYMBOL_GPL(pid_upid_ns);
>>> +
>>> +pid_t pid_nr_ns(struct pid *pid, struct pid_namespace *ns)
>>> +{
>>> +       const struct upid *upid = pid_upid_ns(pid, ns);
>>> +
>>> +       if (!upid)
>>> +               return 0;
>>> +       return upid->nr;
>>>  }
>>>  EXPORT_SYMBOL_GPL(pid_nr_ns);
>>>
>>> diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
>>> index db95d8eb761b..e246802b4361 100644
>>> --- a/kernel/pid_namespace.c
>>> +++ b/kernel/pid_namespace.c
>>> @@ -268,6 +268,22 @@ static int pid_ns_ctl_handler(struct ctl_table *table, int write,
>>>         return proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
>>>  }
>>>
>>> +static int pid_ns_next_highpid_handler(struct ctl_table *table, int write,
>>> +               void __user *buffer, size_t *lenp, loff_t *ppos)
>>> +{
>>> +       struct pid_namespace *pid_ns = task_active_pid_ns(current);
>>> +       struct ctl_table tmp = *table;
>>> +
>>> +       if (write && !ns_capable(pid_ns->user_ns, CAP_SYS_ADMIN))
>>> +               return -EPERM;
>>> +
>>> +       /* This needs to be fixed. */
>>> +       BUILD_BUG_ON(sizeof(u64) != sizeof(unsigned long));
>>> +
>>> +       tmp.data = &pid_ns->next_highpid;
>>> +       return proc_dointvec(&tmp, write, buffer, lenp, ppos);
>>> +}
>>> +
>>>  extern int pid_max;
>>>  static int zero = 0;
>>>  static struct ctl_table pid_ns_ctl_table[] = {
>>> @@ -279,6 +295,12 @@ static struct ctl_table pid_ns_ctl_table[] = {
>>>                 .extra1 = &zero,
>>>                 .extra2 = &pid_max,
>>>         },
>>> +       {
>>> +               .procname = "ns_next_highpid",
>>> +               .maxlen = sizeof(u64),
>>> +               .mode = 0666, /* permissions are checked in the handler */
>>> +               .proc_handler = pid_ns_next_highpid_handler,
>>> +       },
>>>         { }
>>>  };
>>>  static struct ctl_path kern_path[] = { { .procname = "kernel", }, { } };
>>> --
>>> 1.9.3
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>
> --
> Andy Lutomirski
> AMA Capital Management, LLC
