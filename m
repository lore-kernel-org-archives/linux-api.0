From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH 2/5] pidfd: add pidfd_wait()
Date: Fri, 26 Jul 2019 10:24:13 +0200
Message-ID: <20190726082413.n7srvcrqxmvk67z7@brauner.io>
References: <20190724144651.28272-1-christian@brauner.io>
 <20190724144651.28272-3-christian@brauner.io>
 <CAK8P3a0+3wqCzQv-A-QmWTtioFRGjYUvq6QiLysqi9OFs3kJsw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAK8P3a0+3wqCzQv-A-QmWTtioFRGjYUvq6QiLysqi9OFs3kJsw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Joel Fernandes <joel@joelfernandes.org>, Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>, David Howells <dhowells@redhat.com>, Jann Horn <jannh@google.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Aleksa Sarai <cyphar@cyphar.com>, Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Android Kernel Team <kernel-team@android.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jul 26, 2019 at 10:19:55AM +0200, Arnd Bergmann wrote:
> On Wed, Jul 24, 2019 at 4:47 PM Christian Brauner <christian@brauner.io> wrote:
> 
> > +
> > +static int copy_rusage_to_user_any(struct rusage *kru, struct rusage __user *ru)
> > +{
> > +#ifdef CONFIG_COMPAT
> > +       if (in_compat_syscall())
> > +               return put_compat_rusage(kru, (struct compat_rusage __user *)ru);
> > +#endif
> > +       return copy_to_user(ru, kru, sizeof(*kru));
> > +}
> 
> I think this code needs a check for COMPAT_USE_64BIT_TIME in order
> to handle x32 correctly.

Similar to waitid(), indeed.

> 
> It would be nice to introduce it in a separate patch, and then use it
> to kill off
> compat_sys_getrusage() and compat_sys_wait4(), and possibly even
> compat_sys_waitid() in combination with your copy_siginfo_to_user_any().
> That could be done as a cleanup patch afterwards, or as part of your series.

Right, but we won't go the syscall route but instead go the P_PIDFD
route for waitid(). :)

Christian
