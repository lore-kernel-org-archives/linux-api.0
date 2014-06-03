From: Julien Tinnes <jln@google.com>
Subject: Re: [PATCH v5 0/6] seccomp: add PR_SECCOMP_EXT and SECCOMP_EXT_ACT_TSYNC
Date: Tue, 3 Jun 2014 16:47:50 -0700
Message-ID: <CAKyRK=i+nDe3jFXRnYeDbrefc4HwC4gn16Biq8GMjXPRfry+oQ@mail.gmail.com>
References: <1400799936-26499-1-git-send-email-keescook@chromium.org>
	<CAGXu5jLYPbJKCBvhVxfHEUFeCPJO-OBhRFufUSNy6o1N=LJ6UQ@mail.gmail.com>
	<CALCETrV0ZEFipU0E64n5q44LiUV4j4Qqvnz0h_QAoddg+e7V3A@mail.gmail.com>
	<CAGXu5j+YRW_+W8Z9S9O84ep-uUc4wQQRbtSu6_s8o5J2HLPUYg@mail.gmail.com>
	<CALCETrXB0zp8gwpWuxXs0bgB8sQhe6JLE46BOYw3OrBx7hQYVw@mail.gmail.com>
	<CAGXu5jKFte0ZvqU8RYcqjWDCoegWeu66gdwX83tiL8vprcvMgQ@mail.gmail.com>
	<CALCETrWLNFJbwaYKkjBi7XPLBQ2=gEGmW=G==+_9jcrLPW+JdA@mail.gmail.com>
	<CAHO5Pa3F2MjfTtfNxa8LbnkeeU8=YJ+9tDqxZpw7Gz59E-4AUg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHO5Pa3F2MjfTtfNxa8LbnkeeU8=YJ+9tDqxZpw7Gz59E-4AUg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Kees Cook <keescook@chromium.org>, Linux API <linux-api@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, James Morris <james.l.morris@oracle.com>, Stephen Rothwell <sfr@canb.auug.org.au>, "David S. Miller" <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, Will Drewry <wad@chromium.org>, Alexei Starovoitov <ast@plumgrid.com>
List-Id: linux-api@vger.kernel.org

On Tue, Jun 3, 2014 at 3:12 AM, Michael Kerrisk <mtk.manpages@gmail.com> wrote:
> [Kees, thank you for CCing linux-api]
>
> On Tue, Jun 3, 2014 at 1:08 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>> On Mon, Jun 2, 2014 at 4:05 PM, Kees Cook <keescook@chromium.org> wrote:
>
>>> I'd like to hear from other folks on this (akpm?). My instinct is to
>>> continue using prctl since that is already where mediation for seccomp
>>> happens. I don't see why prctl vs a new syscall makes a difference
>>> here, frankly.
>>
>> Aesthetics?  There's a tendency for people to get annoyed at big
>> multiplexed APIs, and your patches will be doubly multiplexed.
>
> prctl() is already a Franken-interface that provides a mass of
> different, mostly completely unrelated, functionality. So, I wonder if
> it would be better not to make the situation worse. Furthermore, the
> very fact that the existing prctl seccomp API is being extended and
> multiplexed suggests that other extensions might be desirable further
> down the line, which also hints that a separate syscall would be a
> good idea. (Or do we have to wait until the prctl seccomp API is
> extended one more time, before we realize that a new system call would
> have been a good idea...)
>
>> TBH, I care more about the atomicity thing than about the actual form
>> of the API.
>
> User-space does not necessarily thank you for that perspective, Andy
> ;-). The atomicity thing is presumably fixable, regardless of the API.
> On the other hand, APIs are things that kernel developers design once
> and forget about, and user-space has to live with forever.

Well, maybe the history of it being a prctl() should count for something.
Most likely, userland will need to test for whether or not these
features are present in the kernel for years to come. With a syscall,
it would now require a syscall (unlikely to be in older headers for a
while, so will require using syscall(3) for a bit) as well as a call
to prctl() to test for seccomp mode 2 (without thread sync) in the
fallback path. It'll be a little odd. As the person who will make this
work in Chromium, I do not feel strongly either way, it's a detail, so
feel free to disregard this point.

But I'm eagerly waiting for:
- Not having to test for the presence of threads at run-time (which
requires a very ugly busy loop with exponential back-off watching for
/proc/self/tasks/ to drop to 1 directory entry).
- Being able to engage the sandbox after third-party libraries have
started threads.

Julien
