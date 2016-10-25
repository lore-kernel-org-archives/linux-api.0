From: Kyle Huey <me@kylehuey.com>
Subject: Re: [PATCH v7 0/6] x86/arch_prctl Add ARCH_[GET|SET]_CPUID for
 controlling the CPUID instruction
Date: Mon, 24 Oct 2016 22:30:58 -0700
Message-ID: <CAP045Apcsb3dVJ1PaDpbJSGmtxK23GRijKWFt5qcBxTnzoyMJQ@mail.gmail.com>
References: <20161019020333.3766-1-khuey@kylehuey.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161019020333.3766-1-khuey@kylehuey.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Robert O'Callahan <robert@ocallahan.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>, Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>, Dmitry Safonov <dsafonov@virtuozzo.com>, Peter Zijlstra <peterz@infradead.org>, Dave Hansen <dave.hansen@linux.intel.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Shuah Khan <shuah@kernel.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Len Brown <len.brown@intel.com>
Cc: open list <linux-kernel@vger.kernel.org>, "open list:USER-MODE LINUX (UML)" <user-mode-linux-devel@lists.sourceforge.net>, "open list:USER-MODE LINUX (UML)" <user-mode-linux-user@lists.sourceforge.net>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 18, 2016 at 7:03 PM, Kyle Huey <me@kylehuey.com> wrote:
> rr (http://rr-project.org/), a userspace record-and-replay reverse-
> execution debugger, would like to trap and emulate the CPUID instruction.
> This would allow us to a) mask away certain hardware features that rr does
> not support (e.g. RDRAND) and b) enable trace portability across machines
> by providing constant results.
>
> Newer Intel CPUs (Ivy Bridge and later) can fault when CPUID is executed at
> CPL > 0.  Expose this capability to userspace as a new pair of arch_prctls,
> ARCH_GET_CPUID and ARCH_SET_CPUID, with two values, ARCH_CPUID_ENABLE and
> ARCH_CPUID_SIGSEGV.
>
> v6 did not get any feedback, so I included the changes since v5.
>
> Since v6:
> - Rebased to 4.9-rc1 (primarily over the new VDSO arch_prctls and the new pkey
>   entries in the syscall table)
>
> Since v5:
>
> Patch 3:
> - do_arch_prctl is again do_arch_prctl_common
>
> Patch 6:
> - Added static qualifiers on get/set_cpuid_mode
> - Braced ifs in disable/enable_cpuid
> - Renamed arch_post_exec to arch_setup_new_exec
>

A friendly ping.  Has anybody had an opportunity to look at this patch
series again?  Any feedback, positive or negative, would be greatly
appreciated.

- Kyle
