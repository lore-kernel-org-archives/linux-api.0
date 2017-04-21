From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v3 2/2] modules:capabilities: add a per-task modules
 autoload restriction
Date: Fri, 21 Apr 2017 16:19:05 -0700
Message-ID: <CAGXu5jJBp6VHvDP9182hJgvzS2sBUbUFpmZZ+196K2FcEHUxzw@mail.gmail.com>
References: <1492640420-27345-1-git-send-email-tixxdz@gmail.com>
 <1492640420-27345-3-git-send-email-tixxdz@gmail.com> <CALCETrXFp-apnfRPg9qx6E7g3KDU8DanBW1pMUnA1zShrB5xKg@mail.gmail.com>
 <CAGXu5jJ5dm8yJJ34tEyOP78OxUr2awXmNhm6RaVP8jE4q+L5Ng@mail.gmail.com> <CALCETrUueOx1tqj+Ru93KGpy2HHR-A_GQ6DrAppiomkPTtX7Lw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrUueOx1tqj+Ru93KGpy2HHR-A_GQ6DrAppiomkPTtX7Lw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, "kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org" <kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>, LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dongsu Park <dpark-VwIFZPTo/vqsTnJN9+BGXg@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Arnaldo Carvalho de Melo <acme-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mauro
List-Id: linux-api@vger.kernel.org

On Wed, Apr 19, 2017 at 7:41 PM, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Wed, Apr 19, 2017 at 4:43 PM, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
>> On Wed, Apr 19, 2017 at 4:15 PM, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>>> On Wed, Apr 19, 2017 at 3:20 PM, Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>>> +/* Sets task's modules_autoload */
>>>> +static inline int task_set_modules_autoload(struct task_struct *task,
>>>> +                                           unsigned long value)
>>>> +{
>>>> +       if (value > MODULES_AUTOLOAD_DISABLED)
>>>> +               return -EINVAL;
>>>> +       else if (task->modules_autoload > value)
>>>> +               return -EPERM;
>>>> +       else if (task->modules_autoload < value)
>>>> +               task->modules_autoload = value;
>>>> +
>>>> +       return 0;
>>>> +}
>>>
>>> This needs to be more locked down.  Otherwise someone could set this
>>> and then run a setuid program.  Admittedly, it would be quite odd if
>>> this particular thing causes a problem, but the issue exists
>>> nonetheless.
>>
>> Eeeh, I don't agree this needs to be changed. APIs provided by modules
>> are different than the existing privilege-manipulation syscalls this
>> concern stems from. Applications are already forced to deal with
>> things being missing like this in the face of it simply not being
>> built into the kernel.
>>
>> Having to hide this behind nnp seems like it'd reduce its utility...
>>
>
> I think that adding an inherited boolean to task_struct that can be
> set by unprivileged tasks and passed to privileged tasks is a terrible
> precedent.  Ideally someone would try to find all the existing things
> like this and kill them off.

(Tristate, not boolean, but yeah.)

I see two others besides seccomp and nnp:

PR_MCE_KILL
PR_SET_THP_DISABLE

I really don't think this needs nnp protection.

> I agree that I don't see how one would exploit this particular
> feature, but I still think I dislike the approach.  This is a slippery
> slope to adding a boolean for perf_event_open(), unshare(), etc, and
> we should solve these for real rather than half-arsing them IMO.

I disagree (obviously); this would be protecting the entire module
autoload attack surface. That's hardly a specific control, and it's a
demonstrably needed flag.

-Kees

-- 
Kees Cook
Pixel Security
