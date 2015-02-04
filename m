From: Calvin Owens <calvinowens-b10kYP2dOMg@public.gmane.org>
Subject: Re: [RFC][PATCH v2] procfs: Always expose /proc/<pid>/map_files/ and
 make it readable
Date: Tue, 3 Feb 2015 19:28:21 -0800
Message-ID: <20150204032821.GA3290085@mail.thefacebook.com>
References: <20150114211613.GH2253@moon>
 <20150122024554.GB23762@mail.thefacebook.com>
 <20150124031544.GA1992748@mail.thefacebook.com>
 <20150126124731.GA26916@node.dhcp.inet.fi>
 <20150126210054.GG651@moon>
 <20150126154346.c63c512e5821e9e0ea31f759@linux-foundation.org>
 <20150128043832.GA2266262@mail.thefacebook.com>
 <CAGXu5j+wa2-CCGaktPzDec=HF0CizP__HVVjZKcjGuJJOvLFyg@mail.gmail.com>
 <20150131015842.GA431662@mail.thefacebook.com>
 <CALCETrUufe3USocUDpkBdwx6SyGKVgVUTh4rg2H9Xn91u+6iHg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrUufe3USocUDpkBdwx6SyGKVgVUTh4rg2H9Xn91u+6iHg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cyrill Gorcunov <gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Peter Feiner <pfeiner-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>, Siddhesh Poyarekar <siddhesh.poyarekar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Monday 02/02 at 12:16 -0800, Andy Lutomirski wrote:
> On Fri, Jan 30, 2015 at 5:58 PM, Calvin Owens <calvinowens-b10kYP2dOMg@public.gmane.org> wrote:
> > On Thursday 01/29 at 17:30 -0800, Kees Cook wrote:
> >> On Tue, Jan 27, 2015 at 8:38 PM, Calvin Owens <calvinowens-b10kYP2dOMg@public.gmane.org> wrote:
> >> > On Monday 01/26 at 15:43 -0800, Andrew Morton wrote:
> >> >> On Tue, 27 Jan 2015 00:00:54 +0300 Cyrill Gorcunov <gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >> >>
> >> >> > On Mon, Jan 26, 2015 at 02:47:31PM +0200, Kirill A. Shutemov wrote:
> >> >> > > On Fri, Jan 23, 2015 at 07:15:44PM -0800, Calvin Owens wrote:
> >> >> > > > Currently, /proc/<pid>/map_files/ is restricted to CAP_SYS_ADMIN, and
> >> >> > > > is only exposed if CONFIG_CHECKPOINT_RESTORE is set. This interface
> >> >> > > > is very useful for enumerating the files mapped into a process when
> >> >> > > > the more verbose information in /proc/<pid>/maps is not needed.
> >> >>
> >> >> This is the main (actually only) justification for the patch, and it it
> >> >> far too thin.  What does "not needed" mean.  Why can't people just use
> >> >> /proc/pid/maps?
> >> >
> >> > The biggest difference is that if you do something like this:
> >> >
> >> >         fd = open("/stuff", O_BLAH);
> >> >         map = mmap(NULL, 4096, PROT_BLAH, MAP_SHARED, fd, 0);
> >> >         close(fd);
> >> >         unlink("/stuff");
> >> >
> >> > ...then map_files/ gives you a way to get a file descriptor for
> >> > "/stuff", which you couldn't do with /proc/pid/maps.
> >> >
> >> > It's also something of a win if you just want to see what is mapped at a
> >> > specific address, since you can just readlink() the symlink for the
> >> > address range you care about and it will go grab the appropriate VMA and
> >> > give you the answer. /proc/pid/maps requires walking the VMA tree, which
> >> > is quite expensive for processes with many thousands of threads, even
> >> > without the O(N^2) issue.
> >> >
> >> > (You have to know what address range you want though, since readdir() on
> >> > map_files/ obviously has to walk the VMA tree just like /proc/N/maps.)
> >> >
> >> >> > > > This patch moves the folder out from behind CHECKPOINT_RESTORE, and
> >> >> > > > removes the CAP_SYS_ADMIN restrictions. Following the links requires
> >> >> > > > the ability to ptrace the process in question, so this doesn't allow
> >> >> > > > an attacker to do anything they couldn't already do before.
> >> >> > > >
> >> >> > > > Signed-off-by: Calvin Owens <calvinowens-b10kYP2dOMg@public.gmane.org>
> >> >> > >
> >> >> > > Cc +linux-api@
> >> >> >
> >> >> > Looks good to me, thanks! Though I would really appreciate if someone
> >> >> > from security camp take a look as well.
> >> >>
> >> >> hm, who's that.  Kees comes to mind.
> >> >>
> >> >> And reviewers' task would be a heck of a lot easier if they knew what
> >> >> /proc/pid/map_files actually does.  This:
> >> >>
> >> >> akpm3:/usr/src/25> grep -r map_files Documentation
> >> >> akpm3:/usr/src/25>
> >> >>
> >> >> does not help.
> >> >>
> >> >> The 640708a2cff7f81 changelog says:
> >> >>
> >> >> :     This one behaves similarly to the /proc/<pid>/fd/ one - it contains
> >> >> :     symlinks one for each mapping with file, the name of a symlink is
> >> >> :     "vma->vm_start-vma->vm_end", the target is the file.  Opening a symlink
> >> >> :     results in a file that point exactly to the same inode as them vma's one.
> >> >> :
> >> >> :     For example the ls -l of some arbitrary /proc/<pid>/map_files/
> >> >> :
> >> >> :      | lr-x------ 1 root root 64 Aug 26 06:40 7f8f80403000-7f8f80404000 -> /lib64/libc-2.5.so
> >> >> :      | lr-x------ 1 root root 64 Aug 26 06:40 7f8f8061e000-7f8f80620000 -> /lib64/libselinux.so.1
> >> >> :      | lr-x------ 1 root root 64 Aug 26 06:40 7f8f80826000-7f8f80827000 -> /lib64/libacl.so.1.1.0
> >> >> :      | lr-x------ 1 root root 64 Aug 26 06:40 7f8f80a2f000-7f8f80a30000 -> /lib64/librt-2.5.so
> >> >> :      | lr-x------ 1 root root 64 Aug 26 06:40 7f8f80a30000-7f8f80a4c000 -> /lib64/ld-2.5.so
> >> >>
> >> >> afacit this info is also available in /proc/pid/maps, so things
> >> >> shouldn't get worse if the /proc/pid/map_files permissions are at least
> >> >> as restrictive as the /proc/pid/maps permissions.  Is that the case?
> >> >> (Please add to changelog).
> >> >
> >> > Yes, the only difference is that you can follow the link as per above.
> >> > I'll resend with a new message explaining that and the deletion thing.
> >> >
> >> >> There's one other problem here: we're assuming that the map_files
> >> >> implementation doesn't have bugs.  If it does have bugs then relaxing
> >> >> permissions like this will create new vulnerabilities.  And the
> >> >> map_files implementation is surprisingly complex.  Is it bug-free?
> >> >
> >> > While I was messing with it I used it a good bit and didn't see any
> >> > issues, although I didn't actively try to fuzz it or anything. I'd be
> >> > happy to write something to test hammering it in weird ways if you like.
> >> > I'm also happy to write testcases for namespaces.
> >> >
> >> > So far as security issues, as others have pointed out you can't follow
> >> > the links unless you can ptrace the process in question, which seems
> >> > like a pretty solid guarantee. As Cyrill pointed out in the discussion
> >> > about the documentation, that's the same protection as /proc/N/fd/*, and
> >> > those links function in the same way.
> >>
> >> My concern here is that fd/* are connected as streams, and while that
> >> has a certain level of badness as an external-to-the-process attacker,
> >> PTRACE_MODE_READ is much weaker than PTRACE_MODE_ATTACH (which is
> >> required for access to /proc/N/mem). Since these fds are the things
> >> mapped into memory on a process, writing to them is a subset of access
> >> to /proc/N/mem, and I don't feel that PTRACE_MODE_READ is sufficient.
> >
> > If you haven't done close() on a mmapped file, doesn't fd/* allow the
> > same access to the corresponding regions of memory? Or am I missing
> > something?
> >
> 
> But if you have called close(), then you can't currently do things
> like ftruncate or ioctl on the mapped file.  These things don't
> persist across execve(), but the do persist across calls to setresuid,
> etc that drop privileges.  The latter part makes me a tiny bit
> nervous.

Hmm, in that scenario you would have to open() the map_files symlink,
and since you've dropped privileges that would only succeed if the user
you dropped to has permission to access that file anyway, right? 

In the deleted file case it does actually allow something that used to
be impossible, but relying on open/map/close/unlink to prevent a user
from opening a file they have permission to open is just buggy in
general.

But, O_TMPFILE lets you end up in that position without the race. The
manpage says that O_TMPFILE files "can never be reached via any
pathname", which isn't strictly true since you can get them from fd/* in
proc. But if you close() after mapping it they are currently truly
inaccessible via any path, and given the language in the manpage it
seems reasonable that somebody might rely on that and be lazy with the
permissions.

I hadn't thought about O_TMPFILE thing: I'm definitely convinced now
that PTRACE_MODE_ATTACH is the right thing here. But I think having to
reopen the file saves you even if you "leak" maps of files across a call
to setresuid/etc. 

> It also might be worth checking for drivers or arch code that creates
> vmas that are backed by a different struct file than the struct file
> that was mmapped in the first place.

Interesting, I'll look into this before I resend.

Thanks,
Calvin
 
> --Andy
