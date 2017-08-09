From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v3 0/4] seccomp: Add SECCOMP_FILTER_FLAG_KILL_PROCESS
Date: Wed,  9 Aug 2017 12:01:53 -0700
Message-ID: <1502305317-85052-1-git-send-email-keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Tyler Hicks <tyhicks@canonical.com>, Fabricio Voznika <fvoznika@google.com>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Tycho Andersen <tycho@docker.com>, Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org, linux-security-module@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This series is the result of Fabricio and I going around a few times
on possible solutions for finding a way to enhance RET_KILL to kill
the process group. There's a lot of ways this could be done, but I
wanted something that felt cleanest. As it happens, Tyler's recent
patch series for logging improvement also needs to know a litte bit
more during filter runs, and the solution for both is to pass back
the matched filter. This lets us examine it here for RET_KILL and
in the future for logging changes.

The filter passing is patch 1, the new flag for RET_KILL is patch 2.
Some test refactoring is in patch 3 for the RET_DATA ordering, and
patch 4 is the test for the new RET_KILL flag.

One thing missing is that CRIU will likely need to be updated, since
saving/restoring seccomp filter _rules_ will not include the filter
_flags_ for a process. This can be addressed separately.

Please take a look!

Thanks,

-Kees

v3:
- adjust seccomp_run_filters() to avoid later filters from masking
  kill-process RET_KILL actions (drewry)
- add test for masked RET_KILL.

v2:
- moved kill_process bool into struct padding gap (tyhicks)
- improved comments/docs in various places for clarify (tyhicks)
- use ASSERT_TRUE() for WIFEXITED and WIFSIGNALLED (tyhicks)
- adding Reviewed-bys from tyhicks
