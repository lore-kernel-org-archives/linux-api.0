From: Ian Kent <raven@themaw.net>
Subject: Re: [PATCH 4/6] vfs: Allow mount information to be queried by
 fsinfo() [ver #15]
Date: Wed, 03 Jul 2019 09:24:25 +0800
Message-ID: <2daf229272884deaf139be510f5842f0689c18a6.camel@themaw.net>
References: <156173681842.14728.9331700785061885270.stgit@warthog.procyon.org.uk>
         <156173685496.14728.9606180227161368035.stgit@warthog.procyon.org.uk>
         <8c70abf248d5ac07f334730af70d64235185b109.camel@themaw.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8c70abf248d5ac07f334730af70d64235185b109.camel@themaw.net>
Sender: linux-kernel-owner@vger.kernel.org
To: christian@brauner.io, David Howells <dhowells@redhat.com>, viro@zeniv.linux.org.uk
Cc: mszeredi@redhat.com, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, 2019-07-03 at 09:09 +0800, Ian Kent wrote:
> Hi Christian,
> 
> About the propagation attributes you mentioned ...

Umm ... how did you work out if a mount is unbindable from proc
mountinfo?

I didn't notice anything that could be used for that when I was
looking at this.

> 
> On Fri, 2019-06-28 at 16:47 +0100, David Howells wrote:
> 
> snip ...
> 
> > +
> > +#ifdef CONFIG_FSINFO
> > +int fsinfo_generic_mount_info(struct path *path, struct fsinfo_kparams
> > *params)
> > +{
> > +	struct fsinfo_mount_info *p = params->buffer;
> > +	struct super_block *sb;
> > +	struct mount *m;
> > +	struct path root;
> > +	unsigned int flags;
> > +
> > +	if (!path->mnt)
> > +		return -ENODATA;
> > +
> > +	m = real_mount(path->mnt);
> > +	sb = m->mnt.mnt_sb;
> > +
> > +	p->f_sb_id		= sb->s_unique_id;
> > +	p->mnt_id		= m->mnt_id;
> > +	p->parent_id		= m->mnt_parent->mnt_id;
> > +	p->change_counter	= atomic_read(&m->mnt_change_counter);
> > +
> > +	get_fs_root(current->fs, &root);
> > +	if (path->mnt == root.mnt) {
> > +		p->parent_id = p->mnt_id;
> > +	} else {
> > +		rcu_read_lock();
> > +		if (!are_paths_connected(&root, path))
> > +			p->parent_id = p->mnt_id;
> > +		rcu_read_unlock();
> > +	}
> > +	if (IS_MNT_SHARED(m))
> > +		p->group_id = m->mnt_group_id;
> > +	if (IS_MNT_SLAVE(m)) {
> > +		int master = m->mnt_master->mnt_group_id;
> > +		int dom = get_dominating_id(m, &root);
> > +		p->master_id = master;
> > +		if (dom && dom != master)
> > +			p->from_id = dom;
> 
> This provides information about mount propagation (well mostly).
> 
> My understanding of this was that:
> "If a mount is propagation private (or slave) the group_id will
> be zero otherwise it's propagation shared and it's group id will
> be non-zero.
> 
> If a mount is propagation slave and propagation peers exist then
> the mount field mnt_master will be non-NULL. Then mnt_master
> (slave's master) can be used to set master_id. If the group id
> of the propagation source is not that of the master then set
> the from_id group as well."
> 
> This parallels the way in which these values are reported in
> the proc pseudo file system.
> 
> Perhaps adding flags as well as setting the fields would be
> useful too, since interpreting the meaning of the structure
> fields isn't obvious, ;)
> 
> David, Al, thoughts?
> 
> Ian
