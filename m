From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup: Add new capability to allow a process to migrate
 other tasks between cgroups
Date: Wed, 19 Oct 2016 16:51:11 -0400
Message-ID: <20161019205111.GF3044@htj.duckdns.org>
References: <1476743724-9104-1-git-send-email-john.stultz@linaro.org>
 <CALCETrXrZpLH8NsSmaoH5ChW5+6Zb=nLsznj=x4jeWUjpQ-ecA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrXrZpLH8NsSmaoH5ChW5+6Zb=nLsznj=x4jeWUjpQ-ecA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: John Stultz <john.stultz@linaro.org>, lkml <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>, Jonathan Corbet <corbet@lwn.net>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, Android Kernel Team <kernel-team@android.com>, Rom Lemarchand <romlem@android.com>, Colin Cross <ccross@android.com>, Dmitry Shmidt <dimitrysh@google.com>, Ricky Zhou <rickyz@chromium.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Todd Kjos <tkjos@google.com>, Christian Poetzsch <christian.potzsch@imgtec.com>, Amit Pundir <amit.pundir@linaro.org>, "Serge E . Hallyn" <serge@hallyn.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Hello, Andy.

On Mon, Oct 17, 2016 at 03:40:37PM -0700, Andy Lutomirski wrote:
> > @@ -2856,7 +2856,8 @@ static int cgroup_procs_write_permission(struct task_struct *task,
> >          */
> >         if (!uid_eq(cred->euid, GLOBAL_ROOT_UID) &&
> >             !uid_eq(cred->euid, tcred->uid) &&
> > -           !uid_eq(cred->euid, tcred->suid))
> > +           !uid_eq(cred->euid, tcred->suid) &&
> > +           !ns_capable(tcred->user_ns, CAP_CGROUP_MIGRATE))
> >                 ret = -EACCES;
> 
> This logic seems rather confused to me.  Without this patch, a user
> can write to procs if it's root *or* it matches the target uid *or* it
> matches the target suid.  How does this make sense?  How about
> ptrace_may_access(...) || ns_capable(tcred->user_ns,
> CAP_CGROUP_MIGRATE)?

Yeah, it's weird.  The problem is that there was no delegation model
defined on v1 and it used a hybrid of file + ptracey access checks.
The goal, I think, was disallowing !root user from pulling in random
tasks into a cgroup it has write access to, which was possible because
there was no isolation on the delegation boundary.

Given how long it has been out in the wild, I don't think changing the
logic is a good idea.  We should simply replace GLOBAL_ROOT_UID test
with CAT_WHATEVER_WE_PICK test and just ignore the whole thing on v2.

Thanks.

-- 
tejun
