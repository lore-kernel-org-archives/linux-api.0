From: Joel Fernandes <joel@joelfernandes.org>
Subject: [PATCH -manpage 0/2] Document memfd F_SEAL_FUTURE_WRITE seal
Date: Sat, 12 Jan 2019 19:14:44 -0500
Message-ID: <20190113001446.158789-1-joel@joelfernandes.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, mtk.manpages@gmail.com
Cc: Joel Fernandes <joel@joelfernandes.org>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, dancol@google.com, Hugh Dickins <hughd@google.com>, Jann Horn <jannh@google.com>, John Stultz <john.stultz@linaro.org>, linux-api@vger.kernel.org, linux-man@vger.kernel.org, linux-mm@kvack.org, marcandre.lureau@redhat.com, Matthew Wilcox <willy@infradead.org>, Mike Kravetz <mike.kravetz@oracle.com>, Shuah Khan <shuah@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>
List-Id: linux-api@vger.kernel.org

Hello,

These manpages correspond to the following kernel patches:
https://lore.kernel.org/patchwork/patch/1031550/
https://lore.kernel.org/patchwork/patch/1031551/

This is just a resend with no changes from last time.

Joel Fernandes (Google) (2):
fcntl.2: Update manpage with new memfd F_SEAL_FUTURE_WRITE seal
memfd_create.2: Update manpage with new memfd F_SEAL_FUTURE_WRITE seal

man2/fcntl.2        | 15 +++++++++++++++
man2/memfd_create.2 | 15 ++++++++++++++-
2 files changed, 29 insertions(+), 1 deletion(-)

--
2.20.1.97.g81188d93c3-goog
