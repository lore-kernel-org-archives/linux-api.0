From: Christoph Lameter <cl@linux.com>
Subject: Re: [RFC] capabilities: Ambient capabilities
Date: Mon, 30 Mar 2015 07:55:04 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1503300754070.5031@gentwo.org>
References: <933931146caf5dac58379f50c017bff9f6c47661.1426183417.git.luto@kernel.org> <CAGXu5jKfvswdUMcrGbr6+wn1ME_JkySMvdNd0wvvHpbQ1C7HUg@mail.gmail.com> <CALQRfL7b8CjYgUnVy3jykNwv48fOc03T385RKo--cfv25YenBg@mail.gmail.com>
 <CAObL_7HgU-ekb7mJS7C=0=idfrzV6=CSqTrG2LvUgdDtvbJx_w@mail.gmail.com> <CALQRfL6HUGMfPtsqLcSed8G14Yqg27R8tpDnMZOKtvQE+rqX0A@mail.gmail.com> <CALCETrVz39pJmMAEFodBNA8cOZjd0xkH95EzMazY0MWJDtpYgg@mail.gmail.com> <CALQRfL5FGGUnK7+Ss=MSDGmxpAERTUjezardGnH3QouBwhbZ4A@mail.gmail.com>
 <CALCETrUGASa3Gp6cC1zdAahcS59DOdyLnTtgNX7t7FucMZLmoQ@mail.gmail.com> <CALQRfL6z2dEtPkWiuGydT0a+y4iWm2qw-cY0Rk9hA-K4gPw_qA@mail.gmail.com> <CALCETrWRHRVLotFs=Cpdr=7KjE7q52NdT62GxZg=xjv+LFZBqw@mail.gmail.com>
 <CALQRfL7AyadFcu9JqtC6FGnuuqY7zbnFAL81XnwBvn0o6c6UWQ@mail.gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALQRfL7AyadFcu9JqtC6FGnuuqY7zbnFAL81XnwBvn0o6c6UWQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Ted Ts'o <tytso@mit.edu>, Andrew Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linuxfoundation.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Linux API <linux-api@vger.kernel.org>, Austin S Hemmelgarn <ahferroin7@gmail.com>, linux-security-module <linux-security-module@vger.kernel.org>, Aaron Jones <aaronmdjones@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Serge Hallyn <serge.hallyn@canonical.com>, Markku Savela <msa@moth.iki.fi>, Kees Cook <keescook@chromium.org>, Jonathan Corbet <corbet@lwn.net>
List-Id: linux-api@vger.kernel.org

On Sat, 14 Mar 2015, Andrew G. Morgan wrote:

>
> I thought I did. Please implement a lockable secure bit and I will

Would this suffice? It puts the CAP_SETPCAP limitation back to how it
was in my earlier patch.



Subject: ambient caps: Allow disabling with SETPCAP

Do not allow setting ambient caps if CAP_SETPCAP is not set.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/security/commoncap.c
===================================================================
--- linux.orig/security/commoncap.c
+++ linux/security/commoncap.c
@@ -962,6 +962,9 @@ int cap_task_prctl(int option, unsigned
 		if (((!cap_valid(arg3)) | arg4 | arg5))
 			return -EINVAL;

+		if (!ns_capable(current_user_ns(), CAP_SETPCAP))
+			return -EPERM;
+
 		if (arg2 == PR_CAP_AMBIENT_GET) {
 			return !!cap_raised(current_cred()->cap_ambient, arg3);
 		} else if (arg2 != PR_CAP_AMBIENT_RAISE &&
