From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: RFC: userspace exception fixups
Date: Thu, 1 Nov 2018 14:24:26 -0700
Message-ID: <CAHk-=wiYSpmDOfpi9n7ETsxK2UrUKfT4kM=Y3yqRSaZuFFPY1A@mail.gmail.com>
References: <CALCETrWdpoDkbZjkucKL91GWpDPG9p=VqYrULade2pFDR7S=GQ@mail.gmail.com>
 <CAG48ez0vBqL0tyfWwmuc_cq+OAUoEi88=r+t6h64a-Fw8z59zA@mail.gmail.com>
 <20181101185225.GC5150@brightrain.aerifal.cx> <CAHk-=wgFo8tuZX5gzCfWGdAwGyn_Ar9JFnnMFNuwr9=vtfDV1g@mail.gmail.com>
 <20181101193107.GE5150@brightrain.aerifal.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181101193107.GE5150@brightrain.aerifal.cx>
Sender: linux-kernel-owner@vger.kernel.org
To: dalias@libc.org
Cc: Jann Horn <jannh@google.com>, luto@kernel.org, dave.hansen@linux.intel.com, sean.j.christopherson@intel.com, jethro@fortanix.com, jarkko.sakkinen@linux.intel.com, fweimer@redhat.com, linux-api@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com, shay.katz-zamir@intel.com, linux-sgx@vger.kernel.org, andriy.shevchenko@linux.intel.com, tglx@linutronix.de, Ingo Molnar <mingo@redhat.com>, bp@alien8.de, carlos@redhat.com, adhemerval.zanella@linaro.org
List-Id: linux-api@vger.kernel.org

On Thu, Nov 1, 2018 at 12:31 PM Rich Felker <dalias@libc.org> wrote:
>
> See my other emails in this thread. You would register the *address*
> (in TLS) of a function pointer object pointing to the handler, rather
> than the function address of the handler. Then switching handler is
> just a single store in userspace, no syscalls involved.

Yes.

And for just EENTER, maybe that's the right model.

If we want to generalize it to other thread-synchronous faults, it
needs way more information and a list of handlers, but if we limit the
thing to _only_ EENTER getting an SGX fault, then a single "this is
the fault handler" address is probably the right thing to do.

                     Linus
