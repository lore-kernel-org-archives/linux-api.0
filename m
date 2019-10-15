From: David Howells <dhowells@redhat.com>
Subject: [RFC PATCH 07/21] pipe: Remove redundant wakeup from pipe_write()
Date: Tue, 15 Oct 2019 22:48:52 +0100
Message-ID: <157117613252.15019.4979488404301515759.stgit@warthog.procyon.org.uk>
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

Remove a redundant wakeup from pipe_write().

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/pipe.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index 5a199b249191..289a887f6b5b 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -516,11 +516,6 @@ pipe_write(struct kiocb *iocb, struct iov_iter *from)
 				ret = -ERESTARTSYS;
 			break;
 		}
-		if (do_wakeup) {
-			wake_up_interruptible_sync_poll(&pipe->wait, EPOLLIN | EPOLLRDNORM);
-			kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
-			do_wakeup = 0;
-		}
 		pipe->waiting_writers++;
 		pipe_wait(pipe);
 		pipe->waiting_writers--;
