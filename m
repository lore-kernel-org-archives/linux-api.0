From: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Subject: Re: [PATCH 04/13] Always expose MAP_UNINITIALIZED to userspace
Date: Tue, 15 Sep 2015 12:42:00 +0300
Message-ID: <20150915094200.GA15444@node.dhcp.inet.fi>
References: <1441832902-28993-1-git-send-email-palmer@dabbelt.com>
 <1442271047-4908-1-git-send-email-palmer@dabbelt.com>
 <1442271047-4908-5-git-send-email-palmer@dabbelt.com>
 <20150915002358.GA12618@node.dhcp.inet.fi>
 <20150915051919.GB4091@x>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150915051919.GB4091@x>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Cc: Palmer Dabbelt <palmer-96lFi9zoCfxBDgjK7y7TUQ@public.gmane.org>, arnd-r2nGTMty4D4@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org, aishchuk-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, 3chas3-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, chris-YvXeqwSYzG2sTnJN9+BGXg@public.gmane.org, dave-gkUM19QKKo4@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, geoff-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, iulia.manda21-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org, jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xtensa-PjhNF2WwrV/0Sa2dR60CXw@public.gmane.org, mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org, jcmvbkbc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, tomi.valkeinen-l0cyMroinI0@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Sep 14, 2015 at 10:19:19PM -0700, Josh Triplett wrote:
> On Tue, Sep 15, 2015 at 03:23:58AM +0300, Kirill A. Shutemov wrote:
> > On Mon, Sep 14, 2015 at 03:50:38PM -0700, Palmer Dabbelt wrote:
> > > This used to be hidden behind CONFIG_MMAP_ALLOW_UNINITIALIZED, so
> > > userspace wouldn't actually ever see it be non-zero.  While I could
> > > have kept hiding it, the man pages seem to indicate that
> > > MAP_UNINITIALIZED should be visible:
> > > 
> > >   mmap(2)
> > >   MAP_UNINITIALIZED (since Linux 2.6.33)
> > >     Don't clear anonymous pages.  This flag is intended to improve
> > >     performance on embedded devices.  This flag is honored only if the
> > >     kernel was configured with the CONFIG_MMAP_ALLOW_UNINITIALIZED
> > >     option.  Because of the security implications, that option is
> > >     normally enabled only on embedded devices (i.e., devices where one
> > >     has complete control of the contents of user memory).
> > > 
> > > and since the only time it shows up in my /usr/include is in this
> > > header I believe this should have been visible to userspace (as
> > > non-zero, which wouldn't do anything when or'd into the flags) all
> > > along.
> > 
> > Are you sure about "wouldn't do anything"?
> > Suspiciously, 0x4000000 is also (1 << MAP_HUGE_SHIFT). I'm not sure if any
> > architecture has order-1 huge pages, but still looks like we have conflict
> > here.
> > 
> > I think it's harmful to expose non-zero MAP_UNINITIALIZED to system which
> > potentially can handle multiple users. Or non-trivial user space in
> > general.
> 
> The flag should always exist.

Sure. And 0 is perfectly fine value for the flag. Like with MAP_FILE.

> If it was defined to conflict with
> something else, that's a serious ABI problem.  But the flag
> should always exist, even if the kernel ends up ignoring it.
> 
> > Should we leave it at least under '#ifndef CONFIG_MMU'? I don't think it's
> > possible to have single ABI for MMU and MMU-less systems anyway. And we
> > can avoid conflict with MAP_HUGE_SHIFT this way.
> 
> No; even if you have an MMU (which is useful for things like fork()), a
> system without user separation (for instance, without CONFIG_MULTIUSER)
> can reasonably use MAP_UNINITIALIZED.

Can? Yes. Reasonably? I don't think so.

> > P.S. MAP_UNINITIALIZED itself looks very broken to me. I probably need dig
> > mailing list on why it was allowed.
> 
> That's what the config option *and* explicit flag are for; there are
> more than enough warnings about the implications.

I think it's misdesigned. It doesn't require explicid opt-in from a
process who owned the page allocated in MAP_UNINITIALIZED mapping before.

#define MAP_LEAK_ME_SOME_DATA MAP_UNINITIALIZED

-- 
 Kirill A. Shutemov
