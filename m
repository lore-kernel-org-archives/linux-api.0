From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v7 07/16] fscrypt: add
 FS_IOC_REMOVE_ENCRYPTION_KEY ioctl
Date: Wed, 31 Jul 2019 11:38:02 -0700
Message-ID: <20190731183802.GA687@sol.localdomain>
References: <20190726224141.14044-1-ebiggers@kernel.org>
 <20190726224141.14044-8-ebiggers@kernel.org>
 <20190728192417.GG6088@mit.edu> <20190729195827.GF169027@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20190729195827.GF169027@gmail.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: "Theodore Y. Ts'o" <tytso@mit.edu>, linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-mtd@lists.infradead.org, linux-api@vger.kernel.org, linux-crypto@vger.kernel.org, keyrings@vger.kernel.org, Paul Crowley <paulcrowley@google.com>, Satya Tangirala <satyat@google.com>
List-Id: linux-api@vger.kernel.org

On Mon, Jul 29, 2019 at 12:58:28PM -0700, Eric Biggers wrote:
> On Sun, Jul 28, 2019 at 03:24:17PM -0400, Theodore Y. Ts'o wrote:
> > > +
> > > +/*
> > > + * Try to remove an fscrypt master encryption key.  If other users have also
> > > + * added the key, we'll remove the current user's usage of the key, then return
> > > + * -EUSERS.  Otherwise we'll continue on and try to actually remove the key.
> > 
> > Nit: this should be moved to patch #11
> > 
> > Also, perror(EUSERS) will display "Too many users" which is going to
> > be confusing.  I understand why you chose this; we would like to
> > distinguish between there are still inodes using this key, and there
> > are other users using this key.
> > 
> > Do we really need to return EUSERS in this case?  It's actually not an
> > *error* that other users are using the key.  After all, the unlink(2)
> > system call doesn't return an advisory error when you delete a file
> > which has other hard links.  And an application which does care about
> > this detail can always call FS_IOC_ENCRYPTION_KEY_STATUS() and check
> > user_count.
> > 
> 
> Returning 0 when the key wasn't fully removed might also be confusing.  But I
> guess you're right that returning an error doesn't match how syscalls usually
> work.  It did remove the current user's usage of the key, after all, rather than
> completely fail.  And as you point out, if someone cares about other users
> having added the key, they can use FS_IOC_GET_ENCRYPTION_KEY_STATUS.
> 
> So I guess I'll change it to 0.
> 

So after making this change and thinking about it some more, I'm not sure it's
actually an improvement.

The normal use case for this ioctl is to "lock" some encrypted directory(s).  If
it returns 0 and doesn't lock the directory(s), that's unexpected.

This is perhaps different from what users expect from unlink().  It's well known
that unlink() just deletes the filename, not the file itself if it's still open
or has other links.  And unlink() by itself isn't meant for use cases where the
file absolutely must be securely erased.  But FS_IOC_REMOVE_ENCRYPTION_KEY
really is meant primarily for that sort of thing.

To give a concrete example: my patch for the userspace tool
https://github.com/google/fscrypt adds a command 'fscrypt lock' which locks an
encrypted directory.  If, say, someone runs 'fscrypt unlock' as uid 0 and then
'fscrypt lock' as uid 1000, then FS_IOC_REMOVE_ENCRYPTION_KEY can't actually
remove the key.  I need to make the tool show a proper error message in this
case.  To do so, it would help to get a unique error code (e.g. EUSERS) from
FS_IOC_REMOVE_ENCRYPTION_KEY, rather than get the ambiguous error code ENOKEY
and have to call FS_IOC_GET_ENCRYPTION_KEY_STATUS to get the real status.

Also, we already have the EBUSY case.  This means that the ioctl removed the
master key secret itself; however, some files were still in-use, so the key
remains in the "incompletely removed" state.  If we were actually going for
unlink() semantics, then for consistency this case really ought to return 0 and
unlink the key object, and people who care about in-use files would need to use
FS_IOC_GET_ENCRYPTION_KEY_STATUS.  But most people *will* care about this, and
may even want to retry the ioctl later, which isn't something you can do with
pure unlink() semantics.

So I'm leaning towards keeping the EUSERS and EBUSY errors.

- Eric
