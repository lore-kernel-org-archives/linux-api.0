From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 0/2] mm,fork,security: introduce MADV_WIPEONFORK
Date: Mon, 7 Aug 2017 15:46:48 +0200
Message-ID: <20170807134648.GI32434@dhcp22.suse.cz>
References: <20170806140425.20937-1-riel@redhat.com>
 <20170807132257.GH32434@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170807132257.GH32434-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, colm-ZXBCfW2eEe/k1uMJSBkQmQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon 07-08-17 15:22:57, Michal Hocko wrote:
> This is an user visible API so make sure you CC linux-api (added)
> 
> On Sun 06-08-17 10:04:23, Rik van Riel wrote:
> > v2: fix MAP_SHARED case and kbuild warnings
> > 
> > Introduce MADV_WIPEONFORK semantics, which result in a VMA being
> > empty in the child process after fork. This differs from MADV_DONTFORK
> > in one important way.
> > 
> > If a child process accesses memory that was MADV_WIPEONFORK, it
> > will get zeroes. The address ranges are still valid, they are just empty.
> > 
> > If a child process accesses memory that was MADV_DONTFORK, it will
> > get a segmentation fault, since those address ranges are no longer
> > valid in the child after fork.
> > 
> > Since MADV_DONTFORK also seems to be used to allow very large
> > programs to fork in systems with strict memory overcommit restrictions,
> > changing the semantics of MADV_DONTFORK might break existing programs.
> > 
> > The use case is libraries that store or cache information, and
> > want to know that they need to regenerate it in the child process
> > after fork.

How do they know that they need to regenerate if they do not get SEGV?
Are they going to assume that a read of zeros is a "must init again"? Isn't
that too fragile? Or do they play other tricks like parse /proc/self/smaps
and read in the flag?
 
> > Examples of this would be:
> > - systemd/pulseaudio API checks (fail after fork)
> >   (replacing a getpid check, which is too slow without a PID cache)
> > - PKCS#11 API reinitialization check (mandated by specification)
> > - glibc's upcoming PRNG (reseed after fork)
> > - OpenSSL PRNG (reseed after fork)
> > 
> > The security benefits of a forking server having a re-inialized
> > PRNG in every child process are pretty obvious. However, due to
> > libraries having all kinds of internal state, and programs getting
> > compiled with many different versions of each library, it is
> > unreasonable to expect calling programs to re-initialize everything
> > manually after fork.
> > 
> > A further complication is the proliferation of clone flags,
> > programs bypassing glibc's functions to call clone directly,
> > and programs calling unshare, causing the glibc pthread_atfork
> > hook to not get called.
> > 
> > It would be better to have the kernel take care of this automatically.
> > 
> > This is similar to the OpenBSD minherit syscall with MAP_INHERIT_ZERO:
> > 
> >     https://man.openbsd.org/minherit.2

I would argue that a MAP_$FOO flag would be more appropriate. Or do you
see any cases where such a special mapping would need to change the
semantic and inherit the content over the fork again?

I do not like the madvise because it is an advise and as such it can be
ignored/not implemented and that shouldn't have any correctness effects
on the child process.
-- 
Michal Hocko
SUSE Labs
