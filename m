From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [RFC]: Convention for naming syscall revisions
Date: Thu, 6 Jun 2019 19:54:35 -0400
Message-ID: <20190606235435.GD23169@mit.edu>
References: <20190606154224.7lln4zp6v3ey4icq@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190606154224.7lln4zp6v3ey4icq@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Jun 06, 2019 at 05:42:25PM +0200, Christian Brauner wrote:
> Hey everyone,
> 
> I hope this is not going to start a trash fire.
> 
> While working on a new clone version I tried to find out what the
> current naming conventions for syscall revisions is. I was told and
> seemed to be able to confirm through the syscall list that revisions of
> syscalls are for the most part (for examples see [1]) named after the
> number of arguments and not for the number of revisions. But some also
> seem to escape that logic (e.g. clone2).

There are also examples which show that it's a revision number:

      preadv2, pwritev2, mlock2, sync_file_range2

immediately come to mind.  It's also important to note that in some
cases, we do something very different (look aht the stat and fstat
variants), and that in some cases the number of parameters for a
system call vary between architectures (because of system call
argument passing limitations), and this gets papered over by glibc.

So we can define what the historical pattern, but there might be a big
difference between what might make sense as an internal naming
convention, and the names that we want to expose to userspace
application programmers --- especially if the number of arguments at
the syscall level might be different (on some architectures) than at
the C library level.

					- Ted
