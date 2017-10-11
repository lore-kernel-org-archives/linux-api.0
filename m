From: Dave Martin <Dave.Martin-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v3 26/28] arm64/sve: Add documentation
Date: Wed, 11 Oct 2017 12:08:11 +0100
Message-ID: <20171011110811.GB19485@e103592.cambridge.arm.com>
References: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
 <1507660725-7986-27-git-send-email-Dave.Martin@arm.com>
 <59DDE958.4080605@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <59DDE958.4080605-5wv7dgnIgG8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Szabolcs Nagy <szabolcs.nagy-5wv7dgnIgG8@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Richard Sandiford <richard.sandiford-5wv7dgnIgG8@public.gmane.org>, Okamoto Takayuki <tokamoto-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Alan Hayward <alan.hayward-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Oct 11, 2017 at 10:50:16AM +0100, Szabolcs Nagy wrote:
> On 10/10/17 19:38, Dave Martin wrote:
> > This patch adds basic documentation of the user/kernel interface
> > provided by the for SVE.
> > 
> > Signed-off-by: Dave Martin <Dave.Martin-5wv7dgnIgG8@public.gmane.org>
> > Cc: Alex Bennée <alex.bennee-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
> > Cc: Alan Hayward <alan.hayward-5wv7dgnIgG8@public.gmane.org>
> > 
> > ---
> > 
> > Changes since v2
> > ----------------
> > 
> > Changes requested by Alan Hayward:
> > 
> >  * Added a note that the caller of PTRACE_SETREGSET will need to do a
> >    GETREGSET if complete certainty about the resulting VL is desired.
> > 
> > ABI changes:
> > 
> >  * Documented the changed return value value semantics for PR_SET_SET_VL
> >    when the PR_SVE_SET_VL_ONEXEC flag is passed.
> > ---
> ...
> > +prctl(PR_SVE_SET_VL, unsigned long arg)
> > +
> > +    Sets the vector length of the calling thread and related flags, where
> > +    arg == vl | flags.
> > +
> > +    vl is the desired vector length, where sve_vl_valid(vl) must be true.
> > +
> > +    flags:
> > +
> > +	PR_SVE_SET_VL_INHERIT
> > +
> > +	    Inherit the current vector length across execve().  Otherwise, the
> > +	    vector length is reset to the system default at execve().  (See
> > +	    Section 9.)
> > +
> > +	PR_SVE_SET_VL_ONEXEC
> > +
> > +	    Defer the requested vector length change until the next execve().
> > +	    This allows launching of a new program with a different vector
> > +	    length, while avoiding runtime side effects in the caller.
> > +
> > +	    This also overrides the effect of PR_SVE_SET_VL_INHERIT for the
> > +	    first execve().
> > +
> > +	    Without PR_SVE_SET_VL_ONEXEC, any outstanding deferred vector
> > +	    length change is cancelled.
> > +
> 
> "next execve" is still ambiguous. (execve has process
> global effect so it may plausibly mean next in the
> process or next in the calling thread)
> 
> "any outstanding deferred vector length change" is
> ambiguous. (it may be for all threads in a process or
> in the calling thread only)
> 
> > +    Return value: a nonnegative on success, or a negative value on error:
> > +	EINVAL: SVE not supported, invalid vector length requested, or
> > +	    invalid flags.
> > +
> > +    On success, the calling thread's vector length is changed to the largest
> > +    value supported by the system that is less than or equal to vl.
> > +    If vl == SVE_VL_MAX, the calling thread's vector length is changed to the
> > +    largest value supported by the system.
> > +
> > +    The returned value describes the resulting configuration, encoded as for
> > +    PR_SVE_GET_VL.  The vector length reported in this value is the new current
> > +    vector length for this thread if PR_SVE_SET_VL_ONEXEC was not passed in the
> > +    input arg; otherwise, the reported vector length is the deferred vector
> > +    length that will be applied at the next exec.
> > +
> ...
> > +9.  System runtime configuration
> > +--------------------------------
> > +
> > +* To mitigate the ABI impact of expansion of the signal frame, a policy
> > +  mechanism is provided for administrators, distro maintainers and developers
> > +  to set the default vector length for userspace processes:
> > +
> > +/proc/cpu/sve_default_vector_length
> > +
> 
> still wrong.

Dang, sorry, I was focusing on the code and completely missed these
documentation changes.

The text actually leaves a fair amount to be desired in some places,
now I look again at it.

How does this look:

diff --git a/Documentation/arm64/sve.txt b/Documentation/arm64/sve.txt
index 2e8f009..27b8833 100644
--- a/Documentation/arm64/sve.txt
+++ b/Documentation/arm64/sve.txt
@@ -75,6 +75,15 @@ the SVE instruction set architecture.
   assumptions about this.  The kernel behaviour may vary on a case-by-case
   basis.
 
+* All other SVE state of a thread, including the currently configured vector
+  length, the state of the PR_SVE_VL_INHERIT flag, and the deferred vector
+  length (if any), is preserved across all syscalls, subject to the specific
+  exceptions for execve() described in section 6.
+
+  In particular, on return from a fork() or clone(), the parent and new child
+  process or thread share identical SVE configuration, matching that of the
+  parent before the call.
+
 
 4.  Signal handling
 -------------------
@@ -136,7 +145,7 @@ length:
 prctl(PR_SVE_SET_VL, unsigned long arg)
 
     Sets the vector length of the calling thread and related flags, where
-    arg == vl | flags.
+    arg == vl | flags.  Other threads of the calling process are unaffected.
 
     vl is the desired vector length, where sve_vl_valid(vl) must be true.
 
@@ -150,36 +159,51 @@ prctl(PR_SVE_SET_VL, unsigned long arg)
 
 	PR_SVE_SET_VL_ONEXEC
 
-	    Defer the requested vector length change until the next execve().
+	    Defer the requested vector length change until the next execve()
+	    performed by this thread.
+
+	    The effect is equivalent to implicit exceution of the following
+	    call immediately after the next execve() (if any) by the thread:
+
+		prctl(PR_SVE_SET_VL, arg & ~PR_SVE_SET_VL_ONEXEC)
+
 	    This allows launching of a new program with a different vector
 	    length, while avoiding runtime side effects in the caller.
 
-	    This also overrides the effect of PR_SVE_SET_VL_INHERIT for the
-	    first execve().
 
-	    Without PR_SVE_SET_VL_ONEXEC, any outstanding deferred vector
-	    length change is cancelled.
+	    Without PR_SVE_SET_VL_ONEXEC, the requested change takes effect
+	    immediately.
+
 
     Return value: a nonnegative on success, or a negative value on error:
 	EINVAL: SVE not supported, invalid vector length requested, or
 	    invalid flags.
 
-    On success, the calling thread's vector length is changed to the largest
-    value supported by the system that is less than or equal to vl.
-    If vl == SVE_VL_MAX, the calling thread's vector length is changed to the
-    largest value supported by the system.
 
-    The returned value describes the resulting configuration, encoded as for
-    PR_SVE_GET_VL.  The vector length reported in this value is the new current
-    vector length for this thread if PR_SVE_SET_VL_ONEXEC was not passed in the
-    input arg; otherwise, the reported vector length is the deferred vector
-    length that will be applied at the next exec.
+    On success:
+
+    * Either the calling thread's vector length or the deferred vector length
+      to be applied at the next execve() by the thread (dependent on whether
+      PR_SVE_SET_VL_ONEXEC is present in arg), is set to the largest value
+      supported by the system that is less than or equal to vl.  If vl ==
+      SVE_VL_MAX, the value set will be the largest value supported by the
+      system.
+
+    * Any previously outstanding deferred vector length change in the calling
+      thread is cancelled.
+
+    * The returned value describes the resulting configuration, encoded as for
+      PR_SVE_GET_VL.  The vector length reported in this value is the new
+      current vector length for this thread if PR_SVE_SET_VL_ONEXEC was not
+      present in arg; otherwise, the reported vector length is the deferred
+      vector length that will be applied at the next execve() by the calling
+      thread.
 
-    Changing the vector length causes all of P0..P15, FFR and all bits of
-    Z0..V31 except for Z0 bits [127:0] .. Z31 bits [127:0] to become
-    unspecified.  Calling PR_SVE_SET_VL with vl equal to the thread's current
-    vector length does not constitute a change to the vector length for this
-    purpose.
+    * Changing the vector length causes all of P0..P15, FFR and all bits of
+      Z0..V31 except for Z0 bits [127:0] .. Z31 bits [127:0] to become
+      unspecified.  Calling PR_SVE_SET_VL with vl equal to the thread's current
+      vector length, or calling PR_SVE_SET_VL with the PR_SVE_SET_VL_ONEXEC
+      flag, does not constitute a change to the vector length for this purpose.
 
 
 prctl(PR_SVE_GET_VL)
@@ -315,7 +339,7 @@ The regset data starts with struct user_sve_header, containing:
   mechanism is provided for administrators, distro maintainers and developers
   to set the default vector length for userspace processes:
 
-/proc/cpu/sve_default_vector_length
+/proc/sys/abi/sve_default_vector_length
 
     Writing the text representation of an integer to this file sets the system
     default vector length to the specified value, unless the value is greater
