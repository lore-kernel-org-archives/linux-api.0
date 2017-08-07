From: =?UTF-8?Q?Colm_MacC=C3=A1rthaigh?= <colm@allcosts.net>
Subject: Re: [PATCH v2 0/2] mm,fork,security: introduce MADV_WIPEONFORK
Date: Mon, 7 Aug 2017 18:02:23 +0200
Message-ID: <CAAF6GDfmBK_dOneBz=0p8MgjaM=fpGfRzkpqGqDf3y9kipZ0EQ@mail.gmail.com>
References: <20170806140425.20937-1-riel@redhat.com> <20170807132257.GH32434@dhcp22.suse.cz>
 <20170807134648.GI32434@dhcp22.suse.cz> <CAAF6GDcNoDUaDSxV6N12A_bOzo8phRUX5b8-OBteuN0AmeCv0g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAAF6GDcNoDUaDSxV6N12A_bOzo8phRUX5b8-OBteuN0AmeCv0g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

[ Resent as text/plain, after sacrificing an offering to the RFC822 gods]

On Mon, Aug 7, 2017 at 3:46 PM, Michal Hocko <mhocko@kernel.org> wrote:
>
>
> > > The use case is libraries that store or cache information, and
> > > want to know that they need to regenerate it in the child process
> > > after fork.
>
> How do they know that they need to regenerate if they do not get SEGV?
> Are they going to assume that a read of zeros is a "must init again"?
> Isn't
> that too fragile? Or do they play other tricks like parse /proc/self/smaps
> and read in the flag?

Hi from a user space crypto maintainer :) Here's how we do exactly this it
in s2n:

https://github.com/awslabs/s2n/blob/master/utils/s2n_random.c , lines 62 - 91

and here's how LibreSSL does it:

https://github.com/libressl-portable/openbsd/blob/57dcd4329d83bff3dd67a293d5c4a53b795c587e/src/lib/libc/crypt/arc4random.h
(lines 37 on)
https://github.com/libressl-portable/openbsd/blob/57dcd4329d83bff3dd67a293d5c4a53b795c587e/src/lib/libc/crypt/arc4random.c
(Line 110)

OpenSSL and libc are in the process of adding similar DRBGs and would use a
WIPEONFORK. BoringSSL's maintainers are also interested as it adds
robustness.  I also recall it being a topic of discussion at the High
Assurance Cryptography Symposium (HACS) where many crypto maintainers meet
and several more maintainers there indicated it would be nice to have.

Right now on Linux we all either use pthread_atfork() to zero the memory on
fork, or getpid() and getppid() guards. The former can be evaded by direct
syscall() and other tricks (which things like Language VMs are prone to
doing), and the latter check is probabilistic as pids can repeat, though if
you use both getpid() and getppid() - which is slow! - the probability of
both PIDs colliding is very low indeed.

The result at the moment on Linux there's no bulletproof way to detect a
fork and erase a key or DRBG state. It would really be nice to be able to
match what we can do with MAP_INHERIT_ZERO and minherit() on BSD.  madvise()
does seem like the established idiom for behavior like this on Linux.  I
don't imagine it will be hard to use in practice, we can fall back to
existing behavior if the flag isn't accepted.


-- 
Colm
