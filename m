From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH] capabilities: Ambient capability set V1
Date: Mon, 23 Feb 2015 07:59:36 -0800
Message-ID: <CALCETrUR7+44ie2fiy0BzC3ktLQ2dcArSL-O3AHnp8kFF92fjg@mail.gmail.com>
References: <alpine.DEB.2.11.1502051554500.4876@gentwo.org>
 <alpine.DEB.2.11.1502230856400.21238@gentwo.org> <CALCETrWJCcBBGGp21C4cdtiU79K-P3t+6rFJUWcXcLR1jqrrFQ@mail.gmail.com>
 <alpine.DEB.2.11.1502230950440.21238@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.11.1502230950440.21238@gentwo.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Lameter <cl@linux.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>, Aaron Jones <aaronmdjones@gmail.com>, Ted Ts'o <tytso@mit.edu>, LSM List <linux-security-module@vger.kernel.org>, Andrew Morton <akpm@linuxfoundation.org>, "Andrew G. Morgan" <morgan@kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Markku Savela <msa@moth.iki.fi>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Jonathan Corbet <corbet@lwn.net>
List-Id: linux-api@vger.kernel.org

On Mon, Feb 23, 2015 at 7:53 AM, Christoph Lameter <cl@linux.com> wrote:
> On Mon, 23 Feb 2015, Andy Lutomirski wrote:
>
>> At the very least, I think it needs to define and implement what
>> happens when a cap is added to ambient and then dropped from
>> permitted. We also may need LSM_UNSAFE_something to clear the ambient
>> set to avoid a major security issue.
>
> The ambient cap needs to stay otherwise we will have issues again if
> another binary/script is forked. IMHO the only way to switch off an
> ambient capability should be another prctl action. The intend is after all
> to have the cap available for all inherited processes.

No, sadly.

If you set ambient caps and then run a setuid program (without
no_new_privs), then the ambient set *must* be cleared by the kernel
because that's what the setuid program expects.  Yes, the whole
concept of setuid is daft, but it exists and we have to keep it
working safely, or at least as safely as it ever worked.

--Andy
