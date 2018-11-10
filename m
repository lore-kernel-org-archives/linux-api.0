From: Willy Tarreau <w@1wt.eu>
Subject: Re: Official Linux system wrapper library?
Date: Sat, 10 Nov 2018 20:33:22 +0100
Message-ID: <20181110193322.GB21185@1wt.eu>
References: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com>
 <20181110190132.GA21185@1wt.eu>
 <CAKOZuevup11kuHGb3QD5GuA1c7_B=Nnq-kDEB5Hbv=OqXVotQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKOZuevup11kuHGb3QD5GuA1c7_B=Nnq-kDEB5Hbv=OqXVotQQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Sat, Nov 10, 2018 at 11:06:45AM -0800, Daniel Colascione wrote:
> Reminds me of LSS: https://chromium.googlesource.com/linux-syscall-support/

Interesting, thanks for the link, I would probably not have started mine
had I known this one :-)

> I'm not a fan of this approach for general-purpose use. There's value
> in having *some* common function-level indirection before actually
> issuing system calls, e.g., for LD_PRELOAD stuff.

I'm not speaking about general purpose replacement but more about
general purpose low level functions that glibc wrappers can safely
use and expose by default. This way general purpose applications
would still use glibc and those willing to use a lower level could
do it more easily by accessing the lower layer, without having to
define their own syscalls. If I could do something like this in my
code :

  #ifndef HAVE_SYSCALL_SPLICE  // exposed by glibc
  # ifdef __linux_splice       // exposed by kernel header
  #  define splice __linux_splice
  # else
  #  error "no splice exposed by either libc or kernel headers"
  # endif
  #endif

It would be easier, safer and cleaner than what I've used to do before :

  #if !defined(HAVE_SYSCALL_SPLICE) && defined(__NR_splice)
  static inline _syscall6(int, splice, int, fdin, loff_t *, off_in, int, fdout, loff_t *, off_out, size_t, len, unsigned long, flags);
  #endif

Willy
