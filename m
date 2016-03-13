From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: [PATCH v18 21/22] ext4: Add richacl support
Date: Mon, 14 Mar 2016 00:49:57 +0100
Message-ID: <CAHc6FU4trGRagkjJBA9Hf_fGfCrwhRRDkUbozRxk4E1O-CbXgw@mail.gmail.com>
References: <1456733847-17982-1-git-send-email-agruenba@redhat.com>
	<1456733847-17982-22-git-send-email-agruenba@redhat.com>
	<20160311142719.GG14808@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <20160311142719.GG14808@infradead.org>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-cifs@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Linux API <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, LKML <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, "J. Bruce Fields" <bfields@fieldses.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4 <linux-ext4@vger.kernel.org>, Anna Schumaker <anna.schumaker@netapp.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 11, 2016 at 3:27 PM, Christoph Hellwig <hch@infradead.org> wrote:
>> +static int
>> +__ext4_set_richacl(handle_t *handle, struct inode *inode, struct richacl *acl)
>> +{
>> +     const int name_index = EXT4_XATTR_INDEX_RICHACL;
>> +     umode_t mode = inode->i_mode;
>> +     int retval, size;
>> +     void *value;
>> +
>> +     if (richacl_equiv_mode(acl, &mode) == 0) {
>> +             inode->i_ctime = ext4_current_time(inode);
>> +             inode->i_mode = mode;
>> +             ext4_mark_inode_dirty(handle, inode);
>> +             return __ext4_remove_richacl(handle, inode);
>> +     }
>
> Should this check for a NULL acl instead of special casing that
> in ext4_set_richacl?

I'm not sure I understand what you mean. When iop->set_richacl is
called with a richacl that is mode-equivalent, the file permission
bits need to be updated and any existing acl needs to be removed.
Doing this at the vfs level would result in two calls, iop->setattr
and iop->set_richacl, which can cause problems. To remove an existing
acl without setting the mode, set_richacl is called with a NULL
richacl.

__ext4_set_richacl() was split into __ext4_set_richacl() and
__ext4_remove_richacl() to align with the xfs code due to the
following comment from Dave Chinner:
  http://oss.sgi.com/archives/xfs/2015-10/msg00354.html

Diff here:
  https://git.kernel.org/cgit/linux/kernel/git/agruen/linux-richacl.git/diff/fs/ext4/richacl.c?id=richacl-2015-10-16&id2=richacl-2015-10-12

>> +int
>> +ext4_init_richacl(handle_t *handle, struct inode *inode, struct inode *dir)
>> +{
>> +     struct richacl *acl = richacl_create(&inode->i_mode, dir);
>> +     int error;
>> +
>> +     error = PTR_ERR(acl);
>> +     if (IS_ERR(acl))
>> +             return error;
>
>         if (IS_ERR(acl))
>                 return PTR_ERR(acl);
>
>> +     if (acl) {
>> +             error = __ext4_set_richacl(handle, inode, acl);
>> +             richacl_put(acl);
>> +     }
>
> Shouldn't richacl_create return NULL if the ACL is equivalent to the
> mode bits instead of letting every filesystem figure that out on it's
> own?

Hm, that's what it does?

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
