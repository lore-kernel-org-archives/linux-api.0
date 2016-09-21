From: Kyle Huey <me-OhBmq/TcCDJWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v5 0/6] x86/arch_prctl Add ARCH_[GET|SET]_CPUID for controlling the CPUID instruction
Date: Wed, 21 Sep 2016 11:58:18 -0700
Message-ID: <20160921185824.18980-1-khuey@kylehuey.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert O'Callahan <robert-7ok7fSEJICeEi8DpZVb4nw@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Jeff Dike <jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Dmitry Safonov <dsafonov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Rafael J . Wysocki" <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Srinivas Pandruvada <srinivas.pandruvada-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, user-mode-linux-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, user-mode-linux-user-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

rr (http://rr-project.org/), a userspace record-and-replay reverse-
execution debugger, would like to trap and emulate the CPUID instruction.
This would allow us to a) mask away certain hardware features that rr does
not support (e.g. RDRAND) and b) enable trace portability across machines
by providing constant results.

Newer Intel CPUs (Ivy Bridge and later) can fault when CPUID is executed at
CPL > 0.  Expose this capability to userspace as a new pair of arch_prctls,
ARCH_GET_CPUID and ARCH_SET_CPUID, with two values, ARCH_CPUID_ENABLE and
ARCH_CPUID_SIGSEGV.

The following changes have been made since v4:

Patch 1:
- Fix missing include on 64bit UML.

Patch 6:
- Fix comment in the test that still referred to an earlier design of the API.

The following changes have been made since v3:

Patch 1 was split into patches 1-4, patches 2 and 3 became patches 5 and 6,
respectively.

Patch 1:
- Use SYSCALL_DEFINE in UML.

Patch 2:
- More descriptive commit message.

Patch 3:
- More decriptive commit message.
- Name the common arch_prctl function do_arch_prctl instead of
  do_arch_prctl_common

Patch 4:
- Move the 32-bit syscall entry point to process_32.c, place the compat
  entry point in process_64.c

Patch 5 (previously Patch 2):
- More descriptive commit message.
- Prefix the #define for the cpuid faulting bit with PLATINFO
- supports_cpuid_faulting returns bool
- Rearrange supports_cpuid_faulting to avoid linebreaks

Patch 6 (previously Patch 3):
- ARCH_GET_CPUID now takes 0 for the second argument, and returns the
  result directly.
- arch_post_exec is now a #define, called from setup_new_exec
- The test now uses errx
- The test now checks that ARCH_GET_CPUID returns ARCH_CPUID_SIGSEGV after
  fork()
