From: Daniel Colascione <dancol@google.com>
Subject: Re: Official Linux system wrapper library?
Date: Sat, 10 Nov 2018 11:06:45 -0800
Message-ID: <CAKOZuevup11kuHGb3QD5GuA1c7_B=Nnq-kDEB5Hbv=OqXVotQQ@mail.gmail.com>
References: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com>
 <20181110190132.GA21185@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181110190132.GA21185@1wt.eu>
Sender: linux-kernel-owner@vger.kernel.org
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Sat, Nov 10, 2018 at 11:01 AM, Willy Tarreau <w@1wt.eu> wrote:
> On Sat, Nov 10, 2018 at 10:52:06AM -0800, Daniel Colascione wrote:
>> Now that glibc is basically not adding any new system call wrappers,
>> how about publishing an "official" system call glue library as part of
>> the kernel distribution, along with the uapi headers? I don't think
>> it's reasonable to expect people to keep using syscall(__NR_XXX) for
>> all new functionality, especially as the system grows increasingly
>> sophisticated capabilities (like the new mount API, and hopefully the
>> new process API) outside the strictures of the POSIX process.
>
> It's partly related, but you may be interested in something I did that
> is in the the RCU tree. It's called "nolibc", it's a set of syscall
> wrappers defined only in include files. It's not complete, but still
> enough to boot some small init wrappers. Mine can extract tar files
> and do stuff like this with it. Here is the kernel port in the RCU
> tree and an example of code using it :
>
>    https://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git/tree/tools/testing/selftests/rcutorture/bin/nolibc.h?h=rcu/next
>    https://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git/tree/tools/testing/selftests/rcutorture/bin/mkinitrd.sh?h=rcu/next
>
> The original one is maintained here (not very active since it works
> well enough for my use cases now eventhough it's far from being
> complete) :
>
>    http://git.formilux.org/?p=people/willy/nolibc.git
>
> Maybe something along this could be done for the vast majority of
> syscalls and the thicker stuff be left to glibc ? That would allow
> simple userland to build without glibc using only kernel headers,
> or by occasionally defining a few extra stuff or glue.

Reminds me of LSS: https://chromium.googlesource.com/linux-syscall-support/

I'm not a fan of this approach for general-purpose use. There's value
in having *some* common function-level indirection before actually
issuing system calls, e.g., for LD_PRELOAD stuff.
