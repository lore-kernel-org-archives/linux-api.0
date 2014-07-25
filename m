From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 10/11] capsicum: prctl(2) to force use of O_BENEATH
Date: Fri, 25 Jul 2014 09:00:33 -0700
Message-ID: <CALCETrUGUuYzvQtHLABh78V4fZJmwqb1Lqk-P65VUdRyrDWLug@mail.gmail.com>
References: <1406296033-32693-1-git-send-email-drysdale@google.com>
 <1406296033-32693-11-git-send-email-drysdale@google.com> <53D26355.9020809@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <53D26355.9020809@redhat.com>
Sender: linux-security-module-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, LSM List <linux-security-module@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Paul Moore <paul@paul-moore.com>, James Morris <james.l.morris@oracle.com>, David Drysdale <drysdale@google.com>, Kees Cook <keescook@chromium.org>, Linux API <linux-api@vger.kernel.org>, Meredydd Luff <meredydd@senatehouse.org>, Christoph Hellwig <hch@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Jul 25, 2014 7:02 AM, "Paolo Bonzini" <pbonzini@redhat.com> wrote:
>
> Il 25/07/2014 15:47, David Drysdale ha scritto:
> > @@ -1996,6 +2013,17 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
> >               if (arg2 || arg3 || arg4 || arg5)
> >                       return -EINVAL;
> >               return current->no_new_privs ? 1 : 0;
> > +     case PR_SET_OPENAT_BENEATH:
> > +             if (arg2 != 1 || arg4 || arg5)
> > +                     return -EINVAL;
> > +             if ((arg3 & ~(PR_SET_OPENAT_BENEATH_TSYNC)) != 0)
> > +                     return -EINVAL;
> > +             error = prctl_set_openat_beneath(me, arg3);
> > +             break;
> > +     case PR_GET_OPENAT_BENEATH:
> > +             if (arg2 || arg3 || arg4 || arg5)
> > +                     return -EINVAL;
> > +             return me->openat_beneath;
> >       case PR_GET_THP_DISABLE:
> >               if (arg2 || arg3 || arg4 || arg5)
> >                       return -EINVAL;
> >
>
> Why are you always forbidding a change of prctl from 1 to 0?  It should
> be safe if current->no_new_privs is clear.

I don't immediately see why you're forbidding unsettling it at all.
If you need it to be sticky, then use seccomp or Capsicum to make it
sticky.

Also, the way implementation is dangerously racy -- if anyone pokes at
adjacent bitfields without the lock, they can get corrupted.  Try
basing on Kees' seccomp tree or security-next and using the new atomic
flags field.


--Andy

>
> Do new threads inherit from the parent?
>
> Also, I wonder if you need something like this check:
>
>         /*
>          * Installing a seccomp filter requires that the task has
>          * CAP_SYS_ADMIN in its namespace or be running with no_new_privs.
>          * This avoids scenarios where unprivileged tasks can affect the
>          * behavior of privileged children.
>          */
>         if (!current->no_new_privs &&
>             security_capable_noaudit(current_cred(), current_user_ns(),
>                                      CAP_SYS_ADMIN) != 0)
>                 return -EACCES;
>
> Paolo
