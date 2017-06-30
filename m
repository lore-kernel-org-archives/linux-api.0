From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH 3/8] signal/sparc: Document a conflict with SI_USER with
	SIGFPE
Date: Fri, 30 Jun 2017 13:13:40 -0500
Message-ID: <8737ahwdgr.fsf@xmission.com>
References: <87efu22set.fsf@xmission.com>
	<20170630123906.8865-3-ebiederm@xmission.com>
	<20170630.124505.736865959393416284.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20170630.124505.736865959393416284.davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org> (David
	Miller's message of "Fri, 30 Jun 2017 12:45:05 -0400 (EDT)")
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Cc: linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, xemul-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, w@1wt.eu, avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org> writes:

> From: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
> Date: Fri, 30 Jun 2017 07:39:01 -0500
>
>> diff --git a/arch/sparc/include/uapi/asm/siginfo.h b/arch/sparc/include/uapi/asm/siginfo.h
>> index 2d9b79ccaa50..6bc5c677e92f 100644
>> --- a/arch/sparc/include/uapi/asm/siginfo.h
>> +++ b/arch/sparc/include/uapi/asm/siginfo.h
>> @@ -17,6 +17,11 @@
>>  #define SI_NOINFO	32767		/* no information in siginfo_t */
>>  
>>  /*
>> + * SIGFPE si_codes
>> + */
>> +#define FPE_FIXME	(__SI_FAULT|0)	/* Broken dup of SI_USER */
>> +
>> +/*
>>   * SIGEMT si_codes
>>   */
>>  #define EMT_TAGOVF	(__SI_FAULT|1)	/* tag overflow */
>
> It's one thing to say FIXME in a comment in a kernel local header or
> C file.
>
> It's quite another to put this into the name of a macro which has
> visibility in the global user compilation namespace.
>
> I don't think you should really do that.

Good point.

Sigh.   It almost fits because we did do something off in the uapi
exported to userspace and we don't have a header file definition for
that case.

Still.  At this point arch/sparc/include/asm/siginfo.h is
a better fit for that definition.

I will respin and fix that.

I wish I knew what would make a better default floating point si_code on
sparc.  Using 0 aka SI_USER is doesn't fit at all.  Sigh.

Unfortunately I don't know the architecture well enough to even guess
what is going on in do_fpe_common when when no bits in fsr are set.

Any suggests for a better fix than just documenting that linux does
something weird and ill advised here?

Eric
