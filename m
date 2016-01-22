From: Paul Moore <paul@paul-moore.com>
Subject: Re: Re: [RFC PATCH 1/1] seccomp: provide
 information about the previous syscall
Date: Fri, 22 Jan 2016 17:10:53 -0500
Message-ID: <CAHC9VhTM7rK2j3Ge1-XbQ5D74gm=P4CaB5mb06UbjCsAN4RnwA@mail.gmail.com>
References: <1453444200-8604-1-git-send-email-daniel.sangorrin@toshiba.co.jp>
	<1453444200-8604-2-git-send-email-daniel.sangorrin@toshiba.co.jp>
	<20160122173050.GE9608@ast-mbp.thefacebook.com>
	<CAGXu5jKbghS7e0sxRt1hEnancaNo-rXQAJrM_NKUwpivFs6sSw@mail.gmail.com>
Reply-To: kernel-hardening@lists.openwall.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kernel-hardening-return-2433-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <CAGXu5jKbghS7e0sxRt1hEnancaNo-rXQAJrM_NKUwpivFs6sSw@mail.gmail.com>
To: kernel-hardening@lists.openwall.com
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>, Daniel Sangorrin <daniel.sangorrin@toshiba.co.jp>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jan 22, 2016 at 4:23 PM, Kees Cook <keescook@chromium.org> wrote:
> Yeah, and if we break abi, we need to add further sanity checking to
> the parser to determine which "version" of seccomp_data we need. I'm
> not convinced that there is enough utility here to break ABI.

PLEASE do not break the seccomp ABI for this alone ... I'm still
trying to sort out the well intentioned, but extremely annoying
direct-wired x86 socket syscalls in 4.4 for libseccomp, I don't want
to have to deal with another big change for at least a month or two ;)

> (Though if we do, I'd like to add tid to the seccomp_data, which has
> been requested in the past to make some pid-based arg checks easier to
> do.)

Agreed, if we break anything, please add this.

-- 
paul moore
www.paul-moore.com
