From: Andrei Vagin <avagin@virtuozzo.com>
Subject: Re: [PATCH RESEND 2/2] pidns: Expose task pid_ns_for_children to
 userspace
Date: Thu, 30 Mar 2017 18:04:10 -0700
Message-ID: <20170331010409.GA22895@outlook.office365.com>
References: <149086931397.4388.9604947335273204415.stgit@localhost.localdomain>
 <149086967937.4388.471494976517194744.stgit@localhost.localdomain>
 <20170330150520.1bdf20e599ff464bda0776b9@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="koi8-r"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170330150520.1bdf20e599ff464bda0776b9@linux-foundation.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>, agruenba@redhat.com, keescook@chromium.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, oleg@redhat.com, paul@paul-moore.com, ebiederm@xmission.com, avagin@openvz.org, linux-fsdevel@vger.kernel.org, mtk.manpages@gmail.com, luto@amacapital.net, mingo@kernel.org, serge@hallyn.com
List-Id: linux-api@vger.kernel.org

On Thu, Mar 30, 2017 at 03:05:20PM -0700, Andrew Morton wrote:
> On Thu, 30 Mar 2017 13:27:59 +0300 Kirill Tkhai <ktkhai@virtuozzo.com> wrote:
> 
> > pid_ns_for_children set by a task is known only to the task itself,
> > and it's impossible to identify it from outside.
> > 
> > It's a big problem for checkpoint/restore software like CRIU,
> > because it can't correctly handle tasks, that do setns(CLONE_NEWPID)
> > in proccess of their work.
> > 
> > This patch solves the problem, and it exposes pid_ns_for_children
> > to ns directory in standard way with the name "pid_for_children":
> > 
> > ~# ls /proc/5531/ns -l | grep pid
> > lrwxrwxrwx 1 root root 0 Jan 14 16:38 pid -> pid:[4026531836]
> > lrwxrwxrwx 1 root root 0 Jan 14 16:38 pid_for_children -> pid:[4026532286]
> > 
> > --- a/fs/proc/namespaces.c
> > +++ b/fs/proc/namespaces.c
> > @@ -23,6 +23,7 @@ static const struct proc_ns_operations *ns_entries[] = {
> >  #endif
> >  #ifdef CONFIG_PID_NS
> >  	&pidns_operations,
> > +	&pidns_for_children_operations,
> >  #endif
> 
> This interface should be documented somewhere under Documentation/. 
> But I can't immediately find where the /proc/pid/ns/ pseudo-files are
> documented...

I know that they are documented in man7/namespaces.7

https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git/tree/man7/namespaces.7#n187

> 
> 
