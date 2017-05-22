From: <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Patch "fanotify: don't expose EOPENSTALE to userspace" has been added to the 4.9-stable tree
Date: Mon, 22 May 2017 18:08:38 +0200
Message-ID: <14954693181565@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, marko.rauhamaa-xdZvthzU1HpWk0Htik3J/w@public.gmane.org
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-commits-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    fanotify: don't expose EOPENSTALE to userspace

to the 4.9-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     fanotify-don-t-expose-eopenstale-to-userspace.patch
and it can be found in the queue-4.9 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> know about it.


>From 4ff33aafd32e084f5ee7faa54ba06e95f8b1b8af Mon Sep 17 00:00:00 2001
From: Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Tue, 25 Apr 2017 14:29:35 +0300
Subject: fanotify: don't expose EOPENSTALE to userspace

From: Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

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

Reported-by: Marko Rauhamaa <marko.rauhamaa-xdZvthzU1HpWk0Htik3J/w@public.gmane.org>
Tested-by: Marko Rauhamaa <marko.rauhamaa-xdZvthzU1HpWk0Htik3J/w@public.gmane.org>
Cc: <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Signed-off-by: Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Signed-off-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>

---
 fs/notify/fanotify/fanotify_user.c |   26 ++++++++++++++++++--------
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
+				spin_lock(&group->notification_lock);
+				list_add_tail(&kevent->list,
+					&group->fanotify_data.access_list);
+				spin_unlock(&group->notification_lock);
 			}
-			spin_lock(&group->notification_lock);
-			list_add_tail(&kevent->list,
-				      &group->fanotify_data.access_list);
-			spin_unlock(&group->notification_lock);
 #endif
 		}
+		if (ret < 0)
+			break;
 		buf += ret;
 		count -= ret;
 	}


Patches currently in stable-queue which might be from amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org are

queue-4.9/fanotify-don-t-expose-eopenstale-to-userspace.patch
