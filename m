From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: [GIT PULL] kselftest fixes for 3.19
Date: Mon, 29 Dec 2014 12:42:09 -0700
Message-ID: <54A1AE91.4020909@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "open list:KERNEL SELFTEST F..." <linux-api@vger.kernel.org>, shuahkh@osg.samsung.com
List-Id: linux-api@vger.kernel.org

Hi Linus,

Please pull the following kselftest fix for 3.19.

thanks,
-- Shuah

The following changes since commit 97bf6af1f928216fd6c5a66e8a57bfa95a659672:

  Linux 3.19-rc1 (2014-12-20 17:08:50 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest
tags/linux-kselftest-3.19-fixes

for you to fetch changes up to 6898b627aab6ba553e6d8b40a0b1ddc43c48d42f:

  selftests/exec: Use %zu to format size_t (2014-12-22 11:11:36 -0700)

----------------------------------------------------------------
kselftest fixes for: 3.19

Fix exec test compile warnings.

----------------------------------------------------------------
Geert Uytterhoeven (1):
      selftests/exec: Use %zu to format size_t

 tools/testing/selftests/exec/execveat.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
