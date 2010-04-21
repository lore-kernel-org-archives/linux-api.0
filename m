From: "Serge E. Hallyn" <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] p9auth: add p9auth driver
Date: Wed, 21 Apr 2010 08:39:17 -0500
Message-ID: <20100421133917.GB16326@us.ibm.com>
References: <20100421012749.GA21338@us.ibm.com>
 <20100421012908.GB24251@us.ibm.com>
 <20100421102739.6ad932fb@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100421102739.6ad932fb-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Cc: lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ashwin Ganti <ashwin.ganti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, rsc-kPPrOchjzlEAvxtiuMwx3w@public.gmane.org, ericvh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ron Minnich <rminnich-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, jt.beard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morgan <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, oleg-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Randy Dunlap <rdunlap-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Quoting Alan Cox (alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org):
> > This is a change which must be discussed.  The use of this
> > privilege can be completely prevented by having init remove
> > CAP_GRANT_ID from its capability bounding set before forking any
> > processes.
> 
> Which is a minor back compat issue - but you could start without it and
> allow init to add it.
> 
> It seems a very complex interface to do a simple thing. A long time ago
> there was discussion around extending the AF_UNIX fd passing to permit
> 'pass handle and auth' so you could send someone a handle with a "become
> me" token attached.
> 
> Alan

Hi Alan,

sorry I thought I had cc:d you, bc I was pretty sure you'd have some
neat ideas.  Like this one.

One could try to argue that this makes every linux process susceptible
to a trojan making it grant its userid to other tasks, but of course
that's silly since the trojan could just fork.  Well, what this would
buy the attacker is the ability to sit inconspicuously under his old
userid, holding on to the fd until the admin goes out to coffee before
switching userids.

The other thing is that offhand I think the server can't easily tell
from the socket which user namespace the client is in, as ucred only
has .uid.  Though (1) we might need to create a 'struct puser' analogous
to 'struct pid' for signals anyway, (2) userspace can segragate with
fs or net_ns (if abstract sock), and (3) client in a container
presumably won't be able to authenticate itself to server on the
host anyway.

Ashwin (and Ron), I think this idea will give us the same tools that
the p9auth driver does, perhaps in a more unix-y way.  Would you have
objections, or do you see shortcomings?

Thanks, Alan.

-serge
