From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v9 1/4] syscalls: Verify address limit before returning
 to user-mode
Date: Mon, 8 May 2017 16:02:30 +0200
Message-ID: <20170508140230.23kxf2kfeazeo4zr@gmail.com>
References: <20170428153213.137279-1-thgarnie@google.com>
 <CAJcbSZGQsRVg3QZ9QfLn2HBC+RP-7fUTab0bYDJ455d8y8GyNw@mail.gmail.com>
 <20170508073352.caqe3fqf7nuxypgi@gmail.com>
 <CAGXu5jKZRESgGhZ6GEoO784Q1G8V0DPcwM1T2PpyTqvEAsrUdg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5jKZRESgGhZ6GEoO784Q1G8V0DPcwM1T2PpyTqvEAsrUdg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Thomas Garnier <thgarnie@google.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, David Howells <dhowells@redhat.com>, =?iso-8859-1?Q?Ren=E9?= Nyffenegger <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Rik van Riel <riel@redhat.com>, Josh Poimboeuf <jpoimboe@redha>
List-Id: linux-api@vger.kernel.org


* Kees Cook <keescook@chromium.org> wrote:

> > And yes, I realize that there were other such bugs and that such bugs might 
> > occur in the future - but why not push the overhead of the security check to 
> > the kernel build phase? I.e. I'm wondering how well we could do static 
> > analysis during kernel build - would a limited mode of Sparse be good enough 
> > for that? Or we could add a new static checker to tools/, built from first 
> > principles and used primarily for extended syntactical checking.
> 
> Static analysis is just not going to cover all cases. We've had vulnerabilities 
> where interrupt handlers left KERNEL_DS set, for example. [...]

Got any commit ID of that bug - was it because a function executed by the 
interrupt handler leaked KERNEL_DS?

> [...] If there are performance concerns, let's put this behind a CONFIG. 2-5 
> instructions is not an issue for most people that want this coverage.

That doesn't really _solve_ the performance concerns, it just forces most people 
to enable it by creating a 'security or performance' false dichotomy ...

> [...] and it still won't catch everything. Bug-finding is different from making 
> a bug class just unexploitable at all. As we've done before, it's the difference 
> between trying to find format string attacks vs just removing %n from the format 
> parser.

No, it does not make it unexploitable, it could still be exploitable if the 
runtime check is buggy or if there's kernel execution outside of the regular 
system call paths - there's plenty of such hardware functionality on x86 for 
example.

Thanks,

	Ingo
