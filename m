From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v7 07/16] fscrypt: add FS_IOC_REMOVE_ENCRYPTION_KEY ioctl
Date: Sun, 28 Jul 2019 15:24:17 -0400
Message-ID: <20190728192417.GG6088@mit.edu>
References: <20190726224141.14044-1-ebiggers@kernel.org>
 <20190726224141.14044-8-ebiggers@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20190726224141.14044-8-ebiggers@kernel.org>
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

On Fri, Jul 26, 2019 at 03:41:32PM -0700, Eric Biggers wrote:
> +	fscrypt_warn(NULL,
> +		     "%s: %zu inodes still busy after removing key with description %*phN, including ino %lu (%s)",

nit: s/inodes/inode(s)/

> +
> +/*
> + * Try to remove an fscrypt master encryption key.  If other users have also
> + * added the key, we'll remove the current user's usage of the key, then return
> + * -EUSERS.  Otherwise we'll continue on and try to actually remove the key.

Nit: this should be moved to patch #11

Also, perror(EUSERS) will display "Too many users" which is going to
be confusing.  I understand why you chose this; we would like to
distinguish between there are still inodes using this key, and there
are other users using this key.

Do we really need to return EUSERS in this case?  It's actually not an
*error* that other users are using the key.  After all, the unlink(2)
system call doesn't return an advisory error when you delete a file
which has other hard links.  And an application which does care about
this detail can always call FS_IOC_ENCRYPTION_KEY_STATUS() and check
user_count.

Other than these nits, looks good.  Feel free to add:

Reviewed-by: Theodore Ts'o <tytso@mit.edu>

						- Ted

______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
