From: Andrew Murray <andrew.murray@arm.com>
Subject: [PATCH v3 7/7] arm64: docs: document AT_HWCAP2 and unused AT_HWCAP bits
Date: Mon,  1 Apr 2019 11:45:15 +0100
Message-ID: <20190401104515.39775-8-andrew.murray@arm.com>
References: <20190401104515.39775-1-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <libc-alpha-return-101082-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <20190401104515.39775-1-andrew.murray@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
Cc: Szabolcs Nagy <Szabolcs.Nagy@arm.com>, dave.martin@arm.com, linux-arm-kernel@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>, Phil Blundell <pb@pbcl.net>, libc-alpha@sourceware.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Now that we have expanded into AT_HWCAP2 let's add some documentation
to describe its presence. We also document the unused top half of
AT_HWCAP which we always return as 0 for userspace interoperation.

Signed-off-by: Andrew Murray <andrew.murray@arm.com>
---
 Documentation/arm64/elf_hwcaps.txt | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/Documentation/arm64/elf_hwcaps.txt b/Documentation/arm64/elf_hwcaps.txt
index c605757dd4db..6b3d4d334db7 100644
--- a/Documentation/arm64/elf_hwcaps.txt
+++ b/Documentation/arm64/elf_hwcaps.txt
@@ -13,9 +13,9 @@ architected discovery mechanism available to userspace code at EL0. The
 kernel exposes the presence of these features to userspace through a set
 of flags called hwcaps, exposed in the auxilliary vector.
 
-Userspace software can test for features by acquiring the AT_HWCAP entry
-of the auxilliary vector, and testing whether the relevant flags are
-set, e.g.
+Userspace software can test for features by acquiring the AT_HWCAP or
+AT_HWCAP2 entry of the auxiliary vector, and testing whether the relevant
+flags are set, e.g.
 
 bool floating_point_is_present(void)
 {
@@ -198,3 +198,11 @@ HWCAP_PACG
     Functionality implied by ID_AA64ISAR1_EL1.GPA == 0b0001 or
     ID_AA64ISAR1_EL1.GPI == 0b0001, as described by
     Documentation/arm64/pointer-authentication.txt.
+
+
+4. Unused AT_HWCAP bits
+-----------------------
+
+Each AT_HWCAP and AT_HWCAP2 entry provides for up to 32 hwcaps contained
+in bits [31:0]. For interoperation with userspace we guarantee that bit
+62 of AT_HWCAP will always be returned as 0.
-- 
2.21.0
