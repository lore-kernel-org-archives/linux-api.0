From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v8 10/20] fscrypt: add FS_IOC_REMOVE_ENCRYPTION_KEY ioctl
Date: Mon, 12 Aug 2019 20:06:44 -0400
Message-ID: <20190813000644.GH28705@mit.edu>
References: <20190805162521.90882-1-ebiggers@kernel.org>
 <20190805162521.90882-11-ebiggers@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20190805162521.90882-11-ebiggers@kernel.org>
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
Cc: Satya Tangirala <satyat@google.com>, linux-api@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-fscrypt@vger.kernel.org, keyrings@vger.kernel.org, linux-mtd@lists.infradead.org, linux-crypto@vger.kernel.org, linux-fsdevel@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>, linux-ext4@vger.kernel.org, Paul Crowley <paulcrowley@google.com>
List-Id: linux-api@vger.kernel.org

> +		/* Some inodes still reference this key; try to evict them. */
> +		if (try_to_lock_encrypted_files(sb, mk) != 0)
> +			status_flags |=
> +				FSCRYPT_KEY_REMOVAL_STATUS_FLAG_FILES_BUSY;
> +	}

try_to_lock_encrypted_files() can return other errors besides -EBUSY;
in particular sync_filesystem() can return other errors, such as -EIO
or -EFSCORUPTED.  In that case, I think we're better off returning the
relevant status code back to the user.  We will have already wiped the
master key, but this situation will only happen in exceptional
conditions (e.g., user has ejected the sdcard, etc.), so it's not
worth it to try to undo the master key wipe to try to restore things
to the pre-ioctl execution state.

So I think we should capture the return code from
try_to_lock_encrypted_files, and if it is EBUSY, we can set FILES_BUSY
flag and return success.  Otherwise, we should return the error.

If you agree, please fix that up and then feel free to add:

Reviewed-by: Theodore Ts'o <tytso@mit.edu>

						- Ted

______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
