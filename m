From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH 03/25] vfs: Allow fsinfo() to query what's in an
 fs_context [ver #14]
Date: Wed, 26 Jun 2019 12:06:10 +0200
Message-ID: <20190626100609.jerxqozukygyojik@brauner.io>
References: <20190625092728.z3jn3gbyopzcg2it@brauner.io>
 <156138532485.25627.7459410522109581052.stgit@warthog.procyon.org.uk>
 <156138535407.25627.15015993364565647650.stgit@warthog.procyon.org.uk>
 <6575.1561543379@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6575.1561543379@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: viro@zeniv.linux.org.uk, raven@themaw.net, mszeredi@redhat.com, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Jun 26, 2019 at 11:02:59AM +0100, David Howells wrote:
> Christian Brauner <christian@brauner.io> wrote:
> 
> > > +	ret = mutex_lock_interruptible(&fc->uapi_mutex);
> > > +	if (ret == 0) {
> > > +		ret = -EIO;
> > 
> > Why EIO when there's no root dentry?
> 
> Because I don't want to use ENODATA/EBADF and preferably not EINVAL and
> because the context you're accessing isn't in the correct state for you to be
> able to do that.  How about EBADFD ("File descriptor in bad state")?

Do we have that? If so that sounds good.

Christian
