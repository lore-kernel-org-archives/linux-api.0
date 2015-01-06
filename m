From: Jan Kara <jack@suse.cz>
Subject: Re: [v8 3/5] ext4: adds project quota support
Date: Tue, 6 Jan 2015 22:52:51 +0100
Message-ID: <20150106215251.GA30687@quack.suse.cz>
References: <1418102548-5469-1-git-send-email-lixi@ddn.com>
 <1418102548-5469-4-git-send-email-lixi@ddn.com>
 <1D4A37F3-9BA1-42E9-97ED-8F7515FC5E8D@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ext4-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1D4A37F3-9BA1-42E9-97ED-8F7515FC5E8D@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Cc: Li Xi <pkuelelixi@gmail.com>, Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>, ext4 development <linux-ext4@vger.kernel.org>, linux-api@vger.kernel.org, tytso@mit.edu, jack@suse.cz, viro@zeniv.linux.org.uk, hch@infradead.org, dmonakhov@openvz.org
List-Id: linux-api@vger.kernel.org

On Tue 06-01-15 13:01:21, Andreas Dilger wrote:
> On Dec 8, 2014, at 10:22 PM, Li Xi <pkuelelixi@gmail.com> wrote:
> > 
> > This patch adds mount options for enabling/disabling project quota
> > accounting and enforcement. A new specific inode is also used for
> > project quota accounting.
> 
> Judy looking through these patches again and saw a minor issue:
> 
> > @@ -1128,10 +1128,11 @@ enum {
> > 	Opt_journal_path, Opt_journal_checksum, Opt_journal_async_commit,
> > 	Opt_abort, Opt_data_journal, Opt_data_ordered, Opt_data_writeback,
> > 	Opt_data_err_abort, Opt_data_err_ignore,
> > -	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
> > +	Opt_usrjquota, Opt_grpjquota, Opt_prjjquota,
> > +	Opt_offusrjquota, Opt_offgrpjquota, Opt_offprjjquota,
> > 	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_jqfmt_vfsv1, Opt_quota,
> > 	Opt_noquota, Opt_barrier, Opt_nobarrier, Opt_err,
> > -	Opt_usrquota, Opt_grpquota, Opt_i_version,
> > +	Opt_usrquota, Opt_grpquota, Opt_prjquota, Opt_i_version,
> > 	Opt_stripe, Opt_delalloc, Opt_nodelalloc, Opt_mblk_io_submit,
> > 	Opt_nomblk_io_submit, Opt_block_validity, Opt_noblock_validity,
> > 	Opt_inode_readahead_blks, Opt_journal_ioprio,
> > @@ -1183,6 +1184,8 @@ static const match_table_t tokens = {
> > 	{Opt_usrjquota, "usrjquota=%s"},
> > 	{Opt_offgrpjquota, "grpjquota="},
> > 	{Opt_grpjquota, "grpjquota=%s"},
> > +	{Opt_offprjjquota, "prjjquota="},
> > +	{Opt_prjjquota, "prjjquota=%s"},
> 
> We don't need to be able to specify the project quota inodes on the
> mount command line.  This was only needed for supporting old (non-
> journaled) user and group quotas, but there is no chance of having
> old project quotas.
> 
> > 	{Opt_jqfmt_vfsold, "jqfmt=vfsold"},
> > 	{Opt_jqfmt_vfsv0, "jqfmt=vfsv0"},
> > 	{Opt_jqfmt_vfsv1, "jqfmt=vfsv1"},
> > @@ -1190,6 +1193,7 @@ static const match_table_t tokens = {
> > 	{Opt_noquota, "noquota"},
> > 	{Opt_quota, "quota"},
> > 	{Opt_usrquota, "usrquota"},
> > +	{Opt_prjquota, "prjquota"},
> 
> Do we want to allow non-journaled project quota at all?  I don't
> see that as a benefit, and it was only allowed for user/group
> quota for compatibility reasons.  Since the project quota support
> will need an updated e2fsprogs anyway, it may as well be journaled
> from the start.
  Yeah, probably you are right that it doesn't make a whole lot of sense to
support project quotas in user visible files. So these could be removed.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
