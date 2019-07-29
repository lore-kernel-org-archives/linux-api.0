From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v7 16/16] fscrypt: document the new ioctls
 and policy version
Date: Sun, 28 Jul 2019 22:00:09 -0400
Message-ID: <20190729020009.GA3863@mit.edu>
References: <20190726224141.14044-1-ebiggers@kernel.org>
 <20190726224141.14044-17-ebiggers@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20190726224141.14044-17-ebiggers@kernel.org>
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

On Fri, Jul 26, 2019 at 03:41:41PM -0700, Eric Biggers wrote:
> +- The kernel cannot magically wipe copies of the master key(s) that
> +  userspace might have as well.  Therefore, userspace must wipe all
> +  copies of the master key(s) it makes as well.  Naturally, the same
> +  also applies to all higher levels in the key hierarchy.  Userspace
> +  should also follow other security precautions such as mlock()ing
> +  memory containing keys to prevent it from being swapped out.

Normally, shouldn't userspace have wiped all copies of the master key
after they have called ADD_KEY?  Why should they be left hanging
around?  Waiting until REMOVE_KEY to remove other copies of the master
key seems.... late.

> +- In general, decrypted contents and filenames in the kernel VFS
> +  caches are freed but not wiped.  Therefore, portions thereof may be
> +  recoverable from freed memory, even after the corresponding key(s)
> +  were wiped.  To partially solve this, you can set
> +  CONFIG_PAGE_POISONING=y in your kernel config and add page_poison=1
> +  to your kernel command line.  However, this has a performance cost.

... and even this won't help if you have swap configured....

> +v1 encryption policies have some weaknesses with respect to online
> +attacks:
> +
> +- There is no verification that the provided master key is correct.
> +  Consequently, malicious users can associate the wrong key with
> +  encrypted files, even files to which they have only read-only
> +  access.

Yes, but they won't be able to trick other users into using that
incorrect key.  With the old interface, it gets written into the
user's session keyring, which won't get used by another user.  And
with the newer interface, only root is allowed to set v1 key.

> +Master keys should be pseudorandom, i.e. indistinguishable from random
> +bytestrings of the same length.  This implies that users **must not**
> +directly use a password as a master key, zero-pad a shorter key, or
> +repeat a shorter key.

These paragraphs starts a bit funny, since we first say "should" in
the first sentence, and then it's followed up by "**must not**" in the
second sentence.  Basically, they *could* do this, but it would just
weaken the security of the system significantly.

At the very least, we should explain the basis of the recommendation.

> +The KDF used for a particular master key differs depending on whether
> +the key is used for v1 encryption policies or for v2 encryption
> +policies.  Users **must not** use the same key for both v1 and v2
> +encryption policies.

"Must not" seems a bit strong.  If they do, and a v1 per-file key and
nonce leaks out, then the encryption key will be compromised.  So the
strength of the key will be limited by the weaknesses of the v1
scheme.  But it's not like using a that was originally meant for v1,
and then using it for v2, causes any additional weakness.  Right?

    	       	      	  	 - Ted
