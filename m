From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 6/9] Add a general, global device notification watch list
 [ver #5]
Date: Fri, 5 Jul 2019 10:44:59 +0200
Message-ID: <20190705084459.GA2579@kroah.com>
References: <20190705051733.GA15821@kroah.com>
 <20190703190846.GA15663@kroah.com>
 <156173690158.15137.3985163001079120218.stgit@warthog.procyon.org.uk>
 <156173697086.15137.9549379251509621554.stgit@warthog.procyon.org.uk>
 <10295.1562256260@warthog.procyon.org.uk>
 <12946.1562313857@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <12946.1562313857@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: viro@zeniv.linux.org.uk, Casey Schaufler <casey@schaufler-ca.com>, Stephen Smalley <sds@tycho.nsa.gov>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Jul 05, 2019 at 09:04:17AM +0100, David Howells wrote:
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 
> > Hm, good point, but there should be some way to test this to verify it
> > works.  Maybe for the other types of events?
> 
> Keyrings is the simplest.  keyutils's testsuite will handle that.  I'm trying
> to work out if I can simply make every macro in there that does a modification
> perform a watch automatically to make sure the appropriate events happen.

That should be good enough to test the basic functionality.  After this
gets merged I'll see if I can come up with a way to test the USB
stuff...

thanks,

greg k-h
