From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCHv2 2/3] selftests: Add test of O_BENEATH & openat(2)
Date: Fri, 12 Dec 2014 11:05:25 +1100
Message-ID: <20141212000524.GI24183@dastard>
References: <1415094884-18349-1-git-send-email-drysdale@google.com>
 <1415094884-18349-3-git-send-email-drysdale@google.com>
 <20141111053641.GR23575@dastard>
 <CAHse=S9OwP8tSErW59Hd3VPbKVrE9VJM=5gMgZQwsv3kB9Ax0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAHse=S9OwP8tSErW59Hd3VPbKVrE9VJM=5gMgZQwsv3kB9Ax0w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Jorge Lucangeli Obes <jorgelo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ricky Zhou <rickyz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Lee Campbell <leecam-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Julien Tinnes <jln-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mike Depinet <mdepinet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Nov 21, 2014 at 02:19:41PM +0000, David Drysdale wrote:
> On Tue, Nov 11, 2014 at 5:36 AM, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org> wrote:
> > [cc fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org]
> >
> > On Tue, Nov 04, 2014 at 09:54:43AM +0000, David Drysdale wrote:
> >> Add simple tests of openat(2) variations, including examples that
> >> check the new O_BENEATH flag.
> >>
> >> Signed-off-by: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> >
> > Wouldn't this be better added to fstests? That's the regression
> > test suite used by filesystem developers and most distro QA
> > organisations and where the fs developers aggregate all their new
> > regression tests.
> >
> > IMO, the fewer places we aggregate VFS/filesystem tests the better.
> > I really don't think the kernel tree is the best place for adding
> > VFS behavioural tests because it has none of the infrastructure
> > around it to test arbitrary filesystems and configurations and hence
> > is not particularly useful to the people whoa re likely to notice
> > and care about fs regression tests suddenly breaking.
> >
> > As an example, the recent renameat() syscall additions (e.g.
> > RENAME_EXCHANGE, RENAME_NOREPLACE) have unit tests in fstests, so
> > these new O_BENEATH tests should really follow the same model...
> 
> Fair enough, that makes sense -- I've now got a version of the selftest
> running within xfstests (git://oss.sgi.com/xfs/cmds/xfstests.git is the
> master repo, right?).

Or git://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git, which is
where I typically update first and push dev branches to.

> Given that xfstests is independent of the kernel, what's the expected
> way to deal with flags (or syscalls) that are only in specific kernel
> versions?  At the moment I've just got a primitive override at
> compile time (#ifndef O_BENEATH #define O_BENEATH ...), and
> then the test will fail at run-time against an older kernel -- is there a
> need for anything more sophisticated?  (And if so, are there any
> examples I can crib from?)

See the code in the src/renameat2.c for an example of how syscalls
and their flags are added prior to their being kernel and userspace
header support.

Also, note the "-t" CLI option for the "test" option in that little
program.  This is used by the _require_renameat2 function that the
tests that make use of this functionality call to determine if th
etest shoul dbe run on this kernel or not.

> Also, is there an archive of the fstests@ mailing list somewhere?

I wish. I've tried to get it archived on all the major sites like
marc, spinics, etc repeatedly since the list was created and not a
single one of them have responded to any of my requests, let alone
started to archive the list....

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
