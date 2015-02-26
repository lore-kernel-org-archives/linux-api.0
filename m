From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH] capabilities: Ambient capability set V1
Date: Thu, 26 Feb 2015 15:32:36 -0600
Message-ID: <20150226213236.GA19753@mail.hallyn.com>
References: <20150225033247.GC29685@ubuntumail>
 <alpine.DEB.2.11.1502251423580.13489@gentwo.org>
 <20150226153524.GC15182@mail.hallyn.com>
 <alpine.DEB.2.11.1502261224580.7451@gentwo.org>
 <20150226193200.GA17709@mail.hallyn.com>
 <alpine.DEB.2.11.1502261412250.7451@gentwo.org>
 <20150226203405.GB18926@mail.hallyn.com>
 <alpine.DEB.2.11.1502261507450.8274@gentwo.org>
 <20150226211324.GB19273@mail.hallyn.com>
 <alpine.DEB.2.11.1502261522300.8444@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1502261522300.8444@gentwo.org>
Sender: linux-security-module-owner@vger.kernel.org
To: Christoph Lameter <cl@linux.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Serge Hallyn <serge.hallyn@ubuntu.com>, Serge Hallyn <serge.hallyn@canonical.com>, Andy Lutomirski <luto@amacapital.net>, Aaron Jones <aaronmdjones@gmail.com>, Ted Ts'o <tytso@mit.edu>, linux-security-module@vger.kernel.org, akpm@linuxfoundation.org, "Andrew G. Morgan" <morgan@kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Markku Savela <msa@moth.iki.fi>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, Jonathan Corbet <corbet@lwn.net>
List-Id: linux-api@vger.kernel.org

On Thu, Feb 26, 2015 at 03:23:35PM -0600, Christoph Lameter wrote:
> On Thu, 26 Feb 2015, Serge E. Hallyn wrote:
> 
> > No.  fE is not "not available".  If you set it with setcap, you *should*
> > (if i'm tinking right) find fE full when calculating the new capability
> > sets, because of magic_etc.
> 
> There is nothing in get_vfs_caps_from_disk that does this and the magic
> vanishes after this function is done.

get_vfs_caps_from_disk does:

        cpu_caps->magic_etc = magic_etc = le32_to_cpu(caps.magic_etc);

then bprm_caps_from_vfs_caps does:

        if (caps->magic_etc & VFS_CAP_FLAGS_EFFECTIVE)
                *effective = true;

and finally cap_bprm_set_creds does:

        if (effective)
                new->cap_effective = new->cap_permitted;
        else
                cap_clear(new->cap_effective);

