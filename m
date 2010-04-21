From: "Serge E. Hallyn" <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] p9auth: add p9auth driver
Date: Wed, 21 Apr 2010 10:09:00 -0500
Message-ID: <20100421150900.GB31880@us.ibm.com>
References: <20100421012749.GA21338@us.ibm.com>
 <20100421012908.GB24251@us.ibm.com>
 <20100421102739.6ad932fb@lxorguk.ukuu.org.uk>
 <20100421133917.GB16326@us.ibm.com>
 <20100421151917.5ae20265@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100421151917.5ae20265-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Cc: lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ashwin Ganti <ashwin.ganti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, rsc-kPPrOchjzlEAvxtiuMwx3w@public.gmane.org, ericvh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ron Minnich <rminnich-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, jt.beard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morgan <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, oleg-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Randy Dunlap <rdunlap-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Quoting Alan Cox (alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org):
> > sorry I thought I had cc:d you, bc I was pretty sure you'd have some
> > neat ideas.  Like this one.
> > 
> > One could try to argue that this makes every linux process susceptible
> > to a trojan making it grant its userid to other tasks, but of course
> > that's silly since the trojan could just fork.  Well, what this would
> > buy the attacker is the ability to sit inconspicuously under his old
> > userid, holding on to the fd until the admin goes out to coffee before
> > switching userids.
> 
> Possibly, could you put a timestamp in the passed object ? (Given the
> expiry of such a uid offer is kind of policy)

Yup, in fact I do that for the p9auth device driver anyway, to avoid
letting a user take up all kernel memory with unused setuid tokens.

> > The other thing is that offhand I think the server can't easily tell
> > from the socket which user namespace the client is in, as ucred only
> > has .uid.  Though (1) we might need to create a 'struct puser' analogous
> > to 'struct pid' for signals anyway, (2) userspace can segragate with
> > fs or net_ns (if abstract sock), and (3) client in a container
> > presumably won't be able to authenticate itself to server on the
> > host anyway.
> 
> That I think needs fixing anyway and now is a good time as any to do it.
> If you are going to be able to pass userids then you need to be sure you
> don't get passed a handle with a uid change on it that you didn't want so
> adding another object type and option of some kind to accept them has to
> occur anyway.

Ignoring namespaces for a moment, I guess we could do something like

struct credentials_pass {
	pid_t global_pid;
	unsigned long unique_id;
	uid_t new_uid;
	gid_t new_gid;
	int num_aux_gids;
	gid_t aux_gids[];
}

The unique_id is assigned by the kernel;  the client reads the whole
struct credentials_pass - except global_pid - from the unix sock,
verifies the desired credentials, then does sys_acceptid(unique_id)
to accept.

Again, how to pass user namespace information is not obvious to me.

And it's probably debatable whether we want to also pass info about
posix capabilities and LSM security data.

Still, my main concern with this approach is that it makes the server
more complicated.  Since I'm passing along my current credentials, that
means I have to construct just the right credentials, which if using
sock identified by pathname may mean I can no longer write to the
socket, right?

And of course one other important consideration is that the overall
p9auth API has been heavily discussed and documented, whereas
implementing our own entirely new approach is breaking new ground
and therefore a lot scarier.

> That also btw needs fixing for other reasons - more than one daemon has
> been written that generically uses recvmsg and so can be attacked with FD
> leaks >-)

Yup.

(By 'needs fixing' you just mean needs to be done right for this
service?  Else I think I'm missing something...)

thanks,
-serge
