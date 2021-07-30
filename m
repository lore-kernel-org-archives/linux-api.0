Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39217C432BE
	for <linux-api@archiver.kernel.org>; Fri, 30 Jul 2021 06:39:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21D9F60F9B
	for <linux-api@archiver.kernel.org>; Fri, 30 Jul 2021 06:39:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237531AbhG3Gjz (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Fri, 30 Jul 2021 02:39:55 -0400
Received: from smtpbg704.qq.com ([203.205.195.105]:35893 "EHLO
        smtpproxy21.qq.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S237274AbhG3Gjz (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Fri, 30 Jul 2021 02:39:55 -0400
X-QQ-mid: bizesmtp51t1627627184trqqb981
Received: from localhost.localdomain (unknown [36.154.209.16])
        by esmtp6.qq.com (ESMTP) with 
        id ; Fri, 30 Jul 2021 14:39:43 +0800 (CST)
X-QQ-SSF: 01400000001000B0P000B00C0000000
X-QQ-FEAT: O9RHVi+JMbLUPY7Z72ydJScM1wEB//DG03nLTbnojYiU27w4RQUaDsKemarlY
        6hAul2jZScuV+t/rrenhQ6GmFVMINVnuGjIK4s/AJFebeJa2GkDpTLSE+w3tYxVM9q4F7c3
        3oxo9NgWbkPYGbmAey4bPqgJesnbdsTvdsRMJ9y86FDxeusST/CW8Hf9uouiQSpHTJS8Gug
        LTQ3qddINsqD93hW/FZvvFdy2QyyMNiTVnF4e9RD7tlCjmiUb5rsDA+4w5zU/02HsES0Lyi
        WVHWtOga105c1t9uRhT7A4zNGCJVIm2BnCsQtb2CrW7vglD/Zgysj4qxQYfOQgmxv3EJWOH
        2bRcPwYYMKul3jlc5Uv+bIRf/3uDw==
X-QQ-GoodBg: 2
From:   Wang Zi-cheng <wzc@smail.nju.edu.cn>
To:     linux-api@vger.kernel.org, akpm@linux-foundation.org
Cc:     Wang Zi-cheng <wzc@smail.nju.edu.cn>
Subject: [PATCH] corrent sys_reboot annotation
Date:   Fri, 30 Jul 2021 14:40:32 +0800
Message-Id: <20210730064032.101113-1-wzc@smail.nju.edu.cn>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:smail.nju.edu.cn:qybgforeign:qybgforeign2
X-QQ-Bgrelay: 1
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Signed-off-by: Wang Zi-cheng <wzc@smail.nju.edu.cn>
---
 include/linux/syscalls.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 586128d5c3b8..68746eec0092 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -735,11 +735,14 @@ asmlinkage long sys_rt_sigtimedwait_time32(const sigset_t __user *uthese,
 				size_t sigsetsize);
 asmlinkage long sys_rt_sigqueueinfo(pid_t pid, int sig, siginfo_t __user *uinfo);
 
+/* kernel/reboot.c */
+asmlinkage long sys_reboot(int magic1, int magic2, unsigned int cmd,
+				void __user *arg);
+
 /* kernel/sys.c */
 asmlinkage long sys_setpriority(int which, int who, int niceval);
 asmlinkage long sys_getpriority(int which, int who);
-asmlinkage long sys_reboot(int magic1, int magic2, unsigned int cmd,
-				void __user *arg);
+
 asmlinkage long sys_setregid(gid_t rgid, gid_t egid);
 asmlinkage long sys_setgid(gid_t gid);
 asmlinkage long sys_setreuid(uid_t ruid, uid_t euid);
-- 
2.32.0

--------------

sys_reboot is in kernel/reboot.c not kernel/sys.c  


