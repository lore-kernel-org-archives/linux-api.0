Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C71D4C433F5
	for <linux-api@archiver.kernel.org>; Wed,  3 Nov 2021 19:32:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A168B6112E
	for <linux-api@archiver.kernel.org>; Wed,  3 Nov 2021 19:32:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbhKCTfe (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 3 Nov 2021 15:35:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:34376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229697AbhKCTfd (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Wed, 3 Nov 2021 15:35:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9ED6261050;
        Wed,  3 Nov 2021 19:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635967976;
        bh=9c8U+TyXsWgnPCQtNOL82QJz48oTyRmpx/f8NpjyETY=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=X7VRxf7vJZED1sh+Cef3WPDcMbSfJMM08q5Qu+cEo2/sY4dA4AftfUdXyRgcdumM7
         5NCV9jn1roGhwx9xmXNdoGSmawJw7prUR3bKm4eWxz4KhCFu0ba950Qp2Jy8z4S5I1
         Van0nttBpT87z8zDhBP0ECJjcAGinnP6K+lVTETy3x/GYr4Ie2A1opTQBn5580y4wM
         puxM4cNqRgrKZ2CEQVkiiOk2vdQRC5TD5kzGKAHYkfOYg5XkkxqqY3oFM3cKNMJ1Ls
         Za6JTRNuB3aAaro5K2/jIT5YxoTFnu8kKYXyg7eyyyOJ3hZMSiuZmv0oS/LNoITGX3
         +ZYALrgVSe+Ag==
Subject: Re: [GIT PULL] per signal_struct coredumps
From:   pr-tracker-bot@kernel.org
In-Reply-To: <878ry512iv.fsf@disp2133>
References: <878ry512iv.fsf@disp2133>
X-PR-Tracked-List-Id: <linux-api.vger.kernel.org>
X-PR-Tracked-Message-Id: <878ry512iv.fsf@disp2133>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git per_signal_struct_coredumps-for-v5.16
X-PR-Tracked-Commit-Id: 3f66f86bfed33dee2e9c1d0e14486915bb0750b0
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a602285ac11b019e9ce7c3907328e9f95f4967f0
Message-Id: <163596797652.1590.12752173027793996526.pr-tracker-bot@kernel.org>
Date:   Wed, 03 Nov 2021 19:32:56 +0000
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Kees Cook <keescook@chromium.org>, linux-api@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

The pull request you sent on Wed, 03 Nov 2021 14:07:36 -0500:

> git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git per_signal_struct_coredumps-for-v5.16

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a602285ac11b019e9ce7c3907328e9f95f4967f0

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
