From: "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH 3/3] p9auth: add p9auth driver
Date: Wed, 21 Apr 2010 09:30:16 -0500
Message-ID: <20100421143016.GA31880@us.ibm.com>
References: <20100421012749.GA21338@us.ibm.com>
 <20100421012908.GB24251@us.ibm.com>
 <20100421102739.6ad932fb@lxorguk.ukuu.org.uk>
 <1271858141.2899.7.camel@dhcp235-240.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1271858141.2899.7.camel@dhcp235-240.rdu.redhat.com>
Sender: linux-security-module-owner@vger.kernel.org
To: Eric Paris <eparis@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, lkml <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Ashwin Ganti <ashwin.ganti@gmail.com>, Greg KH <greg@kroah.com>, rsc@swtch.com, ericvh@gmail.com, linux-security-module@vger.kernel.org, Ron Minnich <rminnich@gmail.com>, jt.beard@gmail.com, Andrew Morton <akpm@linux-foundation.org>, Andrew Morgan <morgan@kernel.org>, oleg@us.ibm.com, "Eric W. Biederman" <ebiederm@xmission.com>, linux-api@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>, sgrubb@redhat.com
List-Id: linux-api@vger.kernel.org

Quoting Eric Paris (eparis@redhat.com):
> On Wed, 2010-04-21 at 10:27 +0100, Alan Cox wrote:
> > > This is a change which must be discussed.  The use of this
> > > privilege can be completely prevented by having init remove
> > > CAP_GRANT_ID from its capability bounding set before forking any
> > > processes.
> > 
> > Which is a minor back compat issue - but you could start without it and
> > allow init to add it.
> > 
> > It seems a very complex interface to do a simple thing. A long time ago
> > there was discussion around extending the AF_UNIX fd passing to permit
> > 'pass handle and auth' so you could send someone a handle with a "become
> > me" token attached.
> 
> If you do go down this path there is a separate (and actually completely
> opposite) but related problem I might be able and willing to work with
> you on.  When looking at how auditing works in this modern day and age
> of dbus+polkit to get background processes to do work on behalf of a

This actually brings up an issue I've been a bit worried about: is
credentials passing for dbus adequate?  I thought that the last time
I looked through some code, there was no way in particular for upstart
to pass posix capabilities info along.  What that means is that as root
I can do

capsh --drop=(list of all capabilities) --
   reboot

and, although I don't have cap_sys_boot, I can reboot the system.  So
the only way I can prevent a container from rebooting the host is to
start it in a fresh network namespace to segrate the abstract unix
domain sockets.  But if I don't want a fresh network namespace, I'm out
of luck.

> user we were discussing an interface that would pass the information
> about the user to the background server process.  The background server
> process could do some magic such that it still had all the permissions
> and rights of itself, but had the audit information of the original
> user.  Thus even though it was a server process with uid=0 that did the
> work, the audit logs could know it was actually on behalf of uid=500.  
> 
> It was discussed passing that token of audit information over an AF_UNIX
> socket.
> 
> -Eric
