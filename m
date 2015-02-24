From: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH] capabilities: Ambient capability set V1
Date: Tue, 24 Feb 2015 09:48:48 -0600 (CST)
Message-ID: <alpine.DEB.2.11.1502240948001.28901@gentwo.org>
References: <alpine.DEB.2.11.1502051554500.4876@gentwo.org> <alpine.DEB.2.11.1502230856400.21238@gentwo.org> <CALCETrWJCcBBGGp21C4cdtiU79K-P3t+6rFJUWcXcLR1jqrrFQ@mail.gmail.com> <alpine.DEB.2.11.1502230950440.21238@gentwo.org>
 <CALCETrUR7+44ie2fiy0BzC3ktLQ2dcArSL-O3AHnp8kFF92fjg@mail.gmail.com> <alpine.DEB.2.11.1502231040270.21784@gentwo.org> <CALCETrXnBvxG7i9A1Q8oS7kr8TG+FuGJMRVBQ_gFsxM6u=qdDA@mail.gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrXnBvxG7i9A1Q8oS7kr8TG+FuGJMRVBQ_gFsxM6u=qdDA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Ted Ts'o <tytso@mit.edu>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Andrew G. Morgan" <morgan@kernel.org>, Andrew Morton <akpm@linuxfoundation.org>, LSM List <linux-security-module@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Linux API <linux-api@vger.kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Aaron Jones <aaronmdjones@gmail.com>, Serge Hallyn <serge.hallyn@canonical.com>, Markku Savela <msa@moth.iki.fi>, Jonathan Corbet <corbet@lwn.net>
List-Id: linux-api@vger.kernel.org

On Mon, 23 Feb 2015, Andy Lutomirski wrote:

> On Feb 23, 2015 8:41 AM, "Christoph Lameter" <cl@linux.com> wrote:
> >
> > On Mon, 23 Feb 2015, Andy Lutomirski wrote:
> >
> > > If you set ambient caps and then run a setuid program (without
> > > no_new_privs), then the ambient set *must* be cleared by the kernel
> > > because that's what the setuid program expects.  Yes, the whole
> >
> > Why would a setuid program expect that? I'd say we expect the ambient set
> > to remain in effect. What would break if the ambient set would stay
> > active?
> >
>
> On a total guess: exim, sendmail, sudo, Apache suexec, etc.  Basically
> anything that expects setresuid(nonzero values); execve to drop caps.

Really? We have been running these things for years with the approach of
leaving these caps active.
