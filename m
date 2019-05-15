From: Yann Droneaud <ydroneaud@opteya.com>
Subject: Re: [PATCH 1/2] pid: add pidfd_open()
Date: Wed, 15 May 2019 17:29:16 +0200
Message-ID: <7afb23699142a3a15f06afde43506458a58614a6.camel@opteya.com>
References: <20190515100400.3450-1-christian@brauner.io>
         <4c5ae46657e1931a832def5645db61eb0bf1accd.camel@opteya.com>
         <20190515141634.lrc5ynllcmjr64mn@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190515141634.lrc5ynllcmjr64mn@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: jannh@google.com, oleg@redhat.com, viro@zeniv.linux.org.uk, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, arnd@arndb.de, dhowells@redhat.com, akpm@linux-foundation.org, cyphar@cyphar.com, ebiederm@xmission.com, elena.reshetova@intel.com, keescook@chromium.org, luto@amacapital.net, luto@kernel.org, tglx@linutronix.de, linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, linux-xtensa@linux-xtensa.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-kselftest@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi,

Le mercredi 15 mai 2019 à 16:16 +0200, Christian Brauner a écrit :
> On Wed, May 15, 2019 at 04:00:20PM +0200, Yann Droneaud wrote:
> > Le mercredi 15 mai 2019 à 12:03 +0200, Christian Brauner a écrit :
> > > diff --git a/kernel/pid.c b/kernel/pid.c
> > > index 20881598bdfa..237d18d6ecb8 100644
> > > --- a/kernel/pid.c
> > > +++ b/kernel/pid.c
> > > @@ -451,6 +452,53 @@ struct pid *find_ge_pid(int nr, struct
> > > pid_namespace *ns)
> > >  	return idr_get_next(&ns->idr, &nr);
> > >  }
> > >  
> > > +/**
> > > + * pidfd_open() - Open new pid file descriptor.
> > > + *
> > > + * @pid:   pid for which to retrieve a pidfd
> > > + * @flags: flags to pass
> > > + *
> > > + * This creates a new pid file descriptor with the O_CLOEXEC flag set for
> > > + * the process identified by @pid. Currently, the process identified by
> > > + * @pid must be a thread-group leader. This restriction currently exists
> > > + * for all aspects of pidfds including pidfd creation (CLONE_PIDFD cannot
> > > + * be used with CLONE_THREAD) and pidfd polling (only supports thread group
> > > + * leaders).
> > > + *
> > 
> > Would it be possible to create file descriptor with "restricted"
> > operation ?
> > 
> > - O_RDONLY: waiting for process completion allowed (for example)
> > - O_WRONLY: sending process signal allowed
> 
> Yes, something like this is likely going to be possible in the future.
> We had discussion around this. But mapping this to O_RDONLY and O_WRONLY
> is not the right model. It makes more sense to have specialized flags
> that restrict actions.

Yes, dedicated flags are the way to go. I've used the old open() flags
here as examples as an echo of the O_CLOEXEC flag used in the comment.

> > For example, a process could send over a Unix socket a process a pidfd,
> > allowing this to only wait for completion, but not sending signal ?
> > 
> > I see the permission check is not done in pidfd_open(), so what prevent
> > a user from sending a signal to another user owned process ?
> 
> That's supposed to be possible. You can do the same right now already
> with pids. Tools like LMK need this probably very much.
> Permission checking for signals is done at send time right now.
> And if you can't signal via a pid you can't signal via a pidfd as
> they're both subject to the same permissions checks.
> 

I would have expect it to behave like most other file descriptor,
permission check done at opening time, which allow more privileged
process to open the file descriptor, then pass it to a less privileged
process, or change its own privileged with setuid() and such. Then the
less privileged process can act on behalf of the privileged process
through the file descriptor.

> > If it's in pidfd_send_signal(), then, passing the socket through
> > SCM_RIGHT won't be useful if the target process is not owned by the
> > same user, or root.
> > 

If the permission check is done at sending time, the scenario above
case cannot be implemented.

Sending a pidfd through SCM_RIGHT is only useful if the receiver
process is equally or more privileged than the sender then.

For isolation purpose, I would have expect to be able to give a right
to send a signal to a highly privileged process a specific less
privileged process though Unix socket.

But I can't come up with a specific use case. So I dunno.

Regards.

-- 
Yann Droneaud
OPTEYA
