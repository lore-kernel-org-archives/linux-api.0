From: Jan Kara <jack@suse.cz>
Subject: Re: [v9 1/5] vfs: adds general codes to enforces project quota limits
Date: Tue, 17 Mar 2015 10:37:40 +0100
Message-ID: <20150317093740.GB23155@quack.suse.cz>
References: <1426043003-31043-1-git-send-email-lixi@ddn.com>
 <1426043003-31043-2-git-send-email-lixi@ddn.com>
 <20150316142944.GN4934@quack.suse.cz>
 <20150316214930.GE28557@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150316214930.GE28557@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, Li Xi <pkuelelixi@gmail.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-api@vger.kernel.org, tytso@mit.edu, adilger@dilger.ca, viro@zeniv.linux.org.uk, hch@infradead.org, dmonakhov@openvz.org, dchinner@redhat.com
List-Id: linux-api@vger.kernel.org

On Tue 17-03-15 08:49:30, Dave Chinner wrote:
> On Mon, Mar 16, 2015 at 03:29:44PM +0100, Jan Kara wrote:
> > On Wed 11-03-15 12:03:19, Li Xi wrote:
> > > This patch adds support for a new quota type PRJQUOTA for project quota
> > > enforcement. Also a new method get_projid() is added into dquot_operations
> > > structure.
> > > 
> > > Signed-off-by: Li Xi <lixi@ddn.com>
> > > Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> > > Reviewed-by: Jan Kara <jack@suse.cz>
> > ...
> > > diff --git a/fs/quota/quota.c b/fs/quota/quota.c
> > > index 2aa4151..c76b350 100644
> > > --- a/fs/quota/quota.c
> > > +++ b/fs/quota/quota.c
> > > @@ -30,11 +30,15 @@ static int check_quotactl_permission(struct super_block *sb, int type, int cmd,
> > >  	case Q_XGETQSTATV:
> > >  	case Q_XQUOTASYNC:
> > >  		break;
> > > -	/* allow to query information for dquots we "own" */
> > > +	/*
> > > +	 * allow to query information for dquots we "own"
> > > +	 * always allow querying project quota
> > > +	 */
> > >  	case Q_GETQUOTA:
> > >  	case Q_XGETQUOTA:
> > >  		if ((type == USRQUOTA && uid_eq(current_euid(), make_kuid(current_user_ns(), id))) ||
> > > -		    (type == GRPQUOTA && in_egroup_p(make_kgid(current_user_ns(), id))))
> > > +		    (type == GRPQUOTA && in_egroup_p(make_kgid(current_user_ns(), id))) ||
> > > +		    (type == PRJQUOTA))
> > >  			break;
> >   I wanted to merge this patch but this hunk caught my eye. Why do we
> > suddently allow querying of project quotas? Traditionally that has been
> > allowed only with CAP_SYS_ADMIN. I agree it looks too restrictive to me but
> > unless that's a bug, I think we have to adhere to original behavior and
> > drop this hunk. Dave, was that behavior of project quotas intended? 
> 
> This is for quota reports, right?
  Yes.

> Project quotas are managed by the administrator as individual users
> may not even have access to all the files under a project and hence
> often cannot do anything about running out of quota space. i.e. users
> don't own project quotas like they "own" user and group quotas.
> user/group quotas imply the user has permission to access/modify the
> files within the quota, whereas that is not true of project quotas.
> 
> e.g. Think about a project that compartmentalises information along
> user acess bounds: even if a user can't access parts of the project
> quota space, allowing them to query the accounting of space used by
> the project is leaking information about how much data there is in
> the project they can't access....
  OK, thanks for the explanation. So Q_GETQUOTA and Q_XGETQUOTA for
PRJQUOTA have to stay for CAP_SYS_ADMIN capable processes only (at least
for now).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
