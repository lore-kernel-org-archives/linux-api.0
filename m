From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [patch 1/3] procfs: fdinfo -- Extend information about epoll
 target files
Date: Fri, 17 Mar 2017 11:26:20 +0300
Message-ID: <20170317082620.GA29364@uranus.lan>
References: <20170310082146.041584651@openvz.org>
 <20170317045908.GA4509@outlook.office365.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170317045908.GA4509@outlook.office365.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrei Vagin <avagin@virtuozzo.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, viro@zeniv.linux.org.uk, akpm@linuxfoundation.org, xemul@virtuozzo.com, mtk.manpages@gmail.com, kir@openvz.org, Andrey Vagin <avagin@openvz.org>, Jason Baron <jbaron@akamai.com>, Andy Lutomirski <luto@amacapital.net>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 16, 2017 at 09:59:09PM -0700, Andrei Vagin wrote:
> On Fri, Mar 10, 2017 at 11:16:56AM +0300, Cyrill Gorcunov wrote:
> > Since it is possbile to have same number in tfd field (say
> > file added, closed, then nother file dup'ed to same number
> > and added back) it is imposible to distinguish such target
> > files solely by their numbers.
> > 
> > Strictly speaking regular applications don't need to recognize
> > these targets at all but for checkpoint/restore sake we need
> > to collect targets to be able to push them back on restore
> > stage in a proper order.
> > 
> > Thus lets add file position, inode and device number where
> > this target lays. This three fields can be used as a primary
> > key for sorting, and together with kcmp help CRIU can find
> > out an exact file target (from the whole set of processes
> > being checkpointed).
> > 
> > Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> > CC: Al Viro <viro@zeniv.linux.org.uk>
> > CC: Andrew Morton <akpm@linuxfoundation.org>
> > CC: Andrey Vagin <avagin@openvz.org>
> > CC: Pavel Emelyanov <xemul@virtuozzo.com>
> > CC: Michael Kerrisk <mtk.manpages@gmail.com>
> > CC: Kir Kolyshkin <kir@openvz.org>
> > CC: Jason Baron <jbaron@akamai.com>
> > CC: Andy Lutomirski <luto@amacapital.net>
> > ---
> >  Documentation/filesystems/proc.txt |    6 +++++-
> >  fs/eventpoll.c                     |    8 ++++++--
> >  2 files changed, 11 insertions(+), 3 deletions(-)
> > 
> > Index: linux-ml.git/Documentation/filesystems/proc.txt
> > ===================================================================
> > --- linux-ml.git.orig/Documentation/filesystems/proc.txt
> > +++ linux-ml.git/Documentation/filesystems/proc.txt
> > @@ -1779,12 +1779,16 @@ pair provide additional information part
> >  	pos:	0
> >  	flags:	02
> >  	mnt_id:	9
> > -	tfd:        5 events:       1d data: ffffffffffffffff
> > +	tfd:        5 events:       1d data: ffffffffffffffff pos:0 ino:61af sdev:7
> 
> I think it may be better to print mnt_id instead of sdev, because there
> may be two file descriptors opened from different bind mounts.

Fetching mnt_id is not that cheap in compare with sdev: instead of
straight dereference inode->i_sb->s_dev we will have to figure out
mnt_id from file+path, and our primary key is from sdev+ino anyway,
so until _really_ needed I prefer cheaper/simplier solution.
