From: Andrew Murray <andrew.murray@arm.com>
Subject: [PATCH v3 5/7] arm64: add CVADP support to the cache maintenance
 helper
Date: Mon,  1 Apr 2019 11:45:13 +0100
Message-ID: <20190401104515.39775-6-andrew.murray@arm.com>
References: <20190401104515.39775-1-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20190401104515.39775-1-andrew.murray@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>, libc-alpha@sourceware.org, Szabolcs Nagy <Szabolcs.Nagy@arm.com>, linux-api@vger.kernel.org, Phil Blundell <pb@pbcl.net>, dave.martin@arm.com, linux-arm-kernel@lists.infradead.org
List-Id: linux-api@vger.kernel.org

Allow users of dcache_by_line_op to specify cvadp as an op.

Signed-off-by: Andrew Murray <andrew.murray@arm.com>
---
 arch/arm64/include/asm/assembler.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index c5308d01e228..d50caf0e6b64 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -407,10 +407,14 @@ alternative_endif
 	.ifc	\op, cvap
 	sys	3, c7, c12, 1, \kaddr	// dc cvap
 	.else
+	.ifc	\op, cvadp
+	sys	3, c7, c13, 1, \kaddr	// dc cvadp
+	.else
 	dc	\op, \kaddr
 	.endif
 	.endif
 	.endif
+	.endif
 	add	\kaddr, \kaddr, \tmp1
 	cmp	\kaddr, \size
 	b.lo	9998b
-- 
2.21.0
