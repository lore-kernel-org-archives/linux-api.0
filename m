From: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 04/14] reset: Add reset_controller_of_init() function
Date: Thu, 12 Feb 2015 18:45:54 +0100
Message-ID: <1423763164-5606-5-git-send-email-mcoquelin.stm32__16080.5228086703$1423763330$gmane$org@gmail.com>
References: <1423763164-5606-1-git-send-email-mcoquelin.stm32@gmail.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1423763164-5606-1-git-send-email-mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Philipp Zabel <p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Antti Palosaari <crope-X3B1VOXEql0@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Nikolay Borisov <Nikolay.Borisov-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Some platforms need to initialize the reset controller before the timers.

This patch introduces a reset_controller_of_init() function that can be
called before the timers intialization.

Signed-off-by: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/reset/core.c              | 20 ++++++++++++++++++++
 include/asm-generic/vmlinux.lds.h |  4 +++-
 include/linux/reset-controller.h  |  6 ++++++
 3 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/reset/core.c b/drivers/reset/core.c
index 7955e00..18ee579 100644
--- a/drivers/reset/core.c
+++ b/drivers/reset/core.c
@@ -86,6 +86,26 @@ void reset_controller_unregister(struct reset_controller_dev *rcdev)
 }
 EXPORT_SYMBOL_GPL(reset_controller_unregister);
 
+extern struct of_device_id __reset_ctrl_of_table[];
+
+static const struct of_device_id __reset_ctrl_of_table_sentinel
+	__used __section(__reset_ctrl_of_table_end);
+
+void __init reset_controller_of_init(void)
+{
+	struct device_node *np;
+	const struct of_device_id *match;
+	of_init_fn_1 init_func;
+
+	for_each_matching_node_and_match(np, __reset_ctrl_of_table, &match) {
+		if (!of_device_is_available(np))
+			continue;
+
+		init_func = match->data;
+		init_func(np);
+	}
+}
+
 /**
  * reset_control_reset - reset the controlled device
  * @rstc: reset controller
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index bee5d68..1f96365 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -168,6 +168,7 @@
 #define RESERVEDMEM_OF_TABLES()	OF_TABLE(CONFIG_OF_RESERVED_MEM, reservedmem)
 #define CPU_METHOD_OF_TABLES()	OF_TABLE(CONFIG_SMP, cpu_method)
 #define EARLYCON_OF_TABLES()	OF_TABLE(CONFIG_SERIAL_EARLYCON, earlycon)
+#define RESET_CTRL_OF_TABLES()	OF_TABLE(CONFIG_RESET_CONTROLLER, reset_ctrl)
 
 #define KERNEL_DTB()							\
 	STRUCT_ALIGN();							\
@@ -502,7 +503,8 @@
 	CPU_METHOD_OF_TABLES()						\
 	KERNEL_DTB()							\
 	IRQCHIP_OF_MATCH_TABLE()					\
-	EARLYCON_OF_TABLES()
+	EARLYCON_OF_TABLES()						\
+	RESET_CTRL_OF_TABLES()
 
 #define INIT_TEXT							\
 	*(.init.text)							\
diff --git a/include/linux/reset-controller.h b/include/linux/reset-controller.h
index ce6b962..f8a030a 100644
--- a/include/linux/reset-controller.h
+++ b/include/linux/reset-controller.h
@@ -51,4 +51,10 @@ struct reset_controller_dev {
 int reset_controller_register(struct reset_controller_dev *rcdev);
 void reset_controller_unregister(struct reset_controller_dev *rcdev);
 
+
+#define RESET_CONTROLLER_OF_DECLARE(name, compat, fn) \
+	OF_DECLARE_1(reset_ctrl, name, compat, fn)
+
+void reset_controller_of_init(void);
+
 #endif
-- 
1.9.1
