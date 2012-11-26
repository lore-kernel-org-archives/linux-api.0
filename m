From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: [PATCH 0/4] namespace man page updates for 3.8
Date: Mon, 26 Nov 2012 16:57:55 -0600
Message-ID: <87a9u4rmz0.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org


The following patches document the namespace user namespace, the pid
namespace, the mount namespace changes that are currently sitting in my
for next-next branch of:
git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git

Except for uid_map and gid_map which should have been documented with
for Linux 3.6 I am a bit early for these changes to be merged, but it
seems a good idea to get the patches out there so things will be
documented and reviewed and thought about in a timely manner.

Eric


 man2/clone.2 |   39 ++++++++++++++++++++++
 man2/setns.2 |   41 +++++++++++++++++++----
 man5/proc.5  |  102 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 174 insertions(+), 8 deletions(-)

Eric W. Biederman (4):
      proc.5: Document /proc/[pid]/uid_map and /proc/[pid]/gid_map
      clone.2:  Describe the user namespace
      proc.5:  Document the proc files for the user, mount, and pid namespaces.
      setns.2: Document the pid, user, and mount namespace support.
