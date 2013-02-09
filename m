From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] signalfd: add ability to read siginfo-s without
 dequeuing signals (v2)
Date: Sat, 9 Feb 2013 23:53:04 +0100
Message-ID: <CAKgNAkiYrP046mEv1_GJED5DckJrZSHvwu2u=P_BRxx-NuKALQ@mail.gmail.com>
References: <1358849741-9611-4-git-send-email-avagin@openvz.org>
 <1359486181-29088-1-git-send-email-avagin@openvz.org> <20130207173447.GA5888@redhat.com>
 <CANaxB-xmSiPfbUAh+rQSgVxBzTXmVQcC7U741WYKaasG3_yc5w@mail.gmail.com>
 <20130208191056.GA13674@redhat.com> <CAKgNAki0xt_wwixp7kdv04fKOCtCh-ObQjkFE9PiX6FapkO34A@mail.gmail.com>
 <20130209182239.GA9947@redhat.com>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130209182239.GA9947-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andrey Wagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sat, Feb 9, 2013 at 7:22 PM, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 02/08, Michael Kerrisk (man-pages) wrote:
>>
>> On Fri, Feb 8, 2013 at 8:10 PM, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> >
>> > Well. I do not know. Up to you and Michael.
>> >
>> > But honestly, I can't say this all looks really nice. And why do we
>> > need SIGNALFD_PEEK then?
>>
>> It surely is no beauty. The hope is at least to make it less ugly than it was.
>
> This is subjective, but I am not sure about "less" ;) Yes, we avoid the
> magic offsets, but we add SFD_SHARED/PER_THREAD which need to change
> dequeue_signal plus other complications. And for what?
>
>> > Seriously, perhaps we should simply add signalfd_fops->ioctl() for PEEK.
>> > Or add PTRACE_{PEEK,POKE}_SIGNAL which looks even logical and useful...
>> > And much simpler/straightforward.
>> >
>> > But I am not going to argue.
>>
>> I suppose I had wondered along similar lines, but in a slightly
>> different direction: would the use of a /proc interface to get the
>> queued signals make some sense?
>
> (Can't resist sorry... yes we need /proc/pid/cr or /dev/cr or whatever
>  which dumps almost everything c/r needs without need to add a lot of
>  cr code everywhere).
>
> Perhaps, but I am not sure about the textual representation.
>
> And to me, the best solution is the simplest solution. Please look
> at the patch below. It is trivial. And we can also drop the SFD_RAW
> patch in -mm.

Oleg,

This looks promising, but I am not sure I understand the user-space
API. Could you explain how it would look to (say) pull all per-thread
signals from user space?

Thanks,

Michael


> --- x/kernel/ptrace.c
> +++ x/kernel/ptrace.c
> @@ -618,6 +618,35 @@ static int ptrace_setsiginfo(struct task
>         return error;
>  }
>
> +static int ptrace_peek_signal(struct task_struct *child,
> +                               unsigned long addr, siginfo_t __user *uinfo)
> +{
> +       siginfo_t info;
> +       struct sigpending *pending;
> +       int ret = -ESOMETHING;
> +
> +       pending = &child->pending;
> +       if (addr & PTRACE_PEEK_SHARED) {
> +               addr &= ~PTRACE_PEEK_SHARED;
> +               pending = &child->signal->shared_pending;
> +       }
> +
> +       spin_lock_irq(&child->sighand->siglock);
> +       list_for_each_entry(q, &pending->list, list) {
> +               if (!addr--) {
> +                       copy_siginfo(info, &q->info);
> +                       ret = 0;
> +                       break;
> +               }
> +       }
> +       spin_lock_irq(&child->sighand->siglock);
> +
> +       if (!ret)
> +               ret = copy_siginfo_to_user(uinfo, info);
> +       if (!ret)
> +               ret = __put_user(info, si_code);
> +       return ret;
> +}
>
>  #ifdef PTRACE_SINGLESTEP
>  #define is_singlestep(request)         ((request) == PTRACE_SINGLESTEP)
> @@ -742,6 +771,10 @@ int ptrace_request(struct task_struct *c
>                 ret = put_user(child->ptrace_message, datalp);
>                 break;
>
> +       case PTRACE_PEEKSIGNAL:
> +               ret = ptrace_peek_signal(child, addr, datavp);
> +               break;
> +
>         case PTRACE_GETSIGINFO:
>                 ret = ptrace_getsiginfo(child, &siginfo);
>                 if (!ret)
>



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
