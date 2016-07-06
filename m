From: Seth Forshee <seth.forshee@canonical.com>
Subject: Re: [PATCH review 0/11] General unprivileged mount support
Date: Wed, 6 Jul 2016 08:54:46 -0500
Message-ID: <20160706135446.GA45215@ubuntu-hedt>
References: <87ziq03qnj.fsf@x220.int.ebiederm.org>
 <20160704085220.GC5200@quack2.suse.cz>
 <87h9c52wsd.fsf@x220.int.ebiederm.org>
 <20160706085440.GD14067@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160706085440.GD14067@quack2.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Linux Containers <containers@lists.linux-foundation.org>, linux-fsdevel@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Djalal Harouni <tixxdz@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, Andy Lutomirski <luto@amacapital.net>, Jann Horn <jannh@google.com>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

On Wed, Jul 06, 2016 at 10:54:40AM +0200, Jan Kara wrote:
> On Mon 04-07-16 11:27:46, Eric W. Biederman wrote:
> > Jan Kara <jack@suse.cz> writes:
> > 
> > > On Sat 02-07-16 12:18:08, Eric W. Biederman wrote:
> > >> 
> > >> As well as in these patches the code is also available from:
> > >> git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git for-testing
> > >> 
> > >> It has been a long time in coming but recently in the userns tree the
> > >> superblock has been expanded with a s_user_ns field indicating the user
> > >> namespace that owns a superblock.
> > >> 
> > >> The s_user_ns owner of a superblock has three implications.
> > >> - Only kuids and kgids that map into s_user_ns are allowed to be sent to a
> > >>  filesystem from the vfs.
> > >> - If the uid or gid on the filesystem does not map into s_user_ns i_uid
> > >>   is set to INVALID_UID and i_gid is set to INVALID_GID.
> > >> - The scope of permission checks can be changed from global to a
> > >>   capabilitiy check in s_user_ns.
> > >
> > > OK, to check that I understand it right:
> > >
> > > So the uids and gids that are stored on disk are still expected to be in
> > > the initial id namespace, aren't they?
> > 
> > No.
> > 
> > The general expectation is that the ids on disk are store in s_user_ns.
> >
> > Id's that don't map to the initial id namespace get stored in the
> > generic data structures as INVALID_UID and INVALID_GID.
> 
> > In practice I don't expect anyone will set up a situation knowingly
> > where id's don't map, but the case has to be handled because mistakes
> > and malicious code happens.
> 
> OK, thanks for explanation. But then the namespace the filesystem is
> mounted with essentially becomes part of the on-disk format, doesn't it?
> Because if someone mounts the media from a different namespace, suddently
> the UID/GIDs may map to different users in initial user namespace and
> consequences may be weird, right? Shouldn't it thus be somehow stored
> together with the filesystem to make things more robust?
> 
> I don't remember the indented uses for user-ns mounts so I may be just
> wrong. But my experience tells me that external data (such as user
> namespace ID mappings in your case) that modify meaning of on-disk format
> tend to cause maintenance difficulties in the long run... Because someone
> *will* have the idea of migrating these fs images between containers /
> machines and then they have to make sure mappings get migrated as well and
> it all becomes cumbersome.

The intended use case for this is containers, with the idea being that I
as a user will get the same behavior in the container as I would in
init_user_ns without needing any userspace modifications to achieve
that.

So if I have a filesystem that contains uid 0 and I mount it in my
container, I should see uid 0. If I mount the same bits in another
container with a different uid mapping I should also see uid 0.

If I mkfs a new filesystem in my container then mount it, the root
directory of the fs is owned by uid 0 in my container without any
modifications to mkfs.

I'd argue that this makes it easier to migrate a disk between containers
because the ids in the disk show up the same within the container
regardless of the id mapping. If someone wants to mount a filesystem in
one container and also access it in another container with a completely
different id mapping, well I don't think that's ever going to work well.

Seth

