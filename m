From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH 04/10] fs: Introduce RWF_NOWAIT
Date: Sat, 10 Jun 2017 06:27:03 +0100
Message-ID: <20170610052703.GC6365@ZenIV.linux.org.uk>
References: <20170606111939.27272-1-rgoldwyn@suse.de>
 <20170606111939.27272-5-rgoldwyn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170606111939.27272-5-rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-IBi9RG/b67k@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, adam.manzanares-Sjgp3cTcYWE@public.gmane.org, Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jun 06, 2017 at 06:19:33AM -0500, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>
> 
> RWF_NOWAIT informs kernel to bail out if an AIO request will block
> for reasons such as file allocations, or a writeback triggered,
> or would block while allocating requests while performing
> direct I/O.
> 
> RWF_NOWAIT is translated to IOCB_NOWAIT for iocb->ki_flags.
> 
> The check for -EOPNOTSUPP is placed in generic_file_write_iter(). This
> is called by most filesystems, either through fsops.write_iter() or through
> the function defined by write_iter(). If not, we perform the check defined
> by .write_iter() which is called for direct IO specifically.
> 
> Filesystems xfs, btrfs and ext4 would be supported in the following patches.

Umm...  What about ->write_iter() instances outside of fs/*?  Even in fs/*,
consider e.g.
int cifs_get_writer(struct cifsInodeInfo *cinode)
{
        int rc;

start:
        rc = wait_on_bit(&cinode->flags, CIFS_INODE_PENDING_OPLOCK_BREAK,
                         TASK_KILLABLE);

and cifs_file_write_iter() calling it before going to generic_file_write_iter().
Ditto for cifs_struct_writev()...  coda_file_write_iter() does inode_lock()
before calling vfs_iter_write().  ext2_dax_write_iter(): inode_lock().
f2fs_file_write_iter(): ditto.  fuse_file_write_iter(): ditto in case when
->writeback_cache is false.  gfs2 is O_APPEND case: almost certainly blocks.
ncp_file_write_iter(): blocks (mutex_lock(&NCP_FINFO(inode)->open_mutex)
in ncp_make_open(), not to mention anything else). ntfs_file_write_iter():
inode_lock().  orangefs_file_write_iter(): ditto.  ubifs_write_iter():
may block in update_mctime().  udf_file_write_iter(): inode_lock().

Lustre sure as hell does block before it gets anywhere near mm/filemap.c.

And that - just from looking at regular files.  Then we have sockets and
pipes, not to mention weird stuff like fs/fuse/cuse.c, etc.
