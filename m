From: Dmitry Safonov <dima@arista.com>
Subject: [PATCH 19/32] x86/vdso2c: Align LOCAL symbols between vdso{-timens,}.so
Date: Wed,  6 Feb 2019 00:10:53 +0000
Message-ID: <20190206001107.16488-20-dima@arista.com>
References: <20190206001107.16488-1-dima@arista.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190206001107.16488-1-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Dmitry Safonov <dima@arista.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andrei Vagin <avagin@gmail.com>, Andy Lutomirski <luto@kernel.org>, Andy Tucker <agtucker@google.com>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Dmitry Safonov <0x7f454c46@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

Align not only VDSO entries as on timens VDSO, but also addresses of
local functions. Otherwise, ld will put them after everything else
into *(.text*). That will result in common VDSO size bigger than
timens VDSO size (sic!).

Unfortunately, filtering by STB_WEAK doesn't work for ia32 VDSO:
by some reason gcc transforms weak symbols into local symbols in .so,
i.e.:
    27: 00000000   219 FUNC    WEAK   DEFAULT   12 clock_gettime
    29: 00000000    95 FUNC    WEAK   DEFAULT   14 gettimeofday
    32: 00000000    40 FUNC    WEAK   DEFAULT   16 time

become:
    20: 000006e0   219 FUNC    LOCAL  DEFAULT   12 clock_gettime
    31: 000007c0    95 FUNC    LOCAL  DEFAULT   12 gettimeofday
    33: 00000820    40 FUNC    LOCAL  DEFAULT   12 time

that results in the same align for two functions in .entries file:
		. = ABSOLUTE(0x6e0);
		*(.text.__vdso_clock_gettime*)
		. = ABSOLUTE(0x6e0);
		*(.text.clock_gettime*)

As result, ld becomes a very sad animal and refuses to cooperate:
ld:arch/x86/entry/vdso/vdso32/vdso32.lds:339 cannot move location counter backwards (from 0000000000000762 to 00000000000006e0)

Align local functions on VDSO to timens VDSO and filter weak functions
from .lds script.

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 arch/x86/entry/vdso/vdso2c.h | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/entry/vdso/vdso2c.h b/arch/x86/entry/vdso/vdso2c.h
index 50566dd94451..7096710140fe 100644
--- a/arch/x86/entry/vdso/vdso2c.h
+++ b/arch/x86/entry/vdso/vdso2c.h
@@ -15,7 +15,7 @@ static void BITSFUNC(go)(void *raw_addr, size_t raw_len,
 	unsigned long mapping_size;
 	ELF(Ehdr) *hdr = (ELF(Ehdr) *)raw_addr;
 	unsigned int i, syms_nr;
-	unsigned long j;
+	unsigned long j, last_entry_addr;
 	ELF(Shdr) *symtab_hdr = NULL, *strtab_hdr, *secstrings_hdr,
 		*alt_sec = NULL;
 	ELF(Dyn) *dyn = 0, *dyn_end = 0;
@@ -121,7 +121,7 @@ static void BITSFUNC(go)(void *raw_addr, size_t raw_len,
 		if (!out_entries_lds)
 			continue;
 
-		if (ELF_FUNC(ST_BIND, sym->st_info) != STB_GLOBAL)
+		if (ELF_FUNC(ST_BIND, sym->st_info) == STB_WEAK)
 			continue;
 
 		if (ELF_FUNC(ST_TYPE, sym->st_info) != STT_FUNC)
@@ -134,8 +134,19 @@ static void BITSFUNC(go)(void *raw_addr, size_t raw_len,
 
 	qsort(entries, next_entry - entries, sizeof(*entries), entry_addr_cmp);
 
+	last_entry_addr = -1UL;
 	while (next_entry != entries && out_entries_lds) {
 		next_entry--;
+
+		/*
+		 * Unfortunately, WEAK symbols from objects are resoved
+		 * into LOCAL symbols on ia32. Filter them here, as
+		 * linker wouldn't like aligning the same symbol twice.
+		 */
+		if (last_entry_addr == next_entry->addr)
+			continue;
+		last_entry_addr = next_entry->addr;
+
 		fprintf(out_entries_lds, "\t\t. = ABSOLUTE(%#lx);\n\t\t*(.text.%s*)\n",
 			next_entry->addr, next_entry->name);
 	}
-- 
2.20.1
