From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] capabilities: Ambient capability set V1
Date: Thu, 26 Feb 2015 15:13:24 -0600
Message-ID: <20150226211324.GB19273@mail.hallyn.com>
References: <20150224164429.GB29685@ubuntumail>
 <alpine.DEB.2.11.1502241120270.29416@gentwo.org>
 <20150225033247.GC29685@ubuntumail>
 <alpine.DEB.2.11.1502251423580.13489@gentwo.org>
 <20150226153524.GC15182@mail.hallyn.com>
 <alpine.DEB.2.11.1502261224580.7451@gentwo.org>
 <20150226193200.GA17709@mail.hallyn.com>
 <alpine.DEB.2.11.1502261412250.7451@gentwo.org>
 <20150226203405.GB18926@mail.hallyn.com>
 <alpine.DEB.2.11.1502261507450.8274@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1502261507450.8274-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Aaron Jones <aaronmdjones-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ted Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, "Andrew G. Morgan" <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Markku Savela <msa-kXoF896ld44xHbG02/KK1g@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Feb 26, 2015 at 03:09:48PM -0600, Christoph Lameter wrote:
> On Thu, 26 Feb 2015, Serge E. Hallyn wrote:
> 
> > > Same problem as before. The ambient bits will not be set in pE'.
> >
> > And what if I weren't scatterbrained and we did
> >
> >  	if (pA)
> >  		pE' = pP'
> >  	else
> >  		pE' = pP' & fE
> >
> > All pP' bits would be set in pE'.
> 
> Ok and the non ambient case would break because fE is not available?
> Doesnt this reduce to
> 
> pE' = pP'
> 
> in either case?

No.  fE is not "not available".  If you set it with setcap, you *should*
(if i'm tinking right) find fE full when calculating the new capability
sets, because of magic_etc.
