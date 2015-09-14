From: Palmer Dabbelt <palmer@dabbelt.com>
Subject: [PATCH v3] Remove #ifdef CONFIG_* from	all userspace headers
Date: Mon, 14 Sep 2015 15:50:34 -0700
Message-ID: <1442271047-4908-1-git-send-email-palmer__9241.37410843304$1442271317$gmane$org@dabbelt.com>
References: <1441832902-28993-1-git-send-email-palmer@dabbelt.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1441832902-28993-1-git-send-email-palmer@dabbelt.com>
Sender: linux-kernel-owner@vger.kernel.org
To: arnd@arndb.de, dhowells@redhat.com
Cc: viro@zeniv.linux.org.uk, ast@plumgrid.com, aishchuk@linux.vnet.ibm.com, aarcange@redhat.com, akpm@linux-foundation.org, luto@kernel.org, acme@kernel.org, bhe@redhat.com, 3chas3@gmail.com, chris@zankel.net, dave@sr71.net, dyoung@redhat.com, drysdale@google.com, davem@davemloft.net, ebiederm@xmission.com, geoff@infradead.org, gregkh@linuxfoundation.org, hpa@zytor.com, mingo@kernel.org, iulia.manda21@gmail.com, plagnioj@jcrosoft.com, jikos@kernel.org, josh@joshtriplett.org, kexec@lists.infradead.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-xtensa@linux-xtensa.org, mathieu.desnoyers@efficios.com, jcmvbkbc@gmail.com, paulmck@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, tglx@linutronix.de, tomi.valkeinen@ti.com, vgoyal@redhat.com, x86@kernel.org
List-Id: linux-api@vger.kernel.org

This patch set used to be called "[PATCH] Remove #ifdef CONFIG_64BIT
from all asm-generic/fcntl.h".

This is version 3 of the patch set.  I think things are kind of
cleaning up, but there's still some questions I have:

 * #4 might be dangerous, but I think this is the best way to do it
   because otherwise arch maintainers will have to #define this to
   something.  Since Xtensa already had exactly the same bug as the
   asm-generic header did, I think it'd be best to avoid those if
   possible.

   I'm OK changing this to define the value to 0 by default (though
   thinking now, I think it'd be better to not define it by default),
   since most kernels aren't going to have MAP_UNINITIALIZED do
   anything anyway.

 * #5 is big and I don't really understand what's going on, so it's
   probably broken somewhere.

Also, there's some checkpatch warnings that I purposely haven't fixed:

 * In #5, there's a checkpatch.pl complaint about same-line struct
   braces.  I've left that in to match the rest of the file, but I can
   also fix all of them if that would be better.

 * In #10, there's a checkpatch.pl complaint about a split printk
   format string, but that was there before and I don't see a way to
   make it a lot cleaner, so I'm leaving it alone.

 * In #13, there's two checkpatch.pl complains.  One is about block
   comments that is bogus, and one is about long lines but there's
   more of those so I think it's OK.

Thanks to everyone who looked at v2!




Changes since v2 (<1441832902-28993-1-git-send-email-palmer@dabbelt.com>)

* Patch set renamed.

* #2 is rewritten to use sys_ni.c instead of an #ifdef

* #3, #6, #8, #9, #10, and #11 no longer use "#ifdef __KERNEL__" but
   have instead moved the offending lines to the correct, kernel-only
   files.

* #4 has been rewritten to always define MAP_UNINITIALIZED to
   non-zero, rather than defining it to zero when in userspace.

* #5 got a whole lot longer -- rather than just always hiding these
   fields from userspace, there is now a second "struct
   elf_fdpic_prstatus" structure.  This should allow userspace to
   parse core dumps correctly.

* Rebased onto 9c488de24f7264f08d341024bffdd637b4d04c96.

Changes since v1 (<1441152610-22566-1-git-send-email-palmer@dabbelt.com>)

* All patches but #1 were added.
