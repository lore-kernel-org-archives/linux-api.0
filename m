From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: CGroup Namespaces (v8)
Date: Fri, 1 Jan 2016 01:42:57 -0800
Message-ID: <CAPcyv4iig_sujK=p0TbNjTmtv39N7a0HSqpVe8mLnfX9Es7zNA@mail.gmail.com>
References: <1450844609-9194-1-git-send-email-serge.hallyn@ubuntu.com>
	<CAA9_cmcNeg4vR7Ft8YcPGZtacftDWjC=5mHs2ZRzu9yXoOAJiA@mail.gmail.com>
	<20160101085911.GA28407@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160101085911.GA28407-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Cc: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jan 1, 2016 at 12:59 AM, Serge E. Hallyn
<serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org> wrote:
> On Fri, Jan 01, 2016 at 12:19:44AM -0800, Dan Williams wrote:
>> On Tue, Dec 22, 2015 at 8:23 PM,  <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org> wrote:
>> > Hi,
>> >
>> > following is a revised set of the CGroup Namespace patchset which =
Aditya
>> > Kali has previously sent.  The code can also be found in the cgrou=
pns.v8
>> > branch of
>> >
>> > https://git.kernel.org/cgit/linux/kernel/git/sergeh/linux-security=
=2Egit/
>>
>> Happy New Year!
>>
>> I'm hitting both a build and boot regression in -next with these
>> patches.  The bisect log reports:
>>
>> git bisect skip f176ae3a5df610e0373c39538cc7744c7788b3df
>> # bad: [54b39d263704b66cc8006ce8f7dd4743fdabae70] cgroup: cgroup
>> namespace setns support
>> git bisect bad 54b39d263704b66cc8006ce8f7dd4743fdabae70
>> # good: [bf9b3590879afbaa54148d817ed68a0b51180375] sched: new clone
>> flag CLONE_NEWCGROUP for c
>> group namespace
>> git bisect good bf9b3590879afbaa54148d817ed68a0b51180375
>> # only skipped commits left to test
>> # possible first bad commit:
>> [54b39d263704b66cc8006ce8f7dd4743fdabae70] cgroup: cgroup namespa
>> ce setns support
>> # possible first bad commit:
>> [f176ae3a5df610e0373c39538cc7744c7788b3df] cgroup: introduce cgro
>> up namespaces
>>
>> Where compiling "f176ae3a5df6"  fails with:
>>
>> kernel/cgroup.c: In function =E2=80=98cgroupns_put=E2=80=99:
>> kernel/cgroup.c:5956:2: error: implicit declaration of function
>> =E2=80=98to_cg_ns=E2=80=99 [-Werror=3Dimplicit-f
>> unction-declaration]
>>  put_cgroup_ns(to_cg_ns(ns));
>
> Hi,
>
> is it possible you have a bad tree?

No, I don't believe so...

>  Looking at
> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree=
/kernel/cgroup.c?id=3Drefs/tags/next-20151231
> to_cg_ns should definately be defined there.
>

Right, but it's not defined until commit 54b39d263704 "cgroup: cgroup
namespace setns support", however it is first used in the preceeding
commit f176ae3a5df6 "cgroup: introduce cgroup namespaces".  The bad
patch ordering breaks bisection.

Commit 54b39d263704 "cgroup: cgroup namespace setns support" not
booting is a separate issue.
