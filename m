From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH v3 3/3] tests: add close_range() tests
Date: Tue, 28 May 2019 13:22:10 +1000
Message-ID: <87zhn7p8kd.fsf@concordia.ellerman.id.au>
References: <20190524111047.6892-1-christian@brauner.io> <20190524111047.6892-4-christian@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190524111047.6892-4-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, fweimer@redhat.com
Cc: jannh@google.com, oleg@redhat.com, tglx@linutronix.de, arnd@arndb.de, shuah@kernel.org, dhowells@redhat.com, tkjos@android.com, ldv@altlinux.org, miklos@szeredi.hu, Christian Brauner <christian@brauner.io>, linux-api@vger.kernel.org, linux-kselftest@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Christian Brauner <christian@brauner.io> writes:
> This adds basic tests for the new close_range() syscall.
> - test that no invalid flags can be passed
> - test that a range of file descriptors is correctly closed
> - test that a range of file descriptors is correctly closed if there there
>   are already closed file descriptors in the range
> - test that max_fd is correctly capped to the current fdtable maximum
>
> Signed-off-by: Christian Brauner <christian@brauner.io>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Jann Horn <jannh@google.com>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Dmitry V. Levin <ldv@altlinux.org>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Florian Weimer <fweimer@redhat.com>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: linux-api@vger.kernel.org
> Cc: linux-kselftest@vger.kernel.org
> ---
> v1: unchanged
> v2:
> - Christian Brauner <christian@brauner.io>:
>   - verify that close_range() correctly closes a single file descriptor
> v3:
> - Christian Brauner <christian@brauner.io>:
>   - add missing Cc for Shuah
>   - add missing Cc for linux-kselftest

Sorry I replied to v2, but I think my comments still apply:

https://lore.kernel.org/lkml/8736kzqpdm.fsf@concordia.ellerman.id.au/

cheers
