From: Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 2/2] modules:capabilities: add a per-task modules
 autoload restriction
Date: Thu, 27 Apr 2017 15:16:13 +0200
Message-ID: <CAEiveUevPA=b5ooDBAvbVBGoWR4COaMsLK-zLMZiY43BcbJ+UQ@mail.gmail.com>
References: <1492640420-27345-1-git-send-email-tixxdz@gmail.com>
 <1492640420-27345-3-git-send-email-tixxdz@gmail.com> <87r30ifmwz.fsf@rustcorp.com.au>
 <CAEiveUfVyLVrCgjniA+7eutv=OGQ2LwBCx0V7JLiySeJz3c5ZQ@mail.gmail.com> <87k266hacq.fsf@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87k266hacq.fsf-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org, LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dongsu Park <dpark-VwIFZPTo/vqsTnJN9+BGXg@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnaldo Carvalho de Melo <acme-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mauro Carvalho Chehab <mchehab-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo@kern>
List-Id: linux-api@vger.kernel.org

On Thu, Apr 27, 2017 at 4:07 AM, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org> wrote:
> Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
>> Hi Rusty,
>>
>> On Mon, Apr 24, 2017 at 6:29 AM, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org> wrote:
>>> Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
>>>> When value is (1), task must have CAP_SYS_MODULE to be able to trigger a
>>>> module auto-load operation, or CAP_NET_ADMIN for modules with a
>>>> 'netdev-%s' alias.
>>>
>>> Sorry, the magic 'netdev-' prefix is a crawling horror.  To do this
>>
>> Yes I agree, that's the not the best part. I added it for backward
>> compatibility since I did notice that some network daemon retain
>> CAP_NET_ADMIN for this case. The aim of the patches is to get modules
>> autoload covered with CAP_SYS_MODULE and make it more like explicit
>> modules loading.
>>
>>> properly, you need to hand the capability (if any) from the
>>> request_module() call.  Probably by adding a new request_module_cap and
>>> making request_module() call that, then fixing up the callers.
>>
>> Hmm, sorry Rusty I'm a bit confused, when you refer to "callers", you
>> mean request_module() callers ?
>
> Yes.
>
>> If so, I'm not sure that the best thing here since it may defeat the
>> purpose of this feature if we allow to pass capabilities.
>>
>> Right now we have modules autoload that can be triggered without
>> privileges, or with CAP_SYS_ADMIN, CAP_NET_ADMIN, CAP_SYS_MODULE...
>> and some caps may allow to load other modules to resolve symbols etc.
>>
>> The public exploits did target CAP_NET_ADMIN, if we offer a way to
>> pass in capabilities it will be used it as it is the case now without
>> it, not to mention that some capabilities are overloaded, exploits
>> will continue for these ones.
>>
>> The goal is to narrow modules autoload only to CAP_SYS_MODULE or
>> disable it completely for process trees. Later you can give
>> CAP_SYS_MODULE and you are sure that only /lib/modules/ will be
>> autoloaded, no arbitrary loads by using seccomp filter on module
>> syscalls, or separate the process in two one with CAP_SYS_MODULE and
>> the other with its own capabilities and feature use.
>>
>> I also don't like that 'netdev-%s' but it is for compatibility for
>> specific cases, maybe there are others that we may have to add. But I
>> would prefer if we narrow it down to only CAP_SYS_MODULE.
>
> There's one place where this is called, net/core/dev_ioctl.c:
>
>         if (no_module && capable(CAP_NET_ADMIN))
>                 no_module = request_module("netdev-%s", name);
>
> *That's the place* you want to add the exception, and the cleanest way
> is probably to add another arg to __request_module:

Ok I see. I guess we have to add comments that this is for netdev
only, and other parts should continue to go with standard
request_module().


> (incomplete patch, but you get the idea):
>
> diff --git a/include/linux/kmod.h b/include/linux/kmod.h
> index c4e441e00db5..2ea82d5d20af 100644
> --- a/include/linux/kmod.h
> +++ b/include/linux/kmod.h
> @@ -33,15 +33,16 @@ extern char modprobe_path[]; /* for sysctl */
>  /* modprobe exit status on success, -ve on error.  Return value
>   * usually useless though. */
>  extern __printf(2, 3)
> -int __request_module(bool wait, const char *name, ...);
> -#define request_module(mod...) __request_module(true, mod)
> -#define request_module_nowait(mod...) __request_module(false, mod)
> -#define try_then_request_module(x, mod...) \
> -       ((x) ?: (__request_module(true, mod), (x)))
> +int __request_module(bool wait, int allow_cap, const char *name, ...);
>  #else
> -static inline int request_module(const char *name, ...) { return -ENOSYS; }
> -static inline int request_module_nowait(const char *name, ...) { return -ENOSYS; }
> -#define try_then_request_module(x, mod...) (x)
> +static inline __printf(2,3)
> +int __request_module(bool wait, int allow_cap, const char *name, ...)
> +{ return -ENOSYS; }
> +#endif
> +#define request_module(mod...) __request_module(true, -1, mod)
> +#define request_module_nowait(mod...) __request_module(false, -1, mod)
> +#define try_then_request_module(x, mod...) \
> +       ((x) ?: (__request_module(true, -1, mod), (x)))
>  #endif
>
>
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 96899fad7016..9f1217c7cb23 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -889,9 +890,9 @@ static inline int security_kernel_create_files_as(struct cred *cred,
>         return 0;
>  }
>
> -static inline int security_kernel_module_request(char *kmod_name)
> +static inline int security_kernel_module_request(char *kmod_name, int allow_cap)
>  {
> -       return 0;
> +       return cap_kernel_module_request(kmod_name, allow_cap);
>  }
>
>  static inline int security_kernel_read_file(struct file *file,
> diff --git a/kernel/kmod.c b/kernel/kmod.c
> index 563f97e2be36..b2d2f525c80b 100644
> --- a/kernel/kmod.c
> +++ b/kernel/kmod.c
> @@ -110,6 +110,7 @@ static int call_modprobe(char *module_name, int wait)
>  /**
>   * __request_module - try to load a kernel module
>   * @wait: wait (or not) for the operation to complete
> + * @allow_cap: if positive, always allow modprobe if this capability set.

Alright! and just to make sure that this will be true only if the
sysctl "modules_autoload_mode" or "task->modules_autoload_mode" are
not in 'disabled' mode. If disabled, then capability is ignored and
modules autoload is disabled for all or for the related process tree.
Ok I have to document that.



>   * @fmt: printf style format string for the name of the module
>   * @...: arguments as specified in the format string
>   *
> @@ -123,7 +124,8 @@ static int call_modprobe(char *module_name, int wait)
>   * If module auto-loading support is disabled then this function
>   * becomes a no-operation.
>   */
> -int __request_module(bool wait, const char *fmt, ...)
> +
> +int __request_module(bool wait, int allow_cap, const char *fmt, ...)
>  {
>         va_list args;
>         char module_name[MODULE_NAME_LEN];
> @@ -150,7 +152,7 @@ int __request_module(bool wait, const char *fmt, ...)
>         if (ret >= MODULE_NAME_LEN)
>                 return -ENAMETOOLONG;
>
> -       ret = security_kernel_module_request(module_name);
> +       ret = security_kernel_module_request(module_name, allow_cap);
>         if (ret)
>                 return ret;
>
> diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
> index b94b1d293506..e7a7dc28761d 100644
> --- a/net/core/dev_ioctl.c
> +++ b/net/core/dev_ioctl.c
> @@ -367,7 +367,8 @@ void dev_load(struct net *net, const char *name)
>
>         no_module = !dev;
>         if (no_module && capable(CAP_NET_ADMIN))
> -               no_module = request_module("netdev-%s", name);
> +               no_module = __request_module(true, CAP_NET_ADMIN,
> +                                            "netdev-%s", name);
>         if (no_module && capable(CAP_SYS_MODULE))
>                 request_module("%s", name);
>  }
>
> Hope that helps,

Indeed. Thank you!

So I'll wait for more feedback maybe other maintainers want to comment
on this bit, I'll re-send after the merge window.


> Rusty.

Thanks!


-- 
tixxdz
