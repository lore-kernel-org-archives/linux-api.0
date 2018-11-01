From: Rich Felker <dalias@libc.org>
Subject: Re: RFC: userspace exception fixups
Date: Thu, 1 Nov 2018 15:31:07 -0400
Message-ID: <20181101193107.GE5150@brightrain.aerifal.cx>
References: <CALCETrWdpoDkbZjkucKL91GWpDPG9p=VqYrULade2pFDR7S=GQ@mail.gmail.com>
 <CAG48ez0vBqL0tyfWwmuc_cq+OAUoEi88=r+t6h64a-Fw8z59zA@mail.gmail.com>
 <20181101185225.GC5150@brightrain.aerifal.cx>
 <CAHk-=wgFo8tuZX5gzCfWGdAwGyn_Ar9JFnnMFNuwr9=vtfDV1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHk-=wgFo8tuZX5gzCfWGdAwGyn_Ar9JFnnMFNuwr9=vtfDV1g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jann Horn <jannh@google.com>, luto@kernel.org, dave.hansen@linux.intel.com, sean.j.christopherson@intel.com, jethro@fortanix.com, jarkko.sakkinen@linux.intel.com, fweimer@redhat.com, linux-api@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com, shay.katz-zamir@intel.com, linux-sgx@vger.kernel.org, andriy.shevchenko@linux.intel.com, tglx@linutronix.de, Ingo Molnar <mingo@redhat.com>, bp@alien8.de, carlos@redhat.com, adhemerval.zanella@linaro.org
List-Id: linux-api@vger.kernel.org

On Thu, Nov 01, 2018 at 12:10:35PM -0700, Linus Torvalds wrote:
> On Thu, Nov 1, 2018 at 11:52 AM Rich Felker <dalias@libc.org> wrote:
> >
> > There's no need to chain if the handler is specific to the context
> > where the fault happens. You just replace the handler with the one
> > relevant to the code you're about to run before you run it.
> 
> That's much too expensive to do as a system call.

See my other emails in this thread. You would register the *address*
(in TLS) of a function pointer object pointing to the handler, rather
than the function address of the handler. Then switching handler is
just a single store in userspace, no syscalls involved.

Rich
