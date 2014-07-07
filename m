From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH 00/11] Adding FreeBSD's Capsicum security framework
 (part 1)
Date: Mon, 07 Jul 2014 14:20:36 +0200
Message-ID: <53BA9094.9080401@redhat.com>
References: <1404124096-21445-1-git-send-email-drysdale@google.com> <53B51E81.4090700@redhat.com> <20140703183927.GA1629@google.com> <53B651C5.80602@redhat.com> <CAHse=S83APPfnEwO1fQbV_tNd=9zsAsZr42KbYM_He-c3C3P6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <CAHse=S83APPfnEwO1fQbV_tNd=9zsAsZr42KbYM_He-c3C3P6A@mail.gmail.com>
Sender: linux-security-module-owner@vger.kernel.org
To: David Drysdale <drysdale@google.com>
Cc: LSM List <linux-security-module@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Meredydd Luff <meredydd@senatehouse.org>, Kees Cook <keescook@chromium.org>, James Morris <james.l.morris@oracle.com>, Linux API <linux-api@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>
List-Id: linux-api@vger.kernel.org

Il 07/07/2014 12:29, David Drysdale ha scritto:
>> I think that's more easily done by opening the file as O_RDONLY/O_WRONLY
>> /O_RDWR.   You could do it by running the file descriptor's seccomp-bpf
>> program once per iocb with synthesized syscall numbers and argument
>> vectors.
>
> Right, but generating the equivalent seccomp input environment for an
> equivalent single-fd syscall is going to be subtle and complex (which
> are worrying words to mention in a security context).  And how many
> other syscalls are going to need similar special-case processing?
> (poll? select? send[m]msg? ...)

Yeah, the difficult part is getting the right balance between:

1) limitations due to seccomp's impossibility to chase pointers (which 
is not something that can be lifted, as it's required for correctness)

2) subtlety and complexity of the resulting code.

The problem stems when you have a single a single syscall operating on 
multiple file descriptors.  So for example among the cases you mention 
poll and select are problematic; sendm?msg are not.  They would be if 
Capsicum had a capability for SCM_RIGHTS file descriptor passing, but I 
cannot find it.

But then you also have to strike the right balance between a complete 
solution and an overengineered one.

For example, even though poll and select are problematic, I wonder what 
would really the point be in blocking them; poll/select are 
level-triggered, and calling them should be idempotent as far as the 
file descriptor is concerned.  If you want to prevent a process/thread 
from issuing blocking system calls, but you'd do that with a per-process 
filter, not with per-file-descriptor filters or capabilities.

> Capsicum capabilities are associated with the file descriptor (a la
> F_GETFD), not the open file itself -- different FDs with different
> associated rights can map to the same underlying open file.

Good to know, thanks.  I suppose you have testcases that cover this.

Paolo
