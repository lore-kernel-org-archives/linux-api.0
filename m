From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH 00/11] Adding FreeBSD's Capsicum security framework
 (part 1)
Date: Thu, 03 Jul 2014 11:12:33 +0200
Message-ID: <53B51E81.4090700@redhat.com>
References: <1404124096-21445-1-git-send-email-drysdale@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1404124096-21445-1-git-send-email-drysdale@google.com>
Sender: linux-security-module-owner@vger.kernel.org
To: David Drysdale <drysdale@google.com>, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Meredydd Luff <meredydd@senatehouse.org>, Kees Cook <keescook@chromium.org>, James Morris <james.l.morris@oracle.com>, linux-api@vger.kernel.org, qemu-devel <qemu-devel@nongnu.org>
List-Id: linux-api@vger.kernel.org

Il 30/06/2014 12:28, David Drysdale ha scritto:
> Hi all,
>
> The last couple of versions of FreeBSD (9.x/10.x) have included the
> Capsicum security framework [1], which allows security-aware
> applications to sandbox themselves in a very fine-grained way.  For
> example, OpenSSH now (>= 6.5) uses Capsicum in its FreeBSD version to
> restrict sshd's credentials checking process, to reduce the chances of
> credential leakage.

Hi David,

we've had similar goals in QEMU.  QEMU can be used as a virtual machine 
monitor from the command line, but it also has an API that lets a 
management tool drive QEMU via AF_UNIX sockets.  Long term, we would 
like to have a restricted mode for QEMU where all file descriptors are 
obtained via SCM_RIGHTS or /dev/fd, and syscalls can be locked down.

Currently we do use seccomp v2 BPF filters, but unfortunately this 
didn't help very much.  QEMU supports hotplugging hence the filter must 
whitelist anything that _might_ be used in the future, which is 
generally... too much.

Something like Capsicum would be really nice because it attaches 
capabilities to file descriptors.  However, I wonder however how 
extensible Capsicum could be, and I am worried about the proliferation 
of capabilities that its design naturally leads to.

Given Linux's previous experience with BPF filters, what do you think 
about attaching specific BPF programs to file descriptors?  Then 
whenever a syscall is run that affects a file descriptor, the BPF 
program for the file descriptor (attached to a struct file* as in 
Capsicum) would run in addition to the process-wide filter.

An equivalent of PR_SET_NO_NEW_PRIVS can also be added to file 
descriptors, so that a program that doesn't lock down syscalls can still 
lock down the operations (including fcntls and ioctls) on specific file 
descriptors.

Converting FreeBSD capabilities to BPF programs can be easily 
implemented in userspace.

>   [Capsicum also includes 'capability mode', which locks down the
>   available syscalls so the rights restrictions can't just be bypassed
>   by opening new file descriptors; I'll describe that separately later.]

This can also be implemented in userspace via seccomp and 
PR_SET_NO_NEW_PRIVS.

>   [Policing the rights checks anywhere else, for example at the system
>   call boundary, isn't a good idea because it opens up the possibility
>   of time-of-check/time-of-use (TOCTOU) attacks [2] where FDs are
>   changed (as openat/close/dup2 are allowed in capability mode) between
>   the 'check' at syscall entry and the 'use' at fget() invocation.]

In the case of BPF filters, I wonder if you could stash the BPF 
"environment" somewhere and then use it at fget() invocation. 
Alternatively, it can be reconstructed at fget() time, similar to your 
introduction of fgetr().

Thanks,

Paolo
