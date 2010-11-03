From: Mike Waychison <mikew@google.com>
Subject: [PATCH v1 12/12] netoops: Allow the driver to be built as a module
Date: Tue, 02 Nov 2010 18:30:37 -0700
Message-ID: <20101103013036.4641.84407.stgit@crlf.mtv.corp.google.com>
References: <20101103012917.4641.57113.stgit@crlf.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101103012917.4641.57113.stgit@crlf.mtv.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: simon.kagstrom@netinsight.net, davem@davemloft.net
Cc: adurbin@google.com, akpm@linux-foundation.org, chavey@google.com, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Now that the netoops driver is completely decoupled from the rest of the
kernel, it can be compiled as a module.

Signed-off-by: Mike Waychison <mikew@google.com>
---
 drivers/net/Kconfig   |    2 +-
 drivers/net/netoops.c |    2 ++
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 4dc53d4..c50411b 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -3321,7 +3321,7 @@ config NETCONSOLE_DYNAMIC
 	  See <file:Documentation/networking/netconsole.txt> for details.
 
 config NETOOPS
-	bool "Network oops support"
+	tristate "Network oops support"
 	depends on PROC_FS
 	help
 	  This option enables the ability to have the kernel logs emitted on
diff --git a/drivers/net/netoops.c b/drivers/net/netoops.c
index 87b2122..3c6d592 100644
--- a/drivers/net/netoops.c
+++ b/drivers/net/netoops.c
@@ -688,3 +688,5 @@ static void __exit netoops_exit(void)
 
 module_init(netoops_init);
 module_exit(netoops_exit);
+
+MODULE_LICENSE("GPL");
