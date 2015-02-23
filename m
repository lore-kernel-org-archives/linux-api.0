From: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH] capabilities: Ambient capability set V1
Date: Mon, 23 Feb 2015 10:47:01 -0600 (CST)
Message-ID: <alpine.DEB.2.11.1502231046080.21888@gentwo.org>
References: <alpine.DEB.2.11.1502051554500.4876@gentwo.org> <alpine.DEB.2.11.1502230856400.21238@gentwo.org> <20150223161625.GD25477@ubuntumail> <CALCETrW78805ayUL=ZYBdFwVdDvJZus2JL0VVmEBE8=L1Nm5Sw@mail.gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrW78805ayUL=ZYBdFwVdDvJZus2JL0VVmEBE8=L1Nm5Sw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>, Serge Hallyn <serge.hallyn@canonical.com>, Aaron Jones <aaronmdjones@gmail.com>, Ted Ts'o <tytso@mit.edu>, LSM List <linux-security-module@vger.kernel.org>, Andrew Morton <akpm@linuxfoundation.org>, "Andrew G. Morgan" <morgan@kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Markku Savela <msa@moth.iki.fi>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Jonathan Corbet <corbet@lwn.net>
List-Id: linux-api@vger.kernel.org

On Mon, 23 Feb 2015, Andy Lutomirski wrote:

> Is there really a need to drop privilege and then regain it or is it
> sufficient to keep the privilege permitted (and perhaps ambient, too)
> and just to have execve not drop it for you?  I assume the latter.

I would think just keep the ambient set active as long as there is no
prctl switching the cap off in the child processes. Do not let it be
affected by the usual drop privs stuff.
