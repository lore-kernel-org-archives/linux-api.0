From: Seth Forshee <seth.forshee@canonical.com>
Subject: Re: [PATCH review 0/11] General unprivileged mount support
Date: Wed, 6 Jul 2016 09:46:32 -0500
Message-ID: <20160706144632.GB45215@ubuntu-hedt>
References: <87ziq03qnj.fsf@x220.int.ebiederm.org>
 <20160704085220.GC5200@quack2.suse.cz>
 <87h9c52wsd.fsf@x220.int.ebiederm.org>
 <20160706085440.GD14067@quack2.suse.cz>
 <20160706135446.GA45215@ubuntu-hedt>
 <20160706142255.GB21164@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160706142255.GB21164@quack2.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Linux Containers <containers@lists.linux-foundation.org>, linux-fsdevel@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Djalal Harouni <tixxdz@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, Andy Lutomirski <luto@amacapital.net>, Jann Horn <jannh@google.com>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

On Wed, Jul 06, 2016 at 04:22:55PM +0200, Jan Kara wrote:
> On Wed 06-07-16 08:54:46, Seth Forshee wrote:
> > On Wed, Jul 06, 2016 at 10:54:40AM +0200, Jan Kara wrote:
> > > On Mon 04-07-16 11:27:46, Eric W. Biederman wrote:
> > > I don't remember the indented uses for user-ns mounts so I may be just
> > > wrong. But my experience tells me that external data (such as user
> > > namespace ID mappings in your case) that modify meaning of on-disk format
> > > tend to cause maintenance difficulties in the long run... Because someone
> > > *will* have the idea of migrating these fs images between containers /
> > > machines and then they have to make sure mappings get migrated as well and
> > > it all becomes cumbersome.
> > 
> > The intended use case for this is containers, with the idea being that I
> > as a user will get the same behavior in the container as I would in
> > init_user_ns without needing any userspace modifications to achieve
> > that.
> > 
> > So if I have a filesystem that contains uid 0 and I mount it in my
> > container, I should see uid 0. If I mount the same bits in another
> > container with a different uid mapping I should also see uid 0.
> > 
> > If I mkfs a new filesystem in my container then mount it, the root
> > directory of the fs is owned by uid 0 in my container without any
> > modifications to mkfs.
> > 
> > I'd argue that this makes it easier to migrate a disk between containers
> > because the ids in the disk show up the same within the container
> > regardless of the id mapping. If someone wants to mount a filesystem in
> > one container and also access it in another container with a completely
> > different id mapping, well I don't think that's ever going to work well.
> 
> OK, I see how this is supposed to work. However you assume here that both
> containers have the same set of valid UIDs, don't you? If that is not the
> case, the mounted image will not be usable in the other container, right?

It's possible of course. I'd expect anyone wanting to use this in
practice to set up their containers with appropriate mappings. Full OS
style containers will at least need some minimal uid mapping to work
properly.

Seth
