From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v4] signal: add taskfd_send_signal() syscall
Date: Fri, 7 Dec 2018 02:54:25 +0100
Message-ID: <20181207015423.4miorx43l3qhppfz@brauner.io>
References: <20181206193017.wpxls5p3zgjd6rv2@brauner.io>
 <871s6u9z6u.fsf@xmission.com>
 <20181206213152.gvci7ijr3dokew7w@brauner.io>
 <87o99y72gi.fsf@xmission.com>
 <20181206223948.gyfdtkgbhtozmpsp@brauner.io>
 <20181206231742.xxi4ghn24z4h2qki@brauner.io>
 <20181207003124.GA11160@mail.hallyn.com>
 <CAKOZuevgF7ObKcVvu-iuNK3xLMX2Ze_S+adBEGNZCdfXRibh1A@mail.gmail.com>
 <20181207005917.GA11302@mail.hallyn.com>
 <CAKOZuesqmPvYoibx3MvVj86EMWRRW4My=7n6iiiBJa+MXo-GJA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKOZuesqmPvYoibx3MvVj86EMWRRW4My=7n6iiiBJa+MXo-GJA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Tim Murray <timmurray@google.com>, linux-man <linux-man@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Florian Weimer <fweimer@redhat.com>, tglx@linutronix.de, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Dec 06, 2018 at 05:39:18PM -0800, Daniel Colascione wrote:
> On Thu, Dec 6, 2018 at 4:59 PM Serge E. Hallyn <serge@hallyn.com> wrote:
> >
> > On Thu, Dec 06, 2018 at 04:34:54PM -0800, Daniel Colascione wrote:
> > > On Thu, Dec 6, 2018 at 4:31 PM Serge E. Hallyn <serge@hallyn.com> wrote:
> > > >
> > > > On Fri, Dec 07, 2018 at 12:17:45AM +0100, Christian Brauner wrote:
> > > > > On Thu, Dec 06, 2018 at 11:39:48PM +0100, Christian Brauner wrote:
> > > > > > On Thu, Dec 06, 2018 at 03:46:53PM -0600, Eric W. Biederman wrote:
> > > > > > > Christian Brauner <christian@brauner.io> writes:
> > > > > > >
> > > > > > > >> Your intention is to add the thread case to support pthreads once the
> > > > > > > >> process case is sorted out.  So this is something that needs to be made
> > > > > > > >> clear.  Did I miss how you plan to handle threads?
> > > > > > > >
> > > > > > > > Yeah, maybe you missed it in the commit message [2] which is based on a
> > > > > > > > discussion with Andy [3] and Arnd [4]:
> > > > > > >
> > > > > > > Looking at your references I haven't missed it.  You are not deciding
> > > > > > > anything as of yet to keep it simple.  Except you are returning
> > > > > > > EOPNOTSUPP.  You are very much intending to do something.
> > > > > >
> > > > > > That was clear all along and was pointed at every occassion in the
> > > > > > threads. I even went through the hazzle to give you all of the
> > > > > > references when there's lore.kernel.org.
> > > > > >
> > > > > > >
> > > > > > > Decide.  Do you use the flags parameter or is the width of the
> > > > > > > target depending on the flags.
> > > > >
> > > > > Ok, let's try to be constructive. I understand the general concern for
> > > > > the future so let's put a contract into the commit message stating that
> > > > > the width of the target aka *what is signaled* will be based on a flag
> > > > > parameter if we ever extend it:
> > > > >
> > > > > taskfd_send_signal(fd, SIGSTOP, NULL, TASKFD_PGID);
> > > > > taskfd_send_signal(fd, SIGSTOP, NULL, TASKFD_TID);
> > > > >
> > > > > with the current default being
> > > > >
> > > > > taskfd_send_signal(fd, SIGSTOP, NULL, TASKFD_PID);
> > > > >
> > > > > This seems to me the cleanest solution as we only use one type of file
> > > > > descriptor. Can everyone be on board with this? If so I'm going to send
> > > > > out a new version of the patch.
> > > > >
> > > > > Christian
> > > >
> > > > I'm on board with this, but I think you need to also clarify what exactly
> > > > the fd stands for.  I think that (a) userspace should not have to care
> > > > about the struct pid implementation, and so (b) the procfd should stand
> > > > for all the pids.  So when taskfd_send_signal(fd, SIGSTOP, NULL, TASKFD_PGID)
> > > > becomes implemented, then open(/proc/5) will pin all three pids, as will
> > > > open(/proc/5/task/6).
> > >
> > > This change doesn't "pin" any PID, and it makes no sense to make a
> > > process FD stand for all its threads. What does that even mean?
> >
> > Currently the patch relies on the procfd inode saving a copy to the PIDTYPE_PID
> > pid.
> 
> struct pid doesn't have a type field. The interpretation depends on
> the caller's use of the struct pid, and in the current path, that's
> PIDTYPE_PID. What, specifically, is wrong with the current approach?
> 
> > I'm not sure offhand, can it go to the PIDTYPE_PGID from that after the
> > task has died, or not?   I didn't think so.  If it can then great.
> 
> You're arguing that something that does, in fact, work, is somehow
> broken in some unspecified way. The kill_pid_info lookup works fine.
> What, specifically, is wrong with the semantics as implemented?
> 
> > The point is (a) these are details which should not have to bother userspace,
> 
> These details *don't* bother userspace.
> 
> You're raising concerns that are either imaginary or long-since
> addressed. Does the patch cause some kind of maintenance burden? No,
> it doesn't, not moreso than any other piece of code. Does the
> interface have unclear semantics? No, it clearly sends a signal to a
> process, just like kill. Does the patch expose kernel implementation
> details? No, it doesn't, because the interface is simply not defined
> in terms of these details. Do we need to change how signal delivery
> works? No, because if it's fine for kill, it's fine for this facility,
> and if some future signal cleanup separates the cases more, that
> cleanup can change this code as well.
> 
> The change is well-documented, simple, extensible, and addresses an
> actual problem. Every legitimate technical criticism has now been
> addressed. I don't understand where this opposition is coming from,
> since the objections refer to nothing that's actually in the patch or
> exposed to the user.
> 
> > and (b) how to decide who we're sending the signal to (tid/pid/pgid) should
> > be specified in precisely one way.  So either a flag, or comign from the type
> > of fd that was opened.
> 
> You can't send signals to a thread with the current patch. There's no
> ambiguity in providing zero ways to do something.

So Serge's point is not about changing the current patch. What he's
basically saying is: If we are expected to state how we were to extend
this syscall in the future which Serge and I figured is currently Eric's
only remaining objection then:
- flags are a good way to go (I agree)
- there's a concrete way how to do this by stashing the relevent struct
  pids for PIDTYPE_PID, PIDTYPE_TGID, PIDTYPE_PGID in file->private_data
  which can then be retrieved in taskfd_send_signal()

There is not intent nor requirement to do this right now. What we have
right now is fine for a start, I agree! But here's how we go forward if
we ever need to! :)

Christian
