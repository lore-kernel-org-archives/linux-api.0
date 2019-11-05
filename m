From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [RFC v2 PATCH] futex: extend set_robust_list to allow 2 locking ABIs at the same time.
Date: Tue, 05 Nov 2019 10:48:39 +0100
Message-ID: <87woceslfs.fsf@oldenburg2.str.redhat.com>
References: <20191104002909.25783-1-shawn@git.icu>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191104002909.25783-1-shawn@git.icu> (Shawn Landden's message
        of "Sun, 3 Nov 2019 16:29:09 -0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Shawn Landden <shawn@git.icu>
Cc: Thomas Gleixner <tglx@linutronix.de>, libc-alpha@sourceware.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Deepa Dinamani <deepa.kernel@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Keith Packard <keithp@keithp.com>
List-Id: linux-api@vger.kernel.org

* Shawn Landden:

> If this new ABI is used, then bit 1 of the *next pointer of the
> user-space robust_list indicates that the futex_offset2 value should
> be used in place of the existing futex_offset.

The futex interface currently has some races which can only be fixed by
API changes.  I'm concerned that we sacrifice the last bit for some
rather obscure feature.  What if we need that bit for fixing the
correctness issues?

Thanks,
Florian
