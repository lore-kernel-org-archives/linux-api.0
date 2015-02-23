From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH] capabilities: Ambient capability set V1
Date: Mon, 23 Feb 2015 10:46:23 -0600
Message-ID: <20150223164623.GB32181@mail.hallyn.com>
References: <alpine.DEB.2.11.1502051554500.4876@gentwo.org>
 <alpine.DEB.2.11.1502230856400.21238@gentwo.org>
 <20150223161625.GD25477@ubuntumail>
 <alpine.DEB.2.11.1502231041580.21784@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1502231041580.21784@gentwo.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Lameter <cl@linux.com>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>, Serge Hallyn <serge.hallyn@canonical.com>, Andy Lutomirski <luto@amacapital.net>, Aaron Jones <aaronmdjones@gmail.com>, Ted Ts'o <tytso@mit.edu>, linux-security-module@vger.kernel.org, akpm@linuxfoundation.org, "Andrew G. Morgan" <morgan@kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Markku Savela <msa@moth.iki.fi>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, Jonathan Corbet <corbet@lwn.net>
List-Id: linux-api@vger.kernel.org

On Mon, Feb 23, 2015 at 10:44:32AM -0600, Christoph Lameter wrote:
> On Mon, 23 Feb 2015, Serge Hallyn wrote:
> 
> > The core concern for amorgan is that an unprivileged user not be
> > able to cause a privileged program to run in a way that it fails to
> > drop privilege before running unprivileged-user-provided code.
> 
> I do not see a problem with dropping privilege since the ambient set
> is supposed to be preserved across a drop of priviledge.

Because you're tricking the program into thinking it has dropped
the privilege, when in fact it has not.

> > Since your desire is precisely for a mode where dropping privilege
> > works as usual, but exec then re-gains some or all of that privilege,
> 
> I would say that the ambient set stays active even if the setuid binary
> drops to regular perms.
> 
> > we need to either agree on a way to enter that mode that ordinary
> > use caes can't be tricked into using, or find a way for legacy
> > users to be tpiped off as to what's going on (without having to be
> > re-written)
> 
> Well if the ambient set is completely separate then the existing
> semantics are preserved while the ambient set stays active as intended.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
