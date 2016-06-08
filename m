From: Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>
Subject: [PATCH 0/6] [RFCv4] add manpages for Memory Protection Keys
Date: Wed, 08 Jun 2016 10:33:51 -0700
Message-ID: <20160608173351.5CF7B2D3@ray>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

Changes from v3:
 * Split patches up, one per manpage.
 * Started new sentences on new lines.
 * Added description of default key to pkey.7
 * reindented and fixed up sys_ in example code, s/err/status/,
   also removed assert()s.
 * Various other fixes in response to Michael's review

One outstanding issue is the language and behavior for the
PKEY_DISABLE_ACCESS/WRITE flags.  Should the manpage describe
the acceptable number of flags as "zero or more" or "zero or
one"?

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

I have propsed adding five new system calls to support this feature.
The five calls are distributed across three man-pages (one existing
and 2 new), plus a new pkey(7) page which serves as a general
overview of the feature.

The system calls for this feature are not currently upstream but
can be found here:

    http://git.kernel.org/cgit/linux/kernel/git/daveh/x86-pkeys.git/

Signed-off-by: Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
