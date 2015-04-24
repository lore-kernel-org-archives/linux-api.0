From: Mark Williamson <mwilliamson-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>
Subject: Re: Regression: Requiring CAP_SYS_ADMIN for /proc/<pid>/pagemap
 causes application-level breakage
Date: Fri, 24 Apr 2015 17:46:25 +0100
Message-ID: <CAEVpBa+JpidwFTxvJj1U1n3y+gRb+5+YJ1bUTEC3d2Wp=34Wow@mail.gmail.com>
References: <CAEVpBa+7Yp+zCTczZqBd6Qp_uM7yy0i8YZfZkUbDeUsPpKtqRQ@mail.gmail.com>
	<CA+55aFymwdHBs02GQkqQYwYF9Ru5dMKd4=2whLUfPwZSPU7ZGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFymwdHBs02GQkqQYwYF9Ru5dMKd4=2whLUfPwZSPU7ZGA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mark Seaborn <mseaborn-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Finn Grimwood <fgrimwood-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>, Daniel James <djames-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Linus,

Thanks for responding so quickly!

On Fri, Apr 24, 2015 at 5:08 PM, Linus Torvalds
<torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> So the one exception to the regression rule is "security fixes", but
> even for security fixes we do try to be as reasonable as humanly
> possible to make them not break things.

Understood - there are clear reasons something had to be done here.

> Now, as you mentioned, one option is to not outright disallow accesses
> to the /proc/PID/pagemap, but to at least hide the page frame numbers.
> However, I don't believe that we have a good enough scrambling model
> to make that reasonable. Remember: any attacker will be able to see
> our scrambling code, so it would need to be both cryptographically
> secure *and* use a truly random per-VM secret key. Quite frankly,
> that's a _lot_ of effort for dubious gain...

*nod*

> So the "just show physical addresses as zero for non-root users"
> (instead of the outright ban on opening the file) is likely the only
> really viable alternative.
>
> It sounds like that could work for you. So if you can modify the app
> to do that, and send me a tested kernel patch that moves the
> permission check into the read phase (remember to use the open-time
> credentials in "file->f_cred" rather than the read-time credentials in
> "current" - otherwise you can trick some suid program to read the fily
> that an unauthorized user opened), then we can have this fixed. Does
> that sound reasonable?

That sounds very reasonable, thank you!  We'll cook up a patch and get
back to you.

Thanks,
Mark
