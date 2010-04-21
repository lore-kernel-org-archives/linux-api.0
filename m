From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 3/3] p9auth: add p9auth driver
Date: Wed, 21 Apr 2010 15:19:17 +0100
Message-ID: <20100421151917.5ae20265@lxorguk.ukuu.org.uk>
References: <20100421012749.GA21338@us.ibm.com>
	<20100421012908.GB24251@us.ibm.com>
	<20100421102739.6ad932fb@lxorguk.ukuu.org.uk>
	<20100421133917.GB16326@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100421133917.GB16326@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Ashwin Ganti <ashwin.ganti@gmail.com>, Greg KH <greg@kroah.com>, rsc@swtch.com, ericvh@gmail.com, linux-security-module@vger.kernel.org, Ron Minnich <rminnich@gmail.com>, jt.beard@gmail.com, Andrew Morton <akpm@linux-foundation.org>, Andrew Morgan <morgan@kernel.org>, oleg@us.ibm.com, Eric Paris <eparis@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, linux-api@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>
List-Id: linux-api@vger.kernel.org

> sorry I thought I had cc:d you, bc I was pretty sure you'd have some
> neat ideas.  Like this one.
> 
> One could try to argue that this makes every linux process susceptible
> to a trojan making it grant its userid to other tasks, but of course
> that's silly since the trojan could just fork.  Well, what this would
> buy the attacker is the ability to sit inconspicuously under his old
> userid, holding on to the fd until the admin goes out to coffee before
> switching userids.

Possibly, could you put a timestamp in the passed object ? (Given the
expiry of such a uid offer is kind of policy)

> The other thing is that offhand I think the server can't easily tell
> from the socket which user namespace the client is in, as ucred only
> has .uid.  Though (1) we might need to create a 'struct puser' analogous
> to 'struct pid' for signals anyway, (2) userspace can segragate with
> fs or net_ns (if abstract sock), and (3) client in a container
> presumably won't be able to authenticate itself to server on the
> host anyway.

That I think needs fixing anyway and now is a good time as any to do it.
If you are going to be able to pass userids then you need to be sure you
don't get passed a handle with a uid change on it that you didn't want so
adding another object type and option of some kind to accept them has to
occur anyway.

That also btw needs fixing for other reasons - more than one daemon has
been written that generically uses recvmsg and so can be attacked with FD
leaks >-)

Alan
