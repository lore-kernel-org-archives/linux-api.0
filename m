From: Borislav Petkov <bp@alien8.de>
Subject: Re: a.out coredumping: fix or delete?
Date: Tue, 5 Mar 2019 10:19:04 +0100
Message-ID: <20190305091904.GB8256@zn.tnic>
References: <CAG48ez1RVd5mQ_Pb6eygQESaZhpQz765OAZYSoPE0kPqfZEXQg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAG48ez1RVd5mQ_Pb6eygQESaZhpQz765OAZYSoPE0kPqfZEXQg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, kernel list <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Sat, Mar 02, 2019 at 12:57:30AM +0100, Jann Horn wrote:
> In theory, Linux can dump cores for a.out binaries. In practice, that
> code is pretty bitrotten and buggy. Does anyone want that code so much
> that they'd like to fix it, or can we just delete it?

I was asking myself the same question while doing

  10970e1b4be9 ("x86/a.out: Clear the dump structure initially")

especially since it is kinda hard to get the toolchain to even create an
a.out executable - your script to create one case-in-point.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
