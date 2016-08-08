From: Dave Hansen <dave@sr71.net>
Subject: [PATCH 09/10] x86, pkeys: allow configuration of init_pkru
Date: Mon, 08 Aug 2016 16:18:33 -0700
Message-ID: <20160808231833.413F267D@viggo.jf.intel.com>
References: <20160808231820.F7A9C4D8@viggo.jf.intel.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20160808231820.F7A9C4D8@viggo.jf.intel.com>
Sender: owner-linux-mm@kvack.org
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-mm@kvack.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, luto@kernel.org, mgorman@techsingularity.net, Dave Hansen <dave@sr71.net>, dave.hansen@linux.intel.com, arnd@arndb.de
List-Id: linux-api@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

As discussed in the previous patch, there is a reliability
benefit to allowing an init value for the Protection Keys Rights
User register (PKRU) which differs from what the XSAVE hardware
provides.

But, having PKRU be 0 (its init value) provides some nonzero
amount of optimization potential to the hardware.  It can, for
instance, skip writes to the XSAVE buffer when it knows that PKRU
is in its init state.

The cost of losing this optimization is approximately 100 cycles
per context switch for a workload which lightly using XSAVE
state (something not using AVX much).  The overhead comes from a
combinaation of actually manipulating PKRU and the overhead of
pullin in an extra cacheline.

This overhead is not huge, but it's also not something that I
think we should unconditionally inflict on everyone.  So, make it
configurable both at boot-time and from debugfs.

Changes to the debugfs value affect all processes created after
the write to debugfs.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-api@vger.kernel.org
Cc: linux-arch@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: x86@kernel.org
Cc: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: mgorman@techsingularity.net
---

 b/arch/x86/mm/pkeys.c |   67 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff -puN arch/x86/mm/pkeys.c~pkeys-141-restrictive-init-pkru-debugfs arch/x86/mm/pkeys.c
--- a/arch/x86/mm/pkeys.c~pkeys-141-restrictive-init-pkru-debugfs	2016-08-08 16:15:13.409160007 -0700
+++ b/arch/x86/mm/pkeys.c	2016-08-08 16:15:13.411160098 -0700
@@ -11,6 +11,7 @@
  * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
  * more details.
  */
+#include <linux/debugfs.h>		/* debugfs_create_u32()		*/
 #include <linux/mm_types.h>             /* mm_struct, vma, etc...       */
 #include <linux/pkeys.h>                /* PKEY_*                       */
 #include <uapi/asm-generic/mman-common.h>
@@ -159,3 +160,69 @@ void copy_init_pkru_to_fpregs(void)
 	 */
 	write_pkru(init_pkru_value_snapshot);
 }
+
+static ssize_t init_pkru_read_file(struct file *file, char __user *user_buf,
+			     size_t count, loff_t *ppos)
+{
+	char buf[32];
+	unsigned int len;
+
+	len = sprintf(buf, "0x%x\n", init_pkru_value);
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t init_pkru_write_file(struct file *file,
+		 const char __user *user_buf, size_t count, loff_t *ppos)
+{
+	char buf[32];
+	ssize_t len;
+	u32 new_init_pkru;
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EFAULT;
+
+	/* Make the buffer a valid string that we can not overrun */
+	buf[len] = '\0';
+	if (kstrtouint(buf, 0, &new_init_pkru))
+		return -EINVAL;
+
+	/*
+	 * Don't allow insane settings that will blow the system
+	 * up immediately if someone attempts to disable access
+	 * or writes to pkey 0.
+	 */
+	if (new_init_pkru & (PKRU_AD_BIT|PKRU_WD_BIT))
+		return -EINVAL;
+
+	WRITE_ONCE(init_pkru_value, new_init_pkru);
+	return count;
+}
+
+static const struct file_operations fops_init_pkru = {
+	.read = init_pkru_read_file,
+	.write = init_pkru_write_file,
+	.llseek = default_llseek,
+};
+
+static int __init create_init_pkru_value(void)
+{
+	debugfs_create_file("init_pkru", S_IRUSR | S_IWUSR,
+			arch_debugfs_dir, NULL, &fops_init_pkru);
+	return 0;
+}
+late_initcall(create_init_pkru_value);
+
+static __init int setup_init_pkru(char *opt)
+{
+	u32 new_init_pkru;
+
+	if (kstrtouint(opt, 0, &new_init_pkru))
+		return 1;
+
+	WRITE_ONCE(init_pkru_value, new_init_pkru);
+
+	return 1;
+}
+__setup("init_pkru=", setup_init_pkru);
+
_

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
