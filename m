From: Willy Tarreau <w@1wt.eu>
Subject: Re: Official Linux system wrapper library?
Date: Sat, 10 Nov 2018 20:01:32 +0100
Message-ID: <20181110190132.GA21185@1wt.eu>
References: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Sat, Nov 10, 2018 at 10:52:06AM -0800, Daniel Colascione wrote:
> Now that glibc is basically not adding any new system call wrappers,
> how about publishing an "official" system call glue library as part of
> the kernel distribution, along with the uapi headers? I don't think
> it's reasonable to expect people to keep using syscall(__NR_XXX) for
> all new functionality, especially as the system grows increasingly
> sophisticated capabilities (like the new mount API, and hopefully the
> new process API) outside the strictures of the POSIX process.

It's partly related, but you may be interested in something I did that
is in the the RCU tree. It's called "nolibc", it's a set of syscall
wrappers defined only in include files. It's not complete, but still
enough to boot some small init wrappers. Mine can extract tar files
and do stuff like this with it. Here is the kernel port in the RCU
tree and an example of code using it :

   https://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git/tree/tools/testing/selftests/rcutorture/bin/nolibc.h?h=rcu/next
   https://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git/tree/tools/testing/selftests/rcutorture/bin/mkinitrd.sh?h=rcu/next

The original one is maintained here (not very active since it works
well enough for my use cases now eventhough it's far from being
complete) :

   http://git.formilux.org/?p=people/willy/nolibc.git

Maybe something along this could be done for the vast majority of
syscalls and the thicker stuff be left to glibc ? That would allow
simple userland to build without glibc using only kernel headers,
or by occasionally defining a few extra stuff or glue.

Willy
