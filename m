From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [RFC PATCH v1 5/5] doc: Add documentation for Yama's open_mayexec_enforce
Date: Wed, 12 Dec 2018 09:17:12 +0100
Message-ID: <20181212081712.32347-6-mic@digikod.net>
References: <20181212081712.32347-1-mic@digikod.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <kernel-hardening-return-14684-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20181212081712.32347-1-mic@digikod.net>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>, Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Matthew Garrett <mjg59@google.com>, Michael Kerrisk <mtk.manpages@gmail.com>, =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mickael.salaun@ssi.gouv.fr>, Mimi Zohar <zohar@linux.ibm.com>, =?UTF-8?q?Philippe=20Tr=C3=A9buchet?= <philippe.trebuchet@ssi.gouv.fr>, Shuah Khan <shuah@kernel.org>, Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, Vincent Strubel <vincent.strubel@ssi.gouv.fr>, Yves-Alexis Perez <yves-alexis.perez@ssi.gouv.fr>, kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Signed-off-by: Mickaël Salaün <mic@digikod.net>
Reviewed-by: Philippe Trébuchet <philippe.trebuchet@ssi.gouv.fr>
Reviewed-by: Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mickaël Salaün <mickael.salaun@ssi.gouv.fr>
---
 Documentation/admin-guide/LSM/Yama.rst | 41 ++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/Documentation/admin-guide/LSM/Yama.rst b/Documentation/admin-guide/LSM/Yama.rst
index d0a060de3973..a72c86a24b35 100644
--- a/Documentation/admin-guide/LSM/Yama.rst
+++ b/Documentation/admin-guide/LSM/Yama.rst
@@ -72,3 +72,44 @@ The sysctl settings (writable only with ``CAP_SYS_PTRACE``) are:
     ``PTRACE_TRACEME``. Once set, this sysctl value cannot be changed.
 
 The original children-only logic was based on the restrictions in grsecurity.
+
+open_mayexec_enforce
+====================
+
+The ``O_MAYEXEC`` flag can be passed to :manpage:`open(2)` to only open files
+(or directories) that are executable.  If the file is not identified as
+executable, then the syscall returns -EACCES.  This may allow a script
+interpreter to check executable permission before reading commands from a file.
+One interesting use case is to enforce a "write xor execute" policy through
+interpreters.
+
+Thanks to this flag, Yama enables to enforce the ``noexec`` mount option (i.e.
+the underlying mount point of the file is mounted with MNT_NOEXEC or its
+underlying superblock is SB_I_NOEXEC) not only on ELF binaries but also on
+scripts.  This may be possible thanks to script interpreters using the
+``O_MAYEXEC`` flag.  The executable permission is then checked before reading
+commands from a file, and thus can enforce the ``noexec`` at the interpreter
+level by propagating this security policy to the scripts.  To be fully
+effective, these interpreters also need to handle the other ways to execute
+code (for which the kernel can't help): command line parameters (e.g., option
+``-e`` for Perl), module loading (e.g., option ``-m`` for Python), stdin, file
+sourcing, environment variables, configuration files...  According to the
+threat model, it may be acceptable to allow some script interpreters (e.g.
+Bash) to interpret commands from stdin, may it be a TTY or a pipe, because it
+may not be enough to (directly) perform syscalls.
+
+Yama implements two complementary security policies to propagate the ``noexec``
+mount option or the executable file permission.  These policies are handled by
+the ``kernel.yama.open_mayexec_enforce`` sysctl (writable only with
+``CAP_MAC_ADMIN``) as a bitmask:
+
+1 - mount restriction:
+    check that the mount options for the underlying VFS mount do not prevent
+    execution.
+
+2 - file permission restriction:
+    check that the to-be-opened file is marked as executable for the current
+    process (e.g., POSIX permissions).
+
+Code samples can be found in tools/testing/selftests/yama/test_omayexec.c and
+https://github.com/clipos-archive/clipos4_portage-overlay/search?q=O_MAYEXEC .
-- 
2.20.0.rc2
