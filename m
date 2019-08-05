From: Andy Lutomirski <luto@kernel.org>
Subject: [WIP 2/4] bpf: Don't require mknod() permission to pin an object
Date: Mon,  5 Aug 2019 14:29:03 -0700
Message-ID: <3bb110117c983f781f545e69ce35d4fcdd0c543b.1565040372.git.luto@kernel.org>
References: <cover.1565040372.git.luto@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <cover.1565040372.git.luto@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Song Liu <songliubraving@fb.com>, Kees Cook <keescook@chromium.org>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Alexei Starovoitov <ast@kernel.org>, Kernel Team <Kernel-team@fb.com>, Lorenz Bauer <lmb@cloudflare.com>, Jann Horn <jannh@google.com>, Greg KH <gregkh@linuxfoundation.org>, Linux API <linux-api@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>
List-Id: linux-api@vger.kernel.org

security_path_mknod() seems excessive for pinning an object --
pinning an object is effectively just creating a file.  It's also
redundant, as vfs_mkobj() calls security_inode_create() by itself.

This isn't strictly required -- mknod(path, S_IFREG, unused) works
to create regular files, but bpf is currently the only user in the
kernel outside of mknod() itself that uses it to create regular
(i.e. S_IFREG) files.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 kernel/bpf/inode.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
index cb07736b33ae..14304609003a 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -394,10 +394,6 @@ static int bpf_obj_do_pin(const struct filename *pathname, void *raw,
 
 	mode = S_IFREG | ((S_IRUSR | S_IWUSR) & ~current_umask());
 
-	ret = security_path_mknod(&path, dentry, mode, 0);
-	if (ret)
-		goto out;
-
 	dir = d_inode(path.dentry);
 	if (dir->i_op != &bpf_dir_iops) {
 		ret = -EPERM;
-- 
2.21.0
