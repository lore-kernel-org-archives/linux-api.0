From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v7 07/16] fscrypt: add
 FS_IOC_REMOVE_ENCRYPTION_KEY ioctl
Date: Mon, 29 Jul 2019 12:58:28 -0700
Message-ID: <20190729195827.GF169027@gmail.com>
References: <20190726224141.14044-1-ebiggers@kernel.org>
 <20190726224141.14044-8-ebiggers@kernel.org>
 <20190728192417.GG6088@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20190728192417.GG6088@mit.edu>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: Satya Tangirala <satyat@google.com>, linux-api@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-fscrypt@vger.kernel.org, keyrings@vger.kernel.org, linux-mtd@lists.infradead.org, linux-crypto@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Paul Crowley <paulcrowley@google.com>
List-Id: linux-api@vger.kernel.org

On Sun, Jul 28, 2019 at 03:24:17PM -0400, Theodore Y. Ts'o wrote:
> > +
> > +/*
> > + * Try to remove an fscrypt master encryption key.  If other users have also
> > + * added the key, we'll remove the current user's usage of the key, then return
> > + * -EUSERS.  Otherwise we'll continue on and try to actually remove the key.
> 
> Nit: this should be moved to patch #11
> 
> Also, perror(EUSERS) will display "Too many users" which is going to
> be confusing.  I understand why you chose this; we would like to
> distinguish between there are still inodes using this key, and there
> are other users using this key.
> 
> Do we really need to return EUSERS in this case?  It's actually not an
> *error* that other users are using the key.  After all, the unlink(2)
> system call doesn't return an advisory error when you delete a file
> which has other hard links.  And an application which does care about
> this detail can always call FS_IOC_ENCRYPTION_KEY_STATUS() and check
> user_count.
> 

Returning 0 when the key wasn't fully removed might also be confusing.  But I
guess you're right that returning an error doesn't match how syscalls usually
work.  It did remove the current user's usage of the key, after all, rather than
completely fail.  And as you point out, if someone cares about other users
having added the key, they can use FS_IOC_GET_ENCRYPTION_KEY_STATUS.

So I guess I'll change it to 0.

Thanks!

- Eric
