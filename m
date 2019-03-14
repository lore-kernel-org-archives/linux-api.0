From: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Subject: [PATCH -manpage 0/2]
Date: Thu, 14 Mar 2019 17:48:42 -0400
Message-ID: <20190314214844.207430-1-joel@joelfernandes.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, mtk.manpages@gmail.com
Cc: "Joel Fernandes (Google)" <joel@joelfernandes.org>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, dancol@google.com, Jann Horn <jannh@google.com>, John Stultz <john.stultz@linaro.org>, kernel-team@android.com, linux-api@vger.kernel.org, linux-man@vger.kernel.org, linux-mm@kvack.org, Matthew Wilcox <willy@infradead.org>, Mike Kravetz <mike.kravetz@oracle.com>, Shuah Khan <shuah@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>
List-Id: linux-api@vger.kernel.org

This documentation is for F_SEAL_FUTURE_WRITE patches that are in linux-next.

Joel Fernandes (Google) (2):
fcntl.2: Update manpage with new memfd F_SEAL_FUTURE_WRITE seal
memfd_create.2: Update manpage with new memfd F_SEAL_FUTURE_WRITE seal

man2/fcntl.2        | 15 +++++++++++++++
man2/memfd_create.2 | 15 ++++++++++++++-
2 files changed, 29 insertions(+), 1 deletion(-)

--
2.21.0.360.g471c308f928-goog
