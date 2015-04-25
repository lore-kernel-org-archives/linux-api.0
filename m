From: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] capabilities: Ambient capabilities
Date: Sat, 25 Apr 2015 02:45:36 +0000
Message-ID: <20150425024536.GA23915@ubuntumail>
References: <alpine.DEB.2.11.1504091024540.13650@gentwo.org>
 <alpine.DEB.2.11.1504230900260.32203@gentwo.org>
 <20150424175348.GL16377@ubuntumail>
 <CALCETrW5_85mFFTkzCVNA5N1KQeNBrkw2d8FF3H3LYtmz6UAPw@mail.gmail.com>
 <20150424190935.GN16377@ubuntumail>
 <CALCETrV7S0dLkNWMSYsL7MFuLgdpQwUEAjW6zTwRE8uhh_AuBQ@mail.gmail.com>
 <alpine.DEB.2.11.1504241512570.11839@gentwo.org>
 <CALCETrUrFm9n_4xTj4ELkzTSnWHfxQtANqz2wpzU7riTihLDaA@mail.gmail.com>
 <20150424211511.GB28613@mail.hallyn.com>
 <CALCETrUdNp18ZeOC8pRYn_YPUp8nFyH7aS+dFoBf34XNmER-nA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrUdNp18ZeOC8pRYn_YPUp8nFyH7aS+dFoBf34XNmER-nA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ted Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, "Andrew G. Morgan" <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Aaron Jones <aaronmdjones-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Markku Savela <msa-kXoF896ld44xHbG02/KK1g@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Quoting Andy Lutomirski (luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org):
> On Apr 24, 2015 2:15 PM, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > On Fri, Apr 24, 2015 at 01:18:44PM -0700, Andy Lutomirski wrote:
> > > On Fri, Apr 24, 2015 at 1:13 PM, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org> wrote:
> > > > On Fri, 24 Apr 2015, Andy Lutomirski wrote:
> > > >
> > > >> That's sort of what my patch does -- you need CAP_SETPCAP to switch
> > > >> the securebit.
> > > >>
> > > >> But Christoph's patch required it to add caps to the ambient set, right?
> > > >
> > > > Yes but you seem to be just adding one additional step without too much of
> > > > a benefit because you still need CAP_SETPCAP.
> > > >
> > >
> > > No, because I set the default to on :)
> >
> > Right - I definately prefer
> >
> > . default off
> > . CAP_SETPCAP required to turn it on (for self and children)
> > . once on, anyone can copy bits from (whatever we decided) to pA.
> >
> 
> Why default off?  If there's some weird reason that switching it on
> could cause a security problem, then I'd agree, but I haven't spotted
> a reason yet.

Cause it's less scary?

I'll just wait for the new patchset :)
