From: Yuri Norov <ynorov@marvell.com>
Subject: [PATCH] arm64: introduce AUDIT_ARCH_AARCH64ILP32 for ilp32
Date: Tue, 8 Jan 2019 21:18:56 +0000
Message-ID: <20190108211840.GA13838@yury-thinkpad>
References: <20180516081910.10067-1-ynorov@caviumnetworks.com>
 <20190107155028.GA25178@yury-thinkpad>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20190107155028.GA25178@yury-thinkpad>
Content-Language: en-US
Content-ID: <ECFB331D797AC1488D832907AB4C052F@namprd18.prod.outlook.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Catalin Marinas <catalin.marinas@arm.com>, Arnd Bergmann <arnd@arndb.de>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, Adam Borowski <kilobyte@angband.pl>, Alexander Graf <agraf@suse.de>, Alexey Klimov <klimov.linux@gmail.com>, Andreas Schwab <schwab@suse.de>, Andrew Pinski <pinskia@gmail.com>, Bamvor Zhangjian <bamv2005@gmail.com>, Chris Metcalf <cmetcalf@mellanox.com>, Christoph
 Muellner <christoph.muellner@theobroma-systems.com>, Dave Martin <Dave.Martin@arm.com>, "David S . Miller" <davem@davemloft.net>, Florian
 Weimer <fweimer@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Heiko Cars
Cc: Andy Lutomirski <luto@amacapital.net>
List-Id: linux-api@vger.kernel.org

Make syscall_get_arch() distinguish arm64 and arm64/ilp32 by adding
AUDIT_ARCH_AARCH64ILP32.

Sugested-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Yury Norov <ynorov@marvell.com>
---
 arch/arm64/include/asm/syscall.h | 3 +++
 include/uapi/linux/audit.h       | 1 +
 2 files changed, 4 insertions(+)

diff --git a/arch/arm64/include/asm/syscall.h b/arch/arm64/include/asm/syscall.h
index 73fbe08763b0..77578d703cb1 100644
--- a/arch/arm64/include/asm/syscall.h
+++ b/arch/arm64/include/asm/syscall.h
@@ -126,6 +126,9 @@ static inline int syscall_get_arch(void)
 	if (is_a32_compat_task())
 		return AUDIT_ARCH_ARM;
 
+	if (is_ilp32_compat_task())
+		return AUDIT_ARCH_AARCH64ILP32;
+
 	return AUDIT_ARCH_AARCH64;
 }
 
diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index 818ae690ab79..624127147404 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -374,6 +374,7 @@ enum {
 #define __AUDIT_ARCH_LE	   0x40000000
 
 #define AUDIT_ARCH_AARCH64	(EM_AARCH64|__AUDIT_ARCH_64BIT|__AUDIT_ARCH_LE)
+#define AUDIT_ARCH_AARCH64ILP32	(EM_AARCH64|__AUDIT_ARCH_LE)
 #define AUDIT_ARCH_ALPHA	(EM_ALPHA|__AUDIT_ARCH_64BIT|__AUDIT_ARCH_LE)
 #define AUDIT_ARCH_ARM		(EM_ARM|__AUDIT_ARCH_LE)
 #define AUDIT_ARCH_ARMEB	(EM_ARM)
-- 
2.17.1
