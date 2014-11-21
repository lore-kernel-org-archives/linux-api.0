From: Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: kdbus: add node and filesystem implementation
Date: Fri, 21 Nov 2014 10:55:25 -0500
Message-ID: <546F606D.40407@oracle.com>
References: <1416546149-24799-1-git-send-email-gregkh@linuxfoundation.org> <1416546149-24799-7-git-send-email-gregkh@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1416546149-24799-7-git-send-email-gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, arnd-r2nGTMty4D4@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, teg-B22kvLQNl6c@public.gmane.org, jkosina-AlSwsSmVLrQ@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 11/21/2014 12:02 AM, Greg Kroah-Hartman wrote:
> +static struct dentry *fs_dir_iop_lookup(struct inode *dir,
> +					struct dentry *dentry,
> +					unsigned int flags)
> +{
> +	struct dentry *dnew = NULL;
> +	struct kdbus_node *parent;
> +	struct kdbus_node *node;
> +	struct inode *inode;
> +
> +	parent = kdbus_node_from_dentry(dentry->d_parent);
> +	if (!kdbus_node_acquire(parent))
> +		return NULL;
> +
> +	/* returns reference to _acquired_ child node */
> +	node = kdbus_node_find_child(parent, dentry->d_name.name);
> +	if (node) {
> +		dentry->d_fsdata = node;
> +		inode = fs_inode_get(dir->i_sb, node);
> +		if (IS_ERR(inode))
> +			dnew = ERR_CAST(inode);
> +		else
> +			dnew = d_materialise_unique(dentry, inode);

d_materialise_unique() is gone in Al's fs tree:

[mandatory]
        d_materialise_unique() is gone; d_splice_alias() does everything you
        need now.  Remember that they have opposite orders of arguments ;-/

Maybe it's worth basing your git tree on top of Al's rather than a random
-rc, since it's now a filesystem?


Thanks,
Sasha
