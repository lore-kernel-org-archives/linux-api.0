From: Oren Laadan <orenl-RdfvBDnrOixBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 00/80] Kernel based checkpoint/restart [v18]
Date: Tue, 29 Sep 2009 14:31:59 -0400
Message-ID: <4AC2529F.8010204@librato.com>
References: <1253749920-18673-1-git-send-email-orenl@librato.com> <20090924154139.2a7dd5ec.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090924154139.2a7dd5ec.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org


Hi,

Andrew Morton wrote:
> On Wed, 23 Sep 2009 19:50:40 -0400
> Oren Laadan <orenl-RdfvBDnrOixBDgjK7y7TUQ@public.gmane.org> wrote:
> 
>> Q: How useful is this code as it stands in real-world usage?
>> A: The application can be single- or multi-processes and threads. It
>>    handles open files (regular files/directories on most file systems,
>>    pipes, fifos, af_unix sockets, /dev/{null,zero,random,urandom} and
>>    pseudo-terminals. It supports shared memory. sysv IPC (except undo
>>    of sempahores). It's suitable for many types of batch jobs as well
>>    as some interactive jobs. (Note: it is assumed that the fs view is
>>    available at restart).
> 
> That's encouraging.
> 
>> Q: What can it checkpoint and restart ?
>> A: A (single threaded) process can checkpoint itself, aka "self"
>>    checkpoint, if it calls the new system calls. Otherise, for an
>>    "external" checkpoint, the caller must first freeze the target
>>    processes. One can either checkpoint an entire container (and
>>    we make best effort to ensure that the result is self-contained),
>>    or merely a subtree of a process hierarchy.
> 
> What is "best effort"?  Will the operation appear to have succeeded,
> only it didn't?

There are two modes of operation: a "full" (container) checkpoint and
a "subtree" checkpoint.

For container-checkpoint, the application runa within its own set
of namespaces (pid, uts, ipc ...). We have a leak-detection algorithm
in place to ensure that the application is entirely contained and
isolated in the container, or else the checkpoint fails. In this case,
restart is guaranteed to succeed (assuming external dependencies are
properly set - see below).

A "subtree" checkpoint is less restrictive. It allows to checkpoint
applications that aren't truly isolated. In this case, restart may
fail, or restart may succeed but the application may fail shortly
after because some dependency may be missing. However, in practice
this works well for many applications transparently, and even more
so for c/r-aware application.

In both modes of operation, some external dependencies are assumed
to exist. One example is the file system view that has to be the
same for the container (or subtree) as during checkpoint. Another
is the network setup. These will be reconstructed (at least in part)
by userspace prior to the actual restart.

(Some of these dependencies can be relaxed for many use-cases,
e.g. when user/application doesn't care about preserving original
network connection after restart).

> IOW, how reliable and robust is code at detecting that it was unable to
> successfully generate a restartable image?

To the best of my knowledge (and unless someone pokes a hole in the
algorithm), container-checkpoint is robust and reliable.

Two reasons for saying "best effort": first, because external
dependencies need to be suitably arranged. If external dependencies
are not arranged - e.g. provide a snapshot of the filesystem from
the time of the checkpoint - restart, or execution thereafter, may
fail.

Second, because even when the application is isolated within a
container, the user from outside may still be able to affect it. I
can think of one (and only one) pathological example: an outside
process signals all tasks in a container during a checkpoint, but
the signal is recorded for only some tasks. I'd argue that this
is improper behavior that we need not support, rather than address
it in the kernel.

> 
>> Q: What about namespaces ?
>> A: Currrently, UTS and IPC namespaces are restored. They demonstrate
>>    how namespaces are handled. More to come.
> 
> Will this new code muck up the kernel?

I forgot to mention user-ns is already included. We have a good
plan for mount-ns and mount-points, and intend to handle net-ns
in userspace (by that, I mean the net-ns setup, not the state of
connections etc).

I don't expect this additional code to be less solid than the
current one.

> 
>> Q: What additional work needs to be done to it?
>> A: Fill in the gory details following the examples so far. Current WIP
>>    includes inet sockets, event-poll, and early work on inotify, mount
>>    namespace and mount-points, pseudo file systems
> 
> Will this new code muck up the kernel, or will it be clean?

Should not.

I guess "gory details" was a bad choice of words, and I really meant
to say "less interesting". IOW, I think we have constructed a solid
and framework. From the kernel side, I think we're left with
completeness - add support for remaining missing features (e.g.
inotify), and goodies - live migration and other optimizations.

> 
>> and x86_64 support.
> 
> eh?  You mean the code doesn't work on x86_64 at present?
> 
> 
> What is the story on migration?  Moving the process(es) to a different
> machine?
> 

It depends on the use-case in mind:

Moving processes between machines without preserving external network
connections (or IP), already works. This can be useful for servers
(e.g. apache, or vnc with user's session), and applications that know
how to recover from, or do not care about lost connections.

Migrating processes with their external network connections is WIP.

In both cases, there needs to be some userspace glue to ensure that
the same filesystem view is available on the target machine as was on
the origin machine (e.g. remote file system, SAN, or even rsync of
changes).

Also ,in both cases, we may want to pre-copy some of the application
state while it is still running, to reduce the application downtime.
This will be added down the road.

Oren.

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
