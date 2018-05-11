From: David Sterba <dsterba@suse.cz>
Subject: Re: [RFC v2 4/4] btrfs: verify symlinks with append/immutable flags
Date: Fri, 11 May 2018 16:04:51 +0200
Message-ID: <20180511140451.GY6649@twin.jikos.cz>
References: <20180510231359.16899-1-mcgrof@kernel.org>
 <20180510231359.16899-5-mcgrof@kernel.org>
Reply-To: dsterba@suse.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180510231359.16899-5-mcgrof@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: viro@zeniv.linux.org.uk, darrick.wong@oracle.com, tytso@mit.edu, adilger.kernel@dilger.ca, clm@fb.com, jbacik@fb.com, dsterba@suse.com, sandeen@sandeen.net, dhowells@redhat.com, fliu@suse.com, jack@suse.cz, jeffm@suse.com, nborisov@suse.com, jake.norris@suse.com, mtk.manpages@gmail.com, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, May 10, 2018 at 04:13:59PM -0700, Luis R. Rodriguez wrote:
> The Linux VFS does not allow a way to set append/immuttable
                                                   ^^^^^^^^^^

Typo, in all 3 patches.

> attributes to symlinks, this is just not possible. If this is
> detected inform the user as the filesystem must be corrupted.
> 
> Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
> ---
>  fs/btrfs/inode.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index c4bdb597b323..d9c786be408c 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -3933,6 +3933,15 @@ static int btrfs_read_locked_inode(struct inode *inode)
>  		inode->i_op = &btrfs_dir_inode_operations;
>  		break;
>  	case S_IFLNK:
> +		/* VFS does not allow setting these so must be corruption */
> +		if (IS_APPEND(inode) || IS_IMMUTABLE(inode)) {
> +			ret = -EUCLEAN;
> +			btrfs_crit(fs_info,
> +				  "corrupt symlink with append/immutable ino=%llu root=%llu\n",

no "\n" and please un-indent the string so it fits 80 columns.

> +				  btrfs_ino(BTRFS_I(inode)),
> +				  root->root_key.objectid);
> +			goto make_bad;

I found some error handling issues, before the switch, there's
btrfs_free_path and there's one more at the make_bad label.

To fix that, please set path = NULL after the first btrfs_free_path, it
can handle a NULL when it's called again.

Next thing I'm not sure about are the ACLs that get initialized in some
cases. There's cache_no_acl() that only resets the inode::i_acl and
inode::i_default_acl, so I think this should be called too. Thanks.
