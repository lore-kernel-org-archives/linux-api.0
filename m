From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH v2 11/20] fscrypt: add
 FS_IOC_REMOVE_ENCRYPTION_KEY ioctl
Date: Tue, 12 Feb 2019 09:12:49 +1100
Message-ID: <20190211221249.GH20493@dastard>
References: <20190211172738.4633-1-ebiggers@kernel.org>
 <20190211172738.4633-12-ebiggers@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20190211172738.4633-12-ebiggers@kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Eric Biggers <ebiggers@kernel.org>
Cc: Satya Tangirala <satyat@google.com>, linux-api@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-fscrypt@vger.kernel.org, keyrings@vger.kernel.org, linux-mtd@lists.infradead.org, linux-crypto@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Paul Crowley <paulcrowley@google.com>
List-Id: linux-api@vger.kernel.org

On Mon, Feb 11, 2019 at 09:27:29AM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Add a new fscrypt ioctl, FS_IOC_REMOVE_ENCRYPTION_KEY.  This ioctl
> removes an encryption key that was added by FS_IOC_ADD_ENCRYPTION_KEY.
> It wipes the secret key itself, then "locks" the encrypted files and
> directories that had been unlocked using that key -- implemented by
> evicting the relevant dentries and inodes from the VFS caches.
> 
> The problem this solves is that many fscrypt users want the ability to
> remove encryption keys, causing the corresponding encrypted directories
> to appear "locked" (presented in ciphertext form) again.  Moreover,
> users want removing an encryption key to *really* remove it, in the
> sense that the removed keys cannot be recovered even if kernel memory is
> compromised, e.g. by the exploit of a kernel security vulnerability or
> by a physical attack.  This is desirable after a user logs out of the
> system, for example.  In many cases users even already assume this to be
> the case and are surprised to hear when it's not.
> 
> It is not sufficient to simply unlink the master key from the keyring
> (or to revoke or invalidate it), since the actual encryption transform
> objects are still pinned in memory by their inodes.  Therefore, to
> really remove a key we must also evict the relevant inodes.
> 
> Currently one workaround is to run 'sync && echo 2 >
> /proc/sys/vm/drop_caches'.  But, that evicts all unused inodes in the
> system rather than just the inodes associated with the key being
> removed, causing severe performance problems.  Moreover, it requires
> root privileges, so regular users can't "lock" their encrypted files.
> 
> Another workaround, used in Chromium OS kernels, is to add a new
> VFS-level ioctl FS_IOC_DROP_CACHE which is a more restricted version of
> drop_caches that operates on a single super_block.  It does:
> 
>         shrink_dcache_sb(sb);
>         invalidate_inodes(sb, false);
> 
> But it's still a hack.  Yet, the major users of filesystem encryption
> want this feature badly enough that they are actually using these hacks.
> 
> To properly solve the problem, start maintaining a list of the inodes
> which have been "unlocked" using each master key.  Originally this
> wasn't possible because the kernel didn't keep track of in-use master
> keys at all.  But, with the ->s_master_keys keyring it is now possible.
> 
> Then, add an ioctl FS_IOC_REMOVE_ENCRYPTION_KEY.  It finds the specified
> master key in ->s_master_keys, then wipes the secret key itself, which
> prevents any additional inodes from being unlocked with the key.  Then,
> it syncs the filesystem and evicts the inodes in the key's list.  The
> normal inode eviction code will free and wipe the per-file keys (in
> ->i_crypt_info).  Note that freeing ->i_crypt_info without evicting the
> inodes was also considered, but would have been racy.

The solution is still so gross. Exporting all the inode cache
internal functions so you can invalidate an external list of inodes
is, IMO, not an appropriate solution for anything.

Indeed, this is exactly what ->drop_inode() is for.

Take this function:

> +static void evict_dentries_for_decrypted_inodes(struct fscrypt_master_key *mk)
> +{
> +	struct fscrypt_info *ci;
> +	struct inode *inode;
> +	struct inode *toput_inode = NULL;
> +
> +	spin_lock(&mk->mk_decrypted_inodes_lock);
> +
> +	list_for_each_entry(ci, &mk->mk_decrypted_inodes, ci_master_key_link) {
> +		inode = ci->ci_inode;
> +		spin_lock(&inode->i_lock);
> +		if (inode->i_state & (I_FREEING | I_WILL_FREE | I_NEW)) {
> +			spin_unlock(&inode->i_lock);
> +			continue;
> +		}
> +		__iget(inode);
> +		spin_unlock(&inode->i_lock);
> +		spin_unlock(&mk->mk_decrypted_inodes_lock);
> +
> +		shrink_dcache_inode(inode);
> +		iput(toput_inode);
> +		toput_inode = inode;
> +
> +		spin_lock(&mk->mk_decrypted_inodes_lock);
> +	}
> +
> +	spin_unlock(&mk->mk_decrypted_inodes_lock);
> +	iput(toput_inode);
> +}

It takes a new reference to each decrypted inode, and then drops it
again after all the dentry cache references have been killed and
we've got a reference to the next inode in the list.  Killing the
dentry references to the inode means it should only have in-use
references and the reference this function holds on it.

If the inode is not in use then there will be only one, and so it
will fall into iput_final() and the ->drop_inode() function
determines if the inode should be evicted from the cache and
destroyed immediately.  IOWs, implement fscrypt_drop_inode() to do
the right thing when the key has been destroyed, and you can get rid
of all this crazy inode cache walk-and-invalidate hackery.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
