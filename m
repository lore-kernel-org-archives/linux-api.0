From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v4 07/17] fs/dcache.c: add shrink_dcache_inode()
Date: Wed, 3 Apr 2019 19:34:12 +0100
Message-ID: <20190403183411.GV2217@ZenIV.linux.org.uk>
References: <20190402154600.32432-1-ebiggers@kernel.org>
 <20190402154600.32432-8-ebiggers@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20190402154600.32432-8-ebiggers@kernel.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd/>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: "linux-mtd" <linux-mtd-bounces@lists.infradead.org>
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org
To: Eric Biggers <ebiggers@kernel.org>
Cc: Satya Tangirala <satyat@google.com>, linux-api@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-fscrypt@vger.kernel.org, keyrings@vger.kernel.org, linux-mtd@lists.infradead.org, linux-crypto@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Paul Crowley <paulcrowley@google.com>
List-Id: linux-api@vger.kernel.org

On Tue, Apr 02, 2019 at 08:45:50AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> When a filesystem encryption key is removed, we need all files which had
> been "unlocked" (had ->i_crypt_info set up) with it to appear "locked"
> again.  This is most easily done by evicting the inodes.  This can
> currently be done using 'echo 2 > /proc/sys/vm/drop_caches'; however,
> that is overkill and not usable by non-root users.
> 
> To evict just the needed inodes we also need the ability to evict those
> inodes' dentries, since an inode is pinned by its dentries.  Therefore,
> add a function shrink_dcache_inode() which iterates through an inode's
> dentries and evicts any unused ones as well as any unused descendants
> (since there may be negative dentries pinning the inode's dentries).

Huh?

> + * Evict all unused aliases of the specified inode from the dcache.  This is
> + * intended to be used when trying to evict a specific inode, since inodes are
> + * pinned by their dentries.  We also have to descend to ->d_subdirs for each
> + * alias, since aliases may be pinned by negative child dentries.
> + */
> +void shrink_dcache_inode(struct inode *inode)
> +{
> +	for (;;) {
> +		struct select_data data;
> +		struct dentry *dentry;
> +
> +		INIT_LIST_HEAD(&data.dispose);
> +		data.start = NULL;
> +		data.found = 0;
> +
> +		spin_lock(&inode->i_lock);
> +		hlist_for_each_entry(dentry, &inode->i_dentry, d_u.d_alias)
> +			d_walk(dentry, &data, select_collect);
> +		spin_unlock(&inode->i_lock);
> +
> +		if (!data.found)
> +			break;
> +
> +		shrink_dentry_list(&data.dispose);
> +		cond_resched();

This is... odd.  What's wrong with
	if (S_ISDIR(inode->i_mode)) {
		dentry = d_find_any_alias(inode);
		if (dentry) {
			shrink_dcache_parent(dentry);
			dput(dentry);
		}
	}
	d_prune_aliases(inode);
instead of that thing?

______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
