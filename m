From: serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org
Subject: namespaced file capabilities
Date: Fri, 22 Apr 2016 12:26:32 -0500
Message-ID: <1461345993-17526-1-git-send-email-serge.hallyn@ubuntu.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi,

I've sent a few patches and emails over the past months about supporting
file capabilities in user namespace confined containers.  A few of the
requirements as I see them are:

1. Root in a user namespace should be able to set file capabilities on a binary
for use by any user mapped into his namespace.

2. Any uid not mapped into the user namespace whose root user set file
capabilities should not gain privileges when running an executable which only
has file capabilities set by this root user.

3. Existing calls to cap_set_file(3) and cap_get_file(3) as well as
setcap(8) and getcap(8) should transparently work.  This would allow
package managers to simply set file capabilities in postinst.

Below is a kernel patch which implements a new security.nscapability
extended attribute.  Setting this xattr on a file requires cap_setfcap
against the current user namespace, and for the file to be owned by
a uid and gid mapped into that namespace.  When found on a file,
the capabilities will take effect only if the file is owned by the
root uid in the caller's namespace, or the root uid in any ancestor
namespace.

While this design supports nested namespaces, it does not support
use of file capabilities by users in unrelated namespaces.  So if
the same file is linked into two namespaces N1 and N2 which do not
share the same root kuid, then the only way for N1 and N2 to both
execute the file while respecting security.nscapability is to have
a common ancestor namespace write the capability.  The only reasonable
way we could handle this case would be to use a securityfs interface
to set file capabilities.  The capability.ko module could then
do the work of keeping a list of uid ranges for which file capabilities
should be honored.  I don't think that flexibility is really called
for.
 
The kernel patch follows, and can be found at
https://git.kernel.org/cgit/linux/kernel/git/sergeh/linux-security.git/log/?h=2016-04-22/nsfscaps

The libcap patch can be found at
https://git.kernel.org/cgit/linux/kernel/git/sergeh/libcap.git/log/?h=2016-04-22/nscaps

Comments/conversation/suggestions greatly appreciated.

thanks,
-serge
