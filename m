From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] capabilities: Ambient capability set V1
Date: Mon, 23 Feb 2015 10:45:57 -0600
Message-ID: <20150223164557.GA32181@mail.hallyn.com>
References: <alpine.DEB.2.11.1502051554500.4876@gentwo.org>
 <alpine.DEB.2.11.1502230856400.21238@gentwo.org>
 <20150223161625.GD25477@ubuntumail>
 <CALCETrW78805ayUL=ZYBdFwVdDvJZus2JL0VVmEBE8=L1Nm5Sw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrW78805ayUL=ZYBdFwVdDvJZus2JL0VVmEBE8=L1Nm5Sw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Aaron Jones <aaronmdjones-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ted Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Andrew G. Morgan" <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Markku Savela <msa-kXoF896ld44xHbG02/KK1g@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Feb 23, 2015 at 08:33:58AM -0800, Andy Lutomirski wrote:
> On Mon, Feb 23, 2015 at 8:16 AM, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org> wrote:
> > Quoting Christoph Lameter (cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org):
> >> Ok 4.0-rc1 is out and this patch has been sitting here for a couple of
> >> weeks without comment after an intensive discussion about the RFCs.
> >>
> >> Since there were no objections: Is there any chance to get this into -next
> >> somehow?
> >
> > Andrew Morgan and Andy Lutomirski appear to have a similar concern
> > but competing ideas on how to address them.  We need them to agree
> > on an approach.
> >
> > The core concern for amorgan is that an unprivileged user not be
> > able to cause a privileged program to run in a way that it fails to
> > drop privilege before running unprivileged-user-provided code.
> >
> > Andy Lutomirski's concern is simply that code which is currently
> > doing the right thing to drop privilege not be run in a way that
> > it thinks it is dropping privilege, but in fact is not.
> >
> 
> I share both concerns.
> 
> > (Please correct me where I've mis-spoken or misunderstood)
> >
> > Since your desire is precisely for a mode where dropping privilege
> > works as usual, but exec then re-gains some or all of that privilege,
> > we need to either agree on a way to enter that mode that ordinary
> > use caes can't be tricked into using, or find a way for legacy
> > users to be tpiped off as to what's going on (without having to be
> > re-written)
> 
> Is there really a need to drop privilege and then regain it or is it
> sufficient to keep the privilege permitted (and perhaps ambient, too)
> and just to have execve not drop it for you?  I assume the latter.

Well right, any perceived security benefit of the temporary drop would
seem to be easily debunked (just run shell for exec /bin/sh to get
around it)

So this is more of a desire, I suspect, for regular programs which
drop privilege to still be usable in this environment.

I think this may be a decent place for a compromise.  Attempts to
drop privilege when ambient caps are set return EPERM.

-serge
