From: Palmer Dabbelt <palmer@dabbelt.com>
Subject: [PATCH v4] Remove #ifdef CONFIG_* from all userspace headers
Date: Tue,  3 Nov 2015 11:46:21 -0800
Message-ID: <1446579994-9937-1-git-send-email-palmer__23638.3262476467$1446580032$gmane$org@dabbelt.com>
References: <1442271047-4908-1-git-send-email-palmer@dabbelt.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1442271047-4908-1-git-send-email-palmer@dabbelt.com>
Sender: linux-kernel-owner@vger.kernel.org
To: arnd@arndb.de, dhowells@redhat.com
Cc: viro@zeniv.linux.org.uk, ast@plumgrid.com, aishchuk@linux.vnet.ibm.com, aarcange@redhat.com, akpm@linux-foundation.org, luto@kernel.org, acme@kernel.org, bhe@redhat.com, 3chas3@gmail.com, chris@zankel.net, dave@sr71.net, dyoung@redhat.com, drysdale@google.com, davem@davemloft.net, ebiederm@xmission.com, geoff@infradead.org, gregkh@linuxfoundation.org, hpa@zytor.com, mingo@kernel.org, iulia.manda21@gmail.com, plagnioj@jcrosoft.com, jikos@kernel.org, josh@joshtriplett.org, kexec@lists.infradead.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-xtensa@linux-xtensa.org, mathieu.desnoyers@efficios.com, jcmvbkbc@gmail.com, paulmck@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, tglx@linutronix.de, tomi.valkeinen@ti.com, vgoyal@redhat.com, x86@kernel.org
List-Id: linux-api@vger.kernel.org

I think this is good to go.  There are two acks, but I wasn't sure if I was
supposed to collect them in the patches or not.  Arnd Bergman acked #1 and #7.

Changes since v3 (<1442271047-4908-1-git-send-email-palmer@dabbelt.com>)

 * #4 is very different: rather than defining a canonical value for
   MAP_UNINITIALIZED, it just punts on the problem and lets arch maintainers
   deal with it.  There's still an #ifndef MAP_UNINITIALIZED in there, but that
   shouldn't get triggered by anything because the arch headers should set it
   to whatever they actually want.

 * #11 defines MAX_RAW_MINORS to 2^20 instead of 2^16.

 * #13 moves the variable around a bit so it gets initialized.  I forgot I was
   in perl and not C :).

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
