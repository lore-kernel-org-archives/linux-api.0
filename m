From: "Jason A. Donenfeld" <Jason-OnJsPKxuuEcAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] xcrypt.3: warn folks not to use these functions
Date: Wed, 14 Jun 2017 18:37:46 +0200
Message-ID: <20170614163746.7005-1-Jason@zx2c4.com>
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org
Cc: "Jason A. Donenfeld" <Jason-OnJsPKxuuEcAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

There is not an acceptable reason to use these functions ever in new code.
For example, just observe the implementation of the KDF:

	/*
	 * Turn password into DES key
	 */
	void
	passwd2des_internal (char *pw, char *key)
	{
	  int i;

	  memset (key, 0, 8);
	  for (i = 0; *pw && i < 8; ++i)
	    key[i] ^= *pw++ << 1;

	  des_setparity (key);
	}

This kind of nonsense isn't okay in the year 2017. Therefore, we
enlighten our poor users.

Signed-off-by: Jason A. Donenfeld <Jason-OnJsPKxuuEcAvxtiuMwx3w@public.gmane.org>
---
 man3/xcrypt.3 | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/man3/xcrypt.3 b/man3/xcrypt.3
index 956df55ba..6bc882549 100644
--- a/man3/xcrypt.3
+++ b/man3/xcrypt.3
@@ -22,6 +22,10 @@ xencrypt, xdecrypt, passwd2des \- RFS password encryption
 .sp
 .BI "int xdecrypt(char *" secret ", char *" passwd ");"
 .SH DESCRIPTION
+.BR WARNING :
+Do not use these functions in new code. They do not achieve
+any type of acceptable cryptographic security guarantees.
+.LP
 The function
 .BR passwd2des ()
 takes a character string
-- 
2.13.1

--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
