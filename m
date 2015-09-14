From: Palmer Dabbelt <palmer-96lFi9zoCfxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3] Remove #ifdef CONFIG_* from	all userspace headers
Date: Mon, 14 Sep 2015 15:50:34 -0700
Message-ID: <1442271047-4908-1-git-send-email-palmer__47337.1118926027$1442271096$gmane$org@dabbelt.com>
References: <1441832902-28993-1-git-send-email-palmer@dabbelt.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1441832902-28993-1-git-send-email-palmer-96lFi9zoCfxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: arnd-r2nGTMty4D4@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org, aishchuk-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, 3chas3-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, chris-YvXeqwSYzG2sTnJN9+BGXg@public.gmane.org, dave-gkUM19QKKo4@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, geoff-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, iulia.manda21-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org, jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xtensa-PjhNF2WwrV/0Sa2dR60CXw@public.gmane.org, mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org, jcmvbkbc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, tomi.valkeinen-l0cyMroinI0@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
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




Changes since v2 (<1441832902-28993-1-git-send-email-palmer-96lFi9zoCfxBDgjK7y7TUQ@public.gmane.org>)

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

Changes since v1 (<1441152610-22566-1-git-send-email-palmer-96lFi9zoCfxBDgjK7y7TUQ@public.gmane.org>)

* All patches but #1 were added.
