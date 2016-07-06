From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH review 0/11] General unprivileged mount support
Date: Wed, 6 Jul 2016 16:22:55 +0200
Message-ID: <20160706142255.GB21164@quack2.suse.cz>
References: <87ziq03qnj.fsf@x220.int.ebiederm.org>
 <20160704085220.GC5200@quack2.suse.cz>
 <87h9c52wsd.fsf@x220.int.ebiederm.org>
 <20160706085440.GD14067@quack2.suse.cz>
 <20160706135446.GA45215@ubuntu-hedt>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160706135446.GA45215@ubuntu-hedt>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed 06-07-16 08:54:46, Seth Forshee wrote:
> On Wed, Jul 06, 2016 at 10:54:40AM +0200, Jan Kara wrote:
> > On Mon 04-07-16 11:27:46, Eric W. Biederman wrote:
> > I don't remember the indented uses for user-ns mounts so I may be just
> > wrong. But my experience tells me that external data (such as user
> > namespace ID mappings in your case) that modify meaning of on-disk format
> > tend to cause maintenance difficulties in the long run... Because someone
> > *will* have the idea of migrating these fs images between containers /
> > machines and then they have to make sure mappings get migrated as well and
> > it all becomes cumbersome.
> 
> The intended use case for this is containers, with the idea being that I
> as a user will get the same behavior in the container as I would in
> init_user_ns without needing any userspace modifications to achieve
> that.
> 
> So if I have a filesystem that contains uid 0 and I mount it in my
> container, I should see uid 0. If I mount the same bits in another
> container with a different uid mapping I should also see uid 0.
> 
> If I mkfs a new filesystem in my container then mount it, the root
> directory of the fs is owned by uid 0 in my container without any
> modifications to mkfs.
> 
> I'd argue that this makes it easier to migrate a disk between containers
> because the ids in the disk show up the same within the container
> regardless of the id mapping. If someone wants to mount a filesystem in
> one container and also access it in another container with a completely
> different id mapping, well I don't think that's ever going to work well.

OK, I see how this is supposed to work. However you assume here that both
containers have the same set of valid UIDs, don't you? If that is not the
case, the mounted image will not be usable in the other container, right?

								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
