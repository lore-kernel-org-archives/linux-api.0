From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH] capabilities: Ambient capability set V2
Date: Thu, 5 Mar 2015 11:13:26 -0600
Message-ID: <20150305171326.GA14998@mail.hallyn.com>
References: <alpine.DEB.2.11.1502261612370.8994@gentwo.org>
 <20150301233359.GA22196@mail.hallyn.com>
 <alpine.DEB.2.11.1503050917380.31001@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1503050917380.31001@gentwo.org>
Sender: linux-security-module-owner@vger.kernel.org
To: Christoph Lameter <cl@linux.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Serge Hallyn <serge.hallyn@canonical.com>, Andy Lutomirski <luto@amacapital.net>, Jonathan Corbet <corbet@lwn.net>, Aaron Jones <aaronmdjones@gmail.com>, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linuxfoundation.org, "Andrew G. Morgan" <morgan@kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Markku Savela <msa@moth.iki.fi>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 05, 2015 at 09:26:24AM -0600, Christoph Lameter wrote:
> On Sun, 1 Mar 2015, Serge E. Hallyn wrote:
> 
> > > +++ linux/security/commoncap.c	2015-02-26 16:10:02.347913397 -0600
> > > @@ -347,15 +347,17 @@ static inline int bprm_caps_from_vfs_cap
> > >  		*has_cap = true;
> > >
> > >  	CAP_FOR_EACH_U32(i) {
> > > +		__u32 ambient = current_cred()->cap_ambient.cap[i];
> > >  		__u32 permitted = caps->permitted.cap[i];
> > >  		__u32 inheritable = caps->inheritable.cap[i];
> > >
> > >  		/*
> > > -		 * pP' = (X & fP) | (pI & fI)
> > > +		 * pP' = (X & fP) | (pI & (fI | pA))
> > >  		 */
> > >  		new->cap_permitted.cap[i] =
> > >  			(new->cap_bset.cap[i] & permitted) |
> > > -			(new->cap_inheritable.cap[i] & inheritable);
> > > +			(new->cap_inheritable.cap[i] &
> > > +					(inheritable | ambient));
> >
> > So I'd say drop this change ^
> 
> Then the ambient caps get ignored for a executables that have capabilities
> seton the file?

Yes.  Those are assumed to already know what they're doing.

> I think we need to keep this one.

Why?  Do you foresee cases where a file that has fP set needs capabilities
that aren't in its fP?

It seems more likely that they'll risk misbehaving due to an unexpected set 
of caps.

If you have a good use case I'm not entirely opposed, but it just seems
unneeded and a potentially bad idea.

> > > @@ -453,8 +455,18 @@ static int get_file_caps(struct linux_bi
> > >  		if (rc == -EINVAL)
> > >  			printk(KERN_NOTICE "%s: get_vfs_caps_from_disk returned %d for %s\n",
> > >  				__func__, rc, bprm->filename);
> > > -		else if (rc == -ENODATA)
> > > +		else if (rc == -ENODATA) {
> > >  			rc = 0;
> > > +			if (!cap_isclear(current_cred()->cap_ambient)) {
> > > +				/*
> > > +				 * The ambient caps are permitted for
> > > +				 * files that have no caps
> > > +				 */
> > > +				bprm->cred->cap_permitted =
> > > +					current_cred()->cap_ambient;
> >
> > and here set vcaps inheritable to current_cred()->ambient.
> 
> We do not call bprm_caps_from_vfs_cap() for files that have no caps so
> this would have no effect. But we could set cap_inheritable here?
> 
> Fixup patch:
> 
> 
> 
> Subject: ambient_caps: Set inheritable bits too
> 
> We were not setting the inheritable bits as they ought to be set.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> Index: linux/security/commoncap.c
> ===================================================================
> --- linux.orig/security/commoncap.c	2015-03-05 09:22:32.123047869 -0600
> +++ linux/security/commoncap.c	2015-03-05 09:22:32.119048001 -0600
> @@ -461,6 +461,8 @@ static int get_file_caps(struct linux_bi
>  				 */
>  				bprm->cred->cap_permitted =
>  					current_cred()->cap_ambient;
> +				bprm->cred->cap_inheritable =
> +					current_cred()->cap_ambient;
>  				*effective = true;
>  			}
>  		}
