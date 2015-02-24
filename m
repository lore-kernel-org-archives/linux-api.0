From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] capabilities: Ambient capability set V1
Date: Tue, 24 Feb 2015 09:47:15 -0600
Message-ID: <20150224154715.GA20682@mail.hallyn.com>
References: <alpine.DEB.2.11.1502051554500.4876@gentwo.org>
 <alpine.DEB.2.11.1502230856400.21238@gentwo.org>
 <20150223161625.GD25477@ubuntumail>
 <alpine.DEB.2.11.1502231041580.21784@gentwo.org>
 <20150223164623.GB32181@mail.hallyn.com>
 <alpine.DEB.2.11.1502231049110.21926@gentwo.org>
 <20150223181553.GE25477@ubuntumail>
 <20150224051928.GA14755@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150224051928.GA14755-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Aaron Jones <aaronmdjones-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ted Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, "Andrew G. Morgan" <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Markku Savela <msa-kXoF896ld44xHbG02/KK1g@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Feb 23, 2015 at 11:19:29PM -0600, Serge E. Hallyn wrote:
> On Mon, Feb 23, 2015 at 06:15:53PM +0000, Serge Hallyn wrote:
> > Quoting Christoph Lameter (cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org):
> > > On Mon, 23 Feb 2015, Serge E. Hallyn wrote:
> > > 
> > > > > I do not see a problem with dropping privilege since the ambient set
> > > > > is supposed to be preserved across a drop of priviledge.
> > > >
> > > > Because you're tricking the program into thinking it has dropped
> > > > the privilege, when in fact it has not.
> > > 
> > > So the cap was dropped from the cap perm set but it is still active
> > > in the ambient set?
> > 
> > Right, and the legacy program doesn't know to check the new set.
> 
> we've been assuming the ambient set must be like fP.  is there any
> reason why it doesn't suffice for them to be or'ed with fI instead at
> exec?  then the bits would need to ne in pI. this might sufice for
> Christoph's use case, as pI will generally not change.  and for programs
> that really care, they can check pI.

The other way to look at it then is that it's basically as though the
privileged task (which has CAP_SETFCAP) could've just added fI=full to
all binaries on the filesystem;  instead it's using the ambient set
so that the risk from fI=full is contained to its own process tree.
