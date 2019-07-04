From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 6/9] Add a general, global device notification watch list [ver #5]
Date: Thu, 04 Jul 2019 17:04:20 +0100
Message-ID: <10295.1562256260@warthog.procyon.org.uk>
References: <20190703190846.GA15663@kroah.com> <156173690158.15137.3985163001079120218.stgit@warthog.procyon.org.uk> <156173697086.15137.9549379251509621554.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190703190846.GA15663@kroah.com>
Content-ID: <10294.1562256260.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, Casey Schaufler <casey@schaufler-ca.com>, Stephen Smalley <sds@tycho.nsa.gov>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> Don't we need a manpage and a kselftest for it?

I've got part of a manpage, but it needs more work.

How do you do a kselftest for this when it does nothing unless hardware events
happen?

> > +	u64 id = 0; /* Might want to allow dev# here. */
> 
> I don't understand the comment here, what does "dev#" refer to?

This is really for mount subtree watches, so I'm removing it for now.

The reason it's there is because a mount object may have multiple watches, but
each watch is set on a dentry within that mount, and it doesn't have to be the
same dentry each time.  The queue is shared between all the dentries, and the
ID is used (a) to label them so that they can be manually removed, (b) to
match them to each dentry when the notification is being propagated rootwards
along the tree and (c) to avoid adding another field to struct dentry.

David
