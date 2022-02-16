Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14525C433EF
	for <linux-api@archiver.kernel.org>; Wed, 16 Feb 2022 15:59:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235812AbiBPP72 (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 16 Feb 2022 10:59:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233462AbiBPP72 (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Wed, 16 Feb 2022 10:59:28 -0500
X-Greylist: delayed 141 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 16 Feb 2022 07:59:14 PST
Received: from out03.mta.xmission.com (out03.mta.xmission.com [166.70.13.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3D392A39CB;
        Wed, 16 Feb 2022 07:59:10 -0800 (PST)
Received: from in01.mta.xmission.com ([166.70.13.51]:57886)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nKMhu-009IKW-FJ; Wed, 16 Feb 2022 08:59:06 -0700
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:37452 helo=localhost.localdomain)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nKMht-002YPH-8X; Wed, 16 Feb 2022 08:59:06 -0700
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     linux-kernel@vger.kernel.org
Cc:     Alexey Gladkov <legion@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Shuah Khan <shuah@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Solar Designer <solar@openwall.com>,
        Ran Xiaokai <ran.xiaokai@zte.com.cn>,
        containers@lists.linux-foundation.org,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        linux-api@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>, stable@vger.kernel.org
Date:   Wed, 16 Feb 2022 09:58:28 -0600
Message-Id: <20220216155832.680775-1-ebiederm@xmission.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <87ilteiz4a.fsf_-_@email.froward.int.ebiederm.org>
References: <87ilteiz4a.fsf_-_@email.froward.int.ebiederm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-XM-SPF: eid=1nKMht-002YPH-8X;;;mid=<20220216155832.680775-1-ebiederm@xmission.com>;;;hst=in01.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19NThaI6BizHvKGbIpdTGv716FzPhyOfYM=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: [PATCH v2 1/5] rlimit: Fix RLIMIT_NPROC enforcement failure caused by capability calls in set_user
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Solar Designer <solar@openwall.com> wrote:
> I'm not aware of anyone actually running into this issue and reporting
> it.  The systems that I personally know use suexec along with rlimits
> still run older/distro kernels, so would not yet be affected.
>
> So my mention was based on my understanding of how suexec works, and
> code review.  Specifically, Apache httpd has the setting RLimitNPROC,
> which makes it set RLIMIT_NPROC:
>
> https://httpd.apache.org/docs/2.4/mod/core.html#rlimitnproc
>
> The above documentation for it includes:
>
> "This applies to processes forked from Apache httpd children servicing
> requests, not the Apache httpd children themselves. This includes CGI
> scripts and SSI exec commands, but not any processes forked from the
> Apache httpd parent, such as piped logs."
>
> In code, there are:
>
> ./modules/generators/mod_cgid.c:        ( (cgid_req.limits.limit_nproc_set) && ((rc = apr_procattr_limit_set(procattr, APR_LIMIT_NPROC,
> ./modules/generators/mod_cgi.c:        ((rc = apr_procattr_limit_set(procattr, APR_LIMIT_NPROC,
> ./modules/filters/mod_ext_filter.c:    rv = apr_procattr_limit_set(procattr, APR_LIMIT_NPROC, conf->limit_nproc);
>
> For example, in mod_cgi.c this is in run_cgi_child().
>
> I think this means an httpd child sets RLIMIT_NPROC shortly before it
> execs suexec, which is a SUID root program.  suexec then switches to the
> target user and execs the CGI script.
>
> Before 2863643fb8b9, the setuid() in suexec would set the flag, and the
> target user's process count would be checked against RLIMIT_NPROC on
> execve().  After 2863643fb8b9, the setuid() in suexec wouldn't set the
> flag because setuid() is (naturally) called when the process is still
> running as root (thus, has those limits bypass capabilities), and
> accordingly execve() would not check the target user's process count
> against RLIMIT_NPROC.

In commit 2863643fb8b9 ("set_user: add capability check when
rlimit(RLIMIT_NPROC) exceeds") capable calls were added to set_user to
make it more consistent with fork.  Unfortunately because of call site
differences those capables calls were checking the credentials of the
user before set*id() instead of after set*id().

This breaks enforcement of RLIMIT_NPROC for applications that set the
rlimit and then call set*id() while holding a full set of
capabilities.  The capabilities are only changed in the new credential
in security_task_fix_setuid().

The code in apache suexec appears to follow this pattern.

Commit 909cc4ae86f3 ("[PATCH] Fix two bugs with process limits
(RLIMIT_NPROC)") where this check was added describes the targes of this
capability check as:

  2/ When a root-owned process (e.g. cgiwrap) sets up process limits and then
      calls setuid, the setuid should fail if the user would then be running
      more than rlim_cur[RLIMIT_NPROC] processes, but it doesn't.  This patch
      adds an appropriate test.  With this patch, and per-user process limit
      imposed in cgiwrap really works.

So the original use case also of this check also appears to match the broken
pattern.

Restore the enforcement of RLIMIT_NPROC by removing the bad capable
checks added in set_user.  This unfortunately restores the
inconsistencies state the code has been in for the last 11 years, but
dealing with the inconsistencies looks like a larger problem.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20210907213042.GA22626@openwall.com/
Link: https://lkml.kernel.org/r/20220212221412.GA29214@openwall.com
Fixes: 2863643fb8b9 ("set_user: add capability check when rlimit(RLIMIT_NPROC) exceeds")
History-Tree: https://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/sys.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index ecc4cf019242..8dd938a3d2bf 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -480,8 +480,7 @@ static int set_user(struct cred *new)
 	 * failure to the execve() stage.
 	 */
 	if (is_ucounts_overlimit(new->ucounts, UCOUNT_RLIMIT_NPROC, rlimit(RLIMIT_NPROC)) &&
-			new_user != INIT_USER &&
-			!capable(CAP_SYS_RESOURCE) && !capable(CAP_SYS_ADMIN))
+			new_user != INIT_USER)
 		current->flags |= PF_NPROC_EXCEEDED;
 	else
 		current->flags &= ~PF_NPROC_EXCEEDED;
-- 
2.29.2

