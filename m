From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [RFC PATCH 00/11] Adding FreeBSD's Capsicum security framework
 (part 1)
Date: Tue, 8 Jul 2014 07:58:08 -0700
Message-ID: <CAGXu5jLoO9QsrT6koUEXebXPh3nBpLfanxqfm0bT7Js+_Fxq4g@mail.gmail.com>
References: <1404124096-21445-1-git-send-email-drysdale@google.com>
	<53B51E81.4090700@redhat.com>
	<20140703183927.GA1629@google.com>
	<53B651C5.80602@redhat.com>
	<CAHse=S83APPfnEwO1fQbV_tNd=9zsAsZr42KbYM_He-c3C3P6A@mail.gmail.com>
	<53BA9094.9080401@redhat.com>
	<CAADnVQ+c2E6eG_juEDh-GyheveqScxQ=98jqO1ZOjp1PgfVBGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAADnVQ+c2E6eG_juEDh-GyheveqScxQ=98jqO1ZOjp1PgfVBGQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexei Starovoitov <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, qemu-devel <qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jul 7, 2014 at 3:33 PM, Alexei Starovoitov
<alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Mon, Jul 7, 2014 at 5:20 AM, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> Il 07/07/2014 12:29, David Drysdale ha scritto:
>>
>>>> I think that's more easily done by opening the file as O_RDONLY/O_WRONLY
>>>> /O_RDWR.   You could do it by running the file descriptor's seccomp-bpf
>>>> program once per iocb with synthesized syscall numbers and argument
>>>> vectors.
>>>
>>>
>>> Right, but generating the equivalent seccomp input environment for an
>>> equivalent single-fd syscall is going to be subtle and complex (which
>>> are worrying words to mention in a security context).  And how many
>>> other syscalls are going to need similar special-case processing?
>>> (poll? select? send[m]msg? ...)
>>
>>
>> Yeah, the difficult part is getting the right balance between:
>>
>> 1) limitations due to seccomp's impossibility to chase pointers (which is
>> not something that can be lifted, as it's required for correctness)
>
> btw once seccomp moves to eBPF it will be able to 'chase pointers',
> since pointer walking will be possible via bpf_load_pointer() function call,
> which is a wrapper of:
>   probe_kernel_read(&ptr, unsafe_ptr, sizeof(void *));
>   return ptr;
> Not sure whether it helps this case or not. Just fyi.

It won't immediately help, since threads can race pointer target
contents (i.e. seccomp sees one thing, and then the syscall see
another thing). Having an immutable memory area could help with this
(i.e. some kind of "locked" memory range that holds all the "approved"
argument strings, at which point seccomp could then trust the chased
pointers that land in this range.) Obviously eBPF is a prerequisite to
this, but it isn't the full solution, as far as I understand it.

-Kees

-- 
Kees Cook
Chrome OS Security
