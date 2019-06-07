From: Christian Brauner <christian@brauner.io>
Subject: Re: [RFC]: Convention for naming syscall revisions
Date: Fri, 7 Jun 2019 15:42:53 +0200
Message-ID: <20190607134252.kf3e6ifm7qpw2cas@brauner.io>
References: <20190606154224.7lln4zp6v3ey4icq@brauner.io>
 <20190606235435.GD23169@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190606235435.GD23169@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Jun 06, 2019 at 07:54:35PM -0400, Theodore Ts'o wrote:
> On Thu, Jun 06, 2019 at 05:42:25PM +0200, Christian Brauner wrote:
> > Hey everyone,
> > 
> > I hope this is not going to start a trash fire.
> > 
> > While working on a new clone version I tried to find out what the
> > current naming conventions for syscall revisions is. I was told and
> > seemed to be able to confirm through the syscall list that revisions of
> > syscalls are for the most part (for examples see [1]) named after the
> > number of arguments and not for the number of revisions. But some also
> > seem to escape that logic (e.g. clone2).
> 
> There are also examples which show that it's a revision number:
> 
>       preadv2, pwritev2, mlock2, sync_file_range2
> 
> immediately come to mind.  It's also important to note that in some

Exactly, that's what made it confusing in the first place.

> cases, we do something very different (look aht the stat and fstat
> variants), and that in some cases the number of parameters for a

Sure, there will always be cases where we will revise a syscall but it
makes sense to name it completely different than its predecessor.
(Very different behavior, bad original naming immediately come to mind
as reasons.)

But for the general case where we do stuff like:
dup()
dup2()
dup3()

we could probably just make a call and document something like:

"If a syscall is revised and a completely new name is not warranted by
its design the consensus is to append the revision number."

and then maybe also add a brief section about what we historically did
and maybe also briefly point out what some good indicators are that a
completely new name could be used.

> system call vary between architectures (because of system call
> argument passing limitations), and this gets papered over by glibc.
> 
> So we can define what the historical pattern, but there might be a big
> difference between what might make sense as an internal naming
> convention, and the names that we want to expose to userspace
> application programmers --- especially if the number of arguments at

Right, but I am specifically interested in naming conventions for the
kernel not for userspace. :)

Christian
