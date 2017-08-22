From: nixiaoming <nixiaoming-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] virt/lib avoids oops by adding parameter checking
Date: Tue, 22 Aug 2017 09:07:53 +0800
Message-ID: <20170822010753.102857-1-nixiaoming@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

The error parameter passed through the external interface
causes the system oops. So it is necessary to increase the
parameter check for all EXPORT_SYMBOL_GPL

example:
 int irq_bypass_register_producer(struct irq_bypass_producer *producer)
 {
 	if (!producer->token) /* oops if producer == null */
 		return -einval;
 }
 EXPORT_SYMBOL_GPL(irq_bypass_register_producer);

Signed-off-by: nixiaoming <nixiaoming-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 virt/lib/irqbypass.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/virt/lib/irqbypass.c b/virt/lib/irqbypass.c
index 6d2fcd6..2bb99e8 100644
--- a/virt/lib/irqbypass.c
+++ b/virt/lib/irqbypass.c
@@ -89,7 +89,7 @@ int irq_bypass_register_producer(struct irq_bypass_producer *producer)
 	struct irq_bypass_producer *tmp;
 	struct irq_bypass_consumer *consumer;
 
-	if (!producer->token)
+	if (!producer || !producer->token)
 		return -EINVAL;
 
 	might_sleep();
@@ -139,7 +139,7 @@ void irq_bypass_unregister_producer(struct irq_bypass_producer *producer)
 	struct irq_bypass_producer *tmp;
 	struct irq_bypass_consumer *consumer;
 
-	if (!producer->token)
+	if (!producer || !producer->token)
 		return;
 
 	might_sleep();
@@ -183,7 +183,7 @@ int irq_bypass_register_consumer(struct irq_bypass_consumer *consumer)
 	struct irq_bypass_consumer *tmp;
 	struct irq_bypass_producer *producer;
 
-	if (!consumer->token ||
+	if (!consumer || !consumer->token ||
 	    !consumer->add_producer || !consumer->del_producer)
 		return -EINVAL;
 
@@ -234,7 +234,7 @@ void irq_bypass_unregister_consumer(struct irq_bypass_consumer *consumer)
 	struct irq_bypass_consumer *tmp;
 	struct irq_bypass_producer *producer;
 
-	if (!consumer->token)
+	if (!consumer || !consumer->token)
 		return;
 
 	might_sleep();
-- 
2.11.0.1
