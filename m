From: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH] capabilities: Ambient capability set V1
Date: Thu, 26 Feb 2015 15:29:44 -0600 (CST)
Message-ID: <alpine.DEB.2.11.1502261528330.8444@gentwo.org>
References: <20150224164429.GB29685@ubuntumail> <alpine.DEB.2.11.1502241120270.29416@gentwo.org> <20150225033247.GC29685@ubuntumail> <alpine.DEB.2.11.1502251423580.13489@gentwo.org> <20150226153524.GC15182@mail.hallyn.com> <alpine.DEB.2.11.1502261224580.7451@gentwo.org>
 <20150226193200.GA17709@mail.hallyn.com> <alpine.DEB.2.11.1502261412250.7451@gentwo.org> <20150226203405.GB18926@mail.hallyn.com> <CALCETrUB1bb4TiiBgdAMVtRJcEAoDzuOH+StTLPVL8QiXXdOfQ@mail.gmail.com> <20150226205512.GA19273@mail.hallyn.com>
 <CALCETrXGO+ejHAfic4fozf1y48WDBdk3Mo=dFt8MMxtN1HOuUg@mail.gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <CALCETrXGO+ejHAfic4fozf1y48WDBdk3Mo=dFt8MMxtN1HOuUg@mail.gmail.com>
Sender: linux-security-module-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Serge Hallyn <serge.hallyn@ubuntu.com>, Serge Hallyn <serge.hallyn@canonical.com>, Aaron Jones <aaronmdjones@gmail.com>, Ted Ts'o <tytso@mit.edu>, LSM List <linux-security-module@vger.kernel.org>, Andrew Morton <akpm@linuxfoundation.org>, "Andrew G. Morgan" <morgan@kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Markku Savela <msa@moth.iki.fi>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Jonathan Corbet <corbet@lwn.net>
List-Id: linux-api@vger.kernel.org

On Thu, 26 Feb 2015, Andy Lutomirski wrote:

> I'm still extremely nervous about allowing nonempty pA to propagate to
> setuid or nonzero fP programs.  It's less obviously dangerous if pA is
> never a superset of pP, but it could still cause problems with setuid
> programs that execute intentionally deprivileged helpers.

Well but the intend of the ambient caps is that all processes spawned have
those caps. So they should not be dropped implicitly by othe mechanisms
because they could spawn scripts etc that need these privs again.

