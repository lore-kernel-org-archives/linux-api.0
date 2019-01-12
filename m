From: Joel Fernandes <joel@joelfernandes.org>
Subject: [PATCH v4 0/2] Add a future write seal to memfd
Date: Sat, 12 Jan 2019 15:38:14 -0500
Message-ID: <20190112203816.85534-1-joel@joelfernandes.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "Joel Fernandes (Google)" <joel@joelfernandes.org>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, dancol@google.com, Hugh Dickins <hughd@google.com>, Jann Horn <jannh@google.com>, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@kernel.org>, John Stultz <john.stultz@linaro.org>, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-mm@kvack.org, =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>, Matthew Wilcox <willy@infradead.org>, Mike Kravetz <mike.kravetz@oracle.com>, minchan@kernel.org, Shuah Khan <shuah@kernel.org>
List-Id: linux-api@vger.kernel.org

From: "Joel Fernandes (Google)" <joel@joelfernandes.org>

This is just a resend of the previous series at
https://lore.kernel.org/patchwork/patch/1014892/
with a small if block refactor as Andy suggested:
https://lore.kernel.org/patchwork/comment/1198679/

All,
Could you please provide your Reviewed-by / Acked-by tags?

I will also resend the manpage changes shortly.

Joel Fernandes (Google) (2):
mm/memfd: Add an F_SEAL_FUTURE_WRITE seal to memfd
selftests/memfd: Add tests for F_SEAL_FUTURE_WRITE seal

fs/hugetlbfs/inode.c                       |  2 +-
include/uapi/linux/fcntl.h                 |  1 +
mm/memfd.c                                 |  3 +-
mm/shmem.c                                 | 25 +++++++-
tools/testing/selftests/memfd/memfd_test.c | 74 ++++++++++++++++++++++
5 files changed, 100 insertions(+), 5 deletions(-)

--
2.20.1.97.g81188d93c3-goog
