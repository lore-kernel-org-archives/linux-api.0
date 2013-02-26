From: Andrey Wagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] ptrace: add ability to retrieve signals without removing
 from a queue (v2)
Date: Tue, 26 Feb 2013 11:33:39 +0400
Message-ID: <CANaxB-x2uzgyd-EmhtyDcKJ6+bB1onL_ftmuZpCTLXnm5z-dcg@mail.gmail.com>
References: <1361786813-14652-1-git-send-email-avagin@openvz.org>
	<20130225141234.99b76738.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130225141234.99b76738.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland McGrath <roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Pedro Alves <palves-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Andrew, thank you for the comments. I will fix them and send a new
patch. A few comments are inline.

2013/2/26 Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>:
> On Mon, 25 Feb 2013 14:06:53 +0400
>> +     for (i = 0; i < arg.nr; i++) {
>> +             off = arg.off + i;
>
> "long long" = "u64" + "int".
>
> Wanna have a little think about what we're doing here, see if we can
> pick the most appropriate types?

A number of signal has the type int, because the system call ptrace()
return "int" and my interface supposed to return a number of dumped
signals.
"off" is signed to check on a negative value and it can not be more
then MAX_RAM / sizeof(siginfo), so
long long is enough. It can be changed on s64 for avoiding misleading.

>
> `off' could be made local to this loop, which is a bit neater.
>
>> +             spin_lock_irq(&child->sighand->siglock);
>> +             list_for_each_entry(q, &pending->list, list) {
>> +                     if (!off--) {
>> +                             copy_siginfo(&info, &q->info);
>> +                             break;
>> +                     }
>> +             }
>> +             spin_unlock_irq(&child->sighand->siglock);
>> +
>> +             if (off >= 0)
>> +                     break;
>
> <scratches head>
>
> Oh I see what you did there - the user requested an entry which is
> beyond the end of the list? A code comment would be nice.
>
> What's the return value in this case?  "i".  So how does userspace find
> out what happened?

The request PTRACE_PEEKSIGINFO returns a number of dumped signals. If
a signal with the specified sequence number doesn't exist, ptrace
returns 0.

>
> Please fully describe the interface so things such as this can be
> understood.
>
>> +#ifdef CONFIG_COMPAT
>> +             if (unlikely(is_compat_task())) {
>> +                     compat_siginfo_t __user *uinfo = compat_ptr(data);
>> +
>> +                     ret = copy_siginfo_to_user32(uinfo, &info);
>> +                     if (!ret)
>> +                             ret = __put_user(info.si_code, &uinfo->si_code);
>> +             } else
>> +#endif
>> +             {
>> +                     siginfo_t __user *uinfo = (siginfo_t __user *) data;
>> +
>> +                     ret = copy_siginfo_to_user(uinfo, &info);
>> +                     if (!ret)
>> +                             ret = __put_user(info.si_code, &uinfo->si_code);
>> +             }
>> +
>> +             if (ret)
>> +                     break;
>> +
>> +             data += sizeof(siginfo_t);
>> +
>> +             if (signal_pending(current)) {
>> +                     i++;
>
> What does the i++ do?

For accounting a current siginfo. I will add a comment here.

>
>> +                     break;
>> +             }
>> +
>> +             cond_resched();
>> +     }
>> +
>> +     return i ? : ret;
>
> I hate that gcc thing :(
>
> Also, is it buggy?  `ret' might be -EFAULT here.  We appear to be using
> read() return semantics here?

I have tried to implement read() semantics here. ptrace() returns a
number of dumped signals even if dumping of the last signal is failed.
And it returns an error if not one signal has been dumped
successfully.

The similar logic is used in read()
generic_file_aio_read()
....
                retval += desc.written;
                if (desc.error) {
                        retval = retval ?: desc.error;
                        break;
                }

Thanks,
  Andrey
