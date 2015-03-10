From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] capabilities: Ambient capability set V2
Date: Tue, 10 Mar 2015 10:47:22 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1503100902500.32324@gentwo.org>
References: <alpine.DEB.2.11.1503050917380.31001@gentwo.org> <20150305171326.GA14998@mail.hallyn.com> <alpine.DEB.2.11.1503060948460.8207@gentwo.org> <20150306163443.GA28386@mail.hallyn.com> <alpine.DEB.2.11.1503061244130.9804@gentwo.org>
 <CALCETrVQF22rkZFD8VAW_xrVQOjwpej6W4TJS9gbN9B431TEKg@mail.gmail.com> <20150306200838.GA29198@mail.hallyn.com> <alpine.DEB.2.11.1503070907330.15173@gentwo.org> <20150307213554.GB9833@mail.hallyn.com> <alpine.DEB.2.11.1503090704230.25725@gentwo.org>
 <20150309143653.GA29594@mail.hallyn.com> <CALQRfL4uG2v7SJWZhN2o=ARnSNLR9JAX6MMsCCsGaAz6JcZTsA@mail.gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALQRfL4uG2v7SJWZhN2o=ARnSNLR9JAX6MMsCCsGaAz6JcZTsA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Andrew G. Morgan" <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Aaron Jones <aaronmdjones-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andrew Morton <akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Markku Savela <msa-kXoF896ld44xHbG02/KK1g@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, 9 Mar 2015, Andrew G. Morgan wrote:

> If this is new info, perhaps you might reconsider the rationale for your
> patch? I suspect you are focused on addressing a problem that you felt was
> unaddressed before, but given how much appears to have been unclear to you
> about the current implementation it might be worth a pause for thought.

The problems with unclear documentation and a weird counterintuitive
implementation that lots of people have trouble to use do not impact the
approach as far as I can tell. The discovery about how to set inheritable
bits does not help with the use cases here.

Even with this patch there is still the need to write a wrapper to get
the functionality that one would expect to just be possible by setting
inheritable bits on a file. The necessity to set the bits via prctl
in the wrapper complicates matters further and makes it even more
difficult than we thought before to make use of this feature.

> http://ols.fedoraproject.org/OLS/Reprints-2008/hallyn-reprint.pdf

Well maybe one should make sure that this info is properly comunicated
in the man pages and related documentation? This seems to be a big decade
old desaster. I need a Ph.D. in capabilities in order to attempt to use
them (but then oww no they still are not able to handle my use cases).

We get security through obscurity and also have then the inabilty to make
effective use of capabilities? Security measures need to follow
basic conventions, be obvious and easily understandable as well as well
documented. There is a huge risk of a sysadmin misconfiguring one of the
multiple measures that one needs to go through in order to gain some
sort of inheritance of capabilities and thereby adding more functionality
than necessary just in order to get it to work.

The best measure would be to make the inheritance bits work as one
would naturally expect. They just allow full inheritance of the caps.
No wrappers needed and its easily understood what it does.
