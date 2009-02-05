From: Michael Kerrisk <mtk.manpages@googlemail.com>
Subject: Re: [patch/rfc] eventfd semaphore-like behavior
Date: Thu, 5 Feb 2009 13:26:32 +1300
Message-ID: <cfd18e0f0902041626x25e0e2d8w1759d824be4cfe77@mail.gmail.com>
References: <alpine.DEB.1.10.0902041349180.6214@alien.or.mcafeemobile.com>
	 <20090204150507.665b5b7c.akpm@linux-foundation.org>
	 <alpine.DEB.1.10.0902041509060.6214@alien.or.mcafeemobile.com>
	 <20090204152434.c8f65d52.akpm@linux-foundation.org>
	 <alpine.DEB.1.10.0902041526590.6214@alien.or.mcafeemobile.com>
	 <20090204155514.6abbdc8f.akpm@linux-foundation.org>
	 <cfd18e0f0902041559l4c40d9b6k704068337a00df7a@mail.gmail.com>
	 <20090204161816.b93a4588.akpm@linux-foundation.org>
Reply-To: mtk.manpages@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1761326AbZBEA0w@vger.kernel.org>
In-Reply-To: <20090204161816.b93a4588.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: davidel@xmailserver.org, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Feb 5, 2009 at 1:18 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 5 Feb 2009 12:59:07 +1300
> Michael Kerrisk <mtk.manpages@googlemail.com> wrote:
>
>> >> > > > What should be userspace's fallback strategy if that support is not
>> >> > > > present?
>> >> > >
>> >> > > #ifdef EFD_SEMAPHORE, maybe?
>> >> >
>> >> > That's compile-time.  People who ship binaries will probably want
>> >> > to find a runtime thing for back-compatibility.
>> >>
>> >> I dunno. How do they actually do when we add new flags, like the O_ ones?
>> >>
>> >
>> > Dunno.  Probably try the syscall and see if it returned -EINVAL.  Does
>> > that work in this case?
>>
>> As youll have seen by now, Ulrich and I noted that it works.
>
> I think you means "should work" ;)
>
> We're talking about this, yes?
>
> SYSCALL_DEFINE2(eventfd2, unsigned int, count, int, flags)
> {
>        int fd;
>        struct eventfd_ctx *ctx;
>
>        /* Check the EFD_* constants for consistency.  */
>        BUILD_BUG_ON(EFD_CLOEXEC != O_CLOEXEC);
>        BUILD_BUG_ON(EFD_NONBLOCK != O_NONBLOCK);
>
>        if (flags & ~(EFD_CLOEXEC | EFD_NONBLOCK))
>                return -EINVAL;
>
> That looks like it should work to me.

Yes, that's what we're talking about, plus a similar check that Ulrih
added in the case that glibc's eventfd() falls back to sy_event().

Cheers,

Michael

--
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
