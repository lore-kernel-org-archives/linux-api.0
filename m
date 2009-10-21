From: Daniel Lezcano <daniel.lezcano-GANU6spQydw@public.gmane.org>
Subject: Re: [RFC][v8][PATCH 0/10] Implement clone3() system call
Date: Wed, 21 Oct 2009 17:53:25 +0200
Message-ID: <4ADF2E75.1020801@free.fr>
References: <20091013044925.GA28181@us.ibm.com> <4AD8C7E4.9000903@free.fr>	<20091016194451.GA28706@us.ibm.com> <4ADCCD68.9030003@free.fr> <4ADCDE7F.4090501@librato.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4ADCDE7F.4090501-RdfvBDnrOixBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oren Laadan <orenl-RdfvBDnrOixBDgjK7y7TUQ@public.gmane.org>
Cc: Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Nathan Lynch <nathanl-V7BBcbaFuwjMbYB6QlFGEg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Louis.Rilling-aw0BnHfMbSpBDgjK7y7TUQ@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Oren Laadan wrote:
>
> Daniel Lezcano wrote:
[ ... ]

>> I forgot to mention a constraint with the specified pid : P2 has to be 
>> child of P1.
>> In other word, you can not specify a pid to clonat which is not your 
>> descendant (including yourself).
>> With this constraint I think there is no security issues.
>
> Sounds dangerous. What if your descendant executed a setuid program ?

That does not happen because you inherit the context of the caller.

>> Concerning of forking on behalf of another process, we can consider it 
>> is up to the caller / programmer to know what it does. If a process in 
>
> Before the user can program with this syscall, _you_ need to define
> the semantics of this syscall. 
Yes, you are right. Here it is the proposition of the semantics.

Function prototype is:

pid_t cloneat(pid_t pid, pid_t hint, struct clone_args *args);

Structure types are:

typedef int clone_flag_t;

struct clone_args {
	clone_flag_t *flags;
	int flags_size;
	u32 reserved1;
	u32 reserved2;
	u64 child_stack_base;
	u64 child_stack_size;
	u64 parent_tid_ptr;
	u64 child_tid_ptr;
	u64 reserved3;
};

With the helper macros:

void CLONE_SET(int flag, clone_flag_t *flags);
void CLONE_CLR(int flag, clone_flag_t *flags);
bool CLONE_ISSET(int flag, clone_flag_t *flags);
void CLONE_ZERO(flag_t *clone_flags);

And:

#define CLONEXT_VM      0x20  /* CLONE_VM>>3 */ 
#define CLONEXT_FS      0x21
#define CLONEXT_FILES   0x22
...

The function clones the current task and reparent the child to the 
process specified in the 'pid' parameter and copy the nsproxy from it 
(if different).

If the 'hint' parameter is different from zero, then the 'hint' value 
will be the pid of the child task, otherwise a value is chosen 
automatically by the system like the usual clone. If the 'hint' is 
specified and the task id is already in use, then the call fails.

The syscall returns the child task id on success, < 0 otherwise.

The specified 'pid' _must_ be a descendant of the caller. This is more 
consistent with the inherited resources with clone in a process 
hierarchy and less dangerous than allowing to cloneat everywhere. The 
caller is at the topmost process hierarchy the cloneat is allowed.

It is not possible for the caller to wait for a process created with 
cloneat where the resulting tasks is not its direct child.

The resources have to be shared across the process hierarchy in order to 
use the right flags to clone. eg. it is not possible to create a thread 
to a child process.

For example:

  P 1
   |
  fork()__________ P 2
   |
   |
   |
   |
 cloneat(P2, 0, { ... flags[0] & CLONE_VM ... } => -EINVAL;


The cloneat syscall can be used for the following use cases:

 * checkpoint / restart:

The restart can be done with a clone(.., CLONE_NEWPID|...);
Then the new pid (aka pid 1) retrieves the proctree from the statefile 
and creates the different tasks with the process hierarchy with the 
cloneat syscall.

The proctree creation can be done from outside of the pid namespace or 
from inside.

Concerning nested pid namespaces, IMHO I would not try to checkpoint / 
restart them. The checkpoint of a nested pid namespace should be 
forbidden except for the leaf of a pid namespaces tree. That should 
allow to do partial process tree checkpoint if the application is aware 
of that and creates a new pid namespace for each subtree it wants to be 
checkpointed.

If this is too restrictive, the struct clone_args can be added with 2 
other fields "unused" for future use.

 * execute a command in a container:

If we have a container with the container init process which is usually 
a child reaper (otherwise daemons are not supported or we have zombie 
factory), we can easily cloneat(initpid, 0, ...) and exec a command. As 
the processes of the container are always reparented to the container 
init, it is safe to do that.

 * clone syscall compatibility + extended clone flags

The cloneat function can be used like the usual clone function with:

    cloneat(getpid(), 0, clone_args);

And the extended clone flags can be used.


[ ... ]

> Can you define more precisely what you mean by "enter" the container ?
>
> If you simply want create a new process in the container, you can
> achieve the same thing with a daemon, or a smart init process (in
> there), or even ptrace tricks.

Yes, you can launch a daemon inside the container, that works for a 
system container because the container is killed by killing the first 
process of the container or by a shutdown inside the container (not 
fully implemented in the kernel).
But this is unreliable for application containers, I won't enter in the 
details but the container exits when the application exits, with a 
daemon inside the container, this is no longer the case because you can 
not detect the application death as the daemon is always there.

With cloneat you restrict the life cycle of the command you launched, 
that is the container exits as soon as all the processes exited the 
container, including the spawned command itself.

> Also, there is a reason why sys_hijack() was hijacked away ... And
> I honestly think that a syscall to force another process to clone
> would be shot down by the kernel guys.
Maybe, maybe not. CLONE_PARENT exists and looks similar to cloneat.

>> Another point. It's another way to extend the exhausted clone  flags as 
>> the cloneat can be called as a compatibility way, with cloneat(getpid(), 
>> 0, ... )
>
> Which is what the proposed new clone_....() does.
Yes, right. What I meant is we still have the clone extension feature 
you have with clone_with_pids.

>>> Note also that 'desiredpid' must be a list of pids (one for each pid
>>> namespaces that the child will belong to) and hence we need 'nr_pids'
>>> to specify the list. Given that we are limited to 6 parameters to the
>>> syscall, such parameters must be stuffed into 'struct clone_args'.
>>>
>>> So we should do something like:
>>>
>>> 	sys_clone3(u32 flags_low, pid_t pid, struct clone_args *carg,
>>> 		pid_t *desired_pids)
>>>
>>> or (to match the name and parameters, move 'pid' parameter into clone_args)
>>>   
>> Well, hiding multiple clone in one clone call is ... weird. AFAIR, there 
>> was a debate between kernel or userspace proctree creation but it looks 
>> like it's done from the kernel with this call.
>
> It isn't multiple clones in one clone. The syscall creates *one* single
> process. We just ask the kernel to assign a specific pid to that process.
>
> And because processes that live in nested pid-namespace own multiple
> pids (one for each level), we need to specify multiple pids (one for
> each level) for this single process that we create.
>
> Then, to create the entire restart process tree, we have to call this
> system call as many times as the number of processes to restart.
>
> And yes, this is all done in userspace. The _only_ kernel-space help
> is an interface to request specific pid(s) for each restarted process.
Aaah, Ok ! I understand better now. Thanks for clarifying this point.

>> I don't really see a difference between sys_restart(pid_t pid , int fd, 
>> long flags) where pid_t is the topmost in the hierarchy, fd is a file 
>> descriptor to a structure "pid_t * + struct clone_args *" and flags is 
>> "PROCTREE".
Ok. Never mind :)


[ ... ]

>
> At this point, I really couldn't care less about how we name the
> new syscall.
>
> Check out the containers IRC channel for the latest pearls:
> clone_plus_with_aloe() and clone_plus_with_aloe_3_args() are
> the prominent contenders, together with xerox() and ditto()...
>
> There you go; these should be enough to keep the discussion
> around on life support for at least another week.
>
> I really really really hope we can settle down on *a* name,
> *any* name, and move forward. Amen.
Amen and Alea Jacta Est :)

Thanks
  -- Daniel
