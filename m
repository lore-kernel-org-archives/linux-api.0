From: Daniel Colascione <dancol@google.com>
Subject: Re: [PATCH] proc: allow killing processes via file descriptors
Date: Sun, 18 Nov 2018 10:31:42 -0800
Message-ID: <CAKOZueuj_MZD0e+Vf8qgyPxvo+KcQ+3QGD3u7KBFFcpZ0ZmMgQ@mail.gmail.com>
References: <20181118111751.6142-1-christian@brauner.io> <CAKOZuet3s0WxxPgrtrNkq8YiOWhYAiK6yEio6PKVV9J_H4_TSA@mail.gmail.com>
 <CALCETrUd2Y2MmO8Qx8aUvQDOTNiyj35Y7bctPBZe0p2i1EUiLw@mail.gmail.com>
 <20181118174148.nvkc4ox2uorfatbm@brauner.io> <CAKOZueto1CmUSWFKjOkazcDcZH6CiXXCr4U=ghewLh8GjE2-=A@mail.gmail.com>
 <CALCETrUb8MSPPBLLz5Md9Fzaq3Kd9HtG8R5JFwWuy21jOuzbUA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrUb8MSPPBLLz5Md9Fzaq3Kd9HtG8R5JFwWuy21jOuzbUA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Christian Brauner <christian@brauner.io>, "Eric W. Biederman" <ebiederm@xmission.com>, LKML <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Tim Murray <timmurray@google.com>, Kees Cook <keescook@chromium.org>, David Howells <dhowells@redhat.com>
List-Id: linux-api@vger.kernel.org

On Sun, Nov 18, 2018 at 10:15 AM, Andy Lutomirski <luto@kernel.org> wrote:
> On Sun, Nov 18, 2018 at 10:07 AM Daniel Colascione <dancol@google.com> wrote:
>> Next, I want to merge my exithand proposal, or something like it. It's
>> likewise a simple change that, in a minimal way, addresses a
>> longstanding API deficiency. I'm very strongly against the
>> POLLERR-on-directory variant of the idea.
>
> Can you explain why you don't like POLLERR-on-a-directory?  I'm not
> saying that POLLERR-on-a-directory is fantastic, but I'd like to
> understand what your objection is.

I've written my objections in more detail at [1]. Basically,

1) Nothing else today works by polling on directory file descriptors.

2) POLLERR is wrong because POLLERR indicates, well, an error, but
since we want notifications upon either a transition to a zombie *or*
actual death, and /proc/pid operations work perfectly well on zombie
processes, there's no error to report, and reporting POLLERR would be
a weird kind of lie. POLLHUP might be less awkward here.

3) POLLERR is a single bit of information. I want exit status as well,
or at least a logical path from whatever we add to some kind of exit
status reporting. You can get exit status from a zombie with openat on
/proc/pid/stat, but what if the process fully dies by the time you get
around to reading its exit status? Should we synthesize a
/proc/pid/stat? It seems simpler to be able to just read(2) the exit
information from some FD.

4) Event monitoring frameworks generally treat POLLERR as some kind of
black sheep. Most people think in terms of bits indicating reading and
writing. I want something that can cleanly integrate into existing
wait mechanisms.

5) Poll events are *hints* that some other operation probably won't
block if attempted. Using poll as the primary way of communicating a
bit of information instead of an attempt-IO-now hint feels awkward.

6) A POLLERR interface can't be used by the shell without some kind of helper.

What *advantage* does a POLLERR interface have? That you don't have to
openat a separate file? That's a trivial operation in profs,
especially compared to the machinery of process shutdown.

I'm not particularly tied to a proc file; if we're adding a system
call interface for killing a process by its procfs dfd, we can add one
for returning an eventfd-like FD representing that process's status.
It's unfortunate that the process handle FD also happens to be a
directory FD; if it were a standalone object type, we could just use
POLLIN more naturally.

[1] https://lore.kernel.org/lkml/CAKOZueszfoSM0pxhmuFLOuPmJqSfYXxgutstyCgqxAyoUi4h3w@mail.gmail.com/
