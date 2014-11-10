From: Milosz Tanski <milosz@adfin.com>
Subject: [PATCH v6 7/7] fs: add a flag for per-operation O_DSYNC semantics
Date: Mon, 10 Nov 2014 11:40:30 -0500
Message-ID: <66d286ef31b6b21ce252ba2716c228639b484e53.1415636409.git.milosz@adfin.com>
References: <cover.1415636409.git.milosz@adfin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <cover.1415636409.git.milosz@adfin.com>
In-Reply-To: <cover.1415636409.git.milosz@adfin.com>
References: <cover.1415636409.git.milosz@adfin.com>
Sender: owner-linux-aio@kvack.org
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>, Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, linux-arch@vger.kernel.org, ceph-devel@vger.kernel.org, fuse-devel@lists.sourceforge.net, linux-nfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-mm@kvack.org
List-Id: linux-api@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

With the new read/write with flags syscalls we can support a flag
to enable O_DSYNC semantics on a per-operation basis.  This =D1=96s
useful to implement protocols like SMB, NFS or SCSI that have such
per-operation flags.

Example program below:

cat > pwritev2.c << EOF

        (off_t) val,                              \
        (off_t) ((((uint64_t) (val)) >> (sizeof (long) * 4)) >> (sizeof (=
long) * 4))

static ssize_t
pwritev2(int fd, const struct iovec *iov, int iovcnt, off_t offset, int f=
lags)
{
        return syscall(__NR_pwritev2, fd, iov, iovcnt, LO_HI_LONG(offset)=
,
			 flags);
}

int main(int argc, char **argv)
{
	int fd =3D open(argv[1], O_WRONLY|O_CREAT|O_TRUNC, 0666);
	char buf[1024];
	struct iovec iov =3D { .iov_base =3D buf, .iov_len =3D 1024 };
	int ret;

        if (fd < 0) {
                perror("open");
                return 0;
        }

	memset(buf, 0xfe, sizeof(buf));

	ret =3D pwritev2(fd, &iov, 1, 0, RWF_DSYNC);
	if (ret < 0)
		perror("pwritev2");
	else
		printf("ret =3D %d\n", ret);

	return 0;
}
EOF

Signed-off-by: Christoph Hellwig <hch@lst.de>
[milosz@adfin.com: comapt syscall changes for RWF_ODSYNC]
Signed-off-by: Milosz Tanski <milosz@adfin.com>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Acked-by: Sage Weil <sage@redhat.com>
---
 fs/ceph/file.c     |  4 +++-
 fs/fuse/file.c     |  2 ++
 fs/nfs/file.c      | 10 ++++++----
 fs/ocfs2/file.c    |  6 ++++--
 fs/read_write.c    |  8 ++++++--
 include/linux/fs.h |  3 ++-
 mm/filemap.c       |  4 +++-
 7 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index b798b5c..2d4e15a 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -983,7 +983,9 @@ retry_snap:
 	ceph_put_cap_refs(ci, got);
=20
 	if (written >=3D 0 &&
-	    ((file->f_flags & O_SYNC) || IS_SYNC(file->f_mapping->host) ||
+	    ((file->f_flags & O_SYNC) ||
+	     IS_SYNC(file->f_mapping->host) ||
+	     (iocb->ki_rwflags & RWF_DSYNC) ||
 	     ceph_osdmap_flag(osdc->osdmap, CEPH_OSDMAP_NEARFULL))) {
 		err =3D vfs_fsync_range(file, pos, pos + written - 1, 1);
 		if (err < 0)
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index caa8d95..bb4fb23 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1248,6 +1248,8 @@ static ssize_t fuse_file_write_iter(struct kiocb *i=
ocb, struct iov_iter *from)
 		written +=3D written_buffered;
 		iocb->ki_pos =3D pos + written_buffered;
 	} else {
+		if (iocb->ki_rwflags & RWF_DSYNC)
+			return -EINVAL;
 		written =3D fuse_perform_write(file, mapping, from, pos);
 		if (written >=3D 0)
 			iocb->ki_pos =3D pos + written;
diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index aa9046f..c59b0b7 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -652,13 +652,15 @@ static const struct vm_operations_struct nfs_file_v=
m_ops =3D {
 	.remap_pages =3D generic_file_remap_pages,
 };
=20
-static int nfs_need_sync_write(struct file *filp, struct inode *inode)
+static int nfs_need_sync_write(struct kiocb *iocb, struct inode *inode)
 {
 	struct nfs_open_context *ctx;
=20
-	if (IS_SYNC(inode) || (filp->f_flags & O_DSYNC))
+	if (IS_SYNC(inode) ||
+	    (iocb->ki_filp->f_flags & O_DSYNC) ||
+	    (iocb->ki_rwflags & RWF_DSYNC))
 		return 1;
-	ctx =3D nfs_file_open_context(filp);
+	ctx =3D nfs_file_open_context(iocb->ki_filp);
 	if (test_bit(NFS_CONTEXT_ERROR_WRITE, &ctx->flags) ||
 	    nfs_ctx_key_to_expire(ctx))
 		return 1;
@@ -705,7 +707,7 @@ ssize_t nfs_file_write(struct kiocb *iocb, struct iov=
_iter *from)
 		written =3D result;
=20
 	/* Return error values for O_DSYNC and IS_SYNC() */
-	if (result >=3D 0 && nfs_need_sync_write(file, inode)) {
+	if (result >=3D 0 && nfs_need_sync_write(iocb, inode)) {
 		int err =3D vfs_fsync(file, 0);
 		if (err < 0)
 			result =3D err;
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index bb66ca4..8f9a86b 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2374,8 +2374,10 @@ out_dio:
 	/* buffered aio wouldn't have proper lock coverage today */
 	BUG_ON(ret =3D=3D -EIOCBQUEUED && !(file->f_flags & O_DIRECT));
=20
-	if (((file->f_flags & O_DSYNC) && !direct_io) || IS_SYNC(inode) ||
-	    ((file->f_flags & O_DIRECT) && !direct_io)) {
+	if (((file->f_flags & O_DSYNC) && !direct_io) ||
+	    IS_SYNC(inode) ||
+	    ((file->f_flags & O_DIRECT) && !direct_io) ||
+	    (iocb->ki_rwflags & RWF_DSYNC)) {
 		ret =3D filemap_fdatawrite_range(file->f_mapping, *ppos,
 					       *ppos + count - 1);
 		if (ret < 0)
diff --git a/fs/read_write.c b/fs/read_write.c
index adf85ab..c2e3c0a 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -841,6 +841,8 @@ static ssize_t do_readv_writev(int type, struct file =
*file,
 	} else {
 		if (type =3D=3D READ && (flags & RWF_NONBLOCK))
 			return -EAGAIN;
+		if (type =3D=3D WRITE && (flags & RWF_DSYNC))
+			return -EINVAL;
=20
 		if (fnv)
 			ret =3D do_sync_readv_writev(file, iov, nr_segs, tot_len,
@@ -888,7 +890,7 @@ ssize_t vfs_writev(struct file *file, const struct io=
vec __user *vec,
 		return -EBADF;
 	if (!(file->f_mode & FMODE_CAN_WRITE))
 		return -EINVAL;
-	if (flags & ~0)
+	if (flags & ~RWF_DSYNC)
 		return -EINVAL;
=20
 	return do_readv_writev(WRITE, file, vec, vlen, pos, flags);
@@ -1082,6 +1084,8 @@ static ssize_t compat_do_readv_writev(int type, str=
uct file *file,
 	} else {
 		if (type =3D=3D READ && (flags & RWF_NONBLOCK))
 			return -EAGAIN;
+		if (type =3D=3D WRITE && (flags & RWF_DSYNC))
+			return -EINVAL;
=20
 		if (fnv)
 			ret =3D do_sync_readv_writev(file, iov, nr_segs, tot_len,
@@ -1221,7 +1225,7 @@ static size_t compat_writev(struct file *file,
 	ret =3D -EINVAL;
 	if (!(file->f_mode & FMODE_CAN_WRITE))
 		goto out;
-	if (flags & ~0)
+	if (flags & ~RWF_DSYNC)
 		goto out;
=20
 	ret =3D compat_do_readv_writev(WRITE, file, vec, vlen, pos, flags);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 7d0e116..7786b88 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1460,7 +1460,8 @@ struct block_device_operations;
 #define HAVE_UNLOCKED_IOCTL 1
=20
 /* These flags are used for the readv/writev syscalls with flags. */
-#define RWF_NONBLOCK 0x00000001
+#define RWF_NONBLOCK	0x00000001
+#define RWF_DSYNC	0x00000002
=20
 struct iov_iter;
=20
diff --git a/mm/filemap.c b/mm/filemap.c
index 535967b..8c50d35 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2669,7 +2669,9 @@ int generic_write_sync(struct kiocb *iocb, loff_t c=
ount)
 	struct file *file =3D iocb->ki_filp;
=20
 	if (count > 0 &&
-	    ((file->f_flags & O_DSYNC) || IS_SYNC(file->f_mapping->host))) {
+	    ((file->f_flags & O_DSYNC) ||
+	     (iocb->ki_rwflags & RWF_DSYNC) ||
+	     IS_SYNC(file->f_mapping->host))) {
 		bool fdatasync =3D !(file->f_flags & __O_SYNC);
 		ssize_t ret;
=20
--=20
1.9.1

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=3Dmailto:"aart@kvack.org">aart@kvack.org</a>
