From: Daniel Lezcano <daniel.lezcano-GANU6spQydw@public.gmane.org>
Subject: Re: [RFC][v8][PATCH 0/10] Implement clone3() system call
Date: Thu, 22 Oct 2009 13:22:49 +0200
Message-ID: <4AE04089.9020907@free.fr>
References: <20091013044925.GA28181@us.ibm.com> <4AD8C7E4.9000903@free.fr>	<20091016194451.GA28706@us.ibm.com> <4ADCCD68.9030003@free.fr> <4ADCDE7F.4090501@librato.com> <4ADF2E75.1020801@free.fr> <4ADF56D4.8030405@librato.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4ADF56D4.8030405-RdfvBDnrOixBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oren Laadan <orenl-RdfvBDnrOixBDgjK7y7TUQ@public.gmane.org>
Cc: Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Nathan Lynch <nathanl-V7BBcbaFuwjMbYB6QlFGEg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Louis.Rilling-aw0BnHfMbSpBDgjK7y7TUQ@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Oren Laadan wrote:
>
> Daniel Lezcano wrote:
>> Oren Laadan wrote:
>>> Daniel Lezcano wrote:
>> [ ... ]
>>
>>>> I forgot to mention a constraint with the specified pid : P2 has to
>>>> be child of P1.
>>>> In other word, you can not specify a pid to clonat which is not your
>>>> descendant (including yourself).
>>>> With this constraint I think there is no security issues.
>>> Sounds dangerous. What if your descendant executed a setuid program ?
>> That does not happen because you inherit the context of the caller.
>>
>>>> Concerning of forking on behalf of another process, we can consider
>>>> it is up to the caller / programmer to know what it does. If a
>>>> process in 
>>> Before the user can program with this syscall, _you_ need to define
>>> the semantics of this syscall. 
>> Yes, you are right. Here it is the proposition of the semantics.
>>
>> Function prototype is:
>>
>> pid_t cloneat(pid_t pid, pid_t hint, struct clone_args *args);
>>
>> Structure types are:
>>
>> typedef int clone_flag_t;
>>
>> struct clone_args {
>>     clone_flag_t *flags;
>>     int flags_size;
>>     u32 reserved1;
>>     u32 reserved2;
>>     u64 child_stack_base;
>>     u64 child_stack_size;
>>     u64 parent_tid_ptr;
>>     u64 child_tid_ptr;
>>     u64 reserved3;
>> };
>>
>> With the helper macros:
>>
>> void CLONE_SET(int flag, clone_flag_t *flags);
>> void CLONE_CLR(int flag, clone_flag_t *flags);
>> bool CLONE_ISSET(int flag, clone_flag_t *flags);
>> void CLONE_ZERO(flag_t *clone_flags);
>>
>> And:
>>
>> #define CLONEXT_VM      0x20  /* CLONE_VM>>3 */ #define CLONEXT_FS     
>> 0x21
>> #define CLONEXT_FILES   0x22
>> ...
>>
>
> The main motivation for your new syscall is to make it possible to
> inject a process into a namespace. IOW, what you are proposing is
> a new incarnation of sys_hijack().
>
> This is _orthogonal_ to the current discussion, which is about an
> extension for clone to allow (a) choosing target pid(s), (b) more
> flags, and (c) future extensions.
>
> (Your suggested syscall may, too, allow the request a specific set
> of pids for the child process, and reuse the current code for that).
>
> I suggest that you start a new thread about your RFC. This will
> reduce distractions on the current thread, and bring more focus to
> your proposal. I surely will post some comments there :)

I can argue exactly the same thing, the main motivation for your new 
syscall is to make it possible to restart a process tree for a 
checkpoint / restart and this is orthogonal with adding extended clone 
flags :)

But my main motivation is to have the possibility to a) choose a target 
__and__ b) clone the process relatively to another one. These 2 features 
allows to do what *we* need, that is recreate a process tree and the 
bonus with this approach is the ability to inject a process into a 
namespace, something asked by several people, eg. debug with gdb an 
application running into another pid namespace (is not supported today).

I am sorry for coming late in the discussion and for distracting.

> [...]
>
>> The cloneat syscall can be used for the following use cases:
>>
>> * checkpoint / restart:
>>
>> The restart can be done with a clone(.., CLONE_NEWPID|...);
>> Then the new pid (aka pid 1) retrieves the proctree from the statefile
>> and creates the different tasks with the process hierarchy with the
>> cloneat syscall.
>
> s/cloneat/$CLONE3/
> (hint: this is how it's done now)
Of course, what is described is what you does with 'clone3' !
Do you think I will come proposing a variant of 'clone3' not doing what 
you need ? :)

>> The proctree creation can be done from outside of the pid namespace or
>> from inside.
>
> Ew .. why would you do that ?
And why not. Is there a semantic specifying how a process tree should be 
recreated ?

>> Concerning nested pid namespaces, IMHO I would not try to checkpoint /
>> restart them. The checkpoint of a nested pid namespace should be
>> forbidden except for the leaf of a pid namespaces tree. That should
>
> Others (me included) *will* try and may get upset if forbidden...
> Seriously, there is no technical reason to restrict this.

Ok.

>  >> Can you define more precisely what you mean by "enter" the container ?
>>> If you simply want create a new process in the container, you can
>>> achieve the same thing with a daemon, or a smart init process (in
>>> there), or even ptrace tricks.
>> Yes, you can launch a daemon inside the container, that works for a
>> system container because the container is killed by killing the first
>> process of the container or by a shutdown inside the container (not
>> fully implemented in the kernel).
>> But this is unreliable for application containers, I won't enter in the
>> details but the container exits when the application exits, with a
>> daemon inside the container, this is no longer the case because you can
>> not detect the application death as the daemon is always there.
>>
>> With cloneat you restrict the life cycle of the command you launched,
>> that is the container exits as soon as all the processes exited the
>> container, including the spawned command itself.
>
> Then start a daemon _in addition_ to the application, or write a
> daemon that will launch the application and monitor it... And also
> there is ptrace -
Already tried :)

http://lxc.git.sourceforge.net/git/gitweb.cgi?p=lxc/lxc;a=blob;f=src/lxc/lxc_cinit.c;h=8f235483c1a9d9c9e0cc1ba69f1c33f1bc98b8aa;hb=57ff723f6a174a2a01c58c6ac367d118ef12b91c

> But, please let's take this off to a new thread about adding how to
> add a process into a namespace from the outside. FYI, I do think
> such an interface may be useful and nicer than the two alternatives
> I suggested above.
>
>>> Also, there is a reason why sys_hijack() was hijacked away ... And
>>> I honestly think that a syscall to force another process to clone
>>> would be shot down by the kernel guys.
>> Maybe, maybe not. CLONE_PARENT exists and looks similar to cloneat.
>
> Actually, I misread previously; I mean not forcing another process
> to clone, but instead forcing another process to become a parent (and
> I shall ignore the ethical issues :)
>
> I still suspect it won't be welcome. Several people would have liked
> to see CLONE_PARENT go away, too, if that was possible without breaking
> userspace applications. Yet another reason to take it to a discussion
> of its own.

At this point, I am hesitating of creating a new thread for this 
discussion. Because, there will be:
 * clone
 * clone2
 * clone3

and we will discuss again about a new clone syscall with a different API :(

I will not continue arguing on this thread except if someone is in favor 
of cloneat.
Otherwise, I will spawn a new thread later.

Thanks
  -- Daniel
