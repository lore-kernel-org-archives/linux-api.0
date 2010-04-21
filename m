From: Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] p9auth: add p9auth driver
Date: Wed, 21 Apr 2010 09:55:41 -0400
Message-ID: <1271858141.2899.7.camel@dhcp235-240.rdu.redhat.com>
References: <20100421012749.GA21338@us.ibm.com>
	 <20100421012908.GB24251@us.ibm.com>
	 <20100421102739.6ad932fb@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100421102739.6ad932fb-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Cc: "Serge E. Hallyn" <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ashwin Ganti <ashwin.ganti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, rsc-kPPrOchjzlEAvxtiuMwx3w@public.gmane.org, ericvh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ron Minnich <rminnich-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, jt.beard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morgan <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, oleg-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Randy Dunlap <rdunlap-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org>, sgrubb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, 2010-04-21 at 10:27 +0100, Alan Cox wrote:
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

If you do go down this path there is a separate (and actually completely
opposite) but related problem I might be able and willing to work with
you on.  When looking at how auditing works in this modern day and age
of dbus+polkit to get background processes to do work on behalf of a
user we were discussing an interface that would pass the information
about the user to the background server process.  The background server
process could do some magic such that it still had all the permissions
and rights of itself, but had the audit information of the original
user.  Thus even though it was a server process with uid=0 that did the
work, the audit logs could know it was actually on behalf of uid=500.  

It was discussed passing that token of audit information over an AF_UNIX
socket.

-Eric
