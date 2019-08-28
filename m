From: Jeff Layton <jlayton@kernel.org>
Subject: Re: [PATCH RESEND v11 7/8] open: openat2(2) syscall
Date: Wed, 28 Aug 2019 11:55:47 -0400
Message-ID: <4da231cd52880991d8a038adb8fbb2ef3d724db9.camel@kernel.org>
References: <20190820033406.29796-1-cyphar@cyphar.com>
         <20190820033406.29796-8-cyphar@cyphar.com> <854l2366zp.fsf@catern.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <854l2366zp.fsf@catern.com>
Sender: linux-kernel-owner@vger.kernel.org
To: sbaugh@catern.com, linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org, linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, linuxppc-dev@ozlabs.org, linux-sh@vger.kernel.org, sparclinux@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, 2019-08-26 at 19:50 +0000, sbaugh@catern.com wrote:
> Aleksa Sarai <cyphar@cyphar.com> writes:
> > To this end, we introduce the openat2(2) syscall. It provides all of the
> > features of openat(2) through the @how->flags argument, but also
> > also provides a new @how->resolve argument which exposes RESOLVE_* flags
> > that map to our new LOOKUP_* flags. It also eliminates the long-standing
> > ugliness of variadic-open(2) by embedding it in a struct.
> 
> I don't like this usage of a structure in memory to pass arguments that
> would fit in registers. This would be quite inconvenient for me as a
> userspace developer.
> 
> Others have brought up issues with this: the issue of seccomp, and the
> issue of mismatch between the userspace interface and the kernel
> interface, are the most important for me. I want to add another,
> admittedly somewhat niche, concern.
> 
> This interfaces requires a program to allocate memory (even on the
> stack) just to pass arguments to the kernel which could be passed
> without allocating that memory. That makes it more difficult and less
> efficient to use this syscall in any case where memory is not so easily
> allocatable: such as early program startup or assembly, where the stack
> may be limited in size or not even available yet, or when injecting a
> syscall while ptracing.
> 
> A struct-passing interface was needed for clone, since we ran out of
> registers; but we have not run out of registers yet for openat, so it
> would be nice to avoid this if we can. We can always expand later...
> 

We can't really expand later like you suggest.

Suppose in a couple of years that we need to add some new argument to
openat2 that isn't just a new flag. If all these values are passed by
individual arguments, you can't add one later without adding yet another
syscall.

Using a struct for this allows this to be extended later, OTOH. You can
extend it, and add a flag that tells the kernel that it can access the
new field. No new syscall required.
-- 
Jeff Layton <jlayton@kernel.org>
