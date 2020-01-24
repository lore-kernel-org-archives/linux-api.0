From: Florian Weimer <fweimer@redhat.com>
Subject: Re: Proposal to fix pwrite with O_APPEND via pwritev2 flag
Date: Fri, 24 Jan 2020 10:37:22 +0100
Message-ID: <87d0b942lp.fsf@oldenburg2.str.redhat.com>
References: <20200124000243.GA12112@brightrain.aerifal.cx>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200124000243.GA12112@brightrain.aerifal.cx> (Rich Felker's
        message of "Thu, 23 Jan 2020 19:02:43 -0500")
Sender: linux-kernel-owner@vger.kernel.org
To: Rich Felker <dalias@libc.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

* Rich Felker:

> There's a longstanding unfixable (due to API stability) bug in the
> pwrite syscall:
>
> http://man7.org/linux/man-pages/man2/pwrite.2.html#BUGS
>
> whereby it wrongly honors O_APPEND if set, ignoring the caller-passed
> offset. Now that there's a pwritev2 syscall that takes a flags
> argument, it's possible to fix this without breaking stability by
> adding a new RWF_NOAPPEND flag, which callers that want the fixed
> behavior can then pass.
>
> I have a completely untested patch to add such a flag, but would like
> to get a feel for whether the concept is acceptable before putting
> time into testing it. If so, I'll submit this as a proper patch with
> detailed commit message etc. Draft is below.

Has this come up before?

I had already written a test case and it turns out that an O_APPEND
descriptor does not protect the previously written data in the file:

openat(AT_FDCWD, "/tmp/append-truncateuoRexJ", O_RDWR|O_CREAT|O_EXCL, 0600) = 3
write(3, "@", 1)                        = 1
close(3)                                = 0
openat(AT_FDCWD, "/tmp/append-truncateuoRexJ", O_WRONLY|O_APPEND) = 3
ftruncate(3, 0)                         = 0

So at least it looks like there is no security issue in adding a
RWF_NOAPPEND flag.

Thanks,
Florian
