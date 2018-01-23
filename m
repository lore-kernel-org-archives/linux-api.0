From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [RFC PATCH 1/2] arm64: fpsimd: Fix bad si_code for undiagnosed SIGFPE
Date: Tue, 23 Jan 2018 12:27:16 -0600
Message-ID: <87tvvc77nf.fsf@xmission.com>
References: <1516623798-25001-1-git-send-email-Dave.Martin@arm.com>
        <1516623798-25001-2-git-send-email-Dave.Martin@arm.com>
        <878tcp8umz.fsf@xmission.com>
        <20180123101446.GP22781@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180123101446.GP22781-M5GwZQ6tE7x5pKCnmE3YQBJ8xKzm50AiAL8bYrjMMd8@public.gmane.org> (Dave Martin's
        message of "Tue, 23 Jan 2018 10:14:48 +0000")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Martin <Dave.Martin-5wv7dgnIgG8@public.gmane.org>
Cc: linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-api@vger.kernel.org

Dave Martin <Dave.Martin-5wv7dgnIgG8@public.gmane.org> writes:

> On Mon, Jan 22, 2018 at 03:13:08PM -0600, Eric W. Biederman wrote:
>> 
>> > diff --git a/include/uapi/asm-generic/siginfo.h b/include/uapi/asm-generic/siginfo.h
>> > index e447283..77edb00 100644
>> > --- a/include/uapi/asm-generic/siginfo.h
>> > +++ b/include/uapi/asm-generic/siginfo.h
>> > @@ -193,7 +193,8 @@ typedef struct siginfo {
>> >  #define FPE_FLTRES	6	/* floating point inexact result */
>> >  #define FPE_FLTINV	7	/* floating point invalid operation */
>> >  #define FPE_FLTSUB	8	/* subscript out of range */
>> > -#define NSIGFPE		8
>> > +#define FPE_UNKNOWN	9	/* undiagnosed floating-point exception */
>> > +#define NSIGFPE		9
>> 
>> Minor nit here.
>> 
>> At least before this is final I would really appreciate if you could
>> rebase this on top of my unificiation of siginfo.h that I posted on
>> linux-arch and is in my siginfo-next branch.
>> 
>> As that already pushes NSIGFPE up to 13.
>> 
>> Which would make this patch change NSIGFPE to 14 and allocate the number
>> 14 for FPE_UNKNOWN
>
> My bad -- I hadn't looked in detail at the whole series.
>
> However, the purpose of this as an RFC was to get feedback on whether
> adding FPE_UNKNOWN is considered acceptable at all from an API
> perspective -- the precise number doesn't matter for that discussion.
>
> Do you have any view on this?

That seems as good a solution as any too me.  It is reality and it
happens in the code and there are several places of the same form I
would use it, just to get rid of the FPE_FIXME.

Eric
