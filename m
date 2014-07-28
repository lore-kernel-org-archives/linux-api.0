From: Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCHv2 00/11] Adding FreeBSD's Capsicum security framework
Date: Mon, 28 Jul 2014 14:30:19 +0200
Message-ID: <53D6425B.40009@redhat.com>
References: <1406296033-32693-1-git-send-email-drysdale@google.com> <871tt796i0.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <871tt796i0.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Il 26/07/2014 23:04, Eric W. Biederman ha scritto:
>> The most significant aspect of Capsicum is associating *rights* with
>> (some) file descriptors, so that the kernel only allows operations on an
>> FD if the rights permit it.  This allows userspace applications to
>> sandbox themselves by tightly constraining what's allowed with both
>> input and outputs; for example, tcpdump might restrict itself so it can
>> only read from the network FD, and only write to stdout.
>>
>> The kernel thus needs to police the rights checks for these file
>> descriptors (referred to as 'Capsicum capabilities', completely
>> different than POSIX.1e capabilities), and the best place to do this is
>> at the points where a file descriptor from userspace is converted to a
>> struct file * within the kernel.
>>
>>   [Policing the rights checks anywhere else, for example at the system
>>   call boundary, isn't a good idea because it opens up the possibility
>>   of time-of-check/time-of-use (TOCTOU) attacks [2] where FDs are
>>   changed (as openat/close/dup2 are allowed in capability mode) between
>>   the 'check' at syscall entry and the 'use' at fget() invocation.]
>>
>> However, this does lead to quite an invasive change to the kernel --
>> every invocation of fget() or similar functions (fdget(),
>> sockfd_lookup(), user_path_at(),...) needs to be annotated with the
>> rights associated with the specific operations that will be performed on
>> the struct file.  There are ~100 such invocations that need
>> annotation.
> 
> And it is silly.  Roughly you just need a locking version of
> fcntl(F_SETFL).
> 
> That is make the restriction in the struct file not in the fd to file
> lookup.

No, they have to be in the file descriptor.  The same file descriptor
can be dup'ed and passed with different capabilities to different processes.

Say you pass an eventfd to a process with SCM_RIGHTS, and you want to
only allow the process to write to it.

>> 4) New System Calls
>> -------------------
>>
>> To allow userspace applications to access the Capsicum capability
>> functionality, I'm proposing two new system calls: cap_rights_limit(2)
>> and cap_rights_get(2).  I guess these could potentially be implemented
>> elsewhere (e.g. as fcntl(2) operations?) but the changes seem
>> significant enough that new syscalls are warranted.
>>
>>   [FreeBSD 10.x actually includes six new syscalls for manipulating the
>>   rights associated with a Capsicum capability -- the capability rights
>>   can police that only specific fcntl(2) or ioctl(2) commands are
>>   allowed, and FreeBSD sets these with distinct syscalls.]
> 
> ioctls?  In a sandbox?  Ick.

KVM?  X11?  Both of them use loads of ioctls.  I'm less sure of the
benefit of picking which fcntls to allow.

Paolo
