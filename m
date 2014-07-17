From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v11 11/11] seccomp: implement SECCOMP_FILTER_FLAG_TSYNC
Date: Thu, 17 Jul 2014 08:45:52 -0700
Message-ID: <CAGXu5j+dFZdnnK8f-HRrUs2vLeyhWyHh_AY-OynDcp-Ye+dy7Q@mail.gmail.com>
References: <1405547442-26641-1-git-send-email-keescook@chromium.org>
	<1405547442-26641-12-git-send-email-keescook@chromium.org>
	<CAHse=S_32tmusk4ceY4U6GbNpX4PkX12iPPDZFVZ7qgv-RAooA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHse=S_32tmusk4ceY4U6GbNpX4PkX12iPPDZFVZ7qgv-RAooA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexei Starovoitov <ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Julien Tinnes <jln-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Linux MIPS Mailing List <linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jul 17, 2014 at 8:04 AM, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> On Wed, Jul 16, 2014 at 10:50 PM, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
>> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
>> index 9065d2c79c56..2125b83ccfd4 100644
>> +/**
>> + * seccomp_can_sync_threads: checks if all threads can be synchronized
>> + *
>> + * Expects sighand and cred_guard_mutex locks to be held.
>> + *
>> + * Returns 0 on success, -ve on error, or the pid of a thread which was
>> + * either not in the correct seccomp mode or it did not have an ancestral
>> + * seccomp filter.
>> + */
>> +static inline pid_t seccomp_can_sync_threads(void)
>> +{
>> +       struct task_struct *thread, *caller;
>> +
>> +       BUG_ON(!mutex_is_locked(&current->signal->cred_guard_mutex));
>> +       BUG_ON(!spin_is_locked(&current->sighand->siglock));
>> +
>> +       if (current->seccomp.mode != SECCOMP_MODE_FILTER)
>> +               return -EACCES;
>
> Quick question -- is it possible to apply the first filter and also synchronize
> it across threads in the same operation?  If so, does this arm also need to
> cope with seccomp.mode being SECCOMP_MODE_DISABLED?
>
> [seccomp_set_mode_filter() looks to call this via seccomp_attach_filter()
> before it does seccomp_assign_mode()]

I don't entirely understand what you're asking. The threads gain the
filter and the mode before the current thread may gain the mode (if
it's the first time this has been called). Due to all the locks,
though, this isn't a problem. Is there a situation you see where there
might be a problem?

-Kees

-- 
Kees Cook
Chrome OS Security
