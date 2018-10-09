From: Aleksa Sarai <cyphar@cyphar.com>
Subject: [PATCH v2 0/3] namei: implement various lookup restriction AT_* flags
Date: Tue,  9 Oct 2018 17:52:56 +1100
Message-ID: <20181009065300.11053-1-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Eric Biederman <ebiederm@xmission.com>
Cc: Aleksa Sarai <cyphar@cyphar.com>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, Jann Horn <jannh@google.com>, Christian Brauner <christian@brauner.io>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, dev@opencontainers.org, containers@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

The need for some sort of control over VFS's path resolution (to avoid
malicious paths resulting in inadvertent breakouts) has been a very
long-standing desire of many userspace applications. This patchset is a
revival of Al Viro's old AT_NO_JUMPS[1,2] patchset (which was a variant
of David Drysdale's O_BENEATH patchset[3] which was a spin-off of the
capsicum patchset[4]) with a few additions and changes made based on the
previous discussion within [5] as well as others I felt were useful.

As per the discussion in the AT_NO_JUMPS thread, AT_NO_JUMPS has been
split into separate flags.

  * AT_XDEV blocks mountpoint crossings (both upwards and downwards).
      openat("/", "tmp", AT_XDEV); // blocked
      openat("/tmp", "..", AT_XDEV); // blocked
      openat("/tmp", "/", AT_XDEV); // blocked

  * AT_NO_PROCLINKS blocks all resolution through /proc/$pid/fd/$fd
	"symlinks". Specifically, this blocks all jumps caused by a
	filesystem using nd_jump_link() to shove you around in the
	filesystem tree (these are referred to as "proclinks" in lieu of a
	better name).

  * AT_BENEATH disallows escapes from the starting dirfd using ".." or
	absolute paths (either in the path or during symlink resolution).
	Conceptually this flag ensures that you "stay below" the starting
	point in the filesystem tree. ".." resolution is allowed if it
	doesn't land you outside of the starting point (this is made safe
	against races by patch 3 in this series).

	AT_BENEATH also currently disallows all "proclink" resolution
	because they can trivially throw you outside of the starting point.
	In a future patch we might allow such resolution (as long as it
	stays within the root).

In addition, two more flags have been added to the series:

  * AT_NO_SYMLINKS disallows *all* symlink resolution, and thus implies
	AT_NO_PROCLINKS. Linus mentioned this is something that git would
	like to have in the original discussion[5].

  * AT_THIS_ROOT is a very similar idea to AT_BENEATH, but it serves a
    very different purpose. Rather than blocking resolutions if they
	would go outside of the starting point, it treats the starting point
	as a form of chroot(2). Container runtimes are one of the primary
	justifications for this flag, as they currently have to implement
	this sort of path handling racily in userspace[6].

	The restrictions on "proclink" resolution are the same as with
	AT_BENEATH (though in AT_THIS_ROOT's case it's not really clear how
	"proclink" jumps outside of the root should be handled), and patch 3
	in this series was also required to make ".." resolution safe.

Patch changelog:
  v2:
    * Made ".." resolution with AT_THIS_ROOT and AT_BENEATH safe by
	  through __d_path checking (see patch 3).
    * Disallowed "proclinks" with AT_THIS_ROOT and AT_BENEATH, in the
	  hopes they can be re-enabled once safe.
    * Removed the selftests as they will be reimplemented as xfstests.

[1]: https://lwn.net/Articles/721443/
[2]: https://lore.kernel.org/patchwork/patch/784221/
[3]: https://lwn.net/Articles/619151/
[4]: https://lwn.net/Articles/603929/
[5]: https://lwn.net/Articles/723057/
[6]: https://github.com/cyphar/filepath-securejoin

Aleksa Sarai (3):
  namei: implement O_BENEATH-style AT_* flags
  namei: implement AT_THIS_ROOT chroot-like path resolution
  namei: aggressively check nd->root on ".." resolution

 fs/fcntl.c                       |   2 +-
 fs/namei.c                       | 192 ++++++++++++++++++++++---------
 fs/open.c                        |  10 ++
 fs/stat.c                        |   4 +-
 include/linux/fcntl.h            |   3 +-
 include/linux/namei.h            |   8 ++
 include/uapi/asm-generic/fcntl.h |  20 ++++
 include/uapi/linux/fcntl.h       |  10 ++
 8 files changed, 193 insertions(+), 56 deletions(-)

-- 
2.19.0
