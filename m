From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v7 04/16] fscrypt: add ->ci_inode to fscrypt_info
Date: Sun, 28 Jul 2019 11:09:27 -0400
Message-ID: <20190728150927.GD6088@mit.edu>
References: <20190726224141.14044-1-ebiggers@kernel.org>
 <20190726224141.14044-5-ebiggers@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20190726224141.14044-5-ebiggers@kernel.org>
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

On Fri, Jul 26, 2019 at 03:41:29PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Add an inode back-pointer to 'struct fscrypt_info', such that
> inode->i_crypt_info->ci_inode == inode.
> 
> This will be useful for:
> 
> 1. Evicting the inodes when a fscrypt key is removed, since we'll track
>    the inodes using a given key by linking their fscrypt_infos together,
>    rather than the inodes directly.  This avoids bloating 'struct inode'
>    with a new list_head.
> 
> 2. Simplifying the per-file key setup, since the inode pointer won't
>    have to be passed around everywhere just in case something goes wrong
>    and it's needed for fscrypt_warn().
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Looks good, feel free to add:

Reviewed-by: Theodore Ts'o <tytso@mit.edu>

______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
