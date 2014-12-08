From: ebiederm@xmission.com (Eric W. Biederman)
Subject: [CFT][PATCH 1/7] userns: Document what the invariant required for safe unprivileged mappings.
Date: Mon, 08 Dec 2014 16:06:06 -0600
Message-ID: <87h9x5re41.fsf_-_@x220.int.ebiederm.org>
References: <52e0643bd47b1e5c65921d6e00aea1f724bb510a.1417281801.git.luto@amacapital.net>
	<87h9xez20g.fsf@x220.int.ebiederm.org>
	<CALCETrXOz4C7Tu8mggBtR=k47ZmkuAhinVUxWJSFyS1Ep0HvRw@mail.gmail.com>
	<87mw75ygwp.fsf@x220.int.ebiederm.org>
	<CALCETrVfO4sBdZcQiZXsofPZMj7pqKeVbX+4g3dAj6WjUca+1w@mail.gmail.com>
	<87fvcxyf28.fsf_-_@x220.int.ebiederm.org>
	<874mtdyexp.fsf_-_@x220.int.ebiederm.org>
	<CALCETrXyC7XPaqj6oe-TmyypOVc_CkZbF6UAAx8YfkyD=gEMOQ@mail.gmail.com>
	<87a935u3nj.fsf@x220.int.ebiederm.org>
	<CALCETrXkEOiyzpvqtXtk1f4sL+M1Q-Y6rV=K91ez3yv2nb4Y0Q@mail.gmail.com>
	<87388xodlj.fsf@x220.int.ebiederm.org>
	<CALCETrXWx2-ZejEHmOi7aSoF-qJMRGR5yseeMhuurZwJRrQbUg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <CALCETrXWx2-ZejEHmOi7aSoF-qJMRGR5yseeMhuurZwJRrQbUg@mail.gmail.com>
	(Andy Lutomirski's message of "Tue, 2 Dec 2014 15:17:32 -0800")
Sender: linux-security-module-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linux Containers <containers@lists.linux-foundation.org>, Josh Triplett <josh@joshtriplett.org>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Linux API <linux-api@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, LSM <linux-security-module@vger.kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, "Serge E. Hallyn" <serge@hallyn.com>, Richard Weinberger <richard@nod.at>, Kenton Varda <kenton@sandstorm.io>, stable <stable@vger.kernel.org>
List-Id: linux-api@vger.kernel.org


The rule is simple.  Don't allow anything that wouldn't be allowed
without unprivileged mappings.

It was previously overlooked that establishing gid mappings would
allow dropping groups and potentially gaining permission to files and
directories that had lesser permissions for a specific group than for
all other users.

This is the rule needed to fix CVE-2014-8989 and prevent any other
security issues with new_idmap_permitted.

The reason for this rule is that the unix permission model is old and
there are programs out there somewhere that take advantage of every
little corner of it.  So allowing a uid or gid mapping to be
established without privielge that would allow anything that would not
be allowed without that mapping will result in expectations from some
code somewhere being violated.  Violated expectations about the
behavior of the OS is a long way to say a security issue.

Cc: stable@vger.kernel.org
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/user_namespace.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index aa312b0dc3ec..b99c862a2e3f 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -812,7 +812,9 @@ static bool new_idmap_permitted(const struct file *file,
 				struct user_namespace *ns, int cap_setid,
 				struct uid_gid_map *new_map)
 {
-	/* Allow mapping to your own filesystem ids */
+	/* Don't allow mappings that would allow anything that wouldn't
+	 * be allowed without the establishment of unprivileged mappings.
+	 */
 	if ((new_map->nr_extents == 1) && (new_map->extent[0].count == 1)) {
 		u32 id = new_map->extent[0].lower_first;
 		if (cap_setid == CAP_SETUID) {
-- 
1.9.1

