From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [PATCH 2/2] seccomp.2: document userspace notification
Date: Fri, 1 Mar 2019 07:53:10 -0700
Message-ID: <20190301145310.GC7413@cisco>
References: <20181213001106.15268-1-tycho@tycho.ws>
 <20181213001106.15268-3-tycho@tycho.ws>
 <2cea5fec-e73e-5749-18af-15c35a4bd23c@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2cea5fec-e73e-5749-18af-15c35a4bd23c@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, linux-man@vger.kernel.org, Kees Cook <keescook@chromium.org>, Linux API <linux-api@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Jann Horn <jann@thejh.net>, Oleg Nesterov <oleg@redhat.com>, Christian Brauner <christian@brauner.io>, "Eric W. Biederman" <ebiederm@xmission.com>, Containers <containers@lists.linux-foundation.org>, Aleksa Sarai <asarai@suse.de>, Tyler Hicks <tyhicks@canonical.com>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>
List-Id: linux-api@vger.kernel.org

On Thu, Feb 28, 2019 at 01:52:19PM +0100, Michael Kerrisk (man-pages) wrote:
> > +a notification will be sent to this fd. See "Userspace Notification" below for
> 
> s/fd/file descriptor/ throughout please.

Will do.

> > +more details.
> 
> I think the description here could be better worded as something like:
> 
>     SECCOMP_FILTER_FLAG_NEW_LISTENER
>         Register a new filter, as usual, but on success return a
>         new file descriptor that provides user-space notifications.
>         When the filter returns SECCOMP_RET_USER_NOTIF, a notification
>         will be provided via this file descriptor. The close-on-exec
>         flag is automatically set on the new file descriptor. ...
> 
> >  .RE
> >  .TP
> >  .BR SECCOMP_GET_ACTION_AVAIL " (since Linux 4.14)"
> > @@ -606,6 +613,17 @@ file.
> >  .TP
> >  .BR SECCOMP_RET_ALLOW
> >  This value results in the system call being executed.
> > +.TP
> > +.BR SECCOMP_RET_USER_NOTIF " (since Linux 4.21)"
> 
> Please see the start of this hanging list in the manual page.
> Can you confirm that SECCOMP_RET_USER_NOTIF really is the lowest
> in the precedence order of all of the filter return values?

Oh, no, I didn't realize it was in a particular order. I'll switch it.

> > +Forwards the syscall to an attached listener in userspace to allow userspace to
> 
> s/syscall/system call throughout please.

Will do.

> > +decide what to do with the syscall. If there is no attached listener (either
> > +because the filter was not installed with the
> > +.BR SECCOMP_FILTER_FLAG_NEW_LISTENER
> > +or because the fd was closed), the filter returns
> > +.BR ENOSYS
> > +similar to what happens when a filter returns
> > +.BR SECCOMP_RET_TRACE
> > +and there is no tracer. See "Userspace Notification" below for more details.
> >  .PP
> >  If an action value other than one of the above is specified,
> >  then the filter action is treated as either
> > @@ -693,10 +711,75 @@ Otherwise, if kernel auditing is enabled and the process is being audited
> >  the action is logged.
> >  .IP *
> >  Otherwise, the action is not logged.
> > +.SS Userspace Notification
> > +Interactin userspace notification functionality in seccomp is primarily done
> > +via file descriptor. 
> 
> That sentence is somewhat garbled. Even if I correct the typo, 
> I still don't really understand it. Could you try again?

Maybe "Userspace interacts with the notification functionality via
a file descriptor"? Perhaps we can just delete it.

> > This file descriptor can be obtained by passing
> > +.BR SECCOMP_FILTER_FLAG_NEW_LISTENER
> > +as a filter flag when installing a new filter.
> > +.PP
> > +Once an fd is obtained, userspace can wait for events using
> > +.BR poll ()
> 
> and presumably select() and epoll?
> 
> What kind of notification event do poll(2)/epoll(7)/select(2) provide?
> It looks to be POLLIN/EPOLLIN/readable. Is that correct?
> These details should be noted here. More generally, my assumption
> is that you can use poll(2)/epoll(7)/select(2) to find out about the
> availability of an event, and then use SECCOMP_IOCTL_NOTIF_RECV
> to read that event. Correct? The text needs to be more explicit on
> this.

Yes.

> > +or
> > +.BR ioctl ().
> > +The supported
> > +.BR ioctl ()
> > +operations on a notification fd are:
> > +.TP
> > +.BR SECCOMP_IOCTL_NOTIF_RECV
> > +The argument to this command should be a pointer to a struct seccomp_notif:
> > +.IP
> > +.in +4n
> > +.EX
> > +struct seccomp_notif {
> > +    __u64 id;
> > +    __u32 pid;
> > +    __u32 flags;
> > +    struct seccomp_data data;
> > +};
> > +.EE
> > +.in
> > +.IP
> > +The id field is a filter-unique id for this syscall, and should be supplied in
> > +the response. It can additionally be used in
> > +.BR SECCOMP_IOCTL_ID_VALID
> > +to test whether or not the request is still alive. The pid here is the pid of
> > +the task as visible from the listener's pid namespace. If the pid is not
> > +visible, it is 0. Flags is unused right now. 
> 
> So, is 'flags' explicitly zeroed by the kernel? the manual page should note
> this.

Yes.

> > struct seccomp_data is the same
> > +data that would be passed to a filter running in the kernel.
> 
> What are the semantics if multiple monitoring processes are employing
> SECCOMP_IOCTL_NOTIF_RECV? Does only one of them get awoken? (Which one?)
> Or do they all get woken up and get a 'struct seccomp_notif'? The semantics
> should be detailed here.

Ok. (Only one notification is sent.)

> > +.TP
> > +.BR SECCOMP_IOCTL_NOTIF_SEND
> > +The argument to this command should be a pointer to a struct seccomp_notif_resp:
> > +.IP
> > +.in +4n
> > +.EX
> > +struct seccomp_notif_resp {
> > +    __u64 id;
> > +    __s64 val;
> > +    __s32 error;
> > +    __u32 flags;
> > +};
> > +.EE
> > +.in
> > +.IP
> > +The id should be the id from struct seccomp_notif; if error is non-zero, it is
> > +used as the return value, otherwise val is. Flags must be 0 right now.
> 
> There really isn't enough detail here to help the reader understand. What
> is the purpose of 'error' vs 'val'? In particular, I'm assuming that the
> monitoring process has (at least) two choices with respect to the system 
> call being made by the target process:
> 
> (1) Cause the system call to fail with an error.
> (2) Allow the system call to proceed.
> 
> How are 'error' and 'val' used in these two cases?
> Are there more than these two cases? How else is 'val' used?

This is basically just an artifact that's exposed because some arches
use different registers to return errors vs. successful values. I'll
make a note of that and how the precedence works.

> Also, what happens if the monitoring process does a SECCOMP_IOCTL_NOTIF_RECV,
> but does not subsequently do a SECCOMP_IOCTL_NOTIF_SEND? This should be
> detailed in the manual page.
> 
> What are the semantics if multiple monitoring processes are employing
> SECCOMP_IOCTL_NOTIF_SEND? An error for all but the first? The semantics
> should be detailed here. 

Ok.

> > +.TP
> > +.BR SECCOMP_IOCTL_NOTIF_ID_VALID
> > +The argument to this command is just the id to be tested. There is a pid reuse
> > +issue where a task may make a syscall, die, its pid get re-used, and the
> > +listener may operate on the wrong pid. So the process for handling modifying a
> > +pid's state in some way would be to open the pid's resources (/proc/pid/mem or
> > +similar), do this call to verify that the id is still valid, and then use the
> > +resource. See the sample below for more detail.
> > +.PP
> > +A complete example is available in the kernel tree at
> > +.IR samples/seccomp/user-trap.c .
> >  .SH RETURN VALUE
> >  On success,
> >  .BR seccomp ()
> > -returns 0.
> > +returns 0, unless
> > +.BR SECCOMP_FILTER_FLAG_NEW_LISTENER
> > +was specified, in which case it returns the fd number for the new listener fd.
> >  On error, if
> >  .BR SECCOMP_FILTER_FLAG_TSYNC
> >  was used,
> 
> More generally though, I'm struggling with this patch because "the 
> big picture" is lacking. Here's my estimate of what I think that
> picture is:
> 
> [[
> Instead of having the seccomp() filter decision being made
> within the filter itself, it is possible to pass off the
> decision making to a (different) user-space process that
> makes the decision. This is done using the following steps.
> 
> 1. The "target process" (i.e., process that will
>    establish a seccomp filter) and the process that will make
>    decisions about system calls ("the monitoring process")
>    establish a connection using a UNIX domain socket. This
>    socket will subsequently be used to exchange a file
>    descriptor.
> 
> 2. The "target process" establishes a seccomp BPF filter in the
>    usual manner, but with two notable differences:
> 
>    * The seccomp() 'flags' argument includes the flag
>      SECCOMP_FILTER_FLAG_NEW_LISTENER. Consequently, the return 
>      value  of a successful seccomp() call is a new "listening"
>      file descriptor that can be used for monitoring.
>    * In cases where it is needed, the BPF filter returns the
>      special action SECCOMP_RET_USER_NOTIF. This return value
>      will trigger a notification event.
>      
> 3. The "target process" passes the "listening file descriptor"
>    to the "monitoring process" via the UNIX domain socket.

or some other means, it doesn't have to be with SCM_RIGHTS.

> 4. The target process then performs its workload, which includes
>    system calls that will be controlled by the BPF filter.
>    Whenever one of these system calls causes the BPF filter to
>    return SECCOMP_RET_USER_NOTIF, a notification event is
>    generated on the listening file descriptor.
> 
> 5. The monitoring process will receive notification events
>    on the listening file descriptor. These events are returned
>    as structures of type 'seccomp_notif'. Because this structure
>    and its size may evolve over kernel version, the monitoring
>    process must first determine the size of this structure using
>    the seccomp() SECCOMP_GET_NOTIF_SIZES operation, which
>    returns a structure of type 'seccomp_notif_sizes'. The
>    monitoring process allocates a buffer of size
>    'seccomp_notif_sizes.seccomp_notif' bytes to receive 
>    monitoring events. In addition,the monitoring process
>    allocates another buffer of size 
>    'seccomp_notif_sizes.seccomp_notif_resp' bytes for the
>    response (a 'struct seccomp_notif_resp') that it will
>    provide to the kernel in order to advise how the system
>    call being made by the target process shall be treated.
> 
> 6. The monitoring process can now repeatedly monitor the
>    listening file descriptor.
> 
>    When a SECCOMP_RET_USER_NOTIF-triggered event occurs,
>    the file descriptor will test as readable for 
>    poll(2)/epoll(7)/select(2). The call
> 
>        ioctl(listenfd, SECCOMP_IOCTL_NOTIF_RECV, reqptr)
> 
>    can be used to read info on the event; this operation
>    blocks until an event is available. It populates
>    the 'struct seccomp_notif' pointed to by the third
>    argument with information about the system call
>    that is being attempted by the target process.
>    
> 7. The monitoring process can use the information in the
>    'struct seccomp_notif' to make a determination about the
>    system call being made by the target process. This
>    structure includes a 'data' field that is the same
>    'struct seccomp_data' that is passed to a BPF filter.
> 
>    In addition, the monitoring process may make use of other 
>    information that is available from user space. For example, 
>    it may inspect the memory of the target process (whose PID
>    is provided in the 'struct seccomp_notif') using
>    /proc/PID/mem, which includes inspecting the values

Again, could be ptrace() or /proc/self/map_files/* or whatever,
/proc/PID/mem is just the most convenient.

>    pointed to by system call arguments (whose location is
>    available 'seccomp_notif.data.args). However, when using
>    the target process PID in this way, one must guard against
>    PID re-use race conditions using the seccomp()
>    SECCOMP_IOCTL_NOTIF_ID_VALID operation.
> 
> 8. Having arrived at a decision about the target process's
>    system call, the monitoring process can inform the kernel
>    of its decision using the operation
> 
>        ioctl(listenfd, SECCOMP_IOCTL_NOTIF_SEND, respptr)
> 
>    where the third argument is a pointer to a
>    'struct seccomp_notif_resp'. [Some more details
>    needed here, but I still don't yet understand fully
>    the semantics of the 'error' and 'val' fields.]
> 
> I'd like to include text along the above lines at the start of
> the "Userspace Notification" section. Could you take a look at
> the above and let me know any errors, improved terminology, or
> other improvements generally. I'll then work that text into
> the page.

Yep, looks good to me, thanks.

Tycho
