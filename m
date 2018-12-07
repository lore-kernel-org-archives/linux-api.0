From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH v4] signal: add taskfd_send_signal() syscall
Date: Thu, 6 Dec 2018 18:31:24 -0600
Message-ID: <20181207003124.GA11160@mail.hallyn.com>
References: <20181206121858.12215-1-christian@brauner.io>
 <87sgzahf7k.fsf@xmission.com>
 <D372C766-572C-4897-8F02-2FD0E72CCFAC@brauner.io>
 <875zw6bh2z.fsf@xmission.com>
 <20181206193017.wpxls5p3zgjd6rv2@brauner.io>
 <871s6u9z6u.fsf@xmission.com>
 <20181206213152.gvci7ijr3dokew7w@brauner.io>
 <87o99y72gi.fsf@xmission.com>
 <20181206223948.gyfdtkgbhtozmpsp@brauner.io>
 <20181206231742.xxi4ghn24z4h2qki@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181206231742.xxi4ghn24z4h2qki@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, luto@kernel.org, arnd@arndb.de, serge@hallyn.com, jannh@google.com, akpm@linux-foundation.org, oleg@redhat.com, cyphar@cyphar.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, dancol@google.com, timmurray@google.com, linux-man@vger.kernel.org, keescook@chromium.org, fweimer@redhat.com, tglx@linutronix.de, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Dec 07, 2018 at 12:17:45AM +0100, Christian Brauner wrote:
> On Thu, Dec 06, 2018 at 11:39:48PM +0100, Christian Brauner wrote:
> > On Thu, Dec 06, 2018 at 03:46:53PM -0600, Eric W. Biederman wrote:
> > > Christian Brauner <christian@brauner.io> writes:
> > > 
> > > >> Your intention is to add the thread case to support pthreads once the
> > > >> process case is sorted out.  So this is something that needs to be made
> > > >> clear.  Did I miss how you plan to handle threads?
> > > >
> > > > Yeah, maybe you missed it in the commit message [2] which is based on a
> > > > discussion with Andy [3] and Arnd [4]:
> > > 
> > > Looking at your references I haven't missed it.  You are not deciding
> > > anything as of yet to keep it simple.  Except you are returning
> > > EOPNOTSUPP.  You are very much intending to do something.
> > 
> > That was clear all along and was pointed at every occassion in the
> > threads. I even went through the hazzle to give you all of the
> > references when there's lore.kernel.org.
> > 
> > > 
> > > Decide.  Do you use the flags parameter or is the width of the
> > > target depending on the flags.
> 
> Ok, let's try to be constructive. I understand the general concern for
> the future so let's put a contract into the commit message stating that
> the width of the target aka *what is signaled* will be based on a flag
> parameter if we ever extend it:
> 
> taskfd_send_signal(fd, SIGSTOP, NULL, TASKFD_PGID);
> taskfd_send_signal(fd, SIGSTOP, NULL, TASKFD_TID);
> 
> with the current default being
> 
> taskfd_send_signal(fd, SIGSTOP, NULL, TASKFD_PID);
> 
> This seems to me the cleanest solution as we only use one type of file
> descriptor. Can everyone be on board with this? If so I'm going to send
> out a new version of the patch.
> 
> Christian

I'm on board with this, but I think you need to also clarify what exactly
the fd stands for.  I think that (a) userspace should not have to care
about the struct pid implementation, and so (b) the procfd should stand
for all the pids.  So when taskfd_send_signal(fd, SIGSTOP, NULL, TASKFD_PGID)
becomes implemented, then open(/proc/5) will pin all three pids, as will
open(/proc/5/task/6).

-serge
