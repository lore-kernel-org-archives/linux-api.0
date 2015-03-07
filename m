From: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH] capabilities: Ambient capability set V2
Date: Sat, 7 Mar 2015 09:06:46 -0600 (CST)
Message-ID: <alpine.DEB.2.11.1503070906130.15173@gentwo.org>
References: <alpine.DEB.2.11.1502261612370.8994@gentwo.org> <20150301233359.GA22196@mail.hallyn.com> <alpine.DEB.2.11.1503050917380.31001@gentwo.org> <20150305171326.GA14998@mail.hallyn.com> <alpine.DEB.2.11.1503060948460.8207@gentwo.org>
 <20150306163443.GA28386@mail.hallyn.com> <alpine.DEB.2.11.1503061244130.9804@gentwo.org> <CALCETrVQF22rkZFD8VAW_xrVQOjwpej6W4TJS9gbN9B431TEKg@mail.gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <CALCETrVQF22rkZFD8VAW_xrVQOjwpej6W4TJS9gbN9B431TEKg@mail.gmail.com>
Sender: linux-security-module-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Serge Hallyn <serge.hallyn@canonical.com>, Jonathan Corbet <corbet@lwn.net>, Aaron Jones <aaronmdjones@gmail.com>, LSM List <linux-security-module@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linuxfoundation.org>, "Andrew G. Morgan" <morgan@kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Markku Savela <msa@moth.iki.fi>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

On Fri, 6 Mar 2015, Andy Lutomirski wrote:

> > christoph@fujitsu-haswell:~$ getcap ambient_test
> >
> > ambient_test = cap_setpcap,cap_net_admin,cap_net_raw,cap_sys_nice+eip
>
> I think that's right.  fI doesn't set pI.

Ok then that is the point of pI if it cannot be set?

