From: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>
Subject: Re: [PATCH -next 0/3] sysvipc: introduce STAT_ALL commands
Date: Tue, 13 Feb 2018 16:42:10 -0800
Message-ID: <20180214004210.7hj3g4zit5uwqgvp@linux-n805>
References: <20180213174136.6346-1-dave@stgolabs.net>
 <20180213150643.0bf5b03f49be656728e1475e@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180213150643.0bf5b03f49be656728e1475e-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, 13 Feb 2018, Andrew Morton wrote:

>On Tue, 13 Feb 2018 09:41:33 -0800 Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org> wrote:
>
>> Hi,
>>
>> The following patches adds the discussed[1] new command for shm
>> as well as for sems and msq as they are subject to the same discrepancies
>> for ipc object permission checks between the syscall and via procfs.
>> These new commands are justified in that (1) we are stuck with this
>> semantics as changing syscall and procfs can break userland; and (2) some
>> users can benefit from performance (for large amounts of shm segments,
>> for example) from not having to parse the procfs interface.
>>
>> Once (if) merged, I will submit the necesary manpage updates. But I'm
>> thinking something like:
>>
>> ...
>>
>> [1] https://lkml.org/lkml/2017/12/19/220
>
>It would be nice to summarize the above discussion right here, rather
>than merely linking to an email thread.

I would have thought (1) and (2) above sumarize the situation. Patches
themselves also have a thorough changelog.

>
>A reported-by:mhocko would be appropriate.

This was really reported by a customer, but sure.

>
>Really, the only reason for this patchset is to speed up the userspace
>interface, yes?  But the changelog is awfull skimpy on the details
>here.  Who cares about it and why and which apps can be changed (ipcs?)
>and why do we care and how much better does it get, etc.

Yes, better performance is the goal here. The customer application is
a large and well known database vendor. When consulted as to why this
functionality was needed (and why the process couldn't be pimped to
CAP_IPC_OWNER):

""
The databaselayer saves its rowstore for some reason inside shared memory
(so large amounts of shared memory). The DB instances communicate with each
other about how much memory(ANON, but not shared) each instance is using.

Due to the nature of shared memory one instance might remove a segment,
but it will never know when it is realy gone unless we ask the kernel
to give us the correct information. When this happens we would be fine
to tell others, but to speed things up we currenty allow each instance
to calculate the shared memory size on their own.
""

As such these very specific workloads that deal with large (+10k) number
of ipc objects (shared memory segments in this case).

>
>
>Dumb question: an admin can do `chmod 0400 /proc/sysvipc/shm' and then
>this data is hidden from unprivileged users.  So doesn't this change
>represent a security hole for such users?

Sure, but you'd even hide data that the user can legitimately have
available (the same data that SHM_STAT would return). This deals with
permissions at an ipc object granularity, not file.

In any case, doing a 0400 on the file would cause 'ipcs -m' would not
show anything for other users.

Thanks,
Davidlohr
