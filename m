From: Tycho Andersen <tycho.andersen@canonical.com>
Subject: Re: [PATCH 1/3] proc: Stop reporting eip and esp in /proc/PID/stat
Date: Fri, 14 Oct 2016 14:01:47 -0600
Message-ID: <20161014200147.GJ9796@smitten>
References: <cover.1475257877.git.luto@kernel.org>
 <a5fed4c3f4e33ed25d4bb03567e329bc5a712bcc.1475257877.git.luto@kernel.org>
 <20160930185642.GH14666@pc.thejh.net>
 <CALCETrUBmsoUK5Shkjwo6n=BGaHFtZhhUZ=2uOcAzWUend-BXg@mail.gmail.com>
 <20161001103728.GM14666@pc.thejh.net>
 <CALCETrWpB=gKpfZWX3O9FvWxxVtw-GrUvyD=f2wOn0tZVLUpCA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrWpB=gKpfZWX3O9FvWxxVtw-GrUvyD=f2wOn0tZVLUpCA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Jann Horn <jann@thejh.net>, Peter Zijlstra <peterz@infradead.org>, Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Brian Gerst <brgerst@gmail.com>, Borislav Petkov <bp@alien8.de>, Linux API <linux-api@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 14, 2016 at 11:25:58AM -0700, Andy Lutomirski wrote:
> On Sat, Oct 1, 2016 at 3:37 AM, Jann Horn <jann@thejh.net> wrote:
> > On Fri, Sep 30, 2016 at 07:01:13PM -0700, Andy Lutomirski wrote:
> >> On an unrelated note, can we please lock down all the silly historical
> >> *userspace* info leaks in /proc?  Nasty ones include: net, cmdline (at
> >> the very least, only argv[0] should be visible if the reader lacks
> >> ptrace access).
> >>
> >> Less nasty ones include: limits, sched, autogroup, comm, wchan,
> >> schedstat, cpuset, cgroup, oom_*, sessionid, coredump_filter
> >
> > If that doesn't break stuff, I'm very much in favor of it.
> >
> >
> >> uid_map, gid_map, etc are just screwed up.  They should be per
> >> *namespace* somewhere, and they should require creds on the namespace.
> >
> > What do you have in mind? Something like
> > /proc/namespaces/user:123456/{uid_map,gid_map,setgroups,parent_ns},
> > with jumped fake symlinks to the directory and its entries in /proc/$pid/?
> >
> 
> Something along those lines would be nice.
> 
> There's an unfortunate tension between having names for namespaces
> (like 123456 in your example) for ease of use and *not* having names
> so CRIU can restore them more easily.

As long as the namespaces aren't visible to the container itself, it
has been okay. For example, LXC (and IIUC OpenVZ as well) put
containers in a /lxc/<name> cgroup, which with cgroup namespaces isn't
visible to the container. CRIU implements support for rewriting this
prefix, so we can do renaming on the fly. Since most container engines
won't allow two containers with the same name, we avoid clashes at a
higher level before we end up with an actual "namespace ID" (cgroup
path) clash. We're doing a similar thing for AppArmor namespaces.

Of course, if the IDs are visible to the container like they would be
in this case, then it is much harder.

Cheers,

Tycho
