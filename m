From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH] capabilities: Ambient capability set V1
Date: Thu, 26 Feb 2015 12:58:33 -0800
Message-ID: <CALCETrXGO+ejHAfic4fozf1y48WDBdk3Mo=dFt8MMxtN1HOuUg@mail.gmail.com>
References: <20150224164429.GB29685@ubuntumail> <alpine.DEB.2.11.1502241120270.29416@gentwo.org>
 <20150225033247.GC29685@ubuntumail> <alpine.DEB.2.11.1502251423580.13489@gentwo.org>
 <20150226153524.GC15182@mail.hallyn.com> <alpine.DEB.2.11.1502261224580.7451@gentwo.org>
 <20150226193200.GA17709@mail.hallyn.com> <alpine.DEB.2.11.1502261412250.7451@gentwo.org>
 <20150226203405.GB18926@mail.hallyn.com> <CALCETrUB1bb4TiiBgdAMVtRJcEAoDzuOH+StTLPVL8QiXXdOfQ@mail.gmail.com>
 <20150226205512.GA19273@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150226205512.GA19273-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Aaron Jones <aaronmdjones-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ted Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Andrew G. Morgan" <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Markku Savela <msa-kXoF896ld44xHbG02/KK1g@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Feb 26, 2015 at 12:55 PM, Serge E. Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> wrote:
> On Thu, Feb 26, 2015 at 12:51:57PM -0800, Andy Lutomirski wrote:
>> On Thu, Feb 26, 2015 at 12:34 PM, Serge E. Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> wrote:
>> > On Thu, Feb 26, 2015 at 02:13:00PM -0600, Christoph Lameter wrote:
>> >> On Thu, 26 Feb 2015, Serge E. Hallyn wrote:
>> >>
>> >> > Andrew Morgan was against that.  What if we changed
>> >> >
>> >> > pE' = pP' & (fE | pA)
>> >> >
>> >> > to
>> >> >
>> >> >     if (pA)
>> >> >             pE' = pP' & fE
>> >> >     else
>> >> >             pE' = pP'
>> >> >
>> >>
>> >> Same problem as before. The ambient bits will not be set in pE'.
>> >
>> > And what if I weren't scatterbrained and we did
>> >
>> >         if (pA)
>> >                 pE' = pP'
>> >         else
>> >                 pE' = pP' & fE
>> >
>> > All pP' bits would be set in pE'.
>>
>> That seems reasonable to me, except for my paranoia:
>>
>> What if there's a program with CAP_DAC_OVERRIDE in fP and fE set to
>> the empty set (i.e. the magic effective bit cleared), and the program
>> relies on that.  A malicious user has CAP_NET_BIND and sets pA =
>> CAP_NET_BIND.  Boom!
>>
>> If we changed that to if (pA') and zeroed pA if fP is non-empty then
>> this problem goes away.
>
> Hm, the problem is that then the empty pA is inherited by children.
> I do see that any program with fP set should probably run with only
> what it requested.  Would
>
>          if (pA && is_empty(fP))
>                  pE' = pP'
>          else
>                  pE' = pP' & fE
>
> help?  Or are you worried about a program with fP set which then
> executes other programs?

The particular worry I expressed there was just about pE.

I'm still extremely nervous about allowing nonempty pA to propagate to
setuid or nonzero fP programs.  It's less obviously dangerous if pA is
never a superset of pP, but it could still cause problems with setuid
programs that execute intentionally deprivileged helpers.

--Andy
