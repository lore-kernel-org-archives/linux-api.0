From: Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 3.16 081/134] fanotify: don't expose EOPENSTALE to userspace
Date: Fri, 18 Aug 2017 14:13:20 +0100
Message-ID: <lsq.1503062000.466803849@decadent.org.uk>
References: <lsq.1503061998.818387115@decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <lsq.1503061998.818387115@decadent.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Amir Goldstein <amir73il@gmail.com>, linux-api@vger.kernel.org, Jan Kara <jack@suse.cz>, Marko Rauhamaa <marko.rauhamaa@f-secure.com>
List-Id: linux-api@vger.kernel.org

3.16.47-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

commit 4ff33aafd32e084f5ee7faa54ba06e95f8b1b8af upstream.

When delivering an event to userspace for a file on an NFS share,
if the file is deleted on server side before user reads the event,
user will not get the event.

If the event queue contained several events, the stale event is
quietly dropped and read() returns to user with events read so far
in the buffer.

If the event queue contains a single stale event or if the stale
event is a permission event, read() returns to user with the kernel
internal error code 518 (EOPENSTALE), which is not a POSIX error code.

Check the internal return value -EOPENSTALE in fanotify_read(), just
the same as it is checked in path_openat() and drop the event in the
cases that it is not already dropped.

This is a reproducer from Marko Rauhamaa:

Just take the example program listed under "man fanotify" ("fantest")
and follow these steps:

    ==============================================================
    NFS Server    NFS Client(1)     NFS Client(2)
    ==============================================================
    # echo foo >/nfsshare/bar.txt
                  # cat /nfsshare/bar.txt
                  foo
                                    # ./fantest /nfsshare
                                    Press enter key to terminate.
                                    Listening for events.
    # rm -f /nfsshare/bar.txt
                  # cat /nfsshare/bar.txt
                                    read: Unknown error 518
                  cat: /nfsshare/bar.txt: Operation not permitted
    ==============================================================

where NFS Client (1) and (2) are two terminal sessions on a single NFS
Client machine.

Reported-by: Marko Rauhamaa <marko.rauhamaa@f-secure.com>
Tested-by: Marko Rauhamaa <marko.rauhamaa@f-secure.com>
Cc: <linux-api@vger.kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/notify/fanotify/fanotify_user.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -294,27 +294,37 @@ static ssize_t fanotify_read(struct file
 		}
 
 		ret = copy_event_to_user(group, kevent, buf);
+		if (unlikely(ret == -EOPENSTALE)) {
+			/*
+			 * We cannot report events with stale fd so drop it.
+			 * Setting ret to 0 will continue the event loop and
+			 * do the right thing if there are no more events to
+			 * read (i.e. return bytes read, -EAGAIN or wait).
+			 */
+			ret = 0;
+		}
+
 		/*
 		 * Permission events get queued to wait for response.  Other
 		 * events can be destroyed now.
 		 */
 		if (!(kevent->mask & FAN_ALL_PERM_EVENTS)) {
 			fsnotify_destroy_event(group, kevent);
-			if (ret < 0)
-				break;
 		} else {
 #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
-			if (ret < 0) {
+			if (ret <= 0) {
 				FANOTIFY_PE(kevent)->response = FAN_DENY;
 				wake_up(&group->fanotify_data.access_waitq);
-				break;
+			} else {
+				spin_lock(&group->fanotify_data.access_lock);
+				list_add_tail(&kevent->list,
+					&group->fanotify_data.access_list);
+				spin_unlock(&group->fanotify_data.access_lock);
 			}
-			spin_lock(&group->fanotify_data.access_lock);
-			list_add_tail(&kevent->list,
-				      &group->fanotify_data.access_list);
-			spin_unlock(&group->fanotify_data.access_lock);
 #endif
 		}
+		if (ret < 0)
+			break;
 		buf += ret;
 		count -= ret;
 	}
