From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v18 21/22] ext4: Add richacl support
Date: Fri, 11 Mar 2016 06:27:19 -0800
Message-ID: <20160311142719.GG14808@infradead.org>
References: <1456733847-17982-1-git-send-email-agruenba@redhat.com>
 <1456733847-17982-22-git-send-email-agruenba@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1456733847-17982-22-git-send-email-agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

> +static inline int
> +ext4_acl_chmod(struct inode *inode, umode_t mode)
> +{
> +	if (IS_RICHACL(inode))
> +		return richacl_chmod(inode, inode->i_mode);
> +	return posix_acl_chmod(inode, inode->i_mode);
> +}

Thi isn't ext4-specific and potentially duplicated in every caller.
Please provide this as a common helper.

Also while we're at it, the mode argument is ignore and the function
always uses inode->i_mode instead.

> +ext4_get_richacl(struct inode *inode)
> +{
> +	const int name_index = EXT4_XATTR_INDEX_RICHACL;
> +	void *value = NULL;
> +	struct richacl *acl = NULL;
> +	int retval;
> +
> +	retval = ext4_xattr_get(inode, name_index, "", NULL, 0);
> +	if (retval > 0) {
> +		value = kmalloc(retval, GFP_NOFS);
> +		if (!value)
> +			return ERR_PTR(-ENOMEM);
> +		retval = ext4_xattr_get(inode, name_index, "", value, retval);
> +	}
> +	if (retval > 0) {
> +		acl = richacl_from_xattr(&init_user_ns, value, retval);
> +		if (acl == ERR_PTR(-EINVAL))
> +			acl = ERR_PTR(-EIO);

Shouldn't richacl_from_xattr return the error pointer that ->get_richacl
callers expect?

> +static int
> +__ext4_set_richacl(handle_t *handle, struct inode *inode, struct richacl *acl)
> +{
> +	const int name_index = EXT4_XATTR_INDEX_RICHACL;
> +	umode_t mode = inode->i_mode;
> +	int retval, size;
> +	void *value;
> +
> +	if (richacl_equiv_mode(acl, &mode) == 0) {
> +		inode->i_ctime = ext4_current_time(inode);
> +		inode->i_mode = mode;
> +		ext4_mark_inode_dirty(handle, inode);
> +		return __ext4_remove_richacl(handle, inode);
> +	}

Should this check for a NULL acl instead of special casing that
in ext4_set_richacl?

> +int
> +ext4_init_richacl(handle_t *handle, struct inode *inode, struct inode *dir)
> +{
> +	struct richacl *acl = richacl_create(&inode->i_mode, dir);
> +	int error;
> +
> +	error = PTR_ERR(acl);
> +	if (IS_ERR(acl))
> +		return error;

	if (IS_ERR(acl))
		return PTR_ERR(acl);

> +	if (acl) {
> +		error = __ext4_set_richacl(handle, inode, acl);
> +		richacl_put(acl);
> +	}

Shouldn't richacl_create return NULL if the ACL is equivalent to the
mode bits instead of letting every filesystem figure that out on it's
own?
