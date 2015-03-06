From: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH] capabilities: Ambient capability set V2
Date: Fri, 6 Mar 2015 12:53:26 -0600 (CST)
Message-ID: <alpine.DEB.2.11.1503061244130.9804@gentwo.org>
References: <alpine.DEB.2.11.1502261612370.8994@gentwo.org> <20150301233359.GA22196@mail.hallyn.com> <alpine.DEB.2.11.1503050917380.31001@gentwo.org> <20150305171326.GA14998@mail.hallyn.com> <alpine.DEB.2.11.1503060948460.8207@gentwo.org>
 <20150306163443.GA28386@mail.hallyn.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20150306163443.GA28386@mail.hallyn.com>
Sender: linux-security-module-owner@vger.kernel.org
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>, Andy Lutomirski <luto@amacapital.net>, Jonathan Corbet <corbet@lwn.net>, Aaron Jones <aaronmdjones@gmail.com>, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linuxfoundation.org, "Andrew G. Morgan" <morgan@kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Markku Savela <msa@moth.iki.fi>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

On Fri, 6 Mar 2015, Serge E. Hallyn wrote:

> Sorry, something about that patch-patch didn't make sense to me, but I
> need to look more closely.  My objection was that you were able to get the
> pA capabilities into pP without them being in your pI.  Your proposed
> change didn't seem like it would fix that.

Just tried to fix that. Could it be that cap_inherited is never set even
for a binary that has

christoph@fujitsu-haswell:~$ getcap ambient_test

ambient_test = cap_setpcap,cap_net_admin,cap_net_raw,cap_sys_nice+eip


I added some printks and it seems that current_cred()->cap_inherited is
not set when running ambient_test.

Index: linux/security/commoncap.c
===================================================================
--- linux.orig/security/commoncap.c     2015-03-06 11:05:10.802218196
-0600
+++ linux/security/commoncap.c  2015-03-06 12:50:38.424330679 -0600
@@ -456,6 +456,10 @@ static int get_file_caps(struct linux_bi
                        kernel_cap_t relevant_ambient = cap_intersect(
                                current_cred()->cap_ambient,
                                current_cred()->cap_inheritable);
+                       printk("task->comm %s: Amb=%x Inh=%x relevant=%x\n",
+                               current->comm, current_cred()->cap_ambient.cap[0],
+                                               current_cred()->cap_inheritable.cap[0],
+                                               relevant_ambient.cap[0]);
                        rc = 0;
                        if (!cap_isclear(relevant_ambient)) {
                                /*



Mar  6 12:42:18 fujitsu-haswell kernel: [  284.715051] task->comm ambient_test: Amb=803000 Inh=0 relevant=0


