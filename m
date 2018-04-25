From: ebiederm@xmission.com (Eric W. Biederman)
Subject: [PATCH] signal/nds32: More information in do_revinsn
Date: Wed, 25 Apr 2018 11:13:45 -0500
Message-ID: <87in8fuuva.fsf_-_@xmission.com>
References: <878t9ilmhv.fsf@xmission.com>
        <20180420010408.24438-5-ebiederm@xmission.com>
        <CAJsyPhyDeafwUQxXgnZ9Rfj6nwYrU_Kgyfv8DQ2q0BkwW25BBw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJsyPhyDeafwUQxXgnZ9Rfj6nwYrU_Kgyfv8DQ2q0BkwW25BBw@mail.gmail.com>
        (Vincent Chen's message of "Wed, 25 Apr 2018 20:10:22 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Vincent Chen <deanbo422@gmail.com>
Cc: linux-arch <linux-arch@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Vincent Chen <vincentc@andestech.com>, Greentime Hu <greentime@andestech.com>, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org


While reviewing f6ed1ecad56f ("signal/nds32: Use force_sig(SIGILL) in do_revisn")
Vincent Chen asked if it was possible to provide more information in do_revinsn
with force_sig_fault.

That seems reasonable and the appropirate si_code appears to be
ILL_ILLOPC (illegal opcode) as the printk indicates this code path
is triggered when a reserved instruction is exectured.

So update do_revinsn to use force_sig_fault(SIGILL, ILL_ILLOPC, ...).
Giving userspace a much better experience when soemone attempts
to execute a reserved instruction.

Cc: Greentime Hu <green.hu@gmail.com>
Cc: Vincent Chen <deanbo422@gmail.com>
Suggested-by: Vincent Chen <deanbo422@gmail.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---

Vincent I have updated this from your suggestion to use
ILL_ILLOPC as that appears the more appropriate si_code.
Normally I expect you could just update your nds32 tree and
make this kind of change but since I am touching this code anyway I will
be happy to take this change along with the others.

Does this look good to you?

 arch/nds32/kernel/traps.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/nds32/kernel/traps.c b/arch/nds32/kernel/traps.c
index a6205fd4db52..5c2f61835ab9 100644
--- a/arch/nds32/kernel/traps.c
+++ b/arch/nds32/kernel/traps.c
@@ -349,7 +349,8 @@ void do_revinsn(struct pt_regs *regs)
 	show_regs(regs);
 	if (!user_mode(regs))
 		do_exit(SIGILL);
-	force_sig(SIGILL, current);
+	force_sig_fault(SIGILL, ILL_ILLOPC,
+			(void __user *)instruction_pointer(regs), current);
 }
 
 #ifdef CONFIG_ALIGNMENT_TRAP
-- 
2.14.1
