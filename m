From: Aleksa Sarai <cyphar@cyphar.com>
Subject: [PATCH v13 9/9] Documentation: update path-lookup to mention trailing
 magic-links
Date: Tue,  1 Oct 2019 04:33:16 +1000
Message-ID: <20190930183316.10190-10-cyphar@cyphar.com>
References: <20190930183316.10190-1-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20190930183316.10190-1-cyphar@cyphar.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-ia64@vger.kernel.org, linux-sh@vger.kernel.org, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Alexei Starovoitov <ast@kernel.org>, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, sparclinux@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>, linux-arch@vger.kernel.org, linux-s390@vger.kernel.org, Tycho Andersen <tycho@tycho.ws>, Aleksa Sarai <asarai@suse.de>, linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, linux-xtensa@linux-xtensa.org, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, linuxppc-dev@lists.ozlabs.org, Aleksa Sarai <cyphar@cyphar.com>, Andy Lutomirski <luto@kernel.org>, Namhyung Kim <namhyung@kernel.org>, David Drysdale <drysdale@google.com>, Christian Brauner <christian@brauner.io>, libc-alpha@sourceware.org, linux-parisc@vger.kernel.org, linux-m68k@li
List-Id: linux-api@vger.kernel.org

We've introduced new (somewhat subtle) behaviour regarding trailing
magic-links, so it's best to make sure everyone can follow along with
the reasoning behind trailing_magiclink().

Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
---
 Documentation/filesystems/path-lookup.rst | 80 ++++++++++++++++++-----
 1 file changed, 63 insertions(+), 17 deletions(-)

diff --git a/Documentation/filesystems/path-lookup.rst b/Documentation/filesystems/path-lookup.rst
index 434a07b0002b..c30145b3d9ba 100644
--- a/Documentation/filesystems/path-lookup.rst
+++ b/Documentation/filesystems/path-lookup.rst
@@ -405,6 +405,10 @@ is requested.  Keeping a reference in the ``nameidata`` ensures that
 only one root is in effect for the entire path walk, even if it races
 with a ``chroot()`` system call.
 
+It should be noted that in the case of ``LOOKUP_IN_ROOT`` or
+``LOOKUP_BENEATH``, the effective root becomes the directory file descriptor
+passed to ``openat2()`` (which exposes these ``LOOKUP_`` flags).
+
 The root is needed when either of two conditions holds: (1) either the
 pathname or a symbolic link starts with a "'/'", or (2) a "``..``"
 component is being handled, since "``..``" from the root must always stay
@@ -1149,22 +1153,61 @@ so ``NULL`` is returned to indicate that the symlink can be released and
 the stack frame discarded.
 
 The other case involves things in ``/proc`` that look like symlinks but
-aren't really::
+aren't really (and are therefore commonly referred to as "magic-links")::
 
      $ ls -l /proc/self/fd/1
      lrwx------ 1 neilb neilb 64 Jun 13 10:19 /proc/self/fd/1 -> /dev/pts/4
 
 Every open file descriptor in any process is represented in ``/proc`` by
-something that looks like a symlink.  It is really a reference to the
-target file, not just the name of it.  When you ``readlink`` these
-objects you get a name that might refer to the same file - unless it
-has been unlinked or mounted over.  When ``walk_component()`` follows
-one of these, the ``->follow_link()`` method in "procfs" doesn't return
-a string name, but instead calls ``nd_jump_link()`` which updates the
-``nameidata`` in place to point to that target.  ``->follow_link()`` then
-returns ``NULL``.  Again there is no final component and ``get_link()``
-reports this by leaving the ``last_type`` field of ``nameidata`` as
-``LAST_BIND``.
+a magic-link.  It is really a reference to the target file, not just the
+name of it (hence making them "magical" compared to ordinary symlinks).
+When you ``readlink`` these objects you get a name that might refer to
+the same file - unless it has been unlinked or mounted over.  When
+``walk_component()`` follows one of these, the ``->follow_link()`` method
+in "procfs" doesn't return a string name, but instead calls
+``nd_jump_link()`` which updates the ``nameidata`` in place to point to
+that target.  ``->follow_link()`` then returns ``NULL``. Again there is
+no final component and ``get_link()`` reports this by leaving the
+``last_type`` field of ``nameidata`` as ``LAST_BIND``.
+
+In order to avoid potential re-opening attacks (especially in the context
+of containers), it is necessary to restrict the ability for a trailing
+magic-link to be opened. The restrictions are as follows (and are
+implemented in ``trailing_magiclink()``):
+
+* If the ``open()`` is an "ordinary open" (without ``O_PATH``), the
+  access-mode of the ``open()`` call must be permitted by one of the
+  octets in the magic-link's file mode (elsewhere in Linux, ordinary
+  symlinks have a file mode of ``0777`` but this doesn't apply to
+  magic-links). Each "ordinary" file in ``/proc/self/fd/$n`` has the user
+  octet of its file mode set to correspond to the access-mode it was
+  opened with.
+
+  This restriction means that you cannot re-open an ``O_RDONLY`` file
+  descriptor through ``/proc/self/fd/$n`` with ``O_RDWR``.
+
+With a "half-open" (with ``O_PATH``), there is no ``-EACCES``-enforced
+restrictions on ``open()``, but there are rules about the mode shown in
+``/proc/self/fd/$n``:
+
+* If the target of the ``open()`` is not a magic-link, then the group
+  octet of the file mode is set to permit all access modes.
+
+* Otherwise, the mode of the new ``O_PATH`` descriptor is set to
+  effectively the same mode as the magic-link (though the permissions are
+  set in the group octet of the mode). This means that an ``O_PATH`` of a
+  magic-link gives you no more re-open permissions than the magic-link
+  itself.
+
+With these ``O_PATH`` restrictions, it is still possible to re-open an
+``O_PATH`` file descriptor but you cannot use ``O_PATH`` to work around
+the above restrictions on "ordinary opens" of magic-links.
+
+In order to avoid certain race conditions (where a file descriptor
+associated with a magic-link is swapped, causing the ``link_inode`` of
+``nameidata`` to become stale during magic-link traversal),
+``nd_jump_link()`` stores the mode of the magic-link during traversal in
+``last_magiclink``.
 
 Following the symlink in the final component
 --------------------------------------------
@@ -1187,7 +1230,8 @@ handles the final component.  If the final component is a symlink
 that needs to be followed, then ``trailing_symlink()`` is called to set
 things up properly and the loop repeats, calling ``link_path_walk()``
 again.  This could loop as many as 40 times if the last component of
-each symlink is another symlink.
+each symlink is another symlink. ``trailing_magiclink()`` is then called to
+deal with permission checks relevant to ``/proc/$pid/fd``-style "symlinks".
 
 The various functions that examine the final component and possibly
 report that it is a symlink are ``lookup_last()``, ``mountpoint_last()``
@@ -1310,12 +1354,14 @@ longer needed.
 ``LOOKUP_JUMPED`` means that the current dentry was chosen not because
 it had the right name but for some other reason.  This happens when
 following "``..``", following a symlink to ``/``, crossing a mount point
-or accessing a "``/proc/$PID/fd/$FD``" symlink.  In this case the
-filesystem has not been asked to revalidate the name (with
-``d_revalidate()``).  In such cases the inode may still need to be
-revalidated, so ``d_op->d_weak_revalidate()`` is called if
+or accessing a "``/proc/$PID/fd/$FD``" symlink (also known as a "magic
+link"). In this case the filesystem has not been asked to revalidate the
+name (with ``d_revalidate()``).  In such cases the inode may still need
+to be revalidated, so ``d_op->d_weak_revalidate()`` is called if
 ``LOOKUP_JUMPED`` is set when the look completes - which may be at the
-final component or, when creating, unlinking, or renaming, at the penultimate component.
+final component or, when creating, unlinking, or renaming, at the
+penultimate component. ``LOOKUP_MAGICLINK_JUMPED`` is set alongside
+``LOOKUP_JUMPED`` if a magic-link was traversed.
 
 Final-component flags
 ~~~~~~~~~~~~~~~~~~~~~
-- 
2.23.0
