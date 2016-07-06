From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH review 0/11] General unprivileged mount support
Date: Wed, 06 Jul 2016 08:23:50 -0700
Message-ID: <1467818630.2369.21.camel@HansenPartnership.com>
References: <87ziq03qnj.fsf@x220.int.ebiederm.org>
	 <20160704085220.GC5200@quack2.suse.cz>
	 <87h9c52wsd.fsf@x220.int.ebiederm.org>
	 <20160706085440.GD14067@quack2.suse.cz>
	 <20160706135446.GA45215@ubuntu-hedt>
	 <20160706142255.GB21164@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20160706142255.GB21164@quack2.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>, Seth Forshee <seth.forshee@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Linux Containers <containers@lists.linux-foundation.org>, linux-fsdevel@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, Djalal Harouni <tixxdz@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, Andy Lutomirski <luto@amacapital.net>, Jann Horn <jannh@google.com>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

On Wed, 2016-07-06 at 16:22 +0200, Jan Kara wrote:
> On Wed 06-07-16 08:54:46, Seth Forshee wrote:
> > On Wed, Jul 06, 2016 at 10:54:40AM +0200, Jan Kara wrote:
> > > On Mon 04-07-16 11:27:46, Eric W. Biederman wrote:
> > > I don't remember the indented uses for user-ns mounts so I may be 
> > > just wrong. But my experience tells me that external data (such 
> > > as user namespace ID mappings in your case) that modify meaning 
> > > of on-disk format tend to cause maintenance difficulties in the 
> > > long run... Because someone *will* have the idea of migrating 
> > > these fs images between containers / machines and then they have 
> > > to make sure mappings get migrated as well and it all becomes
> > > cumbersome.
> > 
> > The intended use case for this is containers, with the idea being 
> > that I as a user will get the same behavior in the container as I 
> > would in init_user_ns without needing any userspace modifications 
> > to achieve that.
> > 
> > So if I have a filesystem that contains uid 0 and I mount it in my
> > container, I should see uid 0. If I mount the same bits in another
> > container with a different uid mapping I should also see uid 0.
> > 
> > If I mkfs a new filesystem in my container then mount it, the root
> > directory of the fs is owned by uid 0 in my container without any
> > modifications to mkfs.
> > 
> > I'd argue that this makes it easier to migrate a disk between 
> > containers because the ids in the disk show up the same within the 
> > container regardless of the id mapping. If someone wants to mount a
> > filesystem in one container and also access it in another container 
> > with a completely different id mapping, well I don't think that's 
> > ever going to work well.
> 
> OK, I see how this is supposed to work. However you assume here that 
> both containers have the same set of valid UIDs, don't you? If that 
> is not the case, the mounted image will not be usable in the other 
> container, right?

You can always set it up wrongly is the rule of containers.  Because
the virtualizations are so granular, there are many possible
configurations which don't make sense in the real world.

The main use case for this is operating system images.  For them we
have a set of known UID/GIDs in the image (usually 0-1000 plus the
nobody/nogroups for both).  Using this scheme, we'd set up the
container in a userns that mapped all these ids to something
unprivileged and then set up a s_user_ns to do the same for the mount
location of the image meaning that the unprivileged container can now
manipulate the image.

There are several self contained proposals on linux-fsdevel for doing
this, like shifts, which is what I'm currently using to manipulate
images, so for me what it does is allows me to get rid of all the
credential shifting when performing operations on the underlying
filesystem.  In fact, I think it pretty much allows me to get rid of a
lot of the upper/lower filesystem distinction in shiftfs and I'd get
quotas and other stuff I ignored for free.

However, any of the other uid/gid shifting proposals can also use this
as the engine.

The point here is, this patch set is simply mechanism; it requires a
glue layer (like shiftfs, fuse or the vfs remapping proposal) to
activate it.  The activation decides how much exposure to the
underlying filesystem there is, so with shiftfs, there's none, it's a
purely volatile system crafted for chosen images.  However, it's fully
possible to come up with an activation where the filesystem would
decide (through some on disk format information) to declare the image
to be safely remapped in this uid/gid range and then we could allow it
to be mounted unprivileged (without a capability check) into a user_ns
that matched the mapping.  This latter is a bit of a fantasy since
container images are currently little more than tar files and we have
no extant way to connect them to linux fs formats, but once the
possibility exists, whose to say this won't change?

James



