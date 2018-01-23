From: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Subject: Re: [RFC PATCH 1/2] arm64: fpsimd: Fix bad si_code for undiagnosed
 SIGFPE
Date: Tue, 23 Jan 2018 13:29:16 -0500 (EST)
Message-ID: <20180123.132916.1025436873838680654.davem@davemloft.net>
References: <878tcp8umz.fsf@xmission.com>
        <20180123101446.GP22781@e103592.cambridge.arm.com>
        <87tvvc77nf.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87tvvc77nf.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org
Cc: Dave.Martin-5wv7dgnIgG8@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-api@vger.kernel.org

From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Date: Tue, 23 Jan 2018 12:27:16 -0600

> Dave Martin <Dave.Martin-5wv7dgnIgG8@public.gmane.org> writes:
> 
>> On Mon, Jan 22, 2018 at 03:13:08PM -0600, Eric W. Biederman wrote:
>> However, the purpose of this as an RFC was to get feedback on whether
>> adding FPE_UNKNOWN is considered acceptable at all from an API
>> perspective -- the precise number doesn't matter for that discussion.
>>
>> Do you have any view on this?
> 
> That seems as good a solution as any too me.  It is reality and it
> happens in the code and there are several places of the same form I
> would use it, just to get rid of the FPE_FIXME.

Eric, feel free to do something similar on Sparc.
