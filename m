From: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCHv2 manpages] getgroups.2: Document unprivileged setgroups calls
Date: Sat, 15 Nov 2014 13:03:02 -0800
Message-ID: <20141115210302.GA22941@thin>
References: <3ccec8a13019b5e8ce7b1d7889677b778b070dc8.1416085112.git.josh@joshtriplett.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3ccec8a13019b5e8ce7b1d7889677b778b070dc8.1416085112.git.josh@joshtriplett.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, mtk.manpages@gmail.com, linux-api@vger.kernel.org, linux-man@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
v2: Document requirement for no_new_privs.

(If this doesn't end up going into 3.18, the version number in the patch will
need updating.)

 man2/getgroups.2 | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/man2/getgroups.2 b/man2/getgroups.2
index 373c204..3f3d330 100644
--- a/man2/getgroups.2
+++ b/man2/getgroups.2
@@ -81,9 +81,11 @@ to be used in a further call to
 .PP
 .BR setgroups ()
 sets the supplementary group IDs for the calling process.
-Appropriate privileges (Linux: the
+As of Linux 3.18, any process that has enabled PR_SET_NO_NEW_PRIVS may drop
+supplementary groups, but may not add new groups. Adding groups, or making any
+change at all without no_new_privs enabled, requires the
 .B CAP_SETGID
-capability) are required.
+capability.
 The
 .I size
 argument specifies the number of supplementary group IDs
-- 
2.1.3
