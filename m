From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH 1/3] proc: Stop reporting eip and esp in /proc/PID/stat
Date: Fri, 14 Oct 2016 11:25:58 -0700
Message-ID: <CALCETrWpB=gKpfZWX3O9FvWxxVtw-GrUvyD=f2wOn0tZVLUpCA@mail.gmail.com>
References: <cover.1475257877.git.luto@kernel.org> <a5fed4c3f4e33ed25d4bb03567e329bc5a712bcc.1475257877.git.luto@kernel.org>
 <20160930185642.GH14666@pc.thejh.net> <CALCETrUBmsoUK5Shkjwo6n=BGaHFtZhhUZ=2uOcAzWUend-BXg@mail.gmail.com>
 <20161001103728.GM14666@pc.thejh.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161001103728.GM14666-J1fxOzX/cBvk1uMJSBkQmQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sat, Oct 1, 2016 at 3:37 AM, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org> wrote:
> On Fri, Sep 30, 2016 at 07:01:13PM -0700, Andy Lutomirski wrote:
>> On an unrelated note, can we please lock down all the silly historical
>> *userspace* info leaks in /proc?  Nasty ones include: net, cmdline (at
>> the very least, only argv[0] should be visible if the reader lacks
>> ptrace access).
>>
>> Less nasty ones include: limits, sched, autogroup, comm, wchan,
>> schedstat, cpuset, cgroup, oom_*, sessionid, coredump_filter
>
> If that doesn't break stuff, I'm very much in favor of it.
>
>
>> uid_map, gid_map, etc are just screwed up.  They should be per
>> *namespace* somewhere, and they should require creds on the namespace.
>
> What do you have in mind? Something like
> /proc/namespaces/user:123456/{uid_map,gid_map,setgroups,parent_ns},
> with jumped fake symlinks to the directory and its entries in /proc/$pid/?
>

Something along those lines would be nice.

There's an unfortunate tension between having names for namespaces
(like 123456 in your example) for ease of use and *not* having names
so CRIU can restore them more easily.

>
>> timerslack is totally fscked up -- it allows ugo to write and it
>> checks the wrong creds.  Jann, does your series fix that?
>
> Nope. Never noticed that thing so far, probably because it was only
> added a few months ago. :/ Will add it to my series.



-- 
Andy Lutomirski
AMA Capital Management, LLC
