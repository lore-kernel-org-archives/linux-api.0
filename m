From: Kyle Huey <me-OhBmq/TcCDJWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v7 0/6] x86/arch_prctl Add ARCH_[GET|SET]_CPUID for controlling the CPUID instruction
Date: Tue, 18 Oct 2016 19:03:27 -0700
Message-ID: <20161019020333.3766-1-khuey@kylehuey.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert O'Callahan <robert-7ok7fSEJICeEi8DpZVb4nw@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Jeff Dike <jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Dmitry Safonov <dsafonov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Rafael J. Wysocki" <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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

v6 did not get any feedback, so I included the changes since v5.

Since v6:
- Rebased to 4.9-rc1 (primarily over the new VDSO arch_prctls and the new pkey
  entries in the syscall table)

Since v5:

Patch 3:
- do_arch_prctl is again do_arch_prctl_common

Patch 6:
- Added static qualifiers on get/set_cpuid_mode
- Braced ifs in disable/enable_cpuid
- Renamed arch_post_exec to arch_setup_new_exec
