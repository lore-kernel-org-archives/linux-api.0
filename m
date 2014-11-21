From: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv2 2/3] selftests: Add test of O_BENEATH & openat(2)
Date: Fri, 21 Nov 2014 14:19:41 +0000
Message-ID: <CAHse=S9OwP8tSErW59Hd3VPbKVrE9VJM=5gMgZQwsv3kB9Ax0w@mail.gmail.com>
References: <1415094884-18349-1-git-send-email-drysdale@google.com>
 <1415094884-18349-3-git-send-email-drysdale@google.com> <20141111053641.GR23575@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141111053641.GR23575@dastard>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Jorge Lucangeli Obes <jorgelo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ricky Zhou <rickyz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Lee Campbell <leecam-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Julien Tinnes <jln-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mike Depinet <mdepinet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Nov 11, 2014 at 5:36 AM, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org> wrote:
> [cc fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org]
>
> On Tue, Nov 04, 2014 at 09:54:43AM +0000, David Drysdale wrote:
>> Add simple tests of openat(2) variations, including examples that
>> check the new O_BENEATH flag.
>>
>> Signed-off-by: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>
> Wouldn't this be better added to fstests? That's the regression
> test suite used by filesystem developers and most distro QA
> organisations and where the fs developers aggregate all their new
> regression tests.
>
> IMO, the fewer places we aggregate VFS/filesystem tests the better.
> I really don't think the kernel tree is the best place for adding
> VFS behavioural tests because it has none of the infrastructure
> around it to test arbitrary filesystems and configurations and hence
> is not particularly useful to the people whoa re likely to notice
> and care about fs regression tests suddenly breaking.
>
> As an example, the recent renameat() syscall additions (e.g.
> RENAME_EXCHANGE, RENAME_NOREPLACE) have unit tests in fstests, so
> these new O_BENEATH tests should really follow the same model...
>
> Cheers,
>
> Dave.

Fair enough, that makes sense -- I've now got a version of the selftest
running within xfstests (git://oss.sgi.com/xfs/cmds/xfstests.git is the
master repo, right?).

Given that xfstests is independent of the kernel, what's the expected
way to deal with flags (or syscalls) that are only in specific kernel
versions?   At the moment I've just got a primitive override at
compile time (#ifndef O_BENEATH #define O_BENEATH ...), and
then the test will fail at run-time against an older kernel -- is there a
need for anything more sophisticated?  (And if so, are there any
examples I can crib from?)

Also, is there an archive of the fstests@ mailing list somewhere?

Thanks,
David
