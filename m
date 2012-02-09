From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] Define ENOAUTHSERVICE to indicate "Authentication service unavailable"
Date: Thu, 09 Feb 2012 10:01:13 +0000
Message-ID: <17357.1328781673@redhat.com>
References: <22934.1328745230@turing-police.cc.vt.edu> <20120208122905.8902.65762.stgit@warthog.procyon.org.uk>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <22934.1328745230-+bZmOdGhbsPr6rcHtW+onFJE71vCis6O@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Valdis.Kletnieks-PjAqaU27lzQ@public.gmane.org
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org, keyrings-6DNke4IJHB0gsBAKwltoeQ@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org
List-Id: linux-api@vger.kernel.org

Valdis.Kletnieks-PjAqaU27lzQ@public.gmane.org wrote:

> Was this an intentional overload of 139 (and so on for other archs)?  Just
> checking - I'm sure if it goes in like this, we'll see a patch to "fix" the
> collision for 3.16.0 or so... ;)

Ummm...  Odd...  I'm surprised StGIT managed to reapply my patches with no
warning.  I'll fix the numbering in them.

David
