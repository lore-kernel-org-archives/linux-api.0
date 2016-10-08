From: Florian Weimer <fw-d32yF4oPJVt0XxTmqZlbVQ@public.gmane.org>
Subject: Return type of getrandom(2)
Date: Sat, 08 Oct 2016 14:28:27 +0200
Message-ID: <87mvifnhxw.fsf@mid.deneb.enyo.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Heinrich Schuchardt <xypron.glpk-Mmb7MZpHnFY@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

The manual page says the return type of getrandom(2) is int, but
ssize_t would be more natural (see read(2) for comparison).  The
kernel uses ssize_t internally, which is converted to long on the
system call boundary.

The difference does not currently matter because the return value is
limited to much less than INT_MAX in the implementation.

Should we use int or ssize_t in the glibc system call wrapper?
