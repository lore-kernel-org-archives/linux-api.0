From: David Howells <dhowells@redhat.com>
Subject: [RFC PATCH 04/21] pipe: Advance tail pointer inside of wait
 spinlock in pipe_read()
Date: Tue, 15 Oct 2019 22:48:26 +0100
Message-ID: <157117610623.15019.10121494102947608380.stgit@warthog.procyon.org.uk>
References: <157117606853.15019.15459271147790470307.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <157117606853.15019.15459271147790470307.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: dhowells@redhat.com, Casey Schaufler <casey@schaufler-ca.com>, Stephen Smalley <sds@tycho.nsa.gov>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>dhowells@redhat.com, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.orglinux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Advance the pipe ring tail pointer inside of wait spinlock in pipe_read()
so that the pipe can be written into with kernel notifications from
contexts where pipe->mutex cannot be taken.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/pipe.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index 0574277bad18..08af7e7bbea2 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -324,9 +324,14 @@ pipe_read(struct kiocb *iocb, struct iov_iter *to)
 
 			if (!buf->len) {
 				pipe_buf_release(pipe, buf);
+				spin_lock_irq(&pipe->wait.lock);
 				tail++;
 				pipe_commit_read(pipe, tail);
-				do_wakeup = 1;
+				do_wakeup = 0;
+				prelocked_wake_up_interruptible_sync_poll(
+					&pipe->wait, EPOLLOUT | EPOLLWRNORM);
+				spin_unlock_irq(&pipe->wait.lock);
+				kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
 			}
 			total_len -= chars;
 			if (!total_len)
@@ -358,6 +363,7 @@ pipe_read(struct kiocb *iocb, struct iov_iter *to)
 		if (do_wakeup) {
 			wake_up_interruptible_sync_poll(&pipe->wait, EPOLLOUT | EPOLLWRNORM);
  			kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
+			do_wakeup = 0;
 		}
 		pipe_wait(pipe);
 	}
