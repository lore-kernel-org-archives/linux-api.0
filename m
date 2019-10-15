From: David Howells <dhowells@redhat.com>
Subject: [RFC PATCH 05/21] pipe: Conditionalise wakeup in pipe_read()
Date: Tue, 15 Oct 2019 22:48:34 +0100
Message-ID: <157117611484.15019.2438330064445318267.stgit@warthog.procyon.org.uk>
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

Only do a wakeup in pipe_read() if we made space in a completely full
buffer.  The producer shouldn't be waiting on pipe->wait otherwise.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/pipe.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index 08af7e7bbea2..0d25cb090a03 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -327,11 +327,13 @@ pipe_read(struct kiocb *iocb, struct iov_iter *to)
 				spin_lock_irq(&pipe->wait.lock);
 				tail++;
 				pipe_commit_read(pipe, tail);
-				do_wakeup = 0;
-				prelocked_wake_up_interruptible_sync_poll(
-					&pipe->wait, EPOLLOUT | EPOLLWRNORM);
+				do_wakeup = 1;
+				if (head - (tail - 1) == pipe->max_usage)
+					prelocked_wake_up_interruptible_sync_poll(
+						&pipe->wait, EPOLLOUT | EPOLLWRNORM);
 				spin_unlock_irq(&pipe->wait.lock);
-				kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
+				if (head - (tail - 1) == pipe->max_usage)
+					kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
 			}
 			total_len -= chars;
 			if (!total_len)
@@ -360,11 +362,6 @@ pipe_read(struct kiocb *iocb, struct iov_iter *to)
 				ret = -ERESTARTSYS;
 			break;
 		}
-		if (do_wakeup) {
-			wake_up_interruptible_sync_poll(&pipe->wait, EPOLLOUT | EPOLLWRNORM);
- 			kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
-			do_wakeup = 0;
-		}
 		pipe_wait(pipe);
 	}
 	__pipe_unlock(pipe);
