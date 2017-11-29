From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH v5 00/30] ARM Scalable Vector Extension (SVE)
Date: Wed, 29 Nov 2017 15:04:12 +0000
Message-ID: <877eu9dt3n.fsf@linaro.org>
References: <1509465082-30427-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-arch-owner@vger.kernel.org>
In-reply-to: <1509465082-30427-1-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, kvmarm@lists.cs.columbia.edu, libc-alpha@sourceware.org, linux-arch@vger.kernel.org, Alan Hayward <alan.hayward@arm.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christoffer Dall <christoffer.dall@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Oleg Nesterov <oleg@redhat.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, "H . J . Lu" <hjl.tools@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk <mtk.manpages@gmail.com>, linux-api@vg
List-Id: linux-api@vger.kernel.org


Dave Martin <Dave.Martin@arm.com> writes:

> This series implements Linux kernel support for the ARM Scalable Vector
> Extension (SVE). [1]  It supersedes the previous v3: see [3] for link
> and full cover letter.
>
> This is a minor update to v4, but does contain a couple of important
> fixes.
<snip>

I seem to have run into a regression with normal non-SVE sigcontexts
while trying to run consecutive RISU runs in the Foundation Model. I'm
failing to get repeatable results playing back a previous --master run.
It works OK with the default Debian kernel.

What is the current status of the tree? I'd like to try an narrow it
down but I seem to recall it was now in a next tree somewhere?
