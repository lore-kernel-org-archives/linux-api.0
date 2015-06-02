From: Tycho Andersen <tycho.andersen@canonical.com>
Subject: Re: [PATCH] seccomp: add ptrace commands for suspend/resume
Date: Tue, 2 Jun 2015 09:46:14 -0600
Message-ID: <20150602154614.GG1823@hopstrocity>
References: <1433186918-9626-1-git-send-email-tycho.andersen@canonical.com>
 <CALCETrVaE5UsTSQDf=48R8J9gG6YiMdp30wOMD+aZvxtOjrLRQ@mail.gmail.com>
 <20150601194707.GA2818@hopstrocity>
 <CALCETrU2c99wQHfVS6Bi_7=sAYSr-gEUpRdgz=+FiGgGxbPyMg@mail.gmail.com>
 <20150601201233.GC2818@hopstrocity>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150601201233.GC2818@hopstrocity>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Will Drewry <wad@chromium.org>, Roland McGrath <roland@hack.frob.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@parallels.com>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>
List-Id: linux-api@vger.kernel.org

Hi Andy,

On Mon, Jun 01, 2015 at 02:12:33PM -0600, Tycho Andersen wrote:
> On Mon, Jun 01, 2015 at 12:51:12PM -0700, Andy Lutomirski wrote:
> > On Mon, Jun 1, 2015 at 12:47 PM, Tycho Andersen
> > <tycho.andersen@canonical.com> wrote:
> > > On Mon, Jun 01, 2015 at 12:38:57PM -0700, Andy Lutomirski wrote:
> > >> On Mon, Jun 1, 2015 at 12:28 PM, Tycho Andersen
> > >> > +int resume_seccomp(struct task_struct *task)
> > >> > +{
> > >> > +       int ret = -EACCES;
> > >> > +
> > >> > +       spin_lock_irq(&task->sighand->siglock);
> > >> > +
> > >> > +       if (!capable(CAP_SYS_ADMIN))
> > >> > +               goto out;
> > >> > +
> > >> > +       task->seccomp.suspended = false;
> > >> > +
> > >> > +#ifdef TIF_NOTSC
> > >> > +       if (task->seccomp.mode == SECCOMP_MODE_STRICT)
> > >> > +               set_tsk_thread_flag(task, TIF_NOTSC);
> > >> > +#endif
> > >>
> > >> Ditto.  Or can the task not be running here?
> > >
> > > It is stopped since ptrace requires it to be stopped; I don't know if
> > > that's enough to guarantee correctness, though. Is there some
> > > additional barrier that is needed?
> > 
> > Dunno.  Does ptrace actually guarantee that for new operations?
> 
> It seems to; it kept giving me ESRCH when I didn't wait for it to
> stop. I'll poke around and see if I can confirm this via the code.

It looks to me like ptrace does guarantee this. The commands that
don't require a task to be stopped are all special cases in the ptrace
syscall definition, and anything that's not one of those is protected
by a ptrace_check_attach(), which IIUC enforces that the task is
stopped.

Tycho
