From: Serge Hallyn <serge.hallyn@ubuntu.com>
Subject: Re: [PATCH] capabilities: Ambient capability set V1
Date: Mon, 23 Feb 2015 16:16:25 +0000
Message-ID: <20150223161625.GD25477@ubuntumail>
References: <alpine.DEB.2.11.1502051554500.4876@gentwo.org>
 <alpine.DEB.2.11.1502230856400.21238@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1502230856400.21238@gentwo.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Lameter <cl@linux.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>, Andy Lutomirski <luto@amacapital.net>, Aaron Jones <aaronmdjones@gmail.com>, Ted Ts'o <tytso@mit.edu>, linux-security-module@vger.kernel.org, akpm@linuxfoundation.org, "Andrew G. Morgan" <morgan@kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Markku Savela <msa@moth.iki.fi>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, Jonathan Corbet <corbet@lwn.net>
List-Id: linux-api@vger.kernel.org

Quoting Christoph Lameter (cl@linux.com):
> Ok 4.0-rc1 is out and this patch has been sitting here for a couple of
> weeks without comment after an intensive discussion about the RFCs.
> 
> Since there were no objections: Is there any chance to get this into -next
> somehow?

Andrew Morgan and Andy Lutomirski appear to have a similar concern
but competing ideas on how to address them.  We need them to agree
on an approach.

The core concern for amorgan is that an unprivileged user not be
able to cause a privileged program to run in a way that it fails to
drop privilege before running unprivileged-user-provided code.

Andy Lutomirski's concern is simply that code which is currently
doing the right thing to drop privilege not be run in a way that
it thinks it is dropping privilege, but in fact is not.

(Please correct me where I've mis-spoken or misunderstood)

Since your desire is precisely for a mode where dropping privilege
works as usual, but exec then re-gains some or all of that privilege,
we need to either agree on a way to enter that mode that ordinary
use caes can't be tricked into using, or find a way for legacy
users to be tpiped off as to what's going on (without having to be
re-written)

-serge
