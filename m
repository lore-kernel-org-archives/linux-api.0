From: Alexei Starovoitov <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 00/11] Adding FreeBSD's Capsicum security framework
 (part 1)
Date: Mon, 7 Jul 2014 15:33:52 -0700
Message-ID: <CAADnVQ+c2E6eG_juEDh-GyheveqScxQ=98jqO1ZOjp1PgfVBGQ@mail.gmail.com>
References: <1404124096-21445-1-git-send-email-drysdale@google.com>
	<53B51E81.4090700@redhat.com>
	<20140703183927.GA1629@google.com>
	<53B651C5.80602@redhat.com>
	<CAHse=S83APPfnEwO1fQbV_tNd=9zsAsZr42KbYM_He-c3C3P6A@mail.gmail.com>
	<53BA9094.9080401@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53BA9094.9080401-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, qemu-devel <qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jul 7, 2014 at 5:20 AM, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Il 07/07/2014 12:29, David Drysdale ha scritto:
>
>>> I think that's more easily done by opening the file as O_RDONLY/O_WRONLY
>>> /O_RDWR.   You could do it by running the file descriptor's seccomp-bpf
>>> program once per iocb with synthesized syscall numbers and argument
>>> vectors.
>>
>>
>> Right, but generating the equivalent seccomp input environment for an
>> equivalent single-fd syscall is going to be subtle and complex (which
>> are worrying words to mention in a security context).  And how many
>> other syscalls are going to need similar special-case processing?
>> (poll? select? send[m]msg? ...)
>
>
> Yeah, the difficult part is getting the right balance between:
>
> 1) limitations due to seccomp's impossibility to chase pointers (which is
> not something that can be lifted, as it's required for correctness)

btw once seccomp moves to eBPF it will be able to 'chase pointers',
since pointer walking will be possible via bpf_load_pointer() function call,
which is a wrapper of:
  probe_kernel_read(&ptr, unsafe_ptr, sizeof(void *));
  return ptr;
Not sure whether it helps this case or not. Just fyi.

> 2) subtlety and complexity of the resulting code.
>
> The problem stems when you have a single a single syscall operating on
> multiple file descriptors.  So for example among the cases you mention poll
> and select are problematic; sendm?msg are not.  They would be if Capsicum
> had a capability for SCM_RIGHTS file descriptor passing, but I cannot find
> it.
>
> But then you also have to strike the right balance between a complete
> solution and an overengineered one.
>
> For example, even though poll and select are problematic, I wonder what
> would really the point be in blocking them; poll/select are level-triggered,
> and calling them should be idempotent as far as the file descriptor is
> concerned.  If you want to prevent a process/thread from issuing blocking
> system calls, but you'd do that with a per-process filter, not with
> per-file-descriptor filters or capabilities.
>
>
>> Capsicum capabilities are associated with the file descriptor (a la
>> F_GETFD), not the open file itself -- different FDs with different
>> associated rights can map to the same underlying open file.
>
>
> Good to know, thanks.  I suppose you have testcases that cover this.
>
> Paolo
> --
>
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
