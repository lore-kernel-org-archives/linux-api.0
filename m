From: "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH 3/3] p9auth: add p9auth driver
Date: Wed, 21 Apr 2010 08:40:40 -0500
Message-ID: <20100421134040.GC16326@us.ibm.com>
References: <20100421012908.GB24251@us.ibm.com>
 <20100421012749.GA21338@us.ibm.com>
 <23120.1271846955@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <23120.1271846955@redhat.com>
Sender: linux-security-module-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Ashwin Ganti <ashwin.ganti@gmail.com>, Greg KH <greg@kroah.com>, rsc@swtch.com, ericvh@gmail.com, linux-security-module@vger.kernel.org, Ron Minnich <rminnich@gmail.com>, jt.beard@gmail.com, Andrew Morton <akpm@linux-foundation.org>, Andrew Morgan <morgan@kernel.org>, oleg@us.ibm.com, Eric Paris <eparis@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, linux-api@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>
List-Id: linux-api@vger.kernel.org

Quoting David Howells (dhowells@redhat.com):
> Serge E. Hallyn <serue@us.ibm.com> wrote:
> 
> > +	if (ret == 0)
> > +		commit_creds(new);
> > +	else
> > +		abort_creds(new);
> > +
> > +	return ret;
> 
> If you make this:
> 
> 	if (ret == 0)
> 		return commit_creds(new);
> 	abort_creds(new);
> 	return ret;
> 
> then gcc can tail-call commit_creds(), which is guaranteed to return 0.
> 
> David

Ok, will do.

thanks,
-serge
