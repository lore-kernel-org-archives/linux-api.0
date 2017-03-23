From: Thomas Garnier <thgarnie@google.com>
Subject: Re: [PATCH v5 2/4] x86/syscalls: Specific usage of verify_pre_usermode_state
Date: Thu, 23 Mar 2017 13:36:48 -0700
Message-ID: <CAJcbSZHo-PTbFJW66VWY0F55ajBF+cFKUq5uZp7WESicA_QTUA@mail.gmail.com>
References: <20170323172515.27950-1-thgarnie@google.com> <20170323172515.27950-2-thgarnie@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kernel-hardening-return-7089-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20170323172515.27950-2-thgarnie@google.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, David Howells <dhowells@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Dave Hansen <dave.hansen@intel.com>, Al Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, =?UTF-8?Q?Ren=C3=A9_Nyffenegger?= <mail@renenyffenegger.ch>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Stephen Smalley <sds@tycho.nsa.gov>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Rik van Riel <riel@redhat.com>, Kees Cook <keescook@chromium.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Borislav Petkov <bp@alien>
Cc: linux-s390 <linux-s390@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, linux-arm-kernel@lists.infradead.org, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 23, 2017 at 10:25 AM, Thomas Garnier <thgarnie@google.com> wrote:
> Implement specific usage of verify_pre_usermode_state for user-mode
> returns for x86.

Signed-off-by: Thomas Garnier <thgarnie@google.com>

Not sure why it was not there anymore.

-- 
Thomas
