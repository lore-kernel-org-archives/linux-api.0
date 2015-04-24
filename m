From: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] capabilities: Ambient capabilities
Date: Fri, 24 Apr 2015 19:09:35 +0000
Message-ID: <20150424190935.GN16377@ubuntumail>
References: <CALCETrUGASa3Gp6cC1zdAahcS59DOdyLnTtgNX7t7FucMZLmoQ@mail.gmail.com>
 <CALQRfL6z2dEtPkWiuGydT0a+y4iWm2qw-cY0Rk9hA-K4gPw_qA@mail.gmail.com>
 <CALCETrWRHRVLotFs=Cpdr=7KjE7q52NdT62GxZg=xjv+LFZBqw@mail.gmail.com>
 <CALQRfL7AyadFcu9JqtC6FGnuuqY7zbnFAL81XnwBvn0o6c6UWQ@mail.gmail.com>
 <alpine.DEB.2.11.1503300754070.5031@gentwo.org>
 <CALCETrW9ckw=7-1JSyFkenhFu2_1MvVqjA+inOmsuuWemGaU0w@mail.gmail.com>
 <alpine.DEB.2.11.1504091024540.13650@gentwo.org>
 <alpine.DEB.2.11.1504230900260.32203@gentwo.org>
 <20150424175348.GL16377@ubuntumail>
 <CALCETrW5_85mFFTkzCVNA5N1KQeNBrkw2d8FF3H3LYtmz6UAPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrW5_85mFFTkzCVNA5N1KQeNBrkw2d8FF3H3LYtmz6UAPw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andrew Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ted Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andrew Morton <akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Andrew G. Morgan" <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Aaron Jones <aaronmdjones-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Markku Savela <msa-kXoF896ld44xHbG02/KK1g@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Quoting Andy Lutomirski (luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org):
> On Fri, Apr 24, 2015 at 10:53 AM, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org> wrote:
> > Quoting Christoph Lameter (cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org):
> >> On Thu, 9 Apr 2015, Christoph Lameter wrote:
> >>
> >> > > I'll submit a new version this week with the securebits.  Sorry for the delay.
> >>  > Are we going to get a new version?
> >>
> >> Replying to my own here. Cant we simply use the SETPCAP approach as per
> >> the patch I posted?
> >
> > Andy had objections to that, but it seems ok to me.
> >
> 
> I object because CAP_SETPCAP is very powerful whereas
> CAP_NET_BIND_SERVICE, for example, isn't.  I'm fine with having a
> switch to turn off ambient caps, but requiring the "on" state to give

Would only really be needed for the initial 'enable ambient caps for this
process tree', though.  Once that was set, add/remove'ing caps from the
ambient set wouldn't need to be required.

> processes superpowers seems unfortunate.
> 
> Sorry for the huge delay.  I got caught up with travel and the merge
> window.  Here's a sneak peek:
> 
> https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/log/?h=cap_ambient
> 
> I need to write the user code to go with it and test it a bit before
> sending it out for real.

Ok, thanks

-serge
