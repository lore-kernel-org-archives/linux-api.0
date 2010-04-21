From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH 3/3] p9auth: add p9auth driver
Date: Wed, 21 Apr 2010 12:15:27 -0700
Message-ID: <m11ve81usw.fsf@fess.ebiederm.org>
References: <20100421012749.GA21338@us.ibm.com>
	<20100421012908.GB24251@us.ibm.com>
	<20100421102739.6ad932fb@lxorguk.ukuu.org.uk>
	<20100421133917.GB16326@us.ibm.com>
	<20100421151917.5ae20265@lxorguk.ukuu.org.uk>
	<20100421150900.GB31880@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20100421150900.GB31880@us.ibm.com> (Serge E. Hallyn's message of "Wed\, 21 Apr 2010 10\:09\:00 -0500")
Sender: linux-security-module-owner@vger.kernel.org
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, lkml <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Ashwin Ganti <ashwin.ganti@gmail.com>, Greg KH <greg@kroah.com>, rsc@swtch.com, ericvh@gmail.com, linux-security-module@vger.kernel.org, Ron Minnich <rminnich@gmail.com>, jt.beard@gmail.com, Andrew Morton <akpm@linux-foundation.org>, Andrew Morgan <morgan@kernel.org>, oleg@us.ibm.com, Eric Paris <eparis@redhat.com>, linux-api@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>
List-Id: linux-api@vger.kernel.org

"Serge E. Hallyn" <serue@us.ibm.com> writes:

> Ignoring namespaces for a moment, I guess we could do something like
>
> struct credentials_pass {
> 	pid_t global_pid;
> 	unsigned long unique_id;
> 	uid_t new_uid;
> 	gid_t new_gid;
> 	int num_aux_gids;
> 	gid_t aux_gids[];
> }

This looks surprising like what I am doing in passing uids and pids
through unix domain sockets.

So if this looks like a direction we want to go it shouldn't be too
difficult.

>> That also btw needs fixing for other reasons - more than one daemon has
>> been written that generically uses recvmsg and so can be attacked with FD
>> leaks >-)
>
> Yup.
>
> (By 'needs fixing' you just mean needs to be done right for this
> service?  Else I think I'm missing something...)

Remember my unix domain socket and the patch for converting struct cred
into a new context, from a month or so ago.  I think that is what we
are talking about.

Eric
