From: Florian Weimer <fweimer@redhat.com>
Subject: Detecting the availability of VSYSCALL
Date: Tue, 25 Jun 2019 17:15:27 +0200
Message-ID: <87v9wty9v4.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kernel-hardening-return-16224-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
To: linux-api@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-x86_64@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, Carlos O'Donell <carlos@redhat.com>
List-Id: linux-api@vger.kernel.org

We're trying to create portable binaries which use VSYSCALL on older
kernels (to avoid performance regressions), but gracefully degrade to
full system calls on kernels which do not have VSYSCALL support compiled
in (or disabled at boot).

For technical reasons, we cannot use vDSO fallback.  Trying vDSO first
and only then use VSYSCALL is the way this has been tackled in the past,
which is why this userspace ABI breakage goes generally unnoticed.  But
we don't have a dynamic linker in our scenario.

Is there any reliable way to detect that VSYSCALL is unavailable,
without resorting to parsing /proc/self/maps or opening file
descriptors?

Should we try mapping something at the magic address (without MAP_FIXED)
and see if we get back a different address?  Something in the auxiliary
vector would work for us, too, but nothing seems to exists there
unfortunately.

Thanks,
Florian
