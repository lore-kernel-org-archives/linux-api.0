From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v2 2/5] clone: add CLONE_PIDFD
Date: Thu, 18 Apr 2019 15:28:23 +0200
Message-ID: <20190418132822.untjt7erfvbbiz7a@brauner.io>
References: <20190418101841.4476-1-christian@brauner.io>
 <20190418101841.4476-3-christian@brauner.io>
 <20190418131206.GB13701@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190418131206.GB13701@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, jannh@google.com, dhowells@redhat.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, serge@hallyn.com, luto@kernel.org, arnd@arndb.de, ebiederm@xmission.com, keescook@chromium.org, tglx@linutronix.de, mtk.manpages@gmail.com, akpm@linux-foundation.org, cyphar@cyphar.com, joel@joelfernandes.org, dancol@google.com
List-Id: linux-api@vger.kernel.org

On Thu, Apr 18, 2019 at 03:12:07PM +0200, Oleg Nesterov wrote:
> On 04/18, Christian Brauner wrote:
> >
> > @@ -1674,13 +1729,14 @@ static __latent_entropy struct task_struct *copy_process(
> >  					unsigned long clone_flags,
> >  					unsigned long stack_start,
> >  					unsigned long stack_size,
> > +					int __user *parent_tidptr,
> >  					int __user *child_tidptr,
> >  					struct pid *pid,
> >  					int trace,
> >  					unsigned long tls,
> >  					int node)
> >  {
> > -	int retval;
> > +	int pidfd = -1, retval;
> 
> it seems that initialization is unneeded, but this is cosmetic.
> 
> I see no technical problems, feel free to add my reviewed-by.

Thank you!

> 
> 
> But let me ask a couple of questions...

Sure!

> 
> 
> Why O_CLOEXEC? I am just curious, I do not really care.

I think that having the file descriptor O_CLOEXEC by default is a good
security measure in general. Most of the time you do not want to pass a
file descriptor through exec() (apart from 0,1,2) and it is usually more
of an issue when you accidently do it then when you accidently don't. So
if users really care about passing a pidfd they should do so by removing
the O_CLOEXEC flag explicitly.
(New file descriptors should probably all default to that but that's just
my opinion.)
Another thing is that for a pidfds it makes even more sense to have them
cloexec by default. You don't want to *unintentionally* leak an fd that
can be used to operate on a process.

> 
> 
> Should we allow CLONE_THREAD | CLONE_PIDFD ?

I think so, yes. I have thought about this. Yes, due to CLONE_FILES |
CLONE_VM you'd necessarily hand the pidfd to the child but threads are
no security boundary in the first place. So if you have a
non-cooperating thread you very much already have a problem. The
situation is not very much different from passing the tid.
Plus, CLONE_PIDFD can make use of the CLONE_UNDETACHED flag in the
future in contrast to all the other flags. So one could potentially (not
saying we have this planned!) add a flag CLONE_PIDFD_KILL_ON_CLOSE (This
is just an improvised bad name rn.) which would cause the child to kill
itself if it does close(pidfd) on its own pidfd and noone else is
holding a reference at which point you'd hand a suicide switch to a new
thread but nothing else.

> 
> 
> Are you sure we will never need to extend this interface? If not, then perhaps it

Well, we can already make use of CLONE_UNDETACHED with CLONE_PIDFD since
we don't just ignore it. :)

> make sense to add something like
> 
> 	if (CLONE_PIDFD) {
> 		unsigned long not_used_yet;
> 		if (get_user(not_used_yet, parent_tidptr) ||
> 		    not_used_yet != 0)
> 			return -EINVAL;

Oh, very interesting point. Yes, I think this is worth it.

> 	}
> 
> this way we can easily add more arguments in future or even turn CLONE_PIDFD into
> CLONE_MORE_ARGS_IN_PARENT_TIDPTR.
> 
> Not that I think this is really good idea, sys_clone2() makes more sense, but still.

No, you're right about leaving this option open. Even if we don't extend
not allowing garbage to be passed is always a good idea.

Christian
