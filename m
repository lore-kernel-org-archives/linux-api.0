From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 2/9] x86: add sys_copy_file_range to syscall tables
Date: Sat, 19 Dec 2015 00:55:18 -0800
Message-ID: <20151219085518.12478.9668.stgit@birch.djwong.org>
References: <20151219085505.12478.71157.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <20151219085505.12478.71157.stgit@birch.djwong.org>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: Zach Brown <zab@redhat.com>, linux-api@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, Anna Schumaker <Anna.Schumaker@Netapp.com>
List-Id: linux-api@vger.kernel.org

Add sys_copy_file_range to the x86 syscall tables.

>From : Anna Schumaker <Anna.Schumaker@Netapp.com>
>From : Zach Brown <zab@redhat.com>

Signed-off-by: Zach Brown <zab@redhat.com>
[Anna Schumaker: Update syscall number in syscall_32.tbl]
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 arch/x86/entry/syscalls/syscall_32.tbl |    1 +
 arch/x86/entry/syscalls/syscall_64.tbl |    1 +
 2 files changed, 2 insertions(+)


diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index f17705e..cb713df 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -383,3 +383,4 @@
 374	i386	userfaultfd		sys_userfaultfd
 375	i386	membarrier		sys_membarrier
 376	i386	mlock2			sys_mlock2
+377	i386	copy_file_range		sys_copy_file_range
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index 314a90b..dc1040a 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -332,6 +332,7 @@
 323	common	userfaultfd		sys_userfaultfd
 324	common	membarrier		sys_membarrier
 325	common	mlock2			sys_mlock2
+326	common	copy_file_range		sys_copy_file_range
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
