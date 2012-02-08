From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] Define ENOAUTHSERVICE to indicate "Authentication service
 unavailable"
Date: Wed, 08 Feb 2012 12:29:05 +0000
Message-ID: <20120208122905.8902.65762.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org
Cc: keyrings-6DNke4IJHB0gsBAKwltoeQ@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org
List-Id: linux-api@vger.kernel.org

As the kernel has or will have filesystems (and possibly other services) that
want to obtain authentication tokens and/or encryption data on demand (via
GSSAPI for example), it would seem useful to provide an additional error code
to indicate a problem with the lookup, rather than overloading some other error
code.

We already have EKEYREJECTED, EKEYREVOKED and EKEYEXPIRED to indicate problems
with a token that we already have, but what if the authentication server just
isn't available?

Define ENOAUTHSERVICE to indicate "Authentication service unavailable".  This
can be used to indicate, for example, that an attempt was made by request_key()
to retrieve a key, but the authentication server (e.g. a KDC) it is supposed to
contact didn't answer or that it couldn't determine the location of a suitable
server.

One way this can be used is that the user of a network filesystem can get a TGT
from the KDC and stash it in their session keyring, then the filesystem can
attempt to automatically get a ticket for accessing the filesystem - but if the
server is uncontactable then the ticket can be negatively instantiated with
KEYCTL_REJECT, giving the error to be handed to future requests as
ENOAUTHSERVICE and a small timeout so that the key will expire from the cache
and allow a retry after a short while to prevent thrashing.

Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---

 arch/alpha/include/asm/errno.h  |    1 +
 arch/mips/include/asm/errno.h   |    1 +
 arch/parisc/include/asm/errno.h |    1 +
 arch/sparc/include/asm/errno.h  |    1 +
 include/asm-generic/errno.h     |    1 +
 5 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/alpha/include/asm/errno.h b/arch/alpha/include/asm/errno.h
index e5f29ca..5edc21e 100644
--- a/arch/alpha/include/asm/errno.h
+++ b/arch/alpha/include/asm/errno.h
@@ -121,6 +121,7 @@
 #define	ENOTRECOVERABLE	137	/* State not recoverable */
 
 #define	ERFKILL		138	/* Operation not possible due to RF-kill */
+#define	ENOAUTHSERVICE	139	/* Authentication service not available */
 
 #define EHWPOISON	139	/* Memory page has hardware error */
 
diff --git a/arch/mips/include/asm/errno.h b/arch/mips/include/asm/errno.h
index 6dcd358..9e0b83f 100644
--- a/arch/mips/include/asm/errno.h
+++ b/arch/mips/include/asm/errno.h
@@ -120,6 +120,7 @@
 #define	ENOTRECOVERABLE	166	/* State not recoverable */
 
 #define	ERFKILL		167	/* Operation not possible due to RF-kill */
+#define	ENOAUTHSERVICE	168	/* Authentication service not available */
 
 #define EHWPOISON	168	/* Memory page has hardware error */
 
diff --git a/arch/parisc/include/asm/errno.h b/arch/parisc/include/asm/errno.h
index 135ad60..c4598b6 100644
--- a/arch/parisc/include/asm/errno.h
+++ b/arch/parisc/include/asm/errno.h
@@ -121,6 +121,7 @@
 #define ENOTRECOVERABLE	255	/* State not recoverable */
 
 #define	ERFKILL		256	/* Operation not possible due to RF-kill */
+#define	ENOAUTHSERVICE	257	/* Authentication service not available */
 
 #define EHWPOISON	257	/* Memory page has hardware error */
 
diff --git a/arch/sparc/include/asm/errno.h b/arch/sparc/include/asm/errno.h
index c351aba..ab4f9f5 100644
--- a/arch/sparc/include/asm/errno.h
+++ b/arch/sparc/include/asm/errno.h
@@ -111,6 +111,7 @@
 #define	ENOTRECOVERABLE	133	/* State not recoverable */
 
 #define	ERFKILL		134	/* Operation not possible due to RF-kill */
+#define	ENOAUTHSERVICE	135	/* Authentication service not available */
 
 #define EHWPOISON	135	/* Memory page has hardware error */
 
diff --git a/include/asm-generic/errno.h b/include/asm-generic/errno.h
index a1331ce..52325ca 100644
--- a/include/asm-generic/errno.h
+++ b/include/asm-generic/errno.h
@@ -107,6 +107,7 @@
 #define	ENOTRECOVERABLE	131	/* State not recoverable */
 
 #define ERFKILL		132	/* Operation not possible due to RF-kill */
+#define	ENOAUTHSERVICE	133	/* Authentication service not available */
 
 #define EHWPOISON	133	/* Memory page has hardware error */
 
