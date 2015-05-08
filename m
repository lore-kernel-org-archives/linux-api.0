From: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Subject: [PATCH] Docmentation, ABI: Update contact for L3 cache index disable
Date: Fri, 8 May 2015 17:44:58 -0500
Message-ID: <1431125098-9470-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: bp@suse.de, gregkh@linuxfoundation.org
Cc: sudeep.holla@arm.com, sboyd@codeaurora.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

The mailing list discuss@x86-64.org is now defunct.
Using x86@kernel.org in its place.

Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
---
 Documentation/ABI/testing/sysfs-devices-system-cpu | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
index 99983e6..f1c46d0 100644
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -162,7 +162,7 @@ Description:	Discover CPUs in the same CPU frequency coordination domain
 What:		/sys/devices/system/cpu/cpu*/cache/index3/cache_disable_{0,1}
 Date:		August 2008
 KernelVersion:	2.6.27
-Contact:	discuss@x86-64.org
+Contact:	x86@kernel.org
 Description:	Disable L3 cache indices
 
 		These files exist in every CPU's cache/index3 directory. Each
-- 
2.4.0
