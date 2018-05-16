From: Yury Norov <ynorov@caviumnetworks.com>
Subject: [PATCH 24/24] arm64: ilp32: Make the Kconfig option default y
Date: Wed, 16 May 2018 11:19:09 +0300
Message-ID: <20180516081910.10067-25-ynorov@caviumnetworks.com>
References: <20180516081910.10067-1-ynorov@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180516081910.10067-1-ynorov@caviumnetworks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>, Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
Cc: Yury Norov <ynorov@caviumnetworks.com>, Adam Borowski <kilobyte@angband.pl>, Alexander Graf <agraf@suse.de>, Alexey Klimov <klimov.linux@gmail.com>, Andreas Schwab <schwab@suse.de>, Andrew Pinski <pinskia@gmail.com>, Bamvor Zhangjian <bamv2005@gmail.com>, Chris Metcalf <cmetcalf@mellanox.com>, Christoph Muellner <christoph.muellner@theobroma-systems.com>, Dave Martin <Dave.Martin@arm.com>, "David S . Miller" <davem@davemloft.net>, Florian Weimer <fweimer@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, James Hogan <james.hogan@imgtec.com>, James Morse <james.morse@arm.com>, Joseph Myers <joseph@codesourcery.com>, Lin Yongting <linyongting@huawei.com>, Manuel Montezelo <manuel.montezelo@gmail.>
List-Id: linux-api@vger.kernel.org

From: Catalin Marinas <catalin.marinas@arm.com>

The intention of the ILP32 branches is to enable ILP32 by default. This
default is to be revisited for upstream merging.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Yury Norov <ynorov@caviumnetworks.com>
---
 arch/arm64/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index a3134b8e3123..3551990a2726 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1249,6 +1249,7 @@ config AARCH32_EL0
 
 config ARM64_ILP32
 	bool "Kernel support for ILP32"
+	default y
 	help
 	  This option enables support for AArch64 ILP32 user space.  ILP32
 	  is an ABI where long and pointers are 32bits but it uses the AARCH64
-- 
2.17.0
