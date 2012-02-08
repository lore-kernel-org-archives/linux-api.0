From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] Define ENONAMESERVICE and ENAMEUNKNOWN to indicate name
 service errors
Date: Wed, 08 Feb 2012 12:29:18 +0000
Message-ID: <20120208122917.8902.78395.stgit@warthog.procyon.org.uk>
References: <20120208122905.8902.65762.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120208122905.8902.65762.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org
Cc: keyrings-6DNke4IJHB0gsBAKwltoeQ@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org
List-Id: linux-api@vger.kernel.org

Now that the kernel has filesystems (and possibly other services) that want to
look up internet addresses corresponding to arbitrary hostnames retrieved from
the server, it would seem useful to provide a couple of error codes to indicate
problems with the look up, rather than overloading some other error code.

Define ENONAMESERVICE to indicate "Network name service unavailable".  This can
be used to indicate, for example, that an attempt was made by dns_query() to
make a query, but the name server (e.g. a DNS server) it is supposed to contact
didn't answer or that it couldn't determine the location of a suitable server.

Define ENAMEUNKNOWN to indicate "Network name unknown".  This can be used to
indicate, for example, that an attempt was made by dns_query() to make a query,
but the name server (e.g. a DNS server) replied indicating that it had no
matching records.

The DNS query upcall program can report these to keyctl_reject() so that cached
failed queries will respond with these errors until they expire.

Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---

 arch/alpha/include/asm/errno.h  |    2 ++
 arch/mips/include/asm/errno.h   |    2 ++
 arch/parisc/include/asm/errno.h |    2 ++
 arch/sparc/include/asm/errno.h  |    2 ++
 include/asm-generic/errno.h     |    2 ++
 5 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/alpha/include/asm/errno.h b/arch/alpha/include/asm/errno.h
index 5edc21e..d6e8582 100644
--- a/arch/alpha/include/asm/errno.h
+++ b/arch/alpha/include/asm/errno.h
@@ -122,6 +122,8 @@
 
 #define	ERFKILL		138	/* Operation not possible due to RF-kill */
 #define	ENOAUTHSERVICE	139	/* Authentication service not available */
+#define	ENONAMESERVICE	140	/* Network name service unavailable */
+#define	ENAMEUNKNOWN	141	/* Network name unknown */
 
 #define EHWPOISON	139	/* Memory page has hardware error */
 
diff --git a/arch/mips/include/asm/errno.h b/arch/mips/include/asm/errno.h
index 9e0b83f..5ae25aa 100644
--- a/arch/mips/include/asm/errno.h
+++ b/arch/mips/include/asm/errno.h
@@ -121,6 +121,8 @@
 
 #define	ERFKILL		167	/* Operation not possible due to RF-kill */
 #define	ENOAUTHSERVICE	168	/* Authentication service not available */
+#define	ENONAMESERVICE	169	/* Network name service unavailable */
+#define	ENAMEUNKNOWN	170	/* Network name unknown */
 
 #define EHWPOISON	168	/* Memory page has hardware error */
 
diff --git a/arch/parisc/include/asm/errno.h b/arch/parisc/include/asm/errno.h
index c4598b6..6b3bc7f 100644
--- a/arch/parisc/include/asm/errno.h
+++ b/arch/parisc/include/asm/errno.h
@@ -122,6 +122,8 @@
 
 #define	ERFKILL		256	/* Operation not possible due to RF-kill */
 #define	ENOAUTHSERVICE	257	/* Authentication service not available */
+#define	ENONAMESERVICE	258	/* Network name service unavailable */
+#define	ENAMEUNKNOWN	259	/* Network name unknown */
 
 #define EHWPOISON	257	/* Memory page has hardware error */
 
diff --git a/arch/sparc/include/asm/errno.h b/arch/sparc/include/asm/errno.h
index ab4f9f5..5fab088 100644
--- a/arch/sparc/include/asm/errno.h
+++ b/arch/sparc/include/asm/errno.h
@@ -112,6 +112,8 @@
 
 #define	ERFKILL		134	/* Operation not possible due to RF-kill */
 #define	ENOAUTHSERVICE	135	/* Authentication service not available */
+#define	ENONAMESERVICE	136	/* Network name service unavailable */
+#define	ENAMEUNKNOWN	137	/* Network name unknown */
 
 #define EHWPOISON	135	/* Memory page has hardware error */
 
diff --git a/include/asm-generic/errno.h b/include/asm-generic/errno.h
index 52325ca..719f60c 100644
--- a/include/asm-generic/errno.h
+++ b/include/asm-generic/errno.h
@@ -108,6 +108,8 @@
 
 #define ERFKILL		132	/* Operation not possible due to RF-kill */
 #define	ENOAUTHSERVICE	133	/* Authentication service not available */
+#define	ENONAMESERVICE	134	/* Network name service unavailable */
+#define	ENAMEUNKNOWN	135	/* Network name unknown */
 
 #define EHWPOISON	133	/* Memory page has hardware error */
 
