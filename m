From: David Howells <dhowells@redhat.com>
Subject: [RFC PATCH 08/21] pipe: Check for ring full inside of the spinlock
 in pipe_write()
Date: Tue, 15 Oct 2019 22:49:01 +0100
Message-ID: <157117614109.15019.15677943675625422728.stgit@warthog.procyon.org.uk>
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

Make pipe_write() check to see if the ring has become full between it
taking the pipe mutex, checking the ring status and then taking the
spinlock.

This can happen if a notification is written into the pipe as that happens
without the pipe mutex.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/pipe.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/pipe.c b/fs/pipe.c
index 289a887f6b5b..0255a5ca5097 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -462,6 +462,11 @@ pipe_write(struct kiocb *iocb, struct iov_iter *from)
 			spin_lock_irq(&pipe->wait.lock);
 
 			head = pipe->head;
+			if (head - pipe->tail == buffers) {
+				spin_unlock_irq(&pipe->wait.lock);
+				continue;
+			}
+
 			pipe_commit_write(pipe, head + 1);
 
 			/* Always wake up, even if the copy fails. Otherwise
