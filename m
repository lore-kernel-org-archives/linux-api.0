From: Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC v2 2/3] security: add the ModAutoRestrict Linux
 Security Module
Date: Mon, 10 Apr 2017 20:27:55 +0200
Message-ID: <CAEiveUeYB8jQoP9R9xSj+5dxc3cfCg46Z=C5TkfkYibDWrEbPQ@mail.gmail.com>
References: <1491734530-25002-1-git-send-email-tixxdz@gmail.com>
 <1491734530-25002-3-git-send-email-tixxdz@gmail.com> <b483ccc8-406c-a620-9f7a-fdcbbc3fdb26@schaufler-ca.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <b483ccc8-406c-a620-9f7a-fdcbbc3fdb26-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org, LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dongsu Park <dpark-VwIFZPTo/vqsTnJN9+BGXg@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Apr 10, 2017 at 5:42 PM, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org> wrote:
> On 4/9/2017 3:42 AM, Djalal Harouni wrote:
[...]
>> +
>> +static inline struct modautoload_task *init_modautoload_task(struct task_struct *tsk,
>> +                                                          unsigned long flags)
>> +{
>> +     struct modautoload_task *modtask;
>> +
>> +     modtask = task_security(tsk, modautorestrict_task_security_index);
>> +
>> +     modtask->flags = (u8)flags;
>
> I don't think you want to do this cast.

Will fix it. Thanks!


[...]
>> +
>> +#ifdef CONFIG_SYSCTL
>> +static int modautoload_dointvec_minmax(struct ctl_table *table, int write,
>> +                                    void __user *buffer, size_t *lenp,
>> +                                    loff_t *ppos)
>> +{
>> +     struct ctl_table table_copy;
>> +
>> +     if (write && !capable(CAP_SYS_MODULE))
>> +             return -EPERM;
>> +
>> +     table_copy = *table;
>> +     if (*(int *)table_copy.data == *(int *)table_copy.extra2)
>
> While it's probably doing what you want, I find this
> sort of casting disturbing.

Ok will try to improve it.


>> +             table_copy.extra1 = table_copy.extra2;
>> +
>> +     return proc_dointvec_minmax(&table_copy, write, buffer, lenp, ppos);
>> +}
>> +
>> +struct ctl_path modautoload_sysctl_path[] = {
>> +     { .procname = "kernel", },
>> +     { .procname = "modautorestrict", },
>> +     { }
>> +};
>> +
>> +static struct ctl_table modautoload_sysctl_table[] = {
>> +     {
>> +             .procname       = "autoload",
>> +             .data           = &autoload_restrict,
>> +             .maxlen         = sizeof(int),
>> +             .mode           = 0644,
>> +             .proc_handler   = modautoload_dointvec_minmax,
>> +             .extra1         = &zero,
>> +             .extra2         = &max_autoload_restrict,
>> +     },
>> +     { }
>> +};
>> +
>> +static void __init modautoload_init_sysctl(void)
>> +{
>> +     if (!register_sysctl_paths(modautoload_sysctl_path, modautoload_sysctl_table))
>> +             panic("modautorestrict: sysctl registration failed.\n");
>> +}
>> +#else
>> +static inline void modautoload_init_sysctl(void) { }
>> +#endif /* CONFIG_SYSCTL */
>> +
>> +void __init modautorestrict_init(void)
>> +{
>> +     modautorestrict_task_security_index =
>> +             security_reserve_task_blob_index(sizeof(struct modautoload_task));
>> +     security_add_hooks(modautoload_hooks,
>> +                        ARRAY_SIZE(modautoload_hooks), "modautorestrict");
>> +
>> +     modautoload_init_sysctl();
>> +     pr_info("ModAutoRestrict LSM:  Initialized\n");
>> +}
>> diff --git a/security/security.c b/security/security.c
>> index 4dc6bca..d8852fe 100644
>> --- a/security/security.c
>> +++ b/security/security.c
>> @@ -70,6 +70,7 @@ int __init security_init(void)
>>       capability_add_hooks();
>>       yama_add_hooks();
>>       loadpin_add_hooks();
>> +     modautorestrict_init();
>
> This should be modautorestrict_add_hooks() if this were
> a "minor" module, but as it's using a blob it is a "major"
> module. Either way, this is not right.

Do you mean that if I'm using a blob, it should go with the rest LSMs
in do_security_initcalls() ?

>>
>>       /*
>>        * Load all the remaining security modules.
>

Thanks for the comments!


-- 
tixxdz
