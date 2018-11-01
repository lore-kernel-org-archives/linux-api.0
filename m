From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: RFC: userspace exception fixups
Date: Thu, 1 Nov 2018 12:10:35 -0700
Message-ID: <CAHk-=wgFo8tuZX5gzCfWGdAwGyn_Ar9JFnnMFNuwr9=vtfDV1g@mail.gmail.com>
References: <CALCETrWdpoDkbZjkucKL91GWpDPG9p=VqYrULade2pFDR7S=GQ@mail.gmail.com>
 <CAG48ez0vBqL0tyfWwmuc_cq+OAUoEi88=r+t6h64a-Fw8z59zA@mail.gmail.com> <20181101185225.GC5150@brightrain.aerifal.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181101185225.GC5150@brightrain.aerifal.cx>
Sender: linux-kernel-owner@vger.kernel.org
To: dalias@libc.org
Cc: Jann Horn <jannh@google.com>, luto@kernel.org, dave.hansen@linux.intel.com, sean.j.christopherson@intel.com, jethro@fortanix.com, jarkko.sakkinen@linux.intel.com, fweimer@redhat.com, linux-api@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com, shay.katz-zamir@intel.com, linux-sgx@vger.kernel.org, andriy.shevchenko@linux.intel.com, tglx@linutronix.de, Ingo Molnar <mingo@redhat.com>, bp@alien8.de, carlos@redhat.com, adhemerval.zanella@linaro.org
List-Id: linux-api@vger.kernel.org

On Thu, Nov 1, 2018 at 11:52 AM Rich Felker <dalias@libc.org> wrote:
>
> There's no need to chain if the handler is specific to the context
> where the fault happens. You just replace the handler with the one
> relevant to the code you're about to run before you run it.

That's much too expensive to do as a system call.

Maybe an rseq-like "register an area where exception information will
be found" and then you can just swap in a pointer there (and nest with
previous pointers).

But even that doesn't work. Maybe some library wants to capture page
faults because they write-protected some area and want to log writes
and then emulate them (or just enable them after logging - statistical
logging is a thing).

And then another library (or just nested code) wants to handle the
eenter fault, so it overwrites the page handler fault. What do you do
if you now get a page fault before you even do the eenter?

The whole "one global error handler" model is broken. It's broken even
if the "global" one is just per-thread. Don't do it.

Even signals didn't make *that* bad a mistake, and signals are horrible.

                        Linus
