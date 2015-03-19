From: Jan Kara <jack@suse.cz>
Subject: Re: [v10 3/5] ext4: adds project quota support
Date: Thu, 19 Mar 2015 10:41:10 +0100
Message-ID: <20150319094110.GE28368@quack.suse.cz>
References: <1426705497-22158-1-git-send-email-lixi@ddn.com>
 <1426705497-22158-4-git-send-email-lixi@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ext4-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1426705497-22158-4-git-send-email-lixi@ddn.com>
Sender: linux-ext4-owner@vger.kernel.org
To: Li Xi <pkuelelixi@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-api@vger.kernel.org, tytso@mit.edu, adilger@dilger.ca, jack@suse.cz, viro@zeniv.linux.org.uk, hch@infradead.org, dmonakhov@openvz.org
List-Id: linux-api@vger.kernel.org

On Thu 19-03-15 04:04:55, Li Xi wrote:
> This patch adds mount options for enabling/disabling project quota
> accounting and enforcement. A new specific inode is also used for
> project quota accounting.
  Here we still don't have resolved the problem that inode number 11 may be
used. Please note that in the changelog as FIXME so that we don't forget.

> @@ -987,6 +988,7 @@ struct ext4_inode_info {
>  #define EXT4_MOUNT_DIOREAD_NOLOCK	0x400000 /* Enable support for dio read nolocking */
>  #define EXT4_MOUNT_JOURNAL_CHECKSUM	0x800000 /* Journal checksums */
>  #define EXT4_MOUNT_JOURNAL_ASYNC_COMMIT	0x1000000 /* Journal Async Commit */
> +#define EXT4_MOUNT_PRJJQUOTA		0x2000000 /* Journaled Project quota */
>  #define EXT4_MOUNT_DELALLOC		0x8000000 /* Delalloc support */
>  #define EXT4_MOUNT_DATA_ERR_ABORT	0x10000000 /* Abort on file data write */
>  #define EXT4_MOUNT_BLOCK_VALIDITY	0x20000000 /* Block validity checking */
  I'm ok with the fact that you removed support for project quota files not
in system files. However why do you keep the PRJJQUOTA mount option then?
Quota tools are clever enough to query kernel for enabled quota without
checking for mount options these days. So they don't need the mount option
for anything. And kernel doesn't need the option for anything either
(usrquota and grpquota mount options are there only for quota in standard
files case).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
