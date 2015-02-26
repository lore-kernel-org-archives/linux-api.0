From: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH] capabilities: Ambient capability set V1
Date: Thu, 26 Feb 2015 15:23:35 -0600 (CST)
Message-ID: <alpine.DEB.2.11.1502261522300.8444@gentwo.org>
References: <20150224164429.GB29685@ubuntumail> <alpine.DEB.2.11.1502241120270.29416@gentwo.org> <20150225033247.GC29685@ubuntumail> <alpine.DEB.2.11.1502251423580.13489@gentwo.org> <20150226153524.GC15182@mail.hallyn.com> <alpine.DEB.2.11.1502261224580.7451@gentwo.org>
 <20150226193200.GA17709@mail.hallyn.com> <alpine.DEB.2.11.1502261412250.7451@gentwo.org> <20150226203405.GB18926@mail.hallyn.com> <alpine.DEB.2.11.1502261507450.8274@gentwo.org> <20150226211324.GB19273@mail.hallyn.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20150226211324.GB19273@mail.hallyn.com>
Sender: linux-security-module-owner@vger.kernel.org
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>, Serge Hallyn <serge.hallyn@canonical.com>, Andy Lutomirski <luto@amacapital.net>, Aaron Jones <aaronmdjones@gmail.com>, Ted Ts'o <tytso@mit.edu>, linux-security-module@vger.kernel.org, akpm@linuxfoundation.org, "Andrew G. Morgan" <morgan@kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Markku Savela <msa@moth.iki.fi>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, Jonathan Corbet <corbet@lwn.net>
List-Id: linux-api@vger.kernel.org

On Thu, 26 Feb 2015, Serge E. Hallyn wrote:

> No.  fE is not "not available".  If you set it with setcap, you *should*
> (if i'm tinking right) find fE full when calculating the new capability
> sets, because of magic_etc.

There is nothing in get_vfs_caps_from_disk that does this and the magic
vanishes after this function is done.

