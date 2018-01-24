From: Dave Martin <Dave.Martin-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [RFC PATCH 1/2] arm64: fpsimd: Fix bad si_code for undiagnosed
 SIGFPE
Date: Wed, 24 Jan 2018 09:53:44 +0000
Message-ID: <20180124095341.GC5862@e103592.cambridge.arm.com>
References: <878tcp8umz.fsf@xmission.com>
 <20180123101446.GP22781@e103592.cambridge.arm.com>
 <87tvvc77nf.fsf@xmission.com>
 <20180123.132916.1025436873838680654.davem@davemloft.net>
 <87lggo7430.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87lggo7430.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Jan 23, 2018 at 01:44:19PM -0600, Eric W. Biederman wrote:
> David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org> writes:
> 
> > From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
> > Date: Tue, 23 Jan 2018 12:27:16 -0600
> >
> >> Dave Martin <Dave.Martin-5wv7dgnIgG8@public.gmane.org> writes:
> >> 
> >>> On Mon, Jan 22, 2018 at 03:13:08PM -0600, Eric W. Biederman wrote:
> >>> However, the purpose of this as an RFC was to get feedback on whether
> >>> adding FPE_UNKNOWN is considered acceptable at all from an API
> >>> perspective -- the precise number doesn't matter for that discussion.
> >>>
> >>> Do you have any view on this?
> >> 
> >> That seems as good a solution as any too me.  It is reality and it
> >> happens in the code and there are several places of the same form I
> >> would use it, just to get rid of the FPE_FIXME.
> >
> > Eric, feel free to do something similar on Sparc.
> 
> Will do.
> 
> This sounds like a good solution for this weird corner case, that
> appears on multiple architectures.

OK, I'll rebase my patches onto your tree (though trivial here) and
repost.

I'm still waiting for feeback on the Arm specifics, but FPE_UNKNOWN
could be picked up independently of that.

Cheers
---Dave
