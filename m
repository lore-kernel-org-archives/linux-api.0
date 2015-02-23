From: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH] capabilities: Ambient capability set V1
Date: Mon, 23 Feb 2015 10:41:51 -0600 (CST)
Message-ID: <alpine.DEB.2.11.1502231040270.21784@gentwo.org>
References: <alpine.DEB.2.11.1502051554500.4876@gentwo.org> <alpine.DEB.2.11.1502230856400.21238@gentwo.org> <CALCETrWJCcBBGGp21C4cdtiU79K-P3t+6rFJUWcXcLR1jqrrFQ@mail.gmail.com> <alpine.DEB.2.11.1502230950440.21238@gentwo.org>
 <CALCETrUR7+44ie2fiy0BzC3ktLQ2dcArSL-O3AHnp8kFF92fjg@mail.gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <CALCETrUR7+44ie2fiy0BzC3ktLQ2dcArSL-O3AHnp8kFF92fjg@mail.gmail.com>
Sender: linux-security-module-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Serge Hallyn <serge.hallyn@canonical.com>, Aaron Jones <aaronmdjones@gmail.com>, Ted Ts'o <tytso@mit.edu>, LSM List <linux-security-module@vger.kernel.org>, Andrew Morton <akpm@linuxfoundation.org>, "Andrew G. Morgan" <morgan@kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Markku Savela <msa@moth.iki.fi>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Jonathan Corbet <corbet@lwn.net>
List-Id: linux-api@vger.kernel.org

On Mon, 23 Feb 2015, Andy Lutomirski wrote:

> If you set ambient caps and then run a setuid program (without
> no_new_privs), then the ambient set *must* be cleared by the kernel
> because that's what the setuid program expects.  Yes, the whole

Why would a setuid program expect that? I'd say we expect the ambient set
to remain in effect. What would break if the ambient set would stay
active?

