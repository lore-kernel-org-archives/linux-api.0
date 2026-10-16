Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03BD36B92D
	for <linux-api@vger.kernel.org>; Fri, 16 Oct 2026 14:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.121.94.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792161425; cv=none; b=CK9CpNItCJKI/xoUz8TdWATbIdqEZvvJL/kzSMN5w+JyZXuaIMf77c4yC9Yzfb5oUhaoFA25gQXhNzeQ5+TW/Im3ig25VWH5+l3bjhaVq+KuBQu9pBcH6HDoIvRtwjd1bo5wQfTfkuwBNP9+5z7RZrrik88Q1B0a7tPQv9qV65Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792161425; c=relaxed/simple;
	bh=fQpMUwg3CntePyNnKFLJefuYnAPAVnHwpx2iy3c4qA8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tOmjBg0blM5EoX91sPVWNG8YeRFlltooA+2sTwRAlSFHk3s7YiUX9Ysx/qQpaowIr3dxqVS+UcyJ2hmHETtGcnxA6HFBCaseuqM4ya9wYisCfFN7eKQ220wHyQTLC3oQAvFPbTtUDpWED66gcm+uu1OfgdlwqzG/IYEyFqBcdtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl; spf=pass smtp.mailfrom=xs4all.nl; dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b=Z79SESvh; arc=none smtp.client-ip=195.121.94.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b="Z79SESvh"
X-KPN-MessageId: 06c9700e-c96f-11f1-a5a4-005056994fde
Received: from smtp.kpnmail.nl (unknown [10.31.155.5])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id 06c9700e-c96f-11f1-a5a4-005056994fde;
	Fri, 16 Oct 2026 16:36:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=mime-version:message-id:date:subject:to:from;
	bh=bwfehsBPhkePwvekbdwvHcr+iTN8RsYJUW8NxaKmk3E=;
	b=Z79SESvhcmnlY5MFgnc+lLng5eVN6iawQ1DeBkDyrfd/urcyr90VnvD60UOnwi+maGIcN2Glw0L4b
	 7+rbB1PRUZzdKy1Xl+lPFjQLxdKU+KQb8KkP8TOkmJ6e68r6mvl1ZmzjDGltYlLoD5e/U8kZkyvkvw
	 luWTKBxx2TTECKFOMsR7+G8SnkITxPjevww3Bu0llj+9pqHIsWJNJdhQeqvJe6NbRzXqsbFdrXiEnB
	 nRBFNXT/XafsXgZcbo1IXy9L93nRqV1a5IpRfNEm4w13cgbu5QyAVJEV3hASW5WCNNnJbRqPOiYF+7
	 aVWhhcdEsIPNVaNOztYUoqlhaPol04w==
X-KPN-MID: 33|Vj7saAE2gcYCJ8UQYdVxo2bV/swd72e5QC28SFWPIPi6kBIR7j6pbB9jTsgSwyi
 g+78DJtdGNk0F8qPr5D0+eyGfF4hJ8U04qWakKe+S4iA=
X-KPN-VerifiedSender: Yes
X-CMASSUN: 33|AQIM97InwttOrgBEqQpyFV1pOxMV5q9+CzvZPXxn+bi6Ygf9uL7Sjee0trt8zcc
 nplN5hUeHNPPkjjh1c1Hf/g==
Received: from daedalus.home (unknown [178.228.137.172])
	by smtp.xs4all.nl (Halon) with ESMTPSA
	id 04081c76-c96f-11f1-a202-00505699b758;
	Fri, 16 Oct 2026 16:36:51 +0200 (CEST)
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Amir Goldstein <amir73il@gmail.com>,
	Aleksa Sarai <cyphar@cyphar.com>,
	Jori Koolstra <jkoolstra@xs4all.nl>
Subject: [PATCH v7 00/12] vfs: add O_CREAT|O_DIRECTORY to open*(2)
Date: Fri, 16 Oct 2026 16:37:54 +0200
Message-ID: <20261016143806.2946578-1-jkoolstra@xs4all.nl>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series implements new semantics for the O_CREAT|O_DIRECTORY flag
combination for open*(2): perform a mkdir and open the resulting
directory; return a pinning fd (which mkdir does not).

The v6 was found by Brauner to contain a bug because ->mkdir
implementations may leave the dentry negative, and do_open() cannot deal
with that (NULL pointer deref.) This behavior occurs in kernfs and
tracefs at least. Since atomic mkdir is wanted for cgroupfs (as per
Brauner at LPC26), kernfs is changed to return the new kernfs_node from
the kernfs_syscall_ops ->mkdir() callbacks and splicing its inode.

Filesystems that do not support O_CREAT|O_DIRECTORY set
SB_I_NO_ATOMIC_MKDIR, and lookup_open() refuses the open with EOPNOTSUPP
for them before doing any lookup. These are all ->atomic_open()
filesystems, which cannot create directories without protocol
extensions, and tracefs, whose ->mkdir() drops the parent's i_rwsem so
that the directory at the name may not be the one created by the call
(or at least it has to be verified that this plays well with the
atomicity guarantee that O_CREAT|O_DIRECTORY attempts to provide.) For
ecryptfs and apparmorfs there are similar concerns and hence they are
also blocked for now.

Most of the work happens in "vfs: add O_CREAT|O_DIRECTORY to open*(2),"
as may be expected. Before that there is some clean-up work and
preparation. The "vfs: short-circuit MAY_WRITE access for O_DIRECTORY
opens" patch is also worth paying extra attention to as it
short-circuits doomed opening of directories as writable. This check (to
prevent one from opening directories as writable) is currently done very
late in do_open(), after an inode has been obtained. However, when
introducing O_CREAT|O_DIRECTORY this is unacceptable as it would create
the directory and then still fail. This patch does however change some
user visible error codes.

Moreover, "vfs: change ->create/->mkdir operations unavailable errno"
also changes the ->create and ->mkdir unavailable errnos to -EOPNOTSUPP.
A previous attempt to do this more widely stranded before.[1] However,
that regression was only for vfat and does seem specific to changing the
return code from vfs_symlink(). We can drop this patch if needed, but it
would be _really_ ugly.

Changes from vn to v(n+1):
v6: https://lore.kernel.org/linux-fsdevel/20260913185016.523376-1-jkoolstra@xs4all.nl/
   - Change kernfs to instantiate ->mkdir dentry.
   - Fix kernfs locking when initializing a new inode to hold
     kernfs_iattr_rwsem.
   - Add flag SB_I_NO_ATOMIC_MKDIR to disable O_CREAT|O_DIRECTORY on
     unsupported filesystems (instead of only looking at ->atomic_open.)
   - Add tests to verify behavior of O_CREAT|O_DIRECTORY on cgroupfs and
     tracefs.
v5: https://lore.kernel.org/linux-fsdevel/20260823160706.358293-1-jkoolstra@xs4all.nl/
   - Uniformize ->create and ->mkdir unavailable errnos to -EOPNOTSUPP.
   - Return -EOPNOTSUPP instead of -ENOENT when O_CREAT|O_DIRECTORY is
     not supported by a ->atomic_open filesystem.
   - Added test cases for dangling symlink and sticky directory
     behaviour, and a test that verifies O_TMPFILE|O_CREAT is still
     -EINVAL.
   - Split off "vfs: lookup_open(): lock the parent as I_MUTEX_PARENT"
     as a separate patch.
   - Fixed the issues pointed out by Brauner in v5.
v4: https://lore.kernel.org/linux-fsdevel/20260712175539.1565444-1-jkoolstra@xs4all.nl/
   - rebased on 7.2, which includes my changes to auditing in
     lookup_open() as well as Neil Brown's changes to the same function
     for the implementation of vfs_lookup_open().
v3: https://lore.kernel.org/linux-fsdevel/20260704164149.3480051-1-jkoolstra@xs4all.nl/
   - address the inconsistency in calling audit_inode_child() in
     lookup_open() versus vfs_create() in a separate series.
   - fclog.c selftest header fix moved to separate patch.
   - add a "with trailing slash test" success test to the included
     selftests. 
   - pass struct qstr by pointer to trailing_slashes() and add a comment
     on what it does
   - changed commit message of "vfs: add O_CREAT|O_DIRECTORY to
     open*(2)" to address comments of Brauner

[1]: https://lore.kernel.org/linux-fsdevel/90228c39-04e7-41ef-ad91-84a8bb866650@sirena.org.uk/


Jori Koolstra (12):
  fs/namei.c: use trailing_slashes()
  vfs: prepare vfs_creat|mkdir_no_perm for reuse in lookup_open()
  vfs: lookup_open(): move setting FMODE_CREATED down
  vfs: move ->create check in lookup_open() to before try_break_deleg()
  vfs: lookup_open(): use vfs_create_no_perm()
  vfs: lookup_open(): lock the parent as I_MUTEX_PARENT
  kernfs: hold kernfs_iattr_rwsem when initializing a new inode
  vfs: add O_CREAT|O_DIRECTORY to open*(2)
  vfs: use finish_lookup() helper in __lookup_slow() and lookup_open()
  vfs: short-circuit MAY_WRITE access for O_DIRECTORY opens
  vfs: change ->create/->mkdir operations unavailable errno
  selftest: add tests for open*(O_CREAT|O_DIRECTORY)

 arch/alpha/include/uapi/asm/errno.h           |   2 +-
 arch/mips/include/uapi/asm/errno.h            |   2 +-
 arch/parisc/include/uapi/asm/errno.h          |   2 +-
 arch/sparc/include/uapi/asm/errno.h           |   2 +-
 fs/9p/vfs_super.c                             |   1 +
 fs/ceph/super.c                               |   1 +
 fs/ecryptfs/main.c                            |   1 +
 fs/fuse/inode.c                               |   1 +
 fs/gfs2/ops_fstype.c                          |   1 +
 fs/kernfs/dir.c                               |  30 +-
 fs/kernfs/inode.c                             |  37 +-
 fs/kernfs/kernfs-internal.h                   |   2 +
 fs/kernfs/mount.c                             |   3 -
 fs/namei.c                                    | 275 +++++++++-----
 fs/nfs/super.c                                |   1 +
 fs/open.c                                     |  42 ++-
 fs/resctrl/rdtgroup.c                         |  35 +-
 fs/smb/client/cifsfs.c                        |   1 +
 fs/tracefs/inode.c                            |   1 +
 fs/vboxsf/super.c                             |   1 +
 include/linux/fcntl.h                         |   6 +
 include/linux/fs/super_types.h                |   1 +
 include/linux/kernfs.h                        |   7 +-
 include/uapi/asm-generic/errno.h              |   2 +-
 kernel/cgroup/cgroup-internal.h               |   3 +-
 kernel/cgroup/cgroup.c                        |  16 +-
 security/apparmor/apparmorfs.c                |   1 +
 .../testing/selftests/filesystems/.gitignore  |   1 +
 tools/testing/selftests/filesystems/Makefile  |   2 +-
 .../filesystems/open_o_creat_o_dir.c          | 346 ++++++++++++++++++
 .../testing/selftests/filesystems/wrappers.h  |  11 +
 31 files changed, 691 insertions(+), 146 deletions(-)
 create mode 100644 tools/testing/selftests/filesystems/open_o_creat_o_dir.c


base-commit: 90201351a862182bdabfc1ad1c97b1e1b6ed5931
-- 
2.56.0

