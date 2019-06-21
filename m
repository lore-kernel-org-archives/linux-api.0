From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH 02/25] vfs: Allow fsinfo() to query what's in an
 fs_context [ver #13]
Date: Fri, 21 Jun 2019 15:28:40 +0200
Message-ID: <20190621132839.6ggsppexqfp5htpw@brauner.io>
References: <20190621094757.zijugn6cfulmchnf@brauner.io>
 <155905626142.1662.18430571708534506785.stgit@warthog.procyon.org.uk>
 <155905627927.1662.13276277442207649583.stgit@warthog.procyon.org.uk>
 <21652.1561122763@warthog.procyon.org.uk>
 <E76F5188-CED8-4472-9136-BDCDFDAF57F0@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <E76F5188-CED8-4472-9136-BDCDFDAF57F0@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: viro@zeniv.linux.org.uk, raven@themaw.net, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, mszeredi@redhat.com
List-Id: linux-api@vger.kernel.org

On Fri, Jun 21, 2019 at 03:16:04PM +0200, Christian Brauner wrote:
> On June 21, 2019 3:12:43 PM GMT+02:00, David Howells <dhowells@redhat.com> wrote:
> >Christian Brauner <christian@brauner.io> wrote:
> >
> >> >  static int vfs_fsinfo_fd(unsigned int fd, struct fsinfo_kparams
> >*params)
> >> >  {
> >> >  	struct fd f = fdget_raw(fd);
> >> 
> >> You're using fdget_raw() which means you want to allow O_PATH fds but
> >> below you're checking whether the f_ops correspond to
> >> fscontext_fops. If it's an O_PATH
> >
> >It can't be.  The only way to get an fs_context fd is from fsopen() or
> >fspick() - neither of which allow O_PATH to be specified.
> >
> >If you tried to go through /proc/pid/fd with open(O_PATH), I think
> >you'd get
> >the symlink, not the target.
> 
> Then you should use fdget(), no? :)

That is unless you want fsinfo() to be useable on any fd and just fds
that are returned from the new mount-api syscalls. Maybe that wasn't
clear from my first mail.

Is the information returned for:

int fd = fsopen()/fspick();
fsinfo(fd);

int ofd = open("/", O_PATH);
fsinfo(ofd, ...);

the same if they refer to the same mount or would they differ?

Christian
