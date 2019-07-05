From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 6/9] Add a general, global device notification watch list
 [ver #5]
Date: Fri, 5 Jul 2019 07:17:33 +0200
Message-ID: <20190705051733.GA15821@kroah.com>
References: <20190703190846.GA15663@kroah.com>
 <156173690158.15137.3985163001079120218.stgit@warthog.procyon.org.uk>
 <156173697086.15137.9549379251509621554.stgit@warthog.procyon.org.uk>
 <10295.1562256260@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <10295.1562256260@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: viro@zeniv.linux.org.uk, Casey Schaufler <casey@schaufler-ca.com>, Stephen Smalley <sds@tycho.nsa.gov>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Jul 04, 2019 at 05:04:20PM +0100, David Howells wrote:
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 
> > Don't we need a manpage and a kselftest for it?
> 
> I've got part of a manpage, but it needs more work.
> 
> How do you do a kselftest for this when it does nothing unless hardware events
> happen?

Hm, good point, but there should be some way to test this to verify it
works.  Maybe for the other types of events?

thanks,

greg k-h
