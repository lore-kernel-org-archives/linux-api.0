From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 1/2] pidmap(2)
Date: Thu, 7 Sep 2017 12:43:21 +0300
Message-ID: <CACVxJT9uZBBB-VdgeofEkZA27WK_jna2dyeiWe1xXbcjdQav+A@mail.gmail.com>
References: <20170905190500.GA13746@avx2> <20170905155320.a683a4853b21a3be32d8b529@linux-foundation.org>
 <d538b917-3e3e-827c-7ca0-5493961cf6f1@infradead.org> <CACVxJT_vg7DnxSGmMtRT5aLCL=jutD94-yXaNOBwrJc-G+g_1w@mail.gmail.com>
 <CALCETrUFnfncs9QdZ4LTeFemVTCx-27bu88M=3U=RKBT8Oykwg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrUFnfncs9QdZ4LTeFemVTCx-27bu88M=3U=RKBT8Oykwg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Djalal Harouni <tixxdz@gmail.com>, Randy Dunlap <rdunlap@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Tatsiana Brouka <Tatsiana_Brouka@epam.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Aliaksandr Patseyenak <Aliaksandr_Patseyenak1@epam.com>
List-Id: linux-api@vger.kernel.org

On 9/7/17, Andy Lutomirski <luto@amacapital.net> wrote:
> On Wed, Sep 6, 2017 at 2:04 AM, Alexey Dobriyan <adobriyan@gmail.com>
> wrote:
>> On 9/6/17, Randy Dunlap <rdunlap@infradead.org> wrote:
>>> On 09/05/17 15:53, Andrew Morton wrote:
>>>> On Tue, 5 Sep 2017 22:05:00 +0300 Alexey Dobriyan <adobriyan@gmail.com>
>>>> wrote:
>>>>
>>>>> Implement system call for bulk retrieveing of pids in binary form.
>>>>>
>>>>> Using /proc is slower than necessary: 3 syscalls + another 3 for each
>>>>> thread +
>>>>> converting with atoi().
>>>>>
>>>>> /proc may be not mounted especially in containers. Natural extension
>>>>> of
>>>>> hidepid=2 efforts is to not mount /proc at all.
>>>>>
>>>>> It could be used by programs like ps, top or CRIU. Speed increase will
>>>>> become more drastic once combined with bulk retrieval of process
>>>>> statistics.
>>>>
>>>> The patches are performance optimizations, but their changelogs contain
>>>> no performance measurements!
>>>>
>>>> Demonstration of some compelling real-world performance benefits would
>>>> help things along a lot.
>>>>
>>>
>>> also, I expect that the tiny kernel people will want kconfig options for
>>> these syscalls.
>>
>> We'll add it but the question if it is a good idea. Ideally these system
>> calls
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
> 2. Add a /proc file that has a nice binary format for task info.
> (nl_attr?)

If you do binary data in /proc there is no need for /proc part.
System call can do everything /proc/$PID/bstat (or whatever the name)
does.

> I don't see why pidmap() deserves to be significantly faster than
> getdents().

Just look at profile. XXX is pure slowdown. _Some_ of it can be deleted
or sped up but not everything. All dcache stuff is unavoidable.

XXX	6.35% [k] number
OK*	5.21% [k] proc_readfd_common  (* partially XXX)
OK	4.19% [k] __rcu_read_unlock
XXX	4.05% [.] __GI_____strtoll_l_internal
XXX	3.73% [k] dput
OK	3.64% [k] entry_SYSCALL_64_fastpath
XXX	3.23% [k] proc_fill_cache
XXX	3.10% [k] __d_lookup
XXX	3.09% [k] filldir
XXX	2.74% [k] format_decode
XXX	2.47% [k] link_path_walk
OK*	2.26% [k] _raw_spin_lock
OK	1.73% [k] get_files_struct
XXX	1.64% [k] __d_lookup_rcu
XXX	1.61% [k] do_sys_open
XXX	1.49% [k] pid_revalidate
OK	1.48% [k] __check_object_size
XXX	1.47% [k] do_filp_open
?	1.44% [.] __memmove_sse2
OK	1.40% [k] __rcu_read_lock
XXX	1.33% [.] __readdir64
XXX	1.32% [k] __follow_mount_rcu.isra.6
XXX	1.30% [k] set_root
XXX	1.27% [k] lookup_fast
XXX	1.23% [k] full_name_hash
OK?	1.17% [k] call_rcu
XXX	1.17% [k] sys_open
?	1.02% [k] lockref_put_or_lock
XXX	1.00% [k] pid_delete_dentry
XXX	0.99% [k] iterate_dir
XXX	0.95% [k] inode_permission
XXX	0.94% [k] __slab_alloc.isra.22.constprop.26
OK	0.93% [k] rcu_process_callbacks
XXX	0.93% [.] __getdents64
XXX	0.93% [k] vsnprintf
XXX	0.92% [k] sys_close

> Also, a pidmap() syscall like this inherently bypasses any security
> restrictions implied by the way that /proc is mounted.  It can respect
> hidepid, but hidepid (as a per-namespace concept) is an enormous turd
> that badly needs to be deprecated, and Djalal is working on exactly
> that.

I agree pid_ns->hide_pid is silly idea. It should be a property of
an individual mount but as posted pidmap() respect it (at a cost of
some slowdown).
