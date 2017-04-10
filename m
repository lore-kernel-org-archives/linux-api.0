From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH RFC v2 2/3] security: add the ModAutoRestrict Linux
 Security Module
Date: Mon, 10 Apr 2017 12:04:25 -0700
Message-ID: <36b005c9-e550-2ee8-61b2-136628f1a05f@schaufler-ca.com>
References: <1491734530-25002-1-git-send-email-tixxdz@gmail.com>
 <1491734530-25002-3-git-send-email-tixxdz@gmail.com>
 <b483ccc8-406c-a620-9f7a-fdcbbc3fdb26@schaufler-ca.com>
 <CAEiveUeYB8jQoP9R9xSj+5dxc3cfCg46Z=C5TkfkYibDWrEbPQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAEiveUeYB8jQoP9R9xSj+5dxc3cfCg46Z=C5TkfkYibDWrEbPQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Djalal Harouni <tixxdz@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, kernel-hardening@lists.openwall.com, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Dongsu Park <dpark@posteo.net>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>, Paul Moore <paul@paul-moore.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-Id: linux-api@vger.kernel.org

On 4/10/2017 11:27 AM, Djalal Harouni wrote:
> On Mon, Apr 10, 2017 at 5:42 PM, Casey Schaufler <casey@schaufler-ca.com> wrote:
>> On 4/9/2017 3:42 AM, Djalal Harouni wrote:
> [...]
>>> +
>>> +static inline struct modautoload_task *init_modautoload_task(struct task_struct *tsk,
>>> +                                                          unsigned long flags)
>>> +{
>>> +     struct modautoload_task *modtask;
>>> +
>>> +     modtask = task_security(tsk, modautorestrict_task_security_index);
>>> +
>>> +     modtask->flags = (u8)flags;
>> I don't think you want to do this cast.
> Will fix it. Thanks!
>
>
> [...]
>>> +
>>> +#ifdef CONFIG_SYSCTL
>>> +static int modautoload_dointvec_minmax(struct ctl_table *table, int write,
>>> +                                    void __user *buffer, size_t *lenp,
>>> +                                    loff_t *ppos)
>>> +{
>>> +     struct ctl_table table_copy;
>>> +
>>> +     if (write && !capable(CAP_SYS_MODULE))
>>> +             return -EPERM;
>>> +
>>> +     table_copy = *table;
>>> +     if (*(int *)table_copy.data == *(int *)table_copy.extra2)
>> While it's probably doing what you want, I find this
>> sort of casting disturbing.
> Ok will try to improve it.
>
>
>>> +             table_copy.extra1 = table_copy.extra2;
>>> +
>>> +     return proc_dointvec_minmax(&table_copy, write, buffer, lenp, ppos);
>>> +}
>>> +
>>> +struct ctl_path modautoload_sysctl_path[] = {
>>> +     { .procname = "kernel", },
>>> +     { .procname = "modautorestrict", },
>>> +     { }
>>> +};
>>> +
>>> +static struct ctl_table modautoload_sysctl_table[] = {
>>> +     {
>>> +             .procname       = "autoload",
>>> +             .data           = &autoload_restrict,
>>> +             .maxlen         = sizeof(int),
>>> +             .mode           = 0644,
>>> +             .proc_handler   = modautoload_dointvec_minmax,
>>> +             .extra1         = &zero,
>>> +             .extra2         = &max_autoload_restrict,
>>> +     },
>>> +     { }
>>> +};
>>> +
>>> +static void __init modautoload_init_sysctl(void)
>>> +{
>>> +     if (!register_sysctl_paths(modautoload_sysctl_path, modautoload_sysctl_table))
>>> +             panic("modautorestrict: sysctl registration failed.\n");
>>> +}
>>> +#else
>>> +static inline void modautoload_init_sysctl(void) { }
>>> +#endif /* CONFIG_SYSCTL */
>>> +
>>> +void __init modautorestrict_init(void)
>>> +{
>>> +     modautorestrict_task_security_index =
>>> +             security_reserve_task_blob_index(sizeof(struct modautoload_task));
>>> +     security_add_hooks(modautoload_hooks,
>>> +                        ARRAY_SIZE(modautoload_hooks), "modautorestrict");
>>> +
>>> +     modautoload_init_sysctl();
>>> +     pr_info("ModAutoRestrict LSM:  Initialized\n");
>>> +}
>>> diff --git a/security/security.c b/security/security.c
>>> index 4dc6bca..d8852fe 100644
>>> --- a/security/security.c
>>> +++ b/security/security.c
>>> @@ -70,6 +70,7 @@ int __init security_init(void)
>>>       capability_add_hooks();
>>>       yama_add_hooks();
>>>       loadpin_add_hooks();
>>> +     modautorestrict_init();
>> This should be modautorestrict_add_hooks() if this were
>> a "minor" module, but as it's using a blob it is a "major"
>> module. Either way, this is not right.
> Do you mean that if I'm using a blob, it should go with the rest LSMs
> in do_security_initcalls() ?

Right. Today you have coincidental non-interference because
no one else is using the task blob. As you're aware, TOMOYO
is going to start using it, and I believe the AppArmor has
plans for it as well. There are parts of the Smack cred blob
that should probably go in the task blob as they aren't used
in access decisions. I haven't looked closely enough, but that's
possible for SELinux, too. So even though it's a new blob, the
major/minor rules apply.

>
>>>       /*
>>>        * Load all the remaining security modules.
> Thanks for the comments!
>
>
