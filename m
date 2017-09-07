From: Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] pidmap(2)
Date: Thu, 7 Sep 2017 07:06:00 +0200
Message-ID: <CAEiveUfwZs+ECNSdiVRfHMXZTiYus33DAkmD3Kr6KczZheCr8g@mail.gmail.com>
References: <20170905190500.GA13746@avx2> <20170905155320.a683a4853b21a3be32d8b529@linux-foundation.org>
 <d538b917-3e3e-827c-7ca0-5493961cf6f1@infradead.org> <CACVxJT_vg7DnxSGmMtRT5aLCL=jutD94-yXaNOBwrJc-G+g_1w@mail.gmail.com>
 <CALCETrUFnfncs9QdZ4LTeFemVTCx-27bu88M=3U=RKBT8Oykwg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrUFnfncs9QdZ4LTeFemVTCx-27bu88M=3U=RKBT8Oykwg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tatsiana Brouka <Tatsiana_Brouka-uRwfk40T5oI@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Aliaksandr Patseyenak <Aliaksandr_Patseyenak1-uRwfk40T5oI@public.gmane.org>, Alexey Gladkov <gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Alexey,

On Thu, Sep 7, 2017 at 4:04 AM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
> On Wed, Sep 6, 2017 at 2:04 AM, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> On 9/6/17, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>>> On 09/05/17 15:53, Andrew Morton wrote:
[...]
>>>
>>> also, I expect that the tiny kernel people will want kconfig options for
>>> these syscalls.
>>
>> We'll add it but the question if it is a good idea. Ideally these system calls
>> should be mandatory and /proc optional.
>>
>> $ size kernel/pidmap.o fs/fdmap.o
>>    text    data     bss     dec     hex filename
>>     560       0       0     560     230 kernel/pidmap.o
>>     617       0       0     617     269 fs/fdmap.o
>
> After much discussion at LPC/KS last year, I thought the idea was to
> try to speed up /proc rather than replacing it outright.  The two
> specific ideas I recall were:
>
> 1. Add a syscall like readfileat() that you can use to, in a single
> operation, open, read, and close a /proc file (or other file).  This
> should vastly reduce locking and RCU overhead.
>
> 2. Add a /proc file that has a nice binary format for task info.  (nl_attr?)
>
> I don't see why pidmap() deserves to be significantly faster than getdents().
>
> Also, a pidmap() syscall like this inherently bypasses any security
> restrictions implied by the way that /proc is mounted.  It can respect
> hidepid, but hidepid (as a per-namespace concept) is an enormous turd
> that badly needs to be deprecated, and Djalal is working on exactly
> that.

Yes as noted by Andy, me and Alexey Gladkov are working on modernizing
procfs [1] and to reduce/remove ties within pid namespaces which has lot
of problems now.

We just picked the task again, and this was the result of discussion
with Andy some months ago, on how to improve hidepid, but also how to
improve procfs in general, so we can add other mechanisms to hide or return
NULL on other /proc/_file_not_needed_by_containers_  or
/proc/_specific_module_files_ everything that is not virtualized , or mount only
some specific view of the whole /proc API this will also be used by containers.
This also should make it hard for attackers since we are planning to have
a backward compatible options on how to better treat some of these files in
regard of some namespaces.

The syscall or readfileat() for one operation is a nice addition
definitively. But
in general it would be better to treat /proc as a filesystem and not add other
specific interfaces that may abstract it with pidns, as it is the situation now
which make it from userspace perspective: hard to use especially for security
context.

Alexey, could you please Cc'us on future, thank you very much!


[1] https://lkml.org/lkml/2017/4/25/282

-- 
tixxdz
