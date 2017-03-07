From: Leonard den Ottolander <leonard-lists-2Avth2y2NeLyQNdsBcn8aGZHpeb/A1Y/@public.gmane.org>
Subject: binfmts.h MAX_ARG_STRINGS excessive value allows heap spraying
Date: Tue, 07 Mar 2017 15:44:28 +0100
Message-ID: <1488897868.5178.3.camel@quad>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

In the article 
https://googleprojectzero.blogspot.nl/2014/08/the-poisoned-nul-byte-2014-edition.html
the author describes launching an attack on an off by one NUL byte bug
in glibc.

He explains that both the memory leak in the option parsing of PolKits
pkexec.c and the excessive value of MAX_ARG_STRINGS in the kernels
include/uapi/linux/binfmts.h (#define MAX_ARG_STRINGS 0x7FFFFFFF)
enabled his attack.

The rationale for that excessive value is a bit odd:

"MAX_ARG_STRINGS is chosen to fit in a signed 32-bit integer."

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/include/uapi/linux/binfmts.h?id=607ca46e97a1b6594b29647d98a32d545c24bdff

The fact that the integer is so large makes that on a 32 bit platform
the entire heap can be initialized with values the attacker provides,
given the memory leak in the option parsing of pkexec.c, an approach the
author calls "heap spraying".

(Note that two similar memory leaks exist in the option parsing of
pkexecs sibling pkcheck.c, so pkcheck will also allow an attacker to
heap spray its entire memory on a 32 bit system.)

If you compare http://www.linuxjournal.com/article/6060 you will see
that the TOTAL amount of memory reserved for command line arguments used
to be 32 pages, i.e. 128KiB (#define MAX_ARG_PAGES 32). The amount of
memory reserved for command line arguments in more current kernels is
the multiplication of MAX_ARG_STRINGS and MAX_ARG_STRLEN.

Both the memory leaks in pkexec.c and pkcheck.c seem very severe, but
their impact would be much less if MAX_ARG_STRINGS would hold a sensible
value.

After some experimentation with
$ rpmbuild -ba kernel.spec
on CentOS-7 I've come up with values that allow this kernel compilation.
As this kind of build is probably one of the most demanding actions in
relation to MAX_ARG_STRINGS and MAX_ARG_STRLEN I believe below values to
be sensible and much safer defaults:

#define MAX_ARG_STRLEN 65536
#define MAX_ARG_STRINGS 4096

allow me to build a kernel on a system using those values.

Since the above value of MAX_ARG_STRLEN is half of the current value we
might leave it alone and only alter MAX_ARG_STRINGS, resulting in

--- a/include/uapi/linux/binfmts.h	2016-11-23 21:02:31.000000000 +0100
+++ b/include/uapi/linux/binfmts.h	2017-02-07 15:40:13.548403615 +0100
@@ -12,7 +12,7 @@ struct pt_regs;
  * MAX_ARG_STRINGS is chosen to fit in a signed 32-bit integer.
  */
 #define MAX_ARG_STRLEN (PAGE_SIZE * 32)
-#define MAX_ARG_STRINGS 0x7FFFFFFF
+#define MAX_ARG_STRINGS 4096
 
 /* sizeof(linux_binprm->buf) */
 #define BINPRM_BUF_SIZE 128

Filed a bug at https://bugzilla.kernel.org/show_bug.cgi?id=194809 .

Regards,
Leonard.

-- 
mount -t life -o ro /dev/dna /genetic/research
