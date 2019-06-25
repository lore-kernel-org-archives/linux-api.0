From: Kees Cook <keescook@chromium.org>
Subject: Re: Detecting the availability of VSYSCALL
Date: Tue, 25 Jun 2019 13:08:07 -0700
Message-ID: <201906251131.419D8ACB@keescook>
References: <87v9wty9v4.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-hardening-return-16232-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
Content-Disposition: inline
In-Reply-To: <87v9wty9v4.fsf@oldenburg2.str.redhat.com>
To: Florian Weimer <fweimer@redhat.com>
Cc: linux-api@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-x86_64@vger.kernel.org, linux-arch@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, Carlos O'Donell <carlos@redhat.com>
List-Id: linux-api@vger.kernel.org

On Tue, Jun 25, 2019 at 05:15:27PM +0200, Florian Weimer wrote:
> Should we try mapping something at the magic address (without MAP_FIXED)
> and see if we get back a different address?  Something in the auxiliary
> vector would work for us, too, but nothing seems to exists there
> unfortunately.

It seems like mmap() won't even work because it's in the high memory
area. I can't map something a page under the vsyscall page either, so I
can't distinguish it with mmap, mprotect, madvise, or msync. :(

-- 
Kees Cook
