From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v3] signal: add procfd_send_signal() syscall
Date: Thu, 6 Dec 2018 04:08:12 +0100
Message-ID: <20181206030810.jo5julsc4v5zy34z@brauner.io>
References: <20181205092203.14105-1-christian@brauner.io>
 <87zhtjn8ck.fsf@xmission.com>
 <20181205205242.hxgba5opiapinj56@brauner.io>
 <CAGXu5jJgYyhUBgzfkkcHGtu6AcC4MBpfwcEoj3M=Y+8q0FZ_dA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5jJgYyhUBgzfkkcHGtu6AcC4MBpfwcEoj3M=Y+8q0FZ_dA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Daniel Colascione <dancol@google.com>, Tim Murray <timmurray@google.com>, linux-man <linux-man@vger.kernel.org>, Florian Weimer <fweimer@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Dec 05, 2018 at 03:24:08PM -0800, Kees Cook wrote:
> On Wed, Dec 5, 2018 at 12:53 PM Christian Brauner <christian@brauner.io> wrote:
> > On Wed, Dec 05, 2018 at 12:20:43PM -0600, Eric W. Biederman wrote:
> > > Christian Brauner <christian@brauner.io> writes:
> > > > [1]:  https://lkml.org/lkml/2018/11/18/130
> > > > [2]:  https://lore.kernel.org/lkml/874lbtjvtd.fsf@oldenburg2.str.redhat.com/
> > > > [3]:  https://lore.kernel.org/lkml/20181204132604.aspfupwjgjx6fhva@brauner.io/
> > > > [4]:  https://lore.kernel.org/lkml/20181203180224.fkvw4kajtbvru2ku@brauner.io/
> > > > [5]:  https://lore.kernel.org/lkml/20181121213946.GA10795@mail.hallyn.com/
> > > > [6]:  https://lore.kernel.org/lkml/20181120103111.etlqp7zop34v6nv4@brauner.io/
> > > > [7]:  https://lore.kernel.org/lkml/36323361-90BD-41AF-AB5B-EE0D7BA02C21@amacapital.net/
> > > > [8]:  https://lore.kernel.org/lkml/87tvjxp8pc.fsf@xmission.com/
> > > > [9]:  https://asciinema.org/a/X1J8eGhe3vCfBE2b9TXtTaSJ7
> > > > [10]: https://lore.kernel.org/lkml/20181203180224.fkvw4kajtbvru2ku@brauner.io/
> > > > [11]: https://lore.kernel.org/lkml/F53D6D38-3521-4C20-9034-5AF447DF62FF@amacapital.net/
> 
> I nominate this for 2018's most-well-documented syscall commit log award. ;)

Hahaha. If I win can I get my price in beer(s)? :)

> 
> > > > +   /*
> > > > +    * Give userspace a way to detect whether /proc/<pid>/task/<tid> fds
> > > > +    * are supported.
> > > > +    */
> > > > +   ret = -EOPNOTSUPP;
> > > > +   if (proc_is_tid_procfd(f.file))
> > > > +           goto err;
> > >
> > >       -EBADF is the proper error code.
> >
> > This is done so that userspace has a way of figuring out that tid fds
> > are not yet supported. This has been discussed with Florian (see commit
> > message).
> 
> Right, we should keep this -EOPNOTSUPP.
> 
> > > > +   /* Is this a procfd? */
> > > > +   ret = -EINVAL;
> > > > +   if (!proc_is_tgid_procfd(f.file))
> > > > +           goto err;
> > >
> > >       -EBADF is the proper error code.
> 
> Yeah, EINVAL tends to be used for bad flags... this is more about an
> improper fd.
> 
> > >
> > > > +   /* Without CONFIG_PROC_FS proc_pid() returns NULL. */
> > > > +   pid = proc_pid(file_inode(f.file));
> > > > +   if (!pid)
> > > > +           goto err;
> > >
> > > Perhaps you want to fold the proc_pid into the proc_is_tgid_procfd
> > > call.  That way proc_pid can stay private to proc.
> >
> > Hm, I guess we can do that for now. My intention was to have reuseable
> > helpers but I guess it would be fine for now.
> >
> > >
> > > > +   if (!may_signal_procfd(pid))
> > > > +           goto err;
> > > > +
> 
> Does the ns parent checking in may_signal_procfd need any locking or
> RCU? I know pid and current namespaces are "pinned", but I don't know
> how parent ns works here. I'm assuming the parents are stuck until all
> children go away?

Yeah, since they are hierarchical killing an ancestor means killing the
children. Also, in case you're interested, there's precedent for that:
kernel/pid_namespace.c:static struct ns_common *pidns_get_parent(struct ns_common *ns)
I'm not using this function because a) I would have to special case the
initial test-case and b) it takes a get() on the pid ns which would
force us to use another put which is unnecessary.

> 
> > > > +   ret = kill_pid_info(sig, &kinfo, pid);
> 
> Just double-checking for myself: this does not bypass
> security_task_kill(), so no problem there AFAIK.
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>

Thanks! :)
As a sidenote I'm switching the name from procfd_send_signal() to
taskfd_send_signal(). It seems to me the best way to handle Eric's
request to reflect that we can eventually both signal tgids and tids.

> 
> -- 
> Kees Cook
