From: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/5] [RFCv5] add manpages for Memory Protection Keys
Date: Tue, 13 Sep 2016 12:44:06 -0700
Message-ID: <20160913194406.20CBFD0C@ray>
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

Changes from v4:
 * Remove references to pkey_get/pkey_set since those were
   removed from the code that got merged
 * Updated example code to stop using  pkey_get/set

Changes from v3:
 * Split patches up, one per manpage.
 * Started new sentences on new lines.
 * Added description of default key to pkey.7
 * reindented and fixed up sys_ in example code, s/err/status/,
   also removed assert()s.
 * Various other fixes in response to Michael's review

Changes from v2:
 * clarified that calling pkey_free() on a pkey in use by
   a mapping is bad.

--

Memory Protection Keys for User pages is an Intel CPU feature
which will first appear on Skylake Servers, but will also be
supported on future non-server parts (there is also a QEMU
implementation).  It provides a mechanism for enforcing
page-based protections, but without requiring modification of the
page tables when an application wishes to change permissions.

I have propsed adding three new system calls to support this feature.
The three calls are distributed across two man-pages (one existing
and one new), plus a new pkey(7) page which serves as a general
overview of the feature with example code.

The system calls for this feature are in the -tip tree currently
and are expected to be merged for 4.9.  I will submit the final
versions of these man-pages once the 4.9 kernel has been released.

The latest version of the code can be found here, in addition to
in the -tip tree and -next.

    http://git.kernel.org/cgit/linux/kernel/git/daveh/x86-pkeys.git/

Signed-off-by: Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
